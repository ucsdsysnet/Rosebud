#include "core.h"
volatile int k;

void __attribute__((interrupt)) int_handler(void) {
  int cause = read_csr(mcause);
  if(cause < 0){ //interrupt
    char int_flag = interrupt_flags();

    if(cause & IRQ_M_TIMER){
      interrupt_ack(0x01);
    }

    if (cause & IRQ_M_EXT) {
      // *** Evict interrupt *** //
      if (int_flag & 0x40){
        interrupt_ack(0x04);

        // INFO: wrapper thinks slots in in_desc FIFO are in progress,
        // so first we emptied the incoming packets.

        // Drop all packets
        struct Desc packet;
        while (in_pkt_ready()){
          read_in_pkt(&packet);
          packet.len=0;
          pkt_send(&packet);
        }

        // Few cycles delay not to read last dropped packet
        for (k=0;k<10;k++);

        // Find remaining active packets and drop them
        packet.len=0;
        int act_slots = active_slots ();
        act_slots = act_slots & ~ (act_slots >> 16); // ignore in_send slots
        for (int i=0; i<MAX_SLOT_COUNT; i++){
          if (act_slots & 1){
            packet.tag=i+1;
            pkt_send(&packet);
          }
          act_slots = act_slots >> 1;
        }

        // Wait for the eviction, drop any on the fly packets
        READY_TO_EVICT = 1;
        while(1){
          if (in_pkt_ready()){
            read_in_pkt(&packet);
            packet.len=0;
            pkt_send(&packet);
          }
        }
      }

      // *** Poke interrupt  *** //
      if (int_flag & 0x10){
        interrupt_ack(0x02);
      }

      // *** External io error interrupt *** //
      if (int_flag & 0x20){
        interrupt_ack(0x08);
      }

      // *** Incoming packet interrupt *** //
      if (int_flag & 0x01) {
        interrupt_ack(0x01);
      }

      // *** Incoming filtered broadcast msg *** //
      if (int_flag & 0x08) {
        interrupt_ack(0x100);
        while (1){
          int_flag = interrupt_flags();
          if (int_flag & 0x08){
            interrupt_ack(0x100);
          } else {
            break;
          }
        }
        if (error_flags() & 0x10) { // bc_int_msg overflow
          // Reset the FIFO
          BC_INT_EN = 0;
          BC_INT_EN = 1;
        }
      }

      // *** Dram interrupt *** //
      if (int_flag & 0x02) {
        write_debug (dram_flags());
        write_dram_flags(0x00000000);
      }
    }
  } else { //exception
      char err_flag = error_flags();

      if (err_flag & 0x01) { // imem addr err
        interrupt_ack(0x10);
      }

      if (err_flag & 0x02) { // dmem addr err
        interrupt_ack(0x20);
      }

      if (err_flag & 0x04) { // pmem addr err
        interrupt_ack(0x40);
      }

      if (err_flag & 0x08) { // internal io addr err
        interrupt_ack(0x80);
      }
  }
};

