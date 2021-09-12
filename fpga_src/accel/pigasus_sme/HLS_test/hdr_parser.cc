typedef struct {
    unsigned short old_tag;
    unsigned short old_ts;
    unsigned int   exp_seq;
    unsigned short cur_tag;
    unsigned short cur_ts;
    unsigned int   cur_seq;
    unsigned char  state;
} flow_info;

int hdr_parser(flow_info info) {
    #pragma HLS INTERFACE ap_vld register port=info
    #pragma HLS INTERFACE ap_ctrl_hs port=return
    #pragma HLS PIPELINE II=1

    // Clean entry
    if (info.state==0)
    	return 1;

    if ((info.cur_ts < info.old_ts) ||
       ((info.cur_ts - info.old_ts) > 4))
      return 1;

    // tag collision, send to host
    if (info.cur_tag != info.old_tag)
      return 2;

    if (info.cur_seq == info.exp_seq)
      return 3;
    else if ((info.cur_seq > (info.exp_seq + 30000)) || //assuming 3 jumbo
             (info.cur_seq <  info.exp_seq ))
      return 0;
    else
      return 4;
}
