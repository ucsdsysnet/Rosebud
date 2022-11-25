#include "core.h"
volatile int int_delayer;

void __attribute__((interrupt)) int_handler(void) {
  int cause = read_csr(mcause);
  if(cause < 0){ //interrupt
    unsigned short int_flag = interrupt_flags() & read_masks(); // needs rework for slot errors

    if(cause & IRQ_M_TIMER){
      interrupt_ack(0x0001);
    }

    if (cause & IRQ_M_EXT) {
      // *** Evict interrupt *** //
      if (int_flag & 0x0020){
        interrupt_ack(0x0020);

        // INFO: RPU interconnect thinks slots in in_desc FIFO are in progress,
        // so first we emptied the incoming packets.

        // Drop all packets
        struct Desc packet;
        while (in_pkt_ready()){
          read_in_pkt(&packet);
          packet.len=0;
          pkt_send(&packet);
        }

        // Few cycles delay not to read last dropped packet
        for (int_delayer=0;int_delayer<10;int_delayer++);

        // Find remaining active packets and drop them
        packet.len=0;
        int act_slots = active_slots ();
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
      if (int_flag & 0x0010){
        interrupt_ack(0x0010);
      }

      // *** Duplicate slot interrupt *** //
      if (int_flag & 0x0400){
        interrupt_ack(0x0400);
      }

      // *** Invalid slot interrupt *** //
      if (int_flag & 0x0800){
        interrupt_ack(0x0800);
      }

      // *** Invalid desc interrupt *** //
      if (int_flag & 0x1000){
        interrupt_ack(0x1000);
      }

      // *** External io error interrupt *** //
      if (int_flag & 0x0200){
        interrupt_ack(0x0200);
      }

      // *** Incoming packet interrupt *** //
      if (int_flag & 0x0002) {
        interrupt_ack(0x0002);
      }
        
      // *** BC msg FIFO error interrupt *** //
      if (int_flag & 0x0100){
        interrupt_ack(0x0100);
        // Reset the FIFO
        BC_MSG_FIFO_EN = 0;
        BC_MSG_FIFO_EN = 1;
      }

      // *** Incoming filtered broadcast msg *** //
      if (int_flag & 0x0008) {
        BC_MSG_RELEASE = 1;
        while (1){
          int_flag = interrupt_flags() & read_masks(); // needs rework for slot errors
          if (int_flag & 0x0008)
            BC_MSG_RELEASE = 1;
          else
            break;
        }
      }

      // *** Dram interrupt *** //
      if (int_flag & 0x0004) {
        write_debug (dram_flags());
        write_dram_flags(0x00000000);
      }
    }
  } else { //exception
      char err_flag = error_flags();

      if (err_flag & 0x01) { // imem addr err
        error_ack(0x01);
      }

      if (err_flag & 0x02) { // dmem addr err
        error_ack(0x02);
      }

      if (err_flag & 0x04) { // pmem addr err
        error_ack(0x04);
      }

      if (err_flag & 0x08) { // internal io addr err
        error_ack(0x08);
      }
  }
};

