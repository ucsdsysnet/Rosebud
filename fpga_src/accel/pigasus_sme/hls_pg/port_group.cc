#include "ap_int.h"

void port_group(bool is_TCP, ap_uint<16> src_port, ap_uint<16> dst_port,
		              ap_uint<128> rule_ID_in,
					  bool valid_out[8]) {
	#pragma HLS INTERFACE mode=ap_none port=src_port
	#pragma HLS INTERFACE mode=ap_none port=dst_port
	#pragma HLS INTERFACE mode=ap_none port=is_TCP
	#pragma HLS INTERFACE ap_ctrl_none port=return

	#pragma HLS PIPELINE II=1
	#pragma HLS array_partition variable=valid_out block factor=8 dim=1 type=complete

	for (int i =0; i<8; i++){
	#pragma HLS unroll factor=8
		ap_uint<13> sel_rule = (rule_ID_in >> (i*16)) & 0x1FFF;
		if (is_TCP && (src_port==1024) && (dst_port==1025) && (sel_rule!=0)) {
			valid_out[i] = true;
		} else {
			valid_out[i] = false;
		}
	}

}
