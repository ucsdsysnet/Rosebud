#include "ap_int.h"

typedef struct {
  ap_uint<16> src_port;
  ap_uint<16> dst_port;
  ap_uint<13> rule_ID_in;
  bool        is_tcp;
} request;

bool is_http(ap_uint<16> port);

bool port_group(request req) {
  #pragma HLS INTERFACE ap_vld register port=req
  #pragma HLS INTERFACE ap_ctrl_none port=return
  #pragma HLS PIPELINE II=1

  // Common ports
  bool src_port_is_http      = is_http(req.src_port);
  bool dst_port_is_http      = is_http(req.dst_port);
  bool src_port_is_file_data = is_http(req.src_port) || (req.src_port==110) || (req.src_port==143);
  bool dst_port_is_file_data = is_http(req.dst_port) || (req.dst_port==110) || (req.dst_port==143);
  // bool req.src_port_is_ftp = (req.src_port==21) || (req.src_port==2100) || (req.src_port==3535);
  bool dst_port_is_ftp = (req.dst_port==21) || (req.dst_port==2100) || (req.dst_port==3535);

  if ( (req.rule_ID_in==1018) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==732) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==509) && (req.is_tcp) && true && (req.dst_port==24800) )
    return true;
  if ( (req.rule_ID_in==139) && (req.is_tcp) && true && (req.dst_port==3689) )
    return true;
  if ( (req.rule_ID_in==2945) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==3528) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==4222) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==5060) && (req.is_tcp) && src_port_is_http && true )
    return true;
  if ( (req.rule_ID_in==6595) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==6607) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==6960) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==7184) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==1366) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==1365) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==1364) && (req.is_tcp) && src_port_is_http && true )
    return true;
  if ( (req.rule_ID_in==1363) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==1362) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==1361) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==1360) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==1359) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==1357) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==1356) && (req.is_tcp) && src_port_is_http && true )
    return true;
  if ( (req.rule_ID_in==1333) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==1282) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==1281) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==1272) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==1271) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==1270) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==1269) && (req.is_tcp) && src_port_is_http && true )
    return true;
  if ( (req.rule_ID_in==1268) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==1255) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==1226) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==1191) && (req.is_tcp) && src_port_is_http && true )
    return true;
  if ( (req.rule_ID_in==1190) && (req.is_tcp) && src_port_is_http && true )
    return true;
  if ( (req.rule_ID_in==1189) && (req.is_tcp) && src_port_is_http && true )
    return true;
  if ( (req.rule_ID_in==1181) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==1180) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==1179) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==1178) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==1177) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==1176) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==1101) && (req.is_tcp) && src_port_is_http && true )
    return true;
  if ( (req.rule_ID_in==1100) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==1099) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==1098) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==1097) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==1095) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==1094) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==1093) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==1002) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==996) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==995) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==994) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==993) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==1407) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==1439) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==1427) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==1462) && (req.is_tcp) && src_port_is_http && true )
    return true;
  if ( (req.rule_ID_in==1460) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==1459) && (req.is_tcp) && src_port_is_http && true )
    return true;
  if ( (req.rule_ID_in==1454) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==1452) && (req.is_tcp) && src_port_is_http && true )
    return true;
  if ( (req.rule_ID_in==1451) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==1450) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==1449) && (req.is_tcp) && src_port_is_http && true )
    return true;
  if ( (req.rule_ID_in==1515) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==1514) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==1511) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==1510) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==1509) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==1508) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==1507) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==1586) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==1585) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==1584) && (req.is_tcp) && src_port_is_http && true )
    return true;
  if ( (req.rule_ID_in==1583) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==1581) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==1617) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==1673) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==1672) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==1671) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==1686) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==1769) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==1767) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==1764) && (req.is_tcp) && src_port_is_http && true )
    return true;
  if ( (req.rule_ID_in==1762) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==1761) && (req.is_tcp) && src_port_is_http && true )
    return true;
  if ( (req.rule_ID_in==1846) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==1844) && (req.is_tcp) && src_port_is_http && true )
    return true;
  if ( (req.rule_ID_in==1843) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==2075) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==2073) && (req.is_tcp) && src_port_is_http && true )
    return true;
  if ( (req.rule_ID_in==2072) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==2071) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==2070) && (req.is_tcp) && src_port_is_http && true )
    return true;
  if ( (req.rule_ID_in==2069) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==2068) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==2067) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==2066) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==2064) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==2061) && (req.is_tcp) && src_port_is_http && true )
    return true;
  if ( (req.rule_ID_in==2077) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==2168) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==2167) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==2166) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==2163) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==2162) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==2161) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==2160) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==2159) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==2156) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==2155) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==2147) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==2235) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==2234) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==2233) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==2265) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==2278) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==2284) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==2302) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==2301) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==2158) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==2157) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==2392) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==2390) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==2387) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==2386) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==2385) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==2384) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==2446) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==2459) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==2485) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==2498) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==2497) && (req.is_tcp) && true && ((req.dst_port==25) || (req.dst_port==2525) || (req.dst_port==465) || (req.dst_port==587)) )
    return true;
  if ( (req.rule_ID_in==2496) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==2495) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==2544) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==2543) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==2542) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==2541) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==2540) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==2539) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==2538) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==2549) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==2681) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==2679) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==2678) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==2677) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==2676) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==2674) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==2688) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==2687) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==2804) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==2799) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==2796) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==2793) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==2788) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==2787) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==2786) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==2785) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==2784) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==2783) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==2833) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==2856) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==2869) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==2867) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==2865) && (req.is_tcp) && src_port_is_http && true )
    return true;
  if ( (req.rule_ID_in==2863) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==2862) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==2948) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==2966) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==2965) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==2964) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==3071) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==3070) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==3069) && (req.is_tcp) && src_port_is_http && true )
    return true;
  if ( (req.rule_ID_in==3068) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==3067) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==3066) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==3065) && (req.is_tcp) && src_port_is_http && true )
    return true;
  if ( (req.rule_ID_in==3041) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==3039) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==3038) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==3036) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==3035) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==3034) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==3030) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==3029) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==3028) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==3027) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==3026) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==3025) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==3024) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==3147) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==3146) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==3145) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==3144) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==3139) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==3155) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==3203) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==3250) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==3248) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==3247) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==3246) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==3243) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==3284) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==3366) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==3365) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==3363) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==3362) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==3361) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==3352) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==3351) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==2944) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==2154) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==2074) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==1890) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==1845) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==1760) && (req.is_tcp) && src_port_is_http && true )
    return true;
  if ( (req.rule_ID_in==1582) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==1512) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==1464) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==1461) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==334) && (req.is_tcp) && src_port_is_http && true )
    return true;
  if ( (req.rule_ID_in==155) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==3450) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==3449) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==3448) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==3447) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==3446) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==3445) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==3444) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==3443) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==3442) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==3441) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==3437) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==3435) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==3434) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==3433) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==3484) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==3513) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==3561) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==3560) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==3558) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==3556) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==3554) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==3553) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==3552) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==3550) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==3547) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==3546) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==3545) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==3645) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==3638) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==3637) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==3636) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==3700) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==3759) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==3757) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==3756) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==3752) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==3748) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==3747) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==3765) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==3806) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==3805) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==3867) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==3866) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==3864) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==3861) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==3860) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==3944) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==3933) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==3932) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==3930) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==3929) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==3928) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==3927) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==3926) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==3925) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==3924) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==3923) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==3922) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==3961) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==3960) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==3959) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==4020) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==4018) && (req.is_tcp) && src_port_is_http && true )
    return true;
  if ( (req.rule_ID_in==4017) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==4016) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==4007) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==4006) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==4005) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==4004) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==4002) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==4000) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==3999) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==3997) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==3996) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==3995) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==3994) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==4140) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==4130) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==4217) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==4216) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==4215) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==4213) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==4212) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==4203) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==4200) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==4199) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==4198) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==4191) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==4225) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==4324) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==4322) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==4321) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==4319) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==4318) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==4316) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==4314) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==4313) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==4312) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==4310) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==4309) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==4308) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==4373) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==4429) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==4428) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==4423) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==4421) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==4531) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==4521) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==4519) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==4513) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==4511) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==4510) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==4642) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==4641) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==4640) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==4639) && (req.is_tcp) && src_port_is_http && true )
    return true;
  if ( (req.rule_ID_in==4635) && (req.is_tcp) && src_port_is_http && true )
    return true;
  if ( (req.rule_ID_in==4631) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==4630) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==4629) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==4699) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==4697) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==4696) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==4694) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==4692) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==4691) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==4690) && (req.is_tcp) && src_port_is_http && true )
    return true;
  if ( (req.rule_ID_in==4707) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==4794) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==4791) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==4788) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==4787) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==4785) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==4782) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==4781) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==4858) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==4849) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==4899) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==4926) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==4913) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==4911) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==5007) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==4996) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==4991) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==4989) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==4988) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==5016) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==5038) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==5094) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==5090) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==5089) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==5088) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==5087) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==5161) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==5180) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==5203) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==5192) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==5257) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==5210) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==5201) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==5200) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==5197) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==5194) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==5193) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==5191) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==5273) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==5272) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==5271) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==5270) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==5269) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==5268) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==5267) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==5266) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==5342) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==5339) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==5332) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==5325) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==5321) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==5320) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==5410) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==5400) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==5399) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==5398) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==5397) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==5390) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==5388) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==5520) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==5519) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==5515) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==5514) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==5494) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==5474) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==5473) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==5472) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==5470) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==5616) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==5614) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==5611) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==5610) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==3737) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==3736) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==5654) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==5652) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==5650) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==5649) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==5725) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==5723) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==5722) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==5721) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==5720) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==5719) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==5718) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==5717) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==5716) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==5799) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==5798) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==5797) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==5796) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==5795) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==5794) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==5793) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==5792) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==5791) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==5785) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==5783) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==5802) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==5849) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==5848) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==5847) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==5846) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==5845) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==5844) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==5855) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==5873) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==5870) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==5906) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==5894) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==5893) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==5941) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==5938) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==5937) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==6025) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==6024) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==6017) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==6015) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==6014) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==6012) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==6009) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==6008) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==6005) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==6003) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==5995) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==6061) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==6123) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==6099) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==6097) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==6095) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==6159) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==6211) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==6205) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==6204) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==6259) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==6257) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==6256) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==6255) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==6254) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==6253) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==6252) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==6251) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==6250) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==6249) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==6248) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==6262) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==6283) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==6282) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==6293) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==6338) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==6337) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==6336) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==6335) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==6333) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==6359) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==6370) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==6395) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==6394) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==6393) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==6392) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==6391) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==6390) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==6453) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==6538) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==6535) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==6534) && (req.is_tcp) && src_port_is_http && true )
    return true;
  if ( (req.rule_ID_in==6533) && (req.is_tcp) && src_port_is_http && true )
    return true;
  if ( (req.rule_ID_in==6530) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==6529) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==6587) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==6614) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==6615) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==6628) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==6647) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==6646) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==6645) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==6643) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==6642) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==6708) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==6763) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==6762) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==6761) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==6760) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==6757) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==6756) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==6755) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==6754) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==6753) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==6752) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==6751) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==6750) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==6748) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==6747) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==6746) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==6745) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==6744) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==6743) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==6741) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==6740) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==6829) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==6827) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==6826) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==6825) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==6824) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==6823) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==6822) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==6821) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==6820) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==6894) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==6933) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==6916) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==6914) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==6913) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==6912) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==6910) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==6908) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==6951) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==6952) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==6963) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==7002) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==7001) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==7000) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==6999) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==6998) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==6997) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==6996) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==6995) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==7132) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==7131) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==7130) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==7129) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==7128) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==7112) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==7109) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==7108) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==7107) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==7106) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==7207) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==7206) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==6258) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==1235) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==2815) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==5162) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==5463) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==1372) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==1561) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==2334) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==2447) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==1789) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==1788) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==1787) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==1598) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==1597) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==3772) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==3771) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==4134) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==4282) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==4418) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==5043) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==6232) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==1399) && (req.is_tcp) && src_port_is_http && true )
    return true;
  if ( (req.rule_ID_in==1398) && (req.is_tcp) && src_port_is_http && true )
    return true;
  if ( (req.rule_ID_in==1397) && (req.is_tcp) && src_port_is_http && true )
    return true;
  if ( (req.rule_ID_in==1396) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==1395) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==1394) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==1393) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==1390) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==1389) && (req.is_tcp) && src_port_is_http && true )
    return true;
  if ( (req.rule_ID_in==1371) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==1370) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==1369) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==1368) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==1367) && (req.is_tcp) && src_port_is_http && true )
    return true;
  if ( (req.rule_ID_in==1344) && (req.is_tcp) && src_port_is_http && true )
    return true;
  if ( (req.rule_ID_in==1343) && (req.is_tcp) && src_port_is_http && true )
    return true;
  if ( (req.rule_ID_in==1275) && (req.is_tcp) && src_port_is_http && true )
    return true;
  if ( (req.rule_ID_in==1267) && (req.is_tcp) && src_port_is_http && true )
    return true;
  if ( (req.rule_ID_in==1259) && (req.is_tcp) && src_port_is_http && true )
    return true;
  if ( (req.rule_ID_in==1258) && (req.is_tcp) && src_port_is_http && true )
    return true;
  if ( (req.rule_ID_in==1257) && (req.is_tcp) && src_port_is_http && true )
    return true;
  if ( (req.rule_ID_in==1252) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==1251) && (req.is_tcp) && src_port_is_http && true )
    return true;
  if ( (req.rule_ID_in==1250) && (req.is_tcp) && src_port_is_http && true )
    return true;
  if ( (req.rule_ID_in==1249) && (req.is_tcp) && src_port_is_http && true )
    return true;
  if ( (req.rule_ID_in==1248) && (req.is_tcp) && src_port_is_http && true )
    return true;
  if ( (req.rule_ID_in==1247) && (req.is_tcp) && src_port_is_http && true )
    return true;
  if ( (req.rule_ID_in==1246) && (req.is_tcp) && src_port_is_http && true )
    return true;
  if ( (req.rule_ID_in==1245) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==1243) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==1239) && (req.is_tcp) && src_port_is_http && true )
    return true;
  if ( (req.rule_ID_in==1238) && (req.is_tcp) && src_port_is_http && true )
    return true;
  if ( (req.rule_ID_in==1237) && (req.is_tcp) && src_port_is_http && true )
    return true;
  if ( (req.rule_ID_in==1224) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==1223) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==1222) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==1217) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==1216) && (req.is_tcp) && src_port_is_http && true )
    return true;
  if ( (req.rule_ID_in==1215) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==1214) && (req.is_tcp) && src_port_is_http && true )
    return true;
  if ( (req.rule_ID_in==1213) && (req.is_tcp) && src_port_is_http && true )
    return true;
  if ( (req.rule_ID_in==1212) && (req.is_tcp) && src_port_is_http && true )
    return true;
  if ( (req.rule_ID_in==1211) && (req.is_tcp) && src_port_is_http && true )
    return true;
  if ( (req.rule_ID_in==1210) && (req.is_tcp) && src_port_is_http && true )
    return true;
  if ( (req.rule_ID_in==1204) && (req.is_tcp) && src_port_is_http && true )
    return true;
  if ( (req.rule_ID_in==1203) && (req.is_tcp) && src_port_is_http && true )
    return true;
  if ( (req.rule_ID_in==1201) && (req.is_tcp) && true && (req.dst_port==82) )
    return true;
  if ( (req.rule_ID_in==1196) && (req.is_tcp) && src_port_is_http && true )
    return true;
  if ( (req.rule_ID_in==1193) && (req.is_tcp) && src_port_is_http && true )
    return true;
  if ( (req.rule_ID_in==1192) && (req.is_tcp) && src_port_is_http && true )
    return true;
  if ( (req.rule_ID_in==1171) && (req.is_tcp) && src_port_is_http && true )
    return true;
  if ( (req.rule_ID_in==1170) && (req.is_tcp) && src_port_is_http && true )
    return true;
  if ( (req.rule_ID_in==1169) && (req.is_tcp) && src_port_is_http && true )
    return true;
  if ( (req.rule_ID_in==1168) && (req.is_tcp) && src_port_is_http && true )
    return true;
  if ( (req.rule_ID_in==1165) && (req.is_tcp) && src_port_is_http && true )
    return true;
  if ( (req.rule_ID_in==1156) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==1155) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==1154) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==1153) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==1152) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==1151) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==1150) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==1149) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==1148) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==1147) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==1146) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==1141) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==1140) && (req.is_tcp) && src_port_is_http && true )
    return true;
  if ( (req.rule_ID_in==1126) && (req.is_tcp) && src_port_is_http && true )
    return true;
  if ( (req.rule_ID_in==1117) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==1116) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==1115) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==1114) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==1109) && (req.is_tcp) && src_port_is_http && true )
    return true;
  if ( (req.rule_ID_in==1108) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==1107) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==1105) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==1104) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==1103) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==1057) && (req.is_tcp) && src_port_is_http && true )
    return true;
  if ( (req.rule_ID_in==1056) && (req.is_tcp) && src_port_is_http && true )
    return true;
  if ( (req.rule_ID_in==1055) && (req.is_tcp) && src_port_is_http && true )
    return true;
  if ( (req.rule_ID_in==1052) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==1051) && (req.is_tcp) && src_port_is_http && true )
    return true;
  if ( (req.rule_ID_in==1026) && (req.is_tcp) && src_port_is_http && true )
    return true;
  if ( (req.rule_ID_in==1025) && (req.is_tcp) && src_port_is_http && true )
    return true;
  if ( (req.rule_ID_in==1024) && (req.is_tcp) && src_port_is_http && true )
    return true;
  if ( (req.rule_ID_in==1023) && (req.is_tcp) && src_port_is_http && true )
    return true;
  if ( (req.rule_ID_in==1022) && (req.is_tcp) && src_port_is_http && true )
    return true;
  if ( (req.rule_ID_in==1021) && (req.is_tcp) && src_port_is_http && true )
    return true;
  if ( (req.rule_ID_in==1015) && (req.is_tcp) && src_port_is_http && true )
    return true;
  if ( (req.rule_ID_in==1006) && (req.is_tcp) && src_port_is_http && true )
    return true;
  if ( (req.rule_ID_in==998) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==997) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==973) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==972) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==971) && (req.is_tcp) && src_port_is_http && true )
    return true;
  if ( (req.rule_ID_in==970) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==969) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==962) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==961) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==960) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==956) && (req.is_tcp) && src_port_is_http && true )
    return true;
  if ( (req.rule_ID_in==949) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==943) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==942) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==941) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==940) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==935) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==934) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==865) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==858) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==857) && (req.is_tcp) && src_port_is_http && true )
    return true;
  if ( (req.rule_ID_in==702) && (req.is_tcp) && src_port_is_http && true )
    return true;
  if ( (req.rule_ID_in==701) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==700) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==699) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==689) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==688) && (req.is_tcp) && src_port_is_http && true )
    return true;
  if ( (req.rule_ID_in==687) && (req.is_tcp) && src_port_is_http && true )
    return true;
  if ( (req.rule_ID_in==686) && (req.is_tcp) && src_port_is_http && true )
    return true;
  if ( (req.rule_ID_in==685) && (req.is_tcp) && src_port_is_http && true )
    return true;
  if ( (req.rule_ID_in==683) && (req.is_tcp) && src_port_is_http && true )
    return true;
  if ( (req.rule_ID_in==614) && (req.is_tcp) && src_port_is_http && true )
    return true;
  if ( (req.rule_ID_in==613) && (req.is_tcp) && src_port_is_http && true )
    return true;
  if ( (req.rule_ID_in==570) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==569) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==568) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==567) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==566) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==565) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==564) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==563) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==531) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==530) && (req.is_tcp) && src_port_is_http && true )
    return true;
  if ( (req.rule_ID_in==482) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==481) && (req.is_tcp) && src_port_is_http && true )
    return true;
  if ( (req.rule_ID_in==480) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==479) && (req.is_tcp) && src_port_is_http && true )
    return true;
  if ( (req.rule_ID_in==475) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==474) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==473) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==472) && (req.is_tcp) && src_port_is_http && true )
    return true;
  if ( (req.rule_ID_in==406) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==1405) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==1443) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==1442) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==1437) && (req.is_tcp) && src_port_is_http && true )
    return true;
  if ( (req.rule_ID_in==1436) && (req.is_tcp) && src_port_is_http && true )
    return true;
  if ( (req.rule_ID_in==1435) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==1434) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==1433) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==1432) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==1431) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==1430) && (req.is_tcp) && src_port_is_http && true )
    return true;
  if ( (req.rule_ID_in==1420) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==1419) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==1418) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==1417) && (req.is_tcp) && src_port_is_http && true )
    return true;
  if ( (req.rule_ID_in==1458) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==1457) && (req.is_tcp) && src_port_is_http && true )
    return true;
  if ( (req.rule_ID_in==1456) && (req.is_tcp) && src_port_is_http && true )
    return true;
  if ( (req.rule_ID_in==1455) && (req.is_tcp) && src_port_is_http && true )
    return true;
  if ( (req.rule_ID_in==1484) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==1483) && (req.is_tcp) && src_port_is_http && true )
    return true;
  if ( (req.rule_ID_in==1481) && (req.is_tcp) && src_port_is_http && true )
    return true;
  if ( (req.rule_ID_in==1540) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==1539) && (req.is_tcp) && src_port_is_http && true )
    return true;
  if ( (req.rule_ID_in==1538) && (req.is_tcp) && src_port_is_http && true )
    return true;
  if ( (req.rule_ID_in==1544) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==1543) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==1542) && (req.is_tcp) && src_port_is_http && true )
    return true;
  if ( (req.rule_ID_in==1556) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==1555) && (req.is_tcp) && src_port_is_http && true )
    return true;
  if ( (req.rule_ID_in==1554) && (req.is_tcp) && src_port_is_http && true )
    return true;
  if ( (req.rule_ID_in==1551) && (req.is_tcp) && src_port_is_http && true )
    return true;
  if ( (req.rule_ID_in==1568) && (req.is_tcp) && src_port_is_http && true )
    return true;
  if ( (req.rule_ID_in==1575) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==1615) && (req.is_tcp) && src_port_is_http && true )
    return true;
  if ( (req.rule_ID_in==1614) && (req.is_tcp) && src_port_is_http && true )
    return true;
  if ( (req.rule_ID_in==1613) && (req.is_tcp) && src_port_is_http && true )
    return true;
  if ( (req.rule_ID_in==1612) && (req.is_tcp) && src_port_is_http && true )
    return true;
  if ( (req.rule_ID_in==1611) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==1610) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==1609) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==1608) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==1607) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==1606) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==1605) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==1604) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==1603) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==1602) && (req.is_tcp) && src_port_is_http && true )
    return true;
  if ( (req.rule_ID_in==1601) && (req.is_tcp) && src_port_is_http && true )
    return true;
  if ( (req.rule_ID_in==1600) && (req.is_tcp) && src_port_is_http && true )
    return true;
  if ( (req.rule_ID_in==1599) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==1594) && (req.is_tcp) && src_port_is_http && true )
    return true;
  if ( (req.rule_ID_in==1593) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==1622) && (req.is_tcp) && src_port_is_http && true )
    return true;
  if ( (req.rule_ID_in==1618) && (req.is_tcp) && src_port_is_http && true )
    return true;
  if ( (req.rule_ID_in==1648) && (req.is_tcp) && src_port_is_http && true )
    return true;
  if ( (req.rule_ID_in==1646) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==1643) && (req.is_tcp) && src_port_is_http && true )
    return true;
  if ( (req.rule_ID_in==1642) && (req.is_tcp) && src_port_is_http && true )
    return true;
  if ( (req.rule_ID_in==1641) && (req.is_tcp) && src_port_is_http && true )
    return true;
  if ( (req.rule_ID_in==1663) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==1662) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==1666) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==1677) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==1676) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==1675) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==1688) && (req.is_tcp) && src_port_is_http && true )
    return true;
  if ( (req.rule_ID_in==1697) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==1696) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==1709) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==1707) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==1706) && (req.is_tcp) && src_port_is_http && true )
    return true;
  if ( (req.rule_ID_in==1730) && (req.is_tcp) && true && true )
    return true;
  if ( (req.rule_ID_in==1748) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==1747) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==1743) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==1742) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==1741) && (req.is_tcp) && src_port_is_http && true )
    return true;
  if ( (req.rule_ID_in==1739) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==1738) && (req.is_tcp) && src_port_is_http && true )
    return true;
  if ( (req.rule_ID_in==1756) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==1755) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==1806) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==1805) && (req.is_tcp) && src_port_is_http && true )
    return true;
  if ( (req.rule_ID_in==1804) && (req.is_tcp) && src_port_is_http && true )
    return true;
  if ( (req.rule_ID_in==1803) && (req.is_tcp) && src_port_is_http && true )
    return true;
  if ( (req.rule_ID_in==1794) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==1816) && (req.is_tcp) && src_port_is_http && true )
    return true;
  if ( (req.rule_ID_in==1815) && (req.is_tcp) && src_port_is_http && true )
    return true;
  if ( (req.rule_ID_in==1854) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==1869) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==1868) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==1867) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==1866) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==1865) && (req.is_tcp) && src_port_is_http && true )
    return true;
  if ( (req.rule_ID_in==1879) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==1878) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==1877) && (req.is_tcp) && src_port_is_http && true )
    return true;
  if ( (req.rule_ID_in==1928) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==1927) && (req.is_tcp) && src_port_is_http && true )
    return true;
  if ( (req.rule_ID_in==1949) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==1948) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==1992) && (req.is_tcp) && src_port_is_http && true )
    return true;
  if ( (req.rule_ID_in==1991) && (req.is_tcp) && src_port_is_http && true )
    return true;
  if ( (req.rule_ID_in==2022) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==2021) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==2020) && (req.is_tcp) && src_port_is_http && true )
    return true;
  if ( (req.rule_ID_in==2019) && (req.is_tcp) && src_port_is_http && true )
    return true;
  if ( (req.rule_ID_in==2018) && (req.is_tcp) && src_port_is_http && true )
    return true;
  if ( (req.rule_ID_in==2017) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==2129) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==2128) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==2127) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==2126) && (req.is_tcp) && src_port_is_http && true )
    return true;
  if ( (req.rule_ID_in==2165) && (req.is_tcp) && src_port_is_http && true )
    return true;
  if ( (req.rule_ID_in==2164) && (req.is_tcp) && src_port_is_http && true )
    return true;
  if ( (req.rule_ID_in==2187) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==1090) && (req.is_tcp) && src_port_is_http && true )
    return true;
  if ( (req.rule_ID_in==2223) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==2222) && (req.is_tcp) && src_port_is_http && true )
    return true;
  if ( (req.rule_ID_in==2221) && (req.is_tcp) && src_port_is_http && true )
    return true;
  if ( (req.rule_ID_in==2218) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==2260) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==2259) && (req.is_tcp) && src_port_is_http && true )
    return true;
  if ( (req.rule_ID_in==2279) && (req.is_tcp) && src_port_is_http && true )
    return true;
  if ( (req.rule_ID_in==2295) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==2294) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==2293) && (req.is_tcp) && src_port_is_http && true )
    return true;
  if ( (req.rule_ID_in==2292) && (req.is_tcp) && src_port_is_http && true )
    return true;
  if ( (req.rule_ID_in==2312) && (req.is_tcp) && src_port_is_http && true )
    return true;
  if ( (req.rule_ID_in==2311) && (req.is_tcp) && src_port_is_http && true )
    return true;
  if ( (req.rule_ID_in==2310) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==2309) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==2308) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==2307) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==2306) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==2305) && (req.is_tcp) && src_port_is_http && true )
    return true;
  if ( (req.rule_ID_in==2304) && (req.is_tcp) && src_port_is_http && true )
    return true;
  if ( (req.rule_ID_in==2303) && (req.is_tcp) && src_port_is_http && true )
    return true;
  if ( (req.rule_ID_in==2341) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==2400) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==2399) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==2398) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==2415) && (req.is_tcp) && true && true )
    return true;
  if ( (req.rule_ID_in==2414) && (req.is_tcp) && true && true )
    return true;
  if ( (req.rule_ID_in==2413) && (req.is_tcp) && true && true )
    return true;
  if ( (req.rule_ID_in==2412) && (req.is_tcp) && true && true )
    return true;
  if ( (req.rule_ID_in==2445) && (req.is_tcp) && true && true )
    return true;
  if ( (req.rule_ID_in==2444) && (req.is_tcp) && src_port_is_http && true )
    return true;
  if ( (req.rule_ID_in==2443) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==2516) && (req.is_tcp) && src_port_is_http && true )
    return true;
  if ( (req.rule_ID_in==2515) && (req.is_tcp) && src_port_is_http && true )
    return true;
  if ( (req.rule_ID_in==2513) && (req.is_tcp) && src_port_is_http && true )
    return true;
  if ( (req.rule_ID_in==2527) && (req.is_tcp) && src_port_is_http && true )
    return true;
  if ( (req.rule_ID_in==2535) && (req.is_tcp) && true && true )
    return true;
  if ( (req.rule_ID_in==2575) && (req.is_tcp) && src_port_is_http && true )
    return true;
  if ( (req.rule_ID_in==2573) && (req.is_tcp) && src_port_is_http && true )
    return true;
  if ( (req.rule_ID_in==2572) && (req.is_tcp) && src_port_is_http && true )
    return true;
  if ( (req.rule_ID_in==2566) && (req.is_tcp) && true && (req.dst_port==8087) )
    return true;
  if ( (req.rule_ID_in==2565) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==2601) && (req.is_tcp) && src_port_is_http && true )
    return true;
  if ( (req.rule_ID_in==2761) && (req.is_tcp) && src_port_is_http && true )
    return true;
  if ( (req.rule_ID_in==2760) && (req.is_tcp) && src_port_is_http && true )
    return true;
  if ( (req.rule_ID_in==2764) && (req.is_tcp) && true && true )
    return true;
  if ( (req.rule_ID_in==2827) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==2826) && (req.is_tcp) && src_port_is_http && true )
    return true;
  if ( (req.rule_ID_in==2894) && (req.is_tcp) && src_port_is_http && true )
    return true;
  if ( (req.rule_ID_in==2893) && (req.is_tcp) && src_port_is_http && true )
    return true;
  if ( (req.rule_ID_in==2910) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==2909) && (req.is_tcp) && src_port_is_http && true )
    return true;
  if ( (req.rule_ID_in==2908) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==2907) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==2930) && (req.is_tcp) && src_port_is_http && true )
    return true;
  if ( (req.rule_ID_in==2963) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==2962) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==2961) && (req.is_tcp) && src_port_is_http && true )
    return true;
  if ( (req.rule_ID_in==2960) && (req.is_tcp) && src_port_is_http && true )
    return true;
  if ( (req.rule_ID_in==2959) && (req.is_tcp) && src_port_is_http && true )
    return true;
  if ( (req.rule_ID_in==2958) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==3009) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==3008) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==3007) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==3014) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==3017) && (req.is_tcp) && src_port_is_http && true )
    return true;
  if ( (req.rule_ID_in==3130) && (req.is_tcp) && true && true )
    return true;
  if ( (req.rule_ID_in==3185) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==3206) && (req.is_tcp) && src_port_is_http && true )
    return true;
  if ( (req.rule_ID_in==3205) && (req.is_tcp) && src_port_is_http && true )
    return true;
  if ( (req.rule_ID_in==3204) && (req.is_tcp) && src_port_is_http && true )
    return true;
  if ( (req.rule_ID_in==3337) && (req.is_tcp) && src_port_is_http && true )
    return true;
  if ( (req.rule_ID_in==3336) && (req.is_tcp) && src_port_is_http && true )
    return true;
  if ( (req.rule_ID_in==2574) && (req.is_tcp) && src_port_is_http && true )
    return true;
  if ( (req.rule_ID_in==2016) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==1754) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==1708) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==1576) && (req.is_tcp) && src_port_is_http && true )
    return true;
  if ( (req.rule_ID_in==1106) && (req.is_tcp) && src_port_is_http && true )
    return true;
  if ( (req.rule_ID_in==3432) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==3502) && (req.is_tcp) && src_port_is_http && true )
    return true;
  if ( (req.rule_ID_in==3544) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==3578) && (req.is_tcp) && src_port_is_http && true )
    return true;
  if ( (req.rule_ID_in==3734) && (req.is_tcp) && src_port_is_http && true )
    return true;
  if ( (req.rule_ID_in==3766) && (req.is_tcp) && src_port_is_http && true )
    return true;
  if ( (req.rule_ID_in==3796) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==3833) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==3843) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==3868) && (req.is_tcp) && true && true )
    return true;
  if ( (req.rule_ID_in==3884) && (req.is_tcp) && src_port_is_http && true )
    return true;
  if ( (req.rule_ID_in==3918) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==3917) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==3954) && (req.is_tcp) && true && true )
    return true;
  if ( (req.rule_ID_in==3957) && (req.is_tcp) && true && true )
    return true;
  if ( (req.rule_ID_in==4027) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==4107) && (req.is_tcp) && src_port_is_http && true )
    return true;
  if ( (req.rule_ID_in==4184) && (req.is_tcp) && src_port_is_http && true )
    return true;
  if ( (req.rule_ID_in==4183) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==4189) && (req.is_tcp) && src_port_is_http && true )
    return true;
  if ( (req.rule_ID_in==4188) && (req.is_tcp) && src_port_is_http && true )
    return true;
  if ( (req.rule_ID_in==4187) && (req.is_tcp) && src_port_is_http && true )
    return true;
  if ( (req.rule_ID_in==4295) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==4294) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==4303) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==4296) && (req.is_tcp) && src_port_is_http && true )
    return true;
  if ( (req.rule_ID_in==4333) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==4332) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==4331) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==4365) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==4366) && (req.is_tcp) && src_port_is_http && true )
    return true;
  if ( (req.rule_ID_in==4405) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==4435) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==4438) && (req.is_tcp) && src_port_is_http && true )
    return true;
  if ( (req.rule_ID_in==4452) && (req.is_tcp) && src_port_is_http && true )
    return true;
  if ( (req.rule_ID_in==4451) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==4481) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==4888) && (req.is_tcp) && src_port_is_http && true )
    return true;
  if ( (req.rule_ID_in==5026) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==5106) && (req.is_tcp) && true && true )
    return true;
  if ( (req.rule_ID_in==5245) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==5407) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==5556) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==5555) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==5950) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==5949) && (req.is_tcp) && src_port_is_http && true )
    return true;
  if ( (req.rule_ID_in==6138) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==6558) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==7182) && (req.is_tcp) && src_port_is_http && true )
    return true;
  if ( (req.rule_ID_in==7181) && (req.is_tcp) && src_port_is_http && true )
    return true;
  if ( (req.rule_ID_in==1161) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==3374) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==5075) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==5074) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==5139) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==5137) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==6064) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==6341) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==6454) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==6641) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==6905) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==4402) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==4401) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==4400) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==4399) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==4398) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==4397) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==4396) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==4395) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==4394) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==4393) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==1292) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==1229) && (req.is_tcp) && (req.src_port==1935) && true )
    return true;
  if ( (req.rule_ID_in==1228) && (req.is_tcp) && true && (req.dst_port==1935) )
    return true;
  if ( (req.rule_ID_in==1183) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==1137) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==1136) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==1135) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==1134) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==1133) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==1111) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==875) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==1403) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==1480) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==1479) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==1792) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==1791) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==1782) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==1781) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==1898) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==1897) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==1896) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==1895) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==2038) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==2037) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==2089) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==2116) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==2244) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==2243) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==2256) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==2277) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==2337) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==2336) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==2416) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==2438) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==2437) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==2436) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==2435) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==2505) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==2504) && (req.is_tcp) && src_port_is_file_data && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==2525) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==2526) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==2562) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==2561) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==2564) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==2563) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==2629) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==2668) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==2659) && (req.is_tcp) && (req.src_port==1935) && true )
    return true;
  if ( (req.rule_ID_in==2708) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==2707) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==2704) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==2703) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==2732) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==2731) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==2730) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==2729) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==2753) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==2823) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==2822) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==2821) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==2820) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==2819) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==2838) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==2837) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==2836) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==2835) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==2834) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==2831) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==2830) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==2825) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==2844) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==2884) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==2883) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==2881) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==2880) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==2889) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==2888) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==2947) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==2946) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==2939) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==2938) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==2957) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==2970) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==2969) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==3006) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==3005) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==3004) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==3003) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==3002) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==3020) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==3019) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==3016) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==3063) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==3062) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==3061) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==3060) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==3059) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==3058) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==3057) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==3056) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==3055) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==3054) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==3053) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==3052) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==3051) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==3050) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==3049) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==3048) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==3047) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==3046) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==3045) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==3044) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==3043) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==3042) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==3091) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==3090) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==3088) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==3087) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==3086) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==3114) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==3113) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==3112) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==3104) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==3103) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==3102) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==3101) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==3100) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==3099) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==3098) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==3097) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==3096) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==3095) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==3119) && (req.is_tcp) && src_port_is_http && true )
    return true;
  if ( (req.rule_ID_in==3118) && (req.is_tcp) && src_port_is_http && true )
    return true;
  if ( (req.rule_ID_in==3184) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==3183) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==3193) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==3192) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==3191) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==3190) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==3202) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==3201) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==3200) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==3199) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==3223) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==3214) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==3274) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==3273) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==3272) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==3271) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==3270) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==3269) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==3268) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==3267) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==3265) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==3264) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==3282) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==3281) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==3280) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==3279) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==3308) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==3307) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==3306) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==3305) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==3304) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==3302) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==3301) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==3297) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==3296) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==3295) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==3294) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==3293) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==3292) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==3291) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==3290) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==3289) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==3320) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==3319) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==3345) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==3344) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==3379) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==2118) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==2117) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==2053) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==2052) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==1813) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==1812) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==1811) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==1810) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==1807) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==1089) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==1087) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==1086) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==421) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==420) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==419) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==418) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==357) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==3407) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==3406) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==3403) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==3402) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==3397) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==3396) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==3394) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==3391) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==3390) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==3385) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==3384) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==3383) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==3382) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==3411) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==3475) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==3474) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==3473) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==3472) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==3462) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==3461) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==3459) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==3458) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==3457) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==3456) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==3455) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==3453) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==3452) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==3451) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==3504) && (req.is_tcp) && true && true )
    return true;
  if ( (req.rule_ID_in==3527) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==3562) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==3589) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==3588) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==3587) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==3586) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==3585) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==3584) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==3583) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==3582) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==3581) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==3580) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==3579) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==3572) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==3571) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==3570) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==3569) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==3568) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==3567) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==3566) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==3565) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==3610) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==3609) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==3632) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==3631) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==3629) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==3628) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==3627) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==3680) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==3679) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==3678) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==3677) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==3676) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==3675) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==3674) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==3671) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==3670) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==3669) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==3668) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==3667) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==3666) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==3665) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==3664) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==3663) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==3662) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==3661) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==3699) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==3698) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==3696) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==3695) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==3694) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==3693) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==3692) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==3691) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==3690) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==3689) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==3688) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==3687) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==3686) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==3685) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==3684) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==3683) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==3682) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==3681) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==3718) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==3717) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==3716) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==3715) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==3710) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==3709) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==3731) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==3730) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==3729) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==3728) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==3746) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==3745) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==3744) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==3743) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==3742) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==3777) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==3776) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==3775) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==3791) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==3790) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==3789) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==3788) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==3787) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==3786) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==3785) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==3784) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==3783) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==3781) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==3793) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==3792) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==3812) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==3811) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==3810) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==3809) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==3836) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==3835) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==3834) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==3832) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==3831) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==3826) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==3825) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==3824) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==3823) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==3821) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==3820) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==3819) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==3859) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==3856) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==3855) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==3854) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==3853) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==3852) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==3851) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==3850) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==3849) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==3848) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==3847) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==3846) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==3845) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==3881) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==3880) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==3876) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==3875) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==3888) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==3887) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==3886) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==3885) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==3903) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==3902) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==3901) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==3900) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==3899) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==3898) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==3895) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==3905) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==3904) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==3977) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==3976) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==3975) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==3974) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==3973) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==3972) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==3970) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==3969) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==3967) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==3966) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==3965) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==3982) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==3981) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==3980) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==3979) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==3986) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==3985) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==3984) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==3983) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==3990) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==4066) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==4065) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==4064) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==4063) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==4062) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==4061) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==4060) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==4056) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==4055) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==4054) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==4053) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==4052) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==4051) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==4050) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==4049) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==4047) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==4046) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==4045) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==4044) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==4078) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==4077) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==4073) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==4071) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==4070) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==4069) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==4068) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==4100) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==4099) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==4098) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==4097) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==4096) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==4095) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==4094) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==4093) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==4092) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==4091) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==4090) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==4089) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==4088) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==4087) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==4085) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==4084) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==4083) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==4082) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==4081) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==4080) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==4102) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==4101) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==4124) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==4123) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==4122) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==4121) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==4120) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==4115) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==4114) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==4113) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==4112) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==4108) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==4106) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==4105) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==4104) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==4103) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==4129) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==4128) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==4127) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==4126) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==4151) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==4150) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==4149) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==4148) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==4232) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==4228) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==4224) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==4223) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==4235) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==4234) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==4237) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==4245) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==4244) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==4253) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==4252) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==4251) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==4250) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==4284) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==4283) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==4280) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==4279) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==4278) && (req.is_tcp) && src_port_is_http && true )
    return true;
  if ( (req.rule_ID_in==4277) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==4276) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==4274) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==4273) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==4271) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==4270) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==4269) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==4268) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==4267) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==4266) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==4265) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==4264) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==4263) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==4262) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==4261) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==4260) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==4259) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==4258) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==4257) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==4256) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==4255) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==4254) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==4300) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==4299) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==4298) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==4297) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==4359) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==4358) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==4356) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==4355) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==4352) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==4351) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==4350) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==4349) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==4348) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==4347) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==4346) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==4345) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==4344) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==4343) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==4342) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==4341) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==4340) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==4339) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==4338) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==4337) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==4336) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==4335) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==4334) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==4364) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==4363) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==4374) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==4404) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==4403) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==4413) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==4444) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==4462) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==4461) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==4460) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==4459) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==4532) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==4530) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==4529) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==4528) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==4527) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==4526) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==4525) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==4517) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==4541) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==4540) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==4545) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==4544) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==4599) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==4598) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==4596) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==4595) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==4594) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==4593) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==4590) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==4589) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==4585) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==4581) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==4579) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==4578) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==4658) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==4657) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==4656) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==4655) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==4654) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==4653) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==4652) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==4651) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==4650) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==4649) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==4648) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==4646) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==4645) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==4644) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==4683) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==4682) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==4686) && (req.is_tcp) && true && dst_port_is_file_data )
    return true;
  if ( (req.rule_ID_in==4721) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==4720) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==4719) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==4717) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==4716) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==4715) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==4714) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==4712) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==4711) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==4710) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==4731) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==4741) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==4740) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==4737) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==4745) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==4750) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==4753) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==4772) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==4826) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==4820) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==4866) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==4865) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==4864) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==4863) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==4862) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==4861) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==4860) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==4884) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==4933) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==4931) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==4945) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==4942) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==4955) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==4971) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==4970) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==5023) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==5022) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==5021) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==5020) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==5019) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==5018) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==5039) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==5035) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==5102) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==5101) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==5100) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==5099) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==5098) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==5097) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==5126) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==5124) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==5121) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==5147) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==5154) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==5179) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==5178) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==5163) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==5184) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==5212) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==5211) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==5209) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==5215) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==5222) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==5230) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==5229) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==5239) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==5289) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==5288) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==5304) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==5303) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==3801) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==5340) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==5413) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==5412) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==5409) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==5408) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==5405) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==5404) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==5403) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==5402) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==5449) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==5525) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==5524) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==5523) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==5518) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==5510) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==5509) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==5506) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==5505) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==5504) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==5503) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==5502) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==5501) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==5500) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==5499) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==5498) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==5497) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==5459) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==5573) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==5570) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==5576) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==5588) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==5615) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==5613) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==5612) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==5655) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==5663) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==5753) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==5739) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==5734) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==5733) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==5852) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==5856) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==5876) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==5888) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==5887) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==5910) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==5911) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==6026) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==6033) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==6032) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==6042) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==6200) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==6199) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==6213) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==6260) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==6349) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==6581) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==6580) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==6804) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==7027) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==7026) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==7077) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==7076) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==272) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==393) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==402) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==389) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==183) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==142) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==390) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==201) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==368) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==401) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==184) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==380) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==245) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==400) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==381) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==137) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==376) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==164) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==246) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==395) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==391) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==392) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==407) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==408) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==403) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==182) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==412) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==427) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==425) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==439) && (req.is_tcp) && ((req.src_port==110) || (req.src_port==143)) && true )
    return true;
  if ( (req.rule_ID_in==432) && (req.is_tcp) && ((req.src_port==110) || (req.src_port==143)) && true )
    return true;
  if ( (req.rule_ID_in==424) && (req.is_tcp) && ((req.src_port==110) || (req.src_port==143)) && true )
    return true;
  if ( (req.rule_ID_in==440) && (req.is_tcp) && ((req.src_port==110) || (req.src_port==143)) && true )
    return true;
  if ( (req.rule_ID_in==431) && (req.is_tcp) && ((req.src_port==110) || (req.src_port==143)) && true )
    return true;
  if ( (req.rule_ID_in==462) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==466) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==467) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==464) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==465) && (req.is_tcp) && ((req.src_port==110) || (req.src_port==143)) && true )
    return true;
  if ( (req.rule_ID_in==463) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==469) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==505) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==516) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==542) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==543) && (req.is_tcp) && ((req.src_port==110) || (req.src_port==143)) && true )
    return true;
  if ( (req.rule_ID_in==599) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==607) && (req.is_tcp) && ((req.src_port==110) || (req.src_port==143)) && true )
    return true;
  if ( (req.rule_ID_in==627) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==640) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==631) && (req.is_tcp) && ((req.src_port==110) || (req.src_port==143)) && true )
    return true;
  if ( (req.rule_ID_in==638) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==637) && (req.is_tcp) && ((req.src_port==110) || (req.src_port==143)) && true )
    return true;
  if ( (req.rule_ID_in==641) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==639) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==642) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==644) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==645) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==652) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==666) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==675) && (req.is_tcp) && ((req.src_port==110) || (req.src_port==143)) && true )
    return true;
  if ( (req.rule_ID_in==663) && (req.is_tcp) && ((req.src_port==110) || (req.src_port==143)) && true )
    return true;
  if ( (req.rule_ID_in==671) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==673) && (req.is_tcp) && ((req.src_port==110) || (req.src_port==143)) && true )
    return true;
  if ( (req.rule_ID_in==669) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==672) && (req.is_tcp) && ((req.src_port==110) || (req.src_port==143)) && true )
    return true;
  if ( (req.rule_ID_in==661) && (req.is_tcp) && ((req.src_port==110) || (req.src_port==143)) && true )
    return true;
  if ( (req.rule_ID_in==664) && (req.is_tcp) && ((req.src_port==110) || (req.src_port==143)) && true )
    return true;
  if ( (req.rule_ID_in==670) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==667) && (req.is_tcp) && ((req.src_port==110) || (req.src_port==143)) && true )
    return true;
  if ( (req.rule_ID_in==676) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==714) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==727) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==713) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==728) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==730) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==760) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==754) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==761) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==773) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==752) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==745) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==740) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==759) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==748) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==747) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==751) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==742) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==788) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==746) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==741) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==823) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==824) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==830) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==843) && (req.is_tcp) && ((req.src_port==110) || (req.src_port==143)) && true )
    return true;
  if ( (req.rule_ID_in==884) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==887) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==888) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==889) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==881) && (req.is_tcp) && ((req.src_port==110) || (req.src_port==143)) && true )
    return true;
  if ( (req.rule_ID_in==900) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==933) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==964) && (req.is_tcp) && src_port_is_http && true )
    return true;
  if ( (req.rule_ID_in==1020) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==1072) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==1120) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==1123) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==1122) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==1124) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==1121) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==1125) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==1158) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==1160) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==1159) && (req.is_tcp) && ((req.src_port==110) || (req.src_port==143)) && true )
    return true;
  if ( (req.rule_ID_in==1163) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==1175) && (req.is_tcp) && ((req.src_port==110) || (req.src_port==143)) && true )
    return true;
  if ( (req.rule_ID_in==1187) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==1227) && (req.is_tcp) && ((req.src_port==110) || (req.src_port==143)) && true )
    return true;
  if ( (req.rule_ID_in==1241) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==1240) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==1373) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==1485) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==1489) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==1726) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==1721) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==1720) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==1768) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==1765) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==1784) && (req.is_tcp) && ((req.src_port==110) || (req.src_port==143)) && true )
    return true;
  if ( (req.rule_ID_in==1783) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==1880) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==2258) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==2257) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==2714) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==2854) && (req.is_tcp) && ((req.src_port==110) || (req.src_port==143)) && true )
    return true;
  if ( (req.rule_ID_in==2918) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==3125) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==3132) && (req.is_tcp) && ((req.src_port==110) || (req.src_port==143)) && true )
    return true;
  if ( (req.rule_ID_in==3357) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==3356) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==2931) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==2758) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==2680) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==2673) && (req.is_tcp) && ((req.src_port==110) || (req.src_port==143)) && true )
    return true;
  if ( (req.rule_ID_in==2567) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==2537) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==2536) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==2131) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==2130) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==2049) && (req.is_tcp) && ((req.src_port==110) || (req.src_port==143)) && true )
    return true;
  if ( (req.rule_ID_in==2014) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==2005) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==2000) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==1958) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==1853) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==1852) && (req.is_tcp) && ((req.src_port==110) || (req.src_port==143)) && true )
    return true;
  if ( (req.rule_ID_in==1851) && (req.is_tcp) && ((req.src_port==110) || (req.src_port==143)) && true )
    return true;
  if ( (req.rule_ID_in==1236) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==1232) && (req.is_tcp) && ((req.src_port==110) || (req.src_port==143)) && true )
    return true;
  if ( (req.rule_ID_in==1231) && (req.is_tcp) && ((req.src_port==110) || (req.src_port==143)) && true )
    return true;
  if ( (req.rule_ID_in==1195) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==1157) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==1088) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==1049) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==1048) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==1047) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==1017) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==1016) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==959) && (req.is_tcp) && ((req.src_port==110) || (req.src_port==143)) && true )
    return true;
  if ( (req.rule_ID_in==948) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==947) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==946) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==945) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==936) && (req.is_tcp) && ((req.src_port==110) || (req.src_port==143)) && true )
    return true;
  if ( (req.rule_ID_in==916) && (req.is_tcp) && (req.src_port==143) && true )
    return true;
  if ( (req.rule_ID_in==909) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==891) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==886) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==885) && (req.is_tcp) && ((req.src_port==110) || (req.src_port==143)) && true )
    return true;
  if ( (req.rule_ID_in==883) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==882) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==854) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==850) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==848) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==846) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==832) && (req.is_tcp) && ((req.src_port==110) || (req.src_port==143)) && true )
    return true;
  if ( (req.rule_ID_in==831) && (req.is_tcp) && ((req.src_port==110) || (req.src_port==143)) && true )
    return true;
  if ( (req.rule_ID_in==798) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==797) && (req.is_tcp) && ((req.src_port==110) || (req.src_port==143)) && true )
    return true;
  if ( (req.rule_ID_in==796) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==795) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==794) && (req.is_tcp) && ((req.src_port==110) || (req.src_port==143)) && true )
    return true;
  if ( (req.rule_ID_in==793) && (req.is_tcp) && ((req.src_port==110) || (req.src_port==143)) && true )
    return true;
  if ( (req.rule_ID_in==790) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==789) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==787) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==786) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==785) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==784) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==783) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==782) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==781) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==780) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==779) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==778) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==777) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==776) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==775) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==774) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==772) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==771) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==770) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==769) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==768) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==767) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==766) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==765) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==764) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==763) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==762) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==758) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==757) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==756) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==755) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==753) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==750) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==749) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==744) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==743) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==739) && (req.is_tcp) && ((req.src_port==110) || (req.src_port==143)) && true )
    return true;
  if ( (req.rule_ID_in==720) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==697) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==696) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==695) && (req.is_tcp) && ((req.src_port==110) || (req.src_port==143)) && true )
    return true;
  if ( (req.rule_ID_in==694) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==693) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==692) && (req.is_tcp) && ((req.src_port==110) || (req.src_port==143)) && true )
    return true;
  if ( (req.rule_ID_in==690) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==677) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==674) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==668) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==665) && (req.is_tcp) && ((req.src_port==110) || (req.src_port==143)) && true )
    return true;
  if ( (req.rule_ID_in==662) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==660) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==659) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==618) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==617) && (req.is_tcp) && ((req.src_port==110) || (req.src_port==143)) && true )
    return true;
  if ( (req.rule_ID_in==616) && (req.is_tcp) && ((req.src_port==110) || (req.src_port==143)) && true )
    return true;
  if ( (req.rule_ID_in==612) && (req.is_tcp) && ((req.src_port==110) || (req.src_port==143)) && true )
    return true;
  if ( (req.rule_ID_in==611) && (req.is_tcp) && ((req.src_port==110) || (req.src_port==143)) && true )
    return true;
  if ( (req.rule_ID_in==609) && (req.is_tcp) && ((req.src_port==110) || (req.src_port==143)) && true )
    return true;
  if ( (req.rule_ID_in==608) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==606) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==605) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==604) && (req.is_tcp) && ((req.src_port==110) || (req.src_port==143)) && true )
    return true;
  if ( (req.rule_ID_in==603) && (req.is_tcp) && ((req.src_port==110) || (req.src_port==143)) && true )
    return true;
  if ( (req.rule_ID_in==602) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==601) && (req.is_tcp) && ((req.src_port==110) || (req.src_port==143)) && true )
    return true;
  if ( (req.rule_ID_in==600) && (req.is_tcp) && ((req.src_port==110) || (req.src_port==143)) && true )
    return true;
  if ( (req.rule_ID_in==588) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==587) && (req.is_tcp) && ((req.src_port==110) || (req.src_port==143)) && true )
    return true;
  if ( (req.rule_ID_in==586) && (req.is_tcp) && ((req.src_port==110) || (req.src_port==143)) && true )
    return true;
  if ( (req.rule_ID_in==585) && (req.is_tcp) && ((req.src_port==110) || (req.src_port==143)) && true )
    return true;
  if ( (req.rule_ID_in==584) && (req.is_tcp) && ((req.src_port==110) || (req.src_port==143)) && true )
    return true;
  if ( (req.rule_ID_in==583) && (req.is_tcp) && ((req.src_port==110) || (req.src_port==143)) && true )
    return true;
  if ( (req.rule_ID_in==582) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==581) && (req.is_tcp) && ((req.src_port==110) || (req.src_port==143)) && true )
    return true;
  if ( (req.rule_ID_in==580) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==579) && (req.is_tcp) && ((req.src_port==110) || (req.src_port==143)) && true )
    return true;
  if ( (req.rule_ID_in==578) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==577) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==576) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==575) && (req.is_tcp) && ((req.src_port==110) || (req.src_port==143)) && true )
    return true;
  if ( (req.rule_ID_in==574) && (req.is_tcp) && ((req.src_port==110) || (req.src_port==143)) && true )
    return true;
  if ( (req.rule_ID_in==573) && (req.is_tcp) && ((req.src_port==110) || (req.src_port==143)) && true )
    return true;
  if ( (req.rule_ID_in==572) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==571) && (req.is_tcp) && ((req.src_port==110) || (req.src_port==143)) && true )
    return true;
  if ( (req.rule_ID_in==557) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==556) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==550) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==549) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==548) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==547) && (req.is_tcp) && ((req.src_port==110) || (req.src_port==143)) && true )
    return true;
  if ( (req.rule_ID_in==546) && (req.is_tcp) && ((req.src_port==110) || (req.src_port==143)) && true )
    return true;
  if ( (req.rule_ID_in==529) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==528) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==527) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==511) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==504) && (req.is_tcp) && src_port_is_http && true )
    return true;
  if ( (req.rule_ID_in==503) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==502) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==485) && (req.is_tcp) && ((req.src_port==110) || (req.src_port==143)) && true )
    return true;
  if ( (req.rule_ID_in==484) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==471) && (req.is_tcp) && ((req.src_port==110) || (req.src_port==143)) && true )
    return true;
  if ( (req.rule_ID_in==470) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==461) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==460) && (req.is_tcp) && ((req.src_port==110) || (req.src_port==143)) && true )
    return true;
  if ( (req.rule_ID_in==459) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==458) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==457) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==456) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==455) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==454) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==453) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==452) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==451) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==450) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==449) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==448) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==447) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==446) && (req.is_tcp) && ((req.src_port==110) || (req.src_port==143)) && true )
    return true;
  if ( (req.rule_ID_in==445) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==444) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==443) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==441) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==438) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==437) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==436) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==435) && (req.is_tcp) && ((req.src_port==110) || (req.src_port==143)) && true )
    return true;
  if ( (req.rule_ID_in==434) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==433) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==426) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==422) && (req.is_tcp) && ((req.src_port==110) || (req.src_port==143)) && true )
    return true;
  if ( (req.rule_ID_in==411) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==410) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==405) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==399) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==398) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==397) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==396) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==394) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==388) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==387) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==386) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==385) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==384) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==383) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==382) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==379) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==378) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==377) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==375) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==374) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==372) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==349) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==288) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==287) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==286) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==270) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==269) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==252) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==241) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==236) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==232) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==228) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==225) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==196) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==170) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==168) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==167) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==158) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==154) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==153) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==149) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==148) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==147) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==145) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==143) && (req.is_tcp) && (req.src_port==554) && true )
    return true;
  if ( (req.rule_ID_in==138) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==135) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==134) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==129) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==122) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==121) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==114) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==109) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==86) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==11) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==4) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==3) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==2) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==3427) && (req.is_tcp) && ((req.src_port==110) || (req.src_port==143)) && true )
    return true;
  if ( (req.rule_ID_in==3576) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==3575) && (req.is_tcp) && ((req.src_port==110) || (req.src_port==143)) && true )
    return true;
  if ( (req.rule_ID_in==3630) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==3624) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==3724) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==3750) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==3882) && (req.is_tcp) && true && true )
    return true;
  if ( (req.rule_ID_in==3947) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==4074) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==4275) && (req.is_tcp) && ((req.src_port==110) || (req.src_port==143)) && true )
    return true;
  if ( (req.rule_ID_in==4372) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==4370) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==4538) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==4537) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==4535) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==4534) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==4770) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==4829) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==4828) && (req.is_tcp) && ((req.src_port==110) || (req.src_port==143)) && true )
    return true;
  if ( (req.rule_ID_in==4854) && (req.is_tcp) && ((req.src_port==110) || (req.src_port==143)) && true )
    return true;
  if ( (req.rule_ID_in==4915) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==4914) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==5061) && (req.is_tcp) && ((req.src_port==110) || (req.src_port==143)) && true )
    return true;
  if ( (req.rule_ID_in==5091) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==5345) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==5355) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==5354) && (req.is_tcp) && ((req.src_port==110) || (req.src_port==143)) && true )
    return true;
  if ( (req.rule_ID_in==5370) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==5369) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==5465) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==5464) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==5599) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==5644) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==5705) && (req.is_tcp) && ((req.src_port==110) || (req.src_port==143)) && true )
    return true;
  if ( (req.rule_ID_in==6063) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==6062) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==6589) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==1358) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==2340) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==2339) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==3260) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==1280) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==3714) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==3830) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==3829) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==4507) && (req.is_tcp) && true && (dst_port_is_http || req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==4568) && (req.is_tcp) && true && (dst_port_is_http || req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==4567) && (req.is_tcp) && true && (dst_port_is_http || req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==4566) && (req.is_tcp) && true && (dst_port_is_http || req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==4587) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==4586) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==4612) && (req.is_tcp) && true && (dst_port_is_http || req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==4742) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==4987) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==5069) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==5117) && (req.is_tcp) && true && (dst_port_is_http || req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==5133) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==5159) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==5158) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==5277) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==5138) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==5343) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==5362) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==5466) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==5539) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==5551) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==5726) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==5731) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==5730) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==5755) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==5752) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==5744) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==5741) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==5921) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==6142) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==6268) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==6396) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==6403) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==6443) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==6442) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==6437) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==6436) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==6434) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==6433) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==6452) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==6444) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==6501) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==6536) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==7003) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==7070) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==7068) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==819) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==818) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==825) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==826) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==829) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==828) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==833) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==840) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==821) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==817) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==822) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==820) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==939) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==991) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==1119) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==1184) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==1302) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==1560) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==1569) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==1857) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==1957) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==1954) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==1953) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==2047) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==2468) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==2706) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==2705) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==2442) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==1856) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==1558) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==1535) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==1516) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==1465) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==1429) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==992) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==847) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==711) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==710) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==709) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==708) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==562) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==561) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==560) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==559) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==3633) && (req.is_tcp) && src_port_is_http && true )
    return true;
  if ( (req.rule_ID_in==3807) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==4233) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==6785) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==1102) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==1440) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==1902) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==2169) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==2241) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==2280) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==2471) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==2470) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==2469) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==3092) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==3303) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==510) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==133) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==3773) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==3877) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==3705) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==4302) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==4301) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==4357) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==4353) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==3703) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==3702) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==5152) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==5240) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==5543) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==5561) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==5557) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==5572) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==6350) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==6474) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==5198) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==5195) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==430) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==63) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==1182) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==1591) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==1590) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==1589) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==1588) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==1587) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==1580) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==1578) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==1679) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==2175) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==2174) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==2173) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==2172) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==2171) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==2170) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==2478) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==2477) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==2487) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==2585) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==2675) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==2798) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==2868) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==2866) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==2861) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==2906) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==3040) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==3037) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==3141) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==3252) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==3251) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==3249) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==3245) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==3244) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==3364) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==1770) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==1753) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==1752) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==1751) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==1750) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==1749) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==1014) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==862) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==815) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==814) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==802) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==712) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==619) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==598) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==597) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==596) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==595) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==251) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==157) && (req.is_tcp) && src_port_is_http && true )
    return true;
  if ( (req.rule_ID_in==3440) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==3439) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==3438) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==3519) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==3518) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==3559) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==3555) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==3549) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==3548) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==3604) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==3654) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==3650) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==3649) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==3648) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==3647) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==3646) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==3644) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==3755) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==3754) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==3753) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==3760) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==3782) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==3808) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==3797) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==3863) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==3862) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==3948) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==3945) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==3940) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==3939) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==3936) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==4026) && (req.is_tcp) && true && ((req.dst_port==139) || (req.dst_port==445)) )
    return true;
  if ( (req.rule_ID_in==4025) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==4024) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==4022) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==4021) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==4014) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==4012) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==4011) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==4010) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==4009) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==4003) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==4001) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==3998) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==4137) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==4133) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==4132) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==4131) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==4162) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==4214) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==4211) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==4210) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==4208) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==4207) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==4206) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==4202) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==4194) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==4193) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==4192) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==4243) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==4242) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==4241) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==4240) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==4327) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==4323) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==4320) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==4424) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==4420) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==4445) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==4464) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==4515) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==4637) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==4636) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==4679) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==4678) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==4677) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==4676) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==4705) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==4704) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==4703) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==4702) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==4701) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==4695) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==4793) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==4792) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==4790) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==4859) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==4855) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==4853) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==4848) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==4847) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==4846) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==4844) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==4843) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==4842) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==4909) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==4938) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==5014) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==5013) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==5012) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==5011) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==5010) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==5006) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==4999) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==4998) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==4995) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==4994) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==5086) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==5085) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==5084) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==5082) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==5081) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==5079) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==5076) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==5122) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==5238) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==5282) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==5280) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==5275) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==5116) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==4618) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==5336) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==5326) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==5324) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==5391) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==5442) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==5429) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==5536) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==5535) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==5478) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==5471) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==5073) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==5072) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==5071) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==5237) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==5537) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==5582) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==4706) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==5640) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==5639) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==5761) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==5788) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==5787) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==5784) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==5843) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==5857) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==5872) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==5903) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==5940) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==6019) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==6010) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==6004) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==6002) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==5999) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==5998) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==5997) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==5996) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==6125) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==6102) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==6101) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==6100) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==6098) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==6209) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==6237) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==6265) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==6339) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==6358) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==6546) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==6545) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==6544) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==6537) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==6550) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==6601) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==6742) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==6929) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==6928) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==6927) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==6926) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==6925) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==6924) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==6923) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==6922) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==6921) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==6920) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==6909) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==7211) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==7215) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==1012) && (req.is_tcp) && src_port_is_http && true )
    return true;
  if ( (req.rule_ID_in==1145) && (req.is_tcp) && src_port_is_http && true )
    return true;
  if ( (req.rule_ID_in==1202) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==364) && (req.is_tcp) && true && (req.dst_port==445) )
    return true;
  if ( (req.rule_ID_in==198) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==1678) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==1701) && (req.is_tcp) && src_port_is_http && true )
    return true;
  if ( (req.rule_ID_in==1766) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==1785) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==1947) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==1946) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==1951) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==2153) && (req.is_tcp) && true && dst_port_is_ftp )
    return true;
  if ( (req.rule_ID_in==2152) && (req.is_tcp) && true && (req.dst_port==20) )
    return true;
  if ( (req.rule_ID_in==2191) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==2600) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==2689) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==2717) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==2716) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==2715) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==2737) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==2736) && (req.is_tcp) && (req.src_port==445) && true )
    return true;
  if ( (req.rule_ID_in==2735) && (req.is_tcp) && (req.src_port==445) && true )
    return true;
  if ( (req.rule_ID_in==2809) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==2805) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==2832) && (req.is_tcp) && src_port_is_http && true )
    return true;
  if ( (req.rule_ID_in==2872) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==3083) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==3143) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==3142) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==3138) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==3360) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==3358) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==3355) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==3354) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==3353) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==3350) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==2242) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==610) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==3389) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==3387) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==3386) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==3593) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==3653) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==3652) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==3643) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==3642) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==3641) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==3640) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==3639) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==3749) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==3865) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==3874) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==3873) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==3943) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==3931) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==3978) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==4008) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==4165) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==4201) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==4247) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==4287) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==4281) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==4272) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==4307) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==4376) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==4427) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==4458) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==4506) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==4574) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==4643) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==4647) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==4681) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==4669) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==4921) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==5015) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==5008) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==5003) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==5002) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==5092) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==5083) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==5077) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==5214) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==5213) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==5208) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==5207) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==5206) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==5205) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==5248) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==5285) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==5265) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==5264) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==5172) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==5156) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==5041) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==4539) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==4536) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==3857) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==3800) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==3799) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==3798) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==5319) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==5318) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==5437) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==5479) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==3732) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==5335) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==5331) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==5153) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==5547) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==5538) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==5560) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==5552) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==5548) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==5579) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==5760) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==5743) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==5907) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==5923) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==5919) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==5931) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==5930) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==5929) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==5974) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==5994) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==6001) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==6000) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==6034) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==6155) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==6153) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==6149) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==6148) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==6146) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==6144) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==6143) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==6137) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==6135) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==6179) && (req.is_tcp) && src_port_is_http && true )
    return true;
  if ( (req.rule_ID_in==6210) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==6261) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==6269) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==6267) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==6266) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==6273) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==6292) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==6304) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==6321) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==6347) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==6334) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==6368) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==6367) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==6441) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==6440) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==6439) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==6438) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==6435) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==6430) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==6449) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==6482) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==6481) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==6475) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==6456) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==6500) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==6505) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==6603) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==6602) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==6597) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==6609) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==6606) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==6605) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==6613) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==6612) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==6632) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==6620) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==6619) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==6617) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==6616) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==6637) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==6636) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==6635) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==6633) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==6644) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==6726) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==6725) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==6727) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==6783) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==6796) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==6792) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==6791) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==6786) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==6799) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==6798) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==6890) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==7028) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==7063) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==7062) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==7061) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==7057) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==7052) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==7071) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==7069) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==7066) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==7064) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==5204) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==152) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==1037) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==1041) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==1038) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==1040) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==1034) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==1050) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==1058) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==1798) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==1797) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==1795) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==1793) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==1786) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==1903) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==2106) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==2107) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==2335) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==2333) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==2331) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==2329) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==2359) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==2358) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==2480) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==2494) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==2509) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==2627) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==2682) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==2744) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==2903) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==2897) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==2896) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==2895) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==2892) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==3378) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==1833) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==1832) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==1809) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==1808) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==1790) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==1693) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==1377) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==1274) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==1113) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==1112) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==497) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==409) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==3405) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==3404) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==3401) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==3400) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==3399) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==3398) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==3393) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==3392) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==3388) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==3413) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==3412) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==3431) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==3430) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==3470) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==3574) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==3573) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==3603) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==3602) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==3595) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==3613) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==3612) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==3620) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==3619) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==3623) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==3719) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==3727) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==3726) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==3722) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==4161) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==4160) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==4159) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==4173) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==4172) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==4171) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==4169) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==4168) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==4167) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==4176) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==4186) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==4185) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==4209) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==4195) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==4288) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==4360) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==4354) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==4524) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==4523) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==4518) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==4565) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==4564) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==4562) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==4561) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==4560) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==4557) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==4556) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==4555) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==4554) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==4553) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==4542) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==4575) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==4597) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==4592) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==4591) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==4588) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==4582) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==4580) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==4606) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==4614) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==4613) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==4610) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==4619) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==4685) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==4722) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==4718) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==4713) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==4709) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==4708) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==4734) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==4747) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==4746) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==4754) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==4761) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==4773) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==4805) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==4889) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==4932) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==4930) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==4937) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==4947) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==4946) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==4968) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==4967) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==4966) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==4965) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==4960) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==4978) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==4973) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==4972) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==4984) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==4983) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==5005) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==5034) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==5047) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==5123) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==5144) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==5143) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==5145) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==5160) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==5188) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==5070) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==5033) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==5338) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==5330) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==5356) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==5361) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==5357) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==5411) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==5406) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==5401) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==5445) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==5444) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==5443) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==5440) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==5430) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==5428) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==5450) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==5507) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==5136) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==5134) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==5542) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==5541) && (req.is_tcp) && true && true )
    return true;
  if ( (req.rule_ID_in==5540) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==5564) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==5563) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==5559) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==5553) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==5550) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==5549) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==5571) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==5569) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==5568) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==5575) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==5584) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==5585) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==5727) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==5754) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==5751) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==5750) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==5745) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==5742) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==5738) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==5764) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==5763) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==5935) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==5934) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==5933) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==5932) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==6016) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==6092) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==6154) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==6152) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==6151) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==6150) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==6145) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==6141) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==6140) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==6139) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==6136) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==6134) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==6133) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==6178) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==6270) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==6284) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==6320) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==6371) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==6384) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==6399) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==6398) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==6473) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==6472) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==6604) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==6598) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==6611) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==6610) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==6608) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==6629) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==6618) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==6634) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==6666) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==6655) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==6673) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==6678) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==6707) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==6706) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==6705) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==6704) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==6715) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==6714) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==6717) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==6721) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==6773) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==6772) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==6771) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==6769) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==6782) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==6781) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==6776) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==6775) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==6784) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==6797) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==6795) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==6794) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==6793) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==6790) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==6789) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==6788) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==6787) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==6807) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==6806) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==6805) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==6803) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==6802) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==6801) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==6800) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==6889) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==6897) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==7032) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==7031) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==7029) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==7060) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==7059) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==7058) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==7056) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==7051) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==7050) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==7048) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==7078) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==7067) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==7065) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==7095) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==7156) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==7155) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==5580) && (!req.is_tcp) && true && (req.dst_port==53) )
    return true;
  if ( (req.rule_ID_in==1144) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==2142) && (req.is_tcp) && src_port_is_http && true )
    return true;
  if ( (req.rule_ID_in==2141) && (req.is_tcp) && src_port_is_http && true )
    return true;
  if ( (req.rule_ID_in==2389) && (req.is_tcp) && src_port_is_http && true )
    return true;
  if ( (req.rule_ID_in==2463) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==2462) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==2461) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==2475) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==2912) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==2085) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==3564) && (req.is_tcp) && (req.src_port==448) && true )
    return true;
  if ( (req.rule_ID_in==3711) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==4797) && (req.is_tcp) && src_port_is_http && true )
    return true;
  if ( (req.rule_ID_in==5048) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==5728) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==5790) && (req.is_tcp) && src_port_is_http && true )
    return true;
  if ( (req.rule_ID_in==5789) && (req.is_tcp) && src_port_is_http && true )
    return true;
  if ( (req.rule_ID_in==5874) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==6374) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==6373) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==6864) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==6863) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==6900) && (req.is_tcp) && src_port_is_http && true )
    return true;
  if ( (req.rule_ID_in==7016) && (req.is_tcp) && (req.src_port==445) && true )
    return true;
  if ( (req.rule_ID_in==7015) && (req.is_tcp) && (req.src_port==445) && true )
    return true;
  if ( (req.rule_ID_in==7014) && (req.is_tcp) && (req.src_port==445) && true )
    return true;
  if ( (req.rule_ID_in==7013) && (req.is_tcp) && (req.src_port==389) && true )
    return true;
  if ( (req.rule_ID_in==7012) && (req.is_tcp) && ((req.src_port==25) || (req.src_port==587)) && true )
    return true;
  if ( (req.rule_ID_in==7011) && (req.is_tcp) && src_port_is_http && true )
    return true;
  if ( (req.rule_ID_in==7010) && (req.is_tcp) && src_port_is_http && true )
    return true;
  if ( (req.rule_ID_in==7009) && (req.is_tcp) && src_port_is_http && true )
    return true;
  if ( (req.rule_ID_in==7008) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==7007) && (req.is_tcp) && (req.src_port==443) && true )
    return true;
  if ( (req.rule_ID_in==7006) && (req.is_tcp) && src_port_is_http && true )
    return true;
  if ( (req.rule_ID_in==7005) && (req.is_tcp) && src_port_is_http && true )
    return true;
  if ( (req.rule_ID_in==7127) && (req.is_tcp) && (req.src_port==445) && true )
    return true;
  if ( (req.rule_ID_in==7126) && (req.is_tcp) && (req.src_port==110) && true )
    return true;
  if ( (req.rule_ID_in==7164) && (req.is_tcp) && (req.src_port==445) && true )
    return true;
  if ( (req.rule_ID_in==7163) && (req.is_tcp) && true && (req.dst_port==445) )
    return true;
  if ( (req.rule_ID_in==7162) && (req.is_tcp) && true && (req.dst_port==445) )
    return true;
  if ( (req.rule_ID_in==7161) && (req.is_tcp) && (req.src_port==445) && true )
    return true;
  if ( (req.rule_ID_in==7160) && (req.is_tcp) && true && (req.dst_port==445) )
    return true;
  if ( (req.rule_ID_in==7183) && (req.is_tcp) && true && true )
    return true;
  if ( (req.rule_ID_in==1035) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==1036) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==1069) && (req.is_tcp) && src_port_is_http && true )
    return true;
  if ( (req.rule_ID_in==1166) && (req.is_tcp) && src_port_is_http && true )
    return true;
  if ( (req.rule_ID_in==1172) && (req.is_tcp) && src_port_is_http && true )
    return true;
  if ( (req.rule_ID_in==1218) && (req.is_tcp) && src_port_is_http && true )
    return true;
  if ( (req.rule_ID_in==1230) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==1428) && (req.is_tcp) && src_port_is_http && true )
    return true;
  if ( (req.rule_ID_in==1482) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==1553) && (req.is_tcp) && src_port_is_http && true )
    return true;
  if ( (req.rule_ID_in==1552) && (req.is_tcp) && src_port_is_http && true )
    return true;
  if ( (req.rule_ID_in==1621) && (req.is_tcp) && src_port_is_http && true )
    return true;
  if ( (req.rule_ID_in==1645) && (req.is_tcp) && src_port_is_http && true )
    return true;
  if ( (req.rule_ID_in==1644) && (req.is_tcp) && src_port_is_http && true )
    return true;
  if ( (req.rule_ID_in==1716) && (req.is_tcp) && src_port_is_http && true )
    return true;
  if ( (req.rule_ID_in==1715) && (req.is_tcp) && src_port_is_http && true )
    return true;
  if ( (req.rule_ID_in==1737) && (req.is_tcp) && src_port_is_http && true )
    return true;
  if ( (req.rule_ID_in==1736) && (req.is_tcp) && src_port_is_http && true )
    return true;
  if ( (req.rule_ID_in==1735) && (req.is_tcp) && src_port_is_http && true )
    return true;
  if ( (req.rule_ID_in==1825) && (req.is_tcp) && src_port_is_http && true )
    return true;
  if ( (req.rule_ID_in==1824) && (req.is_tcp) && src_port_is_http && true )
    return true;
  if ( (req.rule_ID_in==1860) && (req.is_tcp) && src_port_is_http && true )
    return true;
  if ( (req.rule_ID_in==1950) && (req.is_tcp) && src_port_is_http && true )
    return true;
  if ( (req.rule_ID_in==1952) && (req.is_tcp) && src_port_is_http && true )
    return true;
  if ( (req.rule_ID_in==2034) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==5491) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==5453) && (req.is_tcp) && true && true )
    return true;
  if ( (req.rule_ID_in==5598) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==5922) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==6525) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==2025) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==5249) && (!req.is_tcp) && true && (req.dst_port==69) )
    return true;
  if ( (req.rule_ID_in==6906) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==1355) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==1276) && (req.is_tcp) && true && true )
    return true;
  if ( (req.rule_ID_in==1265) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==1208) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==1207) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==1206) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==965) && (req.is_tcp) && true && (req.dst_port==7777) )
    return true;
  if ( (req.rule_ID_in==904) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==839) && (req.is_tcp) && true && (req.dst_port==443) )
    return true;
  if ( (req.rule_ID_in==838) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==837) && (req.is_tcp) && true && (req.dst_port==443) )
    return true;
  if ( (req.rule_ID_in==836) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==718) && (req.is_tcp) && true && (req.dst_port==80) )
    return true;
  if ( (req.rule_ID_in==653) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==633) && (req.is_tcp) && true && (req.dst_port==5447) )
    return true;
  if ( (req.rule_ID_in==632) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==536) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==323) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==189) && (req.is_tcp) && true && (req.dst_port==7777) )
    return true;
  if ( (req.rule_ID_in==188) && (req.is_tcp) && true && (req.dst_port==7777) )
    return true;
  if ( (req.rule_ID_in==187) && (req.is_tcp) && true && (req.dst_port==7777) )
    return true;
  if ( (req.rule_ID_in==132) && (req.is_tcp) && true && true )
    return true;
  if ( (req.rule_ID_in==125) && (req.is_tcp) && true && true )
    return true;
  if ( (req.rule_ID_in==118) && (req.is_tcp) && true && true )
    return true;
  if ( (req.rule_ID_in==117) && (req.is_tcp) && true && true )
    return true;
  if ( (req.rule_ID_in==116) && (req.is_tcp) && true && true )
    return true;
  if ( (req.rule_ID_in==113) && (req.is_tcp) && true && true )
    return true;
  if ( (req.rule_ID_in==112) && (req.is_tcp) && true && true )
    return true;
  if ( (req.rule_ID_in==111) && (req.is_tcp) && true && true )
    return true;
  if ( (req.rule_ID_in==110) && (req.is_tcp) && true && true )
    return true;
  if ( (req.rule_ID_in==108) && (req.is_tcp) && true && true )
    return true;
  if ( (req.rule_ID_in==107) && (req.is_tcp) && true && true )
    return true;
  if ( (req.rule_ID_in==106) && (req.is_tcp) && true && true )
    return true;
  if ( (req.rule_ID_in==105) && (req.is_tcp) && true && true )
    return true;
  if ( (req.rule_ID_in==104) && (req.is_tcp) && true && true )
    return true;
  if ( (req.rule_ID_in==101) && (req.is_tcp) && true && (req.dst_port==1357) )
    return true;
  if ( (req.rule_ID_in==100) && (req.is_tcp) && (req.src_port==503) && true )
    return true;
  if ( (req.rule_ID_in==99) && (req.is_tcp) && true && (req.dst_port==503) )
    return true;
  if ( (req.rule_ID_in==98) && (req.is_tcp) && true && (req.dst_port==501) )
    return true;
  if ( (req.rule_ID_in==97) && (req.is_tcp) && (req.src_port==500) && true )
    return true;
  if ( (req.rule_ID_in==96) && (req.is_tcp) && true && true )
    return true;
  if ( (req.rule_ID_in==95) && (req.is_tcp) && true && (req.dst_port==54320) )
    return true;
  if ( (req.rule_ID_in==94) && (req.is_tcp) && true && true )
    return true;
  if ( (req.rule_ID_in==93) && (req.is_tcp) && true && (req.dst_port==443) )
    return true;
  if ( (req.rule_ID_in==88) && (req.is_tcp) && true && (req.dst_port==58008) )
    return true;
  if ( (req.rule_ID_in==85) && (req.is_tcp) && (req.src_port==5712) && true )
    return true;
  if ( (req.rule_ID_in==84) && (req.is_tcp) && true && (req.dst_port==12667) )
    return true;
  if ( (req.rule_ID_in==83) && (req.is_tcp) && true && (req.dst_port==3132) )
    return true;
  if ( (req.rule_ID_in==82) && (req.is_tcp) && true && (req.dst_port==5600) )
    return true;
  if ( (req.rule_ID_in==81) && (req.is_tcp) && true && true )
    return true;
  if ( (req.rule_ID_in==78) && (req.is_tcp) && true && true )
    return true;
  if ( (req.rule_ID_in==77) && (req.is_tcp) && true && true )
    return true;
  if ( (req.rule_ID_in==60) && (req.is_tcp) && true && (req.dst_port==6666) )
    return true;
  if ( (req.rule_ID_in==59) && (req.is_tcp) && (req.src_port==877) && (req.dst_port==876) )
    return true;
  if ( (req.rule_ID_in==58) && (req.is_tcp) && true && true )
    return true;
  if ( (req.rule_ID_in==38) && (req.is_tcp) && true && true )
    return true;
  if ( (req.rule_ID_in==37) && (req.is_tcp) && true && true )
    return true;
  if ( (req.rule_ID_in==36) && (req.is_tcp) && true && true )
    return true;
  if ( (req.rule_ID_in==35) && (req.is_tcp) && (req.src_port==777) && true )
    return true;
  if ( (req.rule_ID_in==34) && (req.is_tcp) && (req.src_port==30029) && true )
    return true;
  if ( (req.rule_ID_in==33) && (req.is_tcp) && true && (req.dst_port==30029) )
    return true;
  if ( (req.rule_ID_in==32) && (req.is_tcp) && true && (req.dst_port==1480) )
    return true;
  if ( (req.rule_ID_in==31) && (req.is_tcp) && true && (req.dst_port==1480) )
    return true;
  if ( (req.rule_ID_in==30) && (req.is_tcp) && true && (req.dst_port==1480) )
    return true;
  if ( (req.rule_ID_in==29) && (req.is_tcp) && true && (req.dst_port==1480) )
    return true;
  if ( (req.rule_ID_in==28) && (req.is_tcp) && (req.src_port==5555) && true )
    return true;
  if ( (req.rule_ID_in==26) && (req.is_tcp) && true && true )
    return true;
  if ( (req.rule_ID_in==25) && (req.is_tcp) && true && true )
    return true;
  if ( (req.rule_ID_in==24) && (req.is_tcp) && true && true )
    return true;
  if ( (req.rule_ID_in==23) && (req.is_tcp) && true && true )
    return true;
  if ( (req.rule_ID_in==22) && (req.is_tcp) && true && true )
    return true;
  if ( (req.rule_ID_in==21) && (req.is_tcp) && true && (req.dst_port>=1024) )
    return true;
  if ( (req.rule_ID_in==6) && (req.is_tcp) && true && (req.dst_port==5880) )
    return true;
  if ( (req.rule_ID_in==5) && (req.is_tcp) && (req.src_port==5880) && true )
    return true;
  if ( (req.rule_ID_in==1913) && (req.is_tcp) && true && (req.dst_port==2533) )
    return true;
  if ( (req.rule_ID_in==2299) && (req.is_tcp) && true && true )
    return true;
  if ( (req.rule_ID_in==2483) && (req.is_tcp) && true && true )
    return true;
  if ( (req.rule_ID_in==2482) && (req.is_tcp) && true && true )
    return true;
  if ( (req.rule_ID_in==2530) && (req.is_tcp) && true && (req.dst_port==443) )
    return true;
  if ( (req.rule_ID_in==2616) && (req.is_tcp) && true && true )
    return true;
  if ( (req.rule_ID_in==2615) && (req.is_tcp) && true && true )
    return true;
  if ( (req.rule_ID_in==2646) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==2661) && (req.is_tcp) && true && (req.dst_port==58273) )
    return true;
  if ( (req.rule_ID_in==2660) && (req.is_tcp) && true && (req.dst_port==53629) )
    return true;
  if ( (req.rule_ID_in==2712) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==2711) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==2710) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==3162) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==3611) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==3614) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==3721) && (req.is_tcp) && true && (req.dst_port==80) )
    return true;
  if ( (req.rule_ID_in==3720) && (req.is_tcp) && (req.src_port==80) && true )
    return true;
  if ( (req.rule_ID_in==4163) && (req.is_tcp) && true && true )
    return true;
  if ( (req.rule_ID_in==4379) && (req.is_tcp) && src_port_is_http && true )
    return true;
  if ( (req.rule_ID_in==4378) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==4377) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==4502) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==4501) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==4500) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==4499) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==4498) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==4497) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==4496) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==4495) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==4494) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==4493) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==4492) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==4491) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==4490) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==4489) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==4488) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==4487) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==4486) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==4485) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==4484) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==4483) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==4482) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==4605) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==4604) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==5944) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==5971) && (req.is_tcp) && true && true )
    return true;
  if ( (req.rule_ID_in==7166) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==7165) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==7180) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==7179) && (req.is_tcp) && src_port_is_http && true )
    return true;
  if ( (req.rule_ID_in==220) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==297) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==305) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==311) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==307) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==306) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==304) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==308) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==310) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==309) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==303) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==331) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==337) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==726) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==1030) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==1031) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==1027) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==1033) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==1032) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==1028) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==1029) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==2125) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==2479) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==2510) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==2592) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==2591) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==2590) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==2613) && (req.is_tcp) && (req.src_port==443) && true )
    return true;
  if ( (req.rule_ID_in==2612) && (req.is_tcp) && (req.src_port==443) && true )
    return true;
  if ( (req.rule_ID_in==2611) && (req.is_tcp) && (req.src_port==443) && true )
    return true;
  if ( (req.rule_ID_in==2610) && (req.is_tcp) && (req.src_port==443) && true )
    return true;
  if ( (req.rule_ID_in==2609) && (req.is_tcp) && (req.src_port==443) && true )
    return true;
  if ( (req.rule_ID_in==2608) && (req.is_tcp) && (req.src_port==443) && true )
    return true;
  if ( (req.rule_ID_in==2607) && (req.is_tcp) && (req.src_port==443) && true )
    return true;
  if ( (req.rule_ID_in==2606) && (req.is_tcp) && (req.src_port==443) && true )
    return true;
  if ( (req.rule_ID_in==2605) && (req.is_tcp) && (req.src_port==443) && true )
    return true;
  if ( (req.rule_ID_in==2604) && (req.is_tcp) && (req.src_port==443) && true )
    return true;
  if ( (req.rule_ID_in==3105) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==3314) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==3464) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==3778) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==5426) && (req.is_tcp) && true && (req.dst_port==53) )
    return true;
  if ( (req.rule_ID_in==14) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==18) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==197) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==244) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==248) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==247) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==271) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==295) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==294) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==300) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==324) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==345) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==348) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==347) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==356) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==355) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==354) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==359) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==366) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==373) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==487) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==486) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==490) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==488) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==501) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==508) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==522) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==526) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==524) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==525) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==544) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==555) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==553) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==625) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==658) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==678) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==734) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==804) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==880) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==879) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==912) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==932) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==929) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==931) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==963) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==990) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==1004) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==1003) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==1043) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==1194) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==1242) && (req.is_tcp) && true && (req.dst_port==443) )
    return true;
  if ( (req.rule_ID_in==1253) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==1256) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==1298) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==1291) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==1290) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==1332) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==1477) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==1546) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==1545) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==1596) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==1717) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==1774) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==1836) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==1840) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==1839) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==1945) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==1941) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==1937) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==1931) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==1989) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==1981) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==1998) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==2060) && (req.is_tcp) && true && (req.dst_port==80) )
    return true;
  if ( (req.rule_ID_in==2059) && (req.is_tcp) && true && (req.dst_port==80) )
    return true;
  if ( (req.rule_ID_in==2079) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==2086) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==2184) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==2193) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==2220) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==2219) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==2215) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==2212) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==2229) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==2227) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==2236) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==2356) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==2366) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==2375) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==2396) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==2448) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==2603) && (req.is_tcp) && true && true )
    return true;
  if ( (req.rule_ID_in==2602) && (req.is_tcp) && true && true )
    return true;
  if ( (req.rule_ID_in==2631) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==2649) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==2644) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==2728) && (req.is_tcp) && true && true )
    return true;
  if ( (req.rule_ID_in==2727) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==2742) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==2790) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==2767) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==2924) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==2923) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==2922) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==2932) && (req.is_tcp) && true && true )
    return true;
  if ( (req.rule_ID_in==2971) && (req.is_tcp) && true && true )
    return true;
  if ( (req.rule_ID_in==3001) && (req.is_tcp) && true && true )
    return true;
  if ( (req.rule_ID_in==3000) && (req.is_tcp) && true && true )
    return true;
  if ( (req.rule_ID_in==2999) && (req.is_tcp) && true && true )
    return true;
  if ( (req.rule_ID_in==2998) && (req.is_tcp) && true && true )
    return true;
  if ( (req.rule_ID_in==2997) && (req.is_tcp) && true && true )
    return true;
  if ( (req.rule_ID_in==2996) && (req.is_tcp) && true && true )
    return true;
  if ( (req.rule_ID_in==2995) && (req.is_tcp) && true && true )
    return true;
  if ( (req.rule_ID_in==2994) && (req.is_tcp) && true && true )
    return true;
  if ( (req.rule_ID_in==2993) && (req.is_tcp) && true && true )
    return true;
  if ( (req.rule_ID_in==2992) && (req.is_tcp) && true && true )
    return true;
  if ( (req.rule_ID_in==2991) && (req.is_tcp) && true && true )
    return true;
  if ( (req.rule_ID_in==2990) && (req.is_tcp) && true && true )
    return true;
  if ( (req.rule_ID_in==2989) && (req.is_tcp) && true && true )
    return true;
  if ( (req.rule_ID_in==2988) && (req.is_tcp) && true && true )
    return true;
  if ( (req.rule_ID_in==2987) && (req.is_tcp) && true && true )
    return true;
  if ( (req.rule_ID_in==2986) && (req.is_tcp) && true && true )
    return true;
  if ( (req.rule_ID_in==2985) && (req.is_tcp) && true && true )
    return true;
  if ( (req.rule_ID_in==2984) && (req.is_tcp) && true && true )
    return true;
  if ( (req.rule_ID_in==2983) && (req.is_tcp) && true && true )
    return true;
  if ( (req.rule_ID_in==3109) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==3106) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==3124) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==3129) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==3164) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==3178) && (req.is_tcp) && true && (dst_port_is_http || req.dst_port==6969) )
    return true;
  if ( (req.rule_ID_in==3189) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==3186) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==1077) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==3419) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==3468) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==3599) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==3701) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==4361) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==4371) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==4577) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==4576) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==4749) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==4808) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==4840) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==4883) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==4882) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==4878) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==4891) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==4986) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==4985) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==5017) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==5040) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==5036) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==5057) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==5056) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==5142) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==5173) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==5169) && (req.is_tcp) && true && (req.dst_port==443) )
    return true;
  if ( (req.rule_ID_in==5216) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==5291) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==5290) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==5387) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==5425) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==5419) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==5418) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==5417) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==5435) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==5486) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==5595) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==5594) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==5608) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==5618) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==5643) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==5695) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==5694) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==5732) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==5767) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==5807) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==5806) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==3919) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==930) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==1402) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==1401) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==1400) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==1392) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==1391) && (req.is_tcp) && true && (dst_port_is_http || req.dst_port==88) )
    return true;
  if ( (req.rule_ID_in==1388) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==1387) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==1386) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==1385) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==1384) && (req.is_tcp) && (src_port_is_http || (req.src_port==8264) || (req.src_port==8500)) && true )
    return true;
  if ( (req.rule_ID_in==1383) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==1380) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==1379) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==1376) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==1374) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==1354) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==1353) && (req.is_tcp) && src_port_is_http && true )
    return true;
  if ( (req.rule_ID_in==1350) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==1349) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==1348) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==1347) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==1346) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==1345) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==1340) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==1339) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==1338) && (req.is_tcp) && src_port_is_http && true )
    return true;
  if ( (req.rule_ID_in==1337) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==1336) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==1335) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==1331) && (req.is_tcp) && src_port_is_http && true )
    return true;
  if ( (req.rule_ID_in==1330) && (req.is_tcp) && src_port_is_http && true )
    return true;
  if ( (req.rule_ID_in==1329) && (req.is_tcp) && src_port_is_http && true )
    return true;
  if ( (req.rule_ID_in==1328) && (req.is_tcp) && src_port_is_http && true )
    return true;
  if ( (req.rule_ID_in==1327) && (req.is_tcp) && src_port_is_http && true )
    return true;
  if ( (req.rule_ID_in==1326) && (req.is_tcp) && src_port_is_http && true )
    return true;
  if ( (req.rule_ID_in==1325) && (req.is_tcp) && src_port_is_http && true )
    return true;
  if ( (req.rule_ID_in==1324) && (req.is_tcp) && src_port_is_http && true )
    return true;
  if ( (req.rule_ID_in==1323) && (req.is_tcp) && src_port_is_http && true )
    return true;
  if ( (req.rule_ID_in==1322) && (req.is_tcp) && src_port_is_http && true )
    return true;
  if ( (req.rule_ID_in==1321) && (req.is_tcp) && src_port_is_http && true )
    return true;
  if ( (req.rule_ID_in==1320) && (req.is_tcp) && src_port_is_http && true )
    return true;
  if ( (req.rule_ID_in==1319) && (req.is_tcp) && src_port_is_http && true )
    return true;
  if ( (req.rule_ID_in==1318) && (req.is_tcp) && src_port_is_http && true )
    return true;
  if ( (req.rule_ID_in==1317) && (req.is_tcp) && src_port_is_http && true )
    return true;
  if ( (req.rule_ID_in==1316) && (req.is_tcp) && src_port_is_http && true )
    return true;
  if ( (req.rule_ID_in==1315) && (req.is_tcp) && src_port_is_http && true )
    return true;
  if ( (req.rule_ID_in==1314) && (req.is_tcp) && src_port_is_http && true )
    return true;
  if ( (req.rule_ID_in==1313) && (req.is_tcp) && src_port_is_http && true )
    return true;
  if ( (req.rule_ID_in==1312) && (req.is_tcp) && src_port_is_http && true )
    return true;
  if ( (req.rule_ID_in==1311) && (req.is_tcp) && src_port_is_http && true )
    return true;
  if ( (req.rule_ID_in==1310) && (req.is_tcp) && src_port_is_http && true )
    return true;
  if ( (req.rule_ID_in==1309) && (req.is_tcp) && src_port_is_http && true )
    return true;
  if ( (req.rule_ID_in==1308) && (req.is_tcp) && src_port_is_http && true )
    return true;
  if ( (req.rule_ID_in==1307) && (req.is_tcp) && src_port_is_http && true )
    return true;
  if ( (req.rule_ID_in==1306) && (req.is_tcp) && src_port_is_http && true )
    return true;
  if ( (req.rule_ID_in==1305) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==1304) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==1303) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==1301) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==1300) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==1299) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==1296) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==1295) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==1294) && (req.is_tcp) && true && (req.dst_port==250) )
    return true;
  if ( (req.rule_ID_in==1293) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==1289) && (req.is_tcp) && true && true )
    return true;
  if ( (req.rule_ID_in==1288) && (req.is_tcp) && src_port_is_http && true )
    return true;
  if ( (req.rule_ID_in==1287) && (req.is_tcp) && src_port_is_http && true )
    return true;
  if ( (req.rule_ID_in==1286) && (req.is_tcp) && src_port_is_http && true )
    return true;
  if ( (req.rule_ID_in==1285) && (req.is_tcp) && src_port_is_http && true )
    return true;
  if ( (req.rule_ID_in==1284) && (req.is_tcp) && src_port_is_http && true )
    return true;
  if ( (req.rule_ID_in==1278) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==1277) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==1266) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==1264) && (req.is_tcp) && true && true )
    return true;
  if ( (req.rule_ID_in==1263) && (req.is_tcp) && true && (req.dst_port==443) )
    return true;
  if ( (req.rule_ID_in==1262) && (req.is_tcp) && true && true )
    return true;
  if ( (req.rule_ID_in==1261) && (req.is_tcp) && true && true )
    return true;
  if ( (req.rule_ID_in==1260) && (req.is_tcp) && true && true )
    return true;
  if ( (req.rule_ID_in==1254) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==1234) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==1221) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==1220) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==1209) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==1205) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==1200) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==1188) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==1186) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==1185) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==1174) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==1173) && (req.is_tcp) && true && true )
    return true;
  if ( (req.rule_ID_in==1164) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==1162) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==1143) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==1142) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==1139) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==1138) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==1132) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==1128) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==1127) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==1118) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==1110) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==1092) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==1091) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==1085) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==1084) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==1083) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==1082) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==1081) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==1080) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==1079) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==1078) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==1076) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==1075) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==1074) && (req.is_tcp) && true && (req.dst_port==8899) )
    return true;
  if ( (req.rule_ID_in==1073) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==1070) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==1061) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==1060) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==1059) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==1054) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==1053) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==1046) && (req.is_tcp) && true && (req.dst_port==443) )
    return true;
  if ( (req.rule_ID_in==1045) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==1044) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==1042) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==1039) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==1019) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==1011) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==1010) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==1009) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==1008) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==1007) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==1005) && (req.is_tcp) && true && ((req.dst_port==110) || (req.dst_port==8080)) )
    return true;
  if ( (req.rule_ID_in==1001) && (req.is_tcp) && true && true )
    return true;
  if ( (req.rule_ID_in==1000) && (req.is_tcp) && true && true )
    return true;
  if ( (req.rule_ID_in==999) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==989) && (req.is_tcp) && true && true )
    return true;
  if ( (req.rule_ID_in==984) && (req.is_tcp) && src_port_is_http && true )
    return true;
  if ( (req.rule_ID_in==979) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==978) && (req.is_tcp) && true && true )
    return true;
  if ( (req.rule_ID_in==977) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==976) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==975) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==974) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==968) && (req.is_tcp) && true && ((req.dst_port>=1024) && (req.dst_port<=65535)) )
    return true;
  if ( (req.rule_ID_in==966) && (req.is_tcp) && true && ((req.dst_port>=1024) && (req.dst_port<=65535)) )
    return true;
  if ( (req.rule_ID_in==955) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==954) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==951) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==950) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==928) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==911) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==910) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==908) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==907) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==906) && (req.is_tcp) && (req.src_port==406) && true )
    return true;
  if ( (req.rule_ID_in==905) && (req.is_tcp) && true && (req.dst_port==406) )
    return true;
  if ( (req.rule_ID_in==903) && (req.is_tcp) && true && (req.dst_port==81) )
    return true;
  if ( (req.rule_ID_in==901) && (req.is_tcp) && true && (req.dst_port==443) )
    return true;
  if ( (req.rule_ID_in==899) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==898) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==897) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==896) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==895) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==894) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==893) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==892) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==890) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==878) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==877) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==876) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==872) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==871) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==870) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==869) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==868) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==867) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==855) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==853) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==852) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==851) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==849) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==845) && (req.is_tcp) && src_port_is_http && true )
    return true;
  if ( (req.rule_ID_in==844) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==827) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==816) && (req.is_tcp) && true && true )
    return true;
  if ( (req.rule_ID_in==813) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==812) && (req.is_tcp) && true && (req.dst_port==1433) )
    return true;
  if ( (req.rule_ID_in==811) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==809) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==808) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==807) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==806) && (req.is_tcp) && true && (req.dst_port==443) )
    return true;
  if ( (req.rule_ID_in==805) && (req.is_tcp) && true && ((req.dst_port==25) || (req.dst_port==587)) )
    return true;
  if ( (req.rule_ID_in==803) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==799) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==791) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==738) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==737) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==735) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==731) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==729) && (!req.is_tcp) && true && (req.dst_port==53) )
    return true;
  if ( (req.rule_ID_in==725) && (req.is_tcp) && src_port_is_http && true )
    return true;
  if ( (req.rule_ID_in==724) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==722) && (req.is_tcp) && true && (req.dst_port==1001) )
    return true;
  if ( (req.rule_ID_in==721) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==719) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==717) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==716) && (req.is_tcp) && true && (req.dst_port==2011) )
    return true;
  if ( (req.rule_ID_in==715) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==707) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==706) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==705) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==704) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==703) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==684) && (req.is_tcp) && true && (req.dst_port==21) )
    return true;
  if ( (req.rule_ID_in==682) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==681) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==679) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==657) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==656) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==655) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==654) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==650) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==649) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==648) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==647) && (req.is_tcp) && true && true )
    return true;
  if ( (req.rule_ID_in==646) && (req.is_tcp) && true && (req.dst_port==21) )
    return true;
  if ( (req.rule_ID_in==643) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==636) && (req.is_tcp) && true && (req.dst_port>=1024) )
    return true;
  if ( (req.rule_ID_in==635) && (req.is_tcp) && src_port_is_http && true )
    return true;
  if ( (req.rule_ID_in==634) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==629) && (req.is_tcp) && true && (dst_port_is_http || (req.dst_port>=1024)) )
    return true;
  if ( (req.rule_ID_in==628) && (req.is_tcp) && true && (dst_port_is_http || (req.dst_port>=1024)) )
    return true;
  if ( (req.rule_ID_in==622) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==621) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==620) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==615) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==594) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==593) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==592) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==591) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==590) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==589) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==554) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==552) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==551) && (req.is_tcp) && src_port_is_http && true )
    return true;
  if ( (req.rule_ID_in==545) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==540) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==539) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==538) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==537) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==535) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==534) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==521) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==520) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==519) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==518) && (req.is_tcp) && src_port_is_http && true )
    return true;
  if ( (req.rule_ID_in==517) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==515) && (req.is_tcp) && src_port_is_http && true )
    return true;
  if ( (req.rule_ID_in==514) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==513) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==512) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==507) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==506) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==500) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==496) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==495) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==494) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==493) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==492) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==491) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==489) && (req.is_tcp) && true && (req.dst_port==4455) )
    return true;
  if ( (req.rule_ID_in==468) && (req.is_tcp) && (req.src_port==443) && true )
    return true;
  if ( (req.rule_ID_in==442) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==423) && (req.is_tcp) && true && (req.dst_port==443) )
    return true;
  if ( (req.rule_ID_in==417) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==416) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==415) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==414) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==413) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==404) && (req.is_tcp) && true && (req.dst_port==22292) )
    return true;
  if ( (req.rule_ID_in==371) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==370) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==367) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==365) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==363) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==362) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==361) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==360) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==353) && (req.is_tcp) && true && true )
    return true;
  if ( (req.rule_ID_in==352) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==351) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==350) && (req.is_tcp) && true && (req.dst_port==12080) )
    return true;
  if ( (req.rule_ID_in==346) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==343) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==342) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==341) && (req.is_tcp) && true && true )
    return true;
  if ( (req.rule_ID_in==340) && (req.is_tcp) && true && true )
    return true;
  if ( (req.rule_ID_in==339) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==336) && (req.is_tcp) && true && (req.dst_port>=1024) )
    return true;
  if ( (req.rule_ID_in==333) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==332) && (req.is_tcp) && true && (req.dst_port==6667) )
    return true;
  if ( (req.rule_ID_in==330) && (req.is_tcp) && true && (req.dst_port==3070) )
    return true;
  if ( (req.rule_ID_in==329) && (!req.is_tcp) && true && (req.dst_port==9023) )
    return true;
  if ( (req.rule_ID_in==328) && (!req.is_tcp) && true && (req.dst_port==9023) )
    return true;
  if ( (req.rule_ID_in==327) && (req.is_tcp) && true && (req.dst_port>=1024) )
    return true;
  if ( (req.rule_ID_in==326) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==325) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==322) && (req.is_tcp) && true && true )
    return true;
  if ( (req.rule_ID_in==321) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==320) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==319) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==318) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==317) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==316) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==315) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==314) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==313) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==312) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==302) && (req.is_tcp) && true && (req.dst_port==8080) )
    return true;
  if ( (req.rule_ID_in==301) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==299) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==298) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==296) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==290) && (req.is_tcp) && true && (req.dst_port==6667) )
    return true;
  if ( (req.rule_ID_in==289) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==284) && (req.is_tcp) && true && (req.dst_port>=1024) )
    return true;
  if ( (req.rule_ID_in==283) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==282) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==281) && (req.is_tcp) && true && (req.dst_port==1868) )
    return true;
  if ( (req.rule_ID_in==280) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==279) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==268) && (req.is_tcp) && true && (req.dst_port==99) )
    return true;
  if ( (req.rule_ID_in==267) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==266) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==265) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==264) && (req.is_tcp) && true && (req.dst_port>=1024) )
    return true;
  if ( (req.rule_ID_in==263) && (req.is_tcp) && true && (req.dst_port==143) )
    return true;
  if ( (req.rule_ID_in==262) && (req.is_tcp) && true && ((req.dst_port>=6666) && (req.dst_port<=6667)) )
    return true;
  if ( (req.rule_ID_in==261) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==260) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==259) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==258) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==257) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==256) && (req.is_tcp) && true && (req.dst_port>=1024) )
    return true;
  if ( (req.rule_ID_in==255) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==254) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==253) && (req.is_tcp) && true && (req.dst_port==80) )
    return true;
  if ( (req.rule_ID_in==250) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==243) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==242) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==227) && (req.is_tcp) && src_port_is_http && true )
    return true;
  if ( (req.rule_ID_in==226) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==219) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==218) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==217) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==216) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==215) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==214) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==213) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==212) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==211) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==210) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==209) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==208) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==207) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==206) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==203) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==202) && (!req.is_tcp) && true && (req.dst_port==53) )
    return true;
  if ( (req.rule_ID_in==200) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==195) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==194) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==193) && (req.is_tcp) && true && (req.dst_port==7382) )
    return true;
  if ( (req.rule_ID_in==192) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==191) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==190) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==186) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==185) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==181) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==178) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==176) && (req.is_tcp) && true && (req.dst_port==443) )
    return true;
  if ( (req.rule_ID_in==175) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==174) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==173) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==172) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==169) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==166) && (req.is_tcp) && (req.src_port==27374) && true )
    return true;
  if ( (req.rule_ID_in==165) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==163) && (req.is_tcp) && src_port_is_http && true )
    return true;
  if ( (req.rule_ID_in==162) && (req.is_tcp) && src_port_is_http && true )
    return true;
  if ( (req.rule_ID_in==161) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==160) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==156) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==146) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==80) && (req.is_tcp) && true && (req.dst_port==80) )
    return true;
  if ( (req.rule_ID_in==79) && (!req.is_tcp) && (req.src_port==7871) && true )
    return true;
  if ( (req.rule_ID_in==75) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==74) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==73) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==72) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==71) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==66) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==65) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==39) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==1411) && (req.is_tcp) && true && true )
    return true;
  if ( (req.rule_ID_in==1410) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==1409) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==1408) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==1406) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==1404) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==1438) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==1425) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==1423) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==1421) && (req.is_tcp) && true && (req.dst_port==3337) )
    return true;
  if ( (req.rule_ID_in==1416) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==1415) && (req.is_tcp) && src_port_is_http && true )
    return true;
  if ( (req.rule_ID_in==1414) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==1413) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==1412) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==1445) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==1466) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==1476) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==1496) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==1493) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==1492) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==1491) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==1490) && (req.is_tcp) && src_port_is_http && true )
    return true;
  if ( (req.rule_ID_in==1487) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==1498) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==1506) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==1522) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==1521) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==1520) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==1519) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==1518) && (req.is_tcp) && true && (dst_port_is_http || req.dst_port==443) )
    return true;
  if ( (req.rule_ID_in==1517) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==1536) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==1534) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==1533) && (req.is_tcp) && true && (req.dst_port==1314) )
    return true;
  if ( (req.rule_ID_in==1532) && (req.is_tcp) && true && (req.dst_port==1314) )
    return true;
  if ( (req.rule_ID_in==1531) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==1530) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==1529) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==1528) && (req.is_tcp) && true && (req.dst_port==1122) )
    return true;
  if ( (req.rule_ID_in==1527) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==1526) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==1525) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==1524) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==1523) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==1537) && (req.is_tcp) && true && (dst_port_is_http || req.dst_port==443) )
    return true;
  if ( (req.rule_ID_in==1541) && (req.is_tcp) && src_port_is_http && true )
    return true;
  if ( (req.rule_ID_in==1548) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==1547) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==1559) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==1557) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==1550) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==1549) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==1567) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==1574) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==1573) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==1572) && (req.is_tcp) && true && (req.dst_port==443) )
    return true;
  if ( (req.rule_ID_in==1571) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==1570) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==1577) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==1616) && (req.is_tcp) && true && (dst_port_is_http || req.dst_port==443) )
    return true;
  if ( (req.rule_ID_in==1595) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==1592) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==1620) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==1619) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==1624) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==1647) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==1640) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==1639) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==1638) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==1637) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==1636) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==1635) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==1634) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==1633) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==1632) && (req.is_tcp) && true && (req.dst_port==8080) )
    return true;
  if ( (req.rule_ID_in==1631) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==1630) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==1629) && (req.is_tcp) && src_port_is_http && true )
    return true;
  if ( (req.rule_ID_in==1628) && (req.is_tcp) && true && true )
    return true;
  if ( (req.rule_ID_in==1627) && (req.is_tcp) && true && (req.dst_port==21) )
    return true;
  if ( (req.rule_ID_in==1626) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==1649) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==1651) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==1650) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==1661) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==1660) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==1659) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==1658) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==1657) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==1656) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==1655) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==1654) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==1653) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==1665) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==1664) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==1674) && (req.is_tcp) && true && (req.dst_port==666) )
    return true;
  if ( (req.rule_ID_in==1670) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==1669) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==1668) && (req.is_tcp) && true && true )
    return true;
  if ( (req.rule_ID_in==1667) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==1683) && (req.is_tcp) && true && (req.dst_port==443) )
    return true;
  if ( (req.rule_ID_in==1682) && (req.is_tcp) && true && ((req.dst_port>=1024) && (req.dst_port<=65535)) )
    return true;
  if ( (req.rule_ID_in==1681) && (req.is_tcp) && true && ((req.dst_port>=1024) && (req.dst_port<=65535)) )
    return true;
  if ( (req.rule_ID_in==1680) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==1689) && (req.is_tcp) && true && ((req.dst_port>=1024) && (req.dst_port<=65535)) )
    return true;
  if ( (req.rule_ID_in==1687) && (req.is_tcp) && true && ((req.dst_port>=1024) && (req.dst_port<=65535)) )
    return true;
  if ( (req.rule_ID_in==1684) && (req.is_tcp) && true && dst_port_is_ftp )
    return true;
  if ( (req.rule_ID_in==1694) && (req.is_tcp) && true && (req.dst_port==6667) )
    return true;
  if ( (req.rule_ID_in==1692) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==1691) && (req.is_tcp) && true && (req.dst_port==91) )
    return true;
  if ( (req.rule_ID_in==1690) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==1700) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==1695) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==1710) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==1705) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==1719) && (req.is_tcp) && true && (req.dst_port==443) )
    return true;
  if ( (req.rule_ID_in==1714) && (req.is_tcp) && true && (req.dst_port==8000) )
    return true;
  if ( (req.rule_ID_in==1713) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==1712) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==1728) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==1727) && (req.is_tcp) && true && ((req.dst_port>=6666) && (req.dst_port<=7000)) )
    return true;
  if ( (req.rule_ID_in==1746) && (req.is_tcp) && true && (req.dst_port==1039) )
    return true;
  if ( (req.rule_ID_in==1745) && (req.is_tcp) && true && true )
    return true;
  if ( (req.rule_ID_in==1744) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==1734) && (req.is_tcp) && true && (req.dst_port==443) )
    return true;
  if ( (req.rule_ID_in==1731) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==1763) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==1759) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==1758) && (req.is_tcp) && true && true )
    return true;
  if ( (req.rule_ID_in==1757) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==1771) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==1772) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==1775) && (req.is_tcp) && true && (req.dst_port==1314) )
    return true;
  if ( (req.rule_ID_in==1773) && (req.is_tcp) && true && (req.dst_port==21) )
    return true;
  if ( (req.rule_ID_in==1802) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==1801) && (req.is_tcp) && true && (req.dst_port==6178) )
    return true;
  if ( (req.rule_ID_in==1800) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==1799) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==1796) && (req.is_tcp) && true && true )
    return true;
  if ( (req.rule_ID_in==1780) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==1779) && (req.is_tcp) && true && true )
    return true;
  if ( (req.rule_ID_in==1778) && (req.is_tcp) && true && true )
    return true;
  if ( (req.rule_ID_in==1777) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==1776) && (req.is_tcp) && true && dst_port_is_ftp )
    return true;
  if ( (req.rule_ID_in==1814) && (req.is_tcp) && true && (req.dst_port==3306) )
    return true;
  if ( (req.rule_ID_in==1823) && (req.is_tcp) && src_port_is_http && true )
    return true;
  if ( (req.rule_ID_in==1822) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==1821) && (!req.is_tcp) && true && (req.dst_port==2090) )
    return true;
  if ( (req.rule_ID_in==1820) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==1819) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==1818) && (req.is_tcp) && true && (req.dst_port==80) )
    return true;
  if ( (req.rule_ID_in==1817) && (req.is_tcp) && true && true )
    return true;
  if ( (req.rule_ID_in==1724) && (req.is_tcp) && true && (req.dst_port==80) )
    return true;
  if ( (req.rule_ID_in==1733) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==1732) && (req.is_tcp) && true && (req.dst_port==9002) )
    return true;
  if ( (req.rule_ID_in==1831) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==1830) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==1829) && (req.is_tcp) && true && true )
    return true;
  if ( (req.rule_ID_in==1828) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==1827) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==1826) && (req.is_tcp) && true && true )
    return true;
  if ( (req.rule_ID_in==1850) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==1842) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==1841) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==1838) && (req.is_tcp) && true && (req.dst_port>=1024) )
    return true;
  if ( (req.rule_ID_in==1837) && (req.is_tcp) && true && (req.dst_port>=1024) )
    return true;
  if ( (req.rule_ID_in==1872) && (req.is_tcp) && true && true )
    return true;
  if ( (req.rule_ID_in==1871) && (req.is_tcp) && true && true )
    return true;
  if ( (req.rule_ID_in==1870) && (req.is_tcp) && true && true )
    return true;
  if ( (req.rule_ID_in==1864) && (req.is_tcp) && true && (req.dst_port==443) )
    return true;
  if ( (req.rule_ID_in==1863) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==1862) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==1861) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==1859) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==1855) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==1887) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==1881) && (req.is_tcp) && true && (req.dst_port==53) )
    return true;
  if ( (req.rule_ID_in==1876) && (req.is_tcp) && true && (req.dst_port==53) )
    return true;
  if ( (req.rule_ID_in==1875) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==1874) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==1873) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==1889) && (req.is_tcp) && src_port_is_http && true )
    return true;
  if ( (req.rule_ID_in==1901) && (req.is_tcp) && true && (req.dst_port==8111) )
    return true;
  if ( (req.rule_ID_in==1900) && (req.is_tcp) && true && (req.dst_port==8256) )
    return true;
  if ( (req.rule_ID_in==1899) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==1894) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==1893) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==1891) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==1930) && (req.is_tcp) && true && ((req.dst_port==25) || (req.dst_port==465) || (req.dst_port==587) || (req.dst_port==2525) || (req.dst_port==2526)) )
    return true;
  if ( (req.rule_ID_in==1929) && (req.is_tcp) && true && (req.dst_port==2024) )
    return true;
  if ( (req.rule_ID_in==1926) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==1925) && (req.is_tcp) && true && (req.dst_port==80) )
    return true;
  if ( (req.rule_ID_in==1924) && (req.is_tcp) && true && (req.dst_port==133) )
    return true;
  if ( (req.rule_ID_in==1923) && (req.is_tcp) && true && true )
    return true;
  if ( (req.rule_ID_in==1922) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==1921) && (req.is_tcp) && true && (req.dst_port==8889) )
    return true;
  if ( (req.rule_ID_in==1920) && (req.is_tcp) && true && (req.dst_port==80) )
    return true;
  if ( (req.rule_ID_in==1919) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==1918) && (req.is_tcp) && true && (req.dst_port==80) )
    return true;
  if ( (req.rule_ID_in==1917) && (req.is_tcp) && true && (req.dst_port==8080) )
    return true;
  if ( (req.rule_ID_in==1916) && (req.is_tcp) && true && (req.dst_port==8080) )
    return true;
  if ( (req.rule_ID_in==1914) && (req.is_tcp) && true && (req.dst_port==21) )
    return true;
  if ( (req.rule_ID_in==1912) && (req.is_tcp) && true && (req.dst_port==146) )
    return true;
  if ( (req.rule_ID_in==1911) && (req.is_tcp) && true && (dst_port_is_http || req.dst_port==443) )
    return true;
  if ( (req.rule_ID_in==1910) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==1909) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==1908) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==1907) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==1906) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==1905) && (req.is_tcp) && true && (req.dst_port==1863) )
    return true;
  if ( (req.rule_ID_in==1904) && (req.is_tcp) && true && (req.dst_port==1431) )
    return true;
  if ( (req.rule_ID_in==1944) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==1943) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==1942) && (req.is_tcp) && true && (req.dst_port==80) )
    return true;
  if ( (req.rule_ID_in==1940) && (req.is_tcp) && true && (req.dst_port==21) )
    return true;
  if ( (req.rule_ID_in==1939) && (req.is_tcp) && true && (req.dst_port==80) )
    return true;
  if ( (req.rule_ID_in==1938) && (req.is_tcp) && true && (req.dst_port==80) )
    return true;
  if ( (req.rule_ID_in==1936) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==1935) && (req.is_tcp) && true && (req.dst_port==80) )
    return true;
  if ( (req.rule_ID_in==1934) && (req.is_tcp) && true && (req.dst_port==80) )
    return true;
  if ( (req.rule_ID_in==1932) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==1972) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==1971) && (req.is_tcp) && true && true )
    return true;
  if ( (req.rule_ID_in==1970) && (req.is_tcp) && true && (req.dst_port==80) )
    return true;
  if ( (req.rule_ID_in==1969) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==1968) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==1967) && (req.is_tcp) && src_port_is_http && true )
    return true;
  if ( (req.rule_ID_in==1966) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==1964) && (req.is_tcp) && true && (req.dst_port==443) )
    return true;
  if ( (req.rule_ID_in==1963) && (req.is_tcp) && true && (req.dst_port==443) )
    return true;
  if ( (req.rule_ID_in==1962) && (req.is_tcp) && true && (req.dst_port==80) )
    return true;
  if ( (req.rule_ID_in==1961) && (req.is_tcp) && true && (req.dst_port==80) )
    return true;
  if ( (req.rule_ID_in==1960) && (req.is_tcp) && true && (req.dst_port==80) )
    return true;
  if ( (req.rule_ID_in==1959) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==1956) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==1955) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==1990) && (req.is_tcp) && true && (req.dst_port==80) )
    return true;
  if ( (req.rule_ID_in==1988) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==1987) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==1986) && (req.is_tcp) && true && (req.dst_port==80) )
    return true;
  if ( (req.rule_ID_in==1985) && (req.is_tcp) && true && (req.dst_port==80) )
    return true;
  if ( (req.rule_ID_in==1984) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==1983) && (req.is_tcp) && true && (req.dst_port==80) )
    return true;
  if ( (req.rule_ID_in==1982) && (req.is_tcp) && true && (req.dst_port==80) )
    return true;
  if ( (req.rule_ID_in==1980) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==1979) && (req.is_tcp) && true && (req.dst_port==921) )
    return true;
  if ( (req.rule_ID_in==1978) && (req.is_tcp) && true && true )
    return true;
  if ( (req.rule_ID_in==1977) && (req.is_tcp) && true && true )
    return true;
  if ( (req.rule_ID_in==1976) && (req.is_tcp) && true && true )
    return true;
  if ( (req.rule_ID_in==1975) && (req.is_tcp) && true && true )
    return true;
  if ( (req.rule_ID_in==1974) && (req.is_tcp) && true && ((req.dst_port==1994) || (req.dst_port==81)) )
    return true;
  if ( (req.rule_ID_in==1973) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==2002) && (req.is_tcp) && true && (req.dst_port==2080) )
    return true;
  if ( (req.rule_ID_in==1999) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==1997) && (req.is_tcp) && true && (req.dst_port==80) )
    return true;
  if ( (req.rule_ID_in==1996) && (req.is_tcp) && true && (req.dst_port==3308) )
    return true;
  if ( (req.rule_ID_in==1995) && (req.is_tcp) && true && (req.dst_port==80) )
    return true;
  if ( (req.rule_ID_in==1993) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==2015) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==2013) && (req.is_tcp) && true && (req.dst_port==443) )
    return true;
  if ( (req.rule_ID_in==2012) && (req.is_tcp) && true && (req.dst_port==6178) )
    return true;
  if ( (req.rule_ID_in==2011) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==2010) && (req.is_tcp) && true && ((req.dst_port>=1024) && (req.dst_port<=65535)) )
    return true;
  if ( (req.rule_ID_in==2009) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==2008) && (req.is_tcp) && true && (req.dst_port==21) )
    return true;
  if ( (req.rule_ID_in==2006) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==2026) && (req.is_tcp) && true && (req.dst_port==80) )
    return true;
  if ( (req.rule_ID_in==2024) && (req.is_tcp) && true && (req.dst_port==80) )
    return true;
  if ( (req.rule_ID_in==2023) && (req.is_tcp) && true && (req.dst_port>=1024) )
    return true;
  if ( (req.rule_ID_in==2033) && (req.is_tcp) && true && (req.dst_port==80) )
    return true;
  if ( (req.rule_ID_in==2032) && (req.is_tcp) && true && (req.dst_port==3301) )
    return true;
  if ( (req.rule_ID_in==2031) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==2030) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==2028) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==2027) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==2046) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==2045) && (req.is_tcp) && true && (req.dst_port==60005) )
    return true;
  if ( (req.rule_ID_in==2044) && (req.is_tcp) && true && ((req.dst_port>=80) && (req.dst_port<=81)) )
    return true;
  if ( (req.rule_ID_in==2043) && (req.is_tcp) && true && (req.dst_port==80) )
    return true;
  if ( (req.rule_ID_in==2042) && (req.is_tcp) && true && (req.dst_port==27977) )
    return true;
  if ( (req.rule_ID_in==2041) && (req.is_tcp) && true && (req.dst_port==80) )
    return true;
  if ( (req.rule_ID_in==2040) && (req.is_tcp) && true && (req.dst_port==53) )
    return true;
  if ( (req.rule_ID_in==2039) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==2036) && (req.is_tcp) && true && (req.dst_port==80) )
    return true;
  if ( (req.rule_ID_in==2076) && (req.is_tcp) && true && (req.dst_port==2352) )
    return true;
  if ( (req.rule_ID_in==2065) && (req.is_tcp) && true && (dst_port_is_http || req.dst_port==443) )
    return true;
  if ( (req.rule_ID_in==2063) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==2062) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==2058) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==2056) && (req.is_tcp) && true && (req.dst_port==80) )
    return true;
  if ( (req.rule_ID_in==2055) && (req.is_tcp) && true && (req.dst_port==80) )
    return true;
  if ( (req.rule_ID_in==2054) && (req.is_tcp) && true && (req.dst_port==80) )
    return true;
  if ( (req.rule_ID_in==2082) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==2081) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==2080) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==2084) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==2083) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==2087) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==2105) && (req.is_tcp) && true && (req.dst_port==888) )
    return true;
  if ( (req.rule_ID_in==2104) && (req.is_tcp) && true && (req.dst_port==6000) )
    return true;
  if ( (req.rule_ID_in==2103) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==2102) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==2101) && (req.is_tcp) && true && (req.dst_port==8080) )
    return true;
  if ( (req.rule_ID_in==2100) && (req.is_tcp) && true && (req.dst_port==80) )
    return true;
  if ( (req.rule_ID_in==2099) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==2098) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==2097) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==2096) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==2095) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==2094) && (req.is_tcp) && true && (req.dst_port==80) )
    return true;
  if ( (req.rule_ID_in==2093) && (req.is_tcp) && src_port_is_http && true )
    return true;
  if ( (req.rule_ID_in==2092) && (req.is_tcp) && src_port_is_http && true )
    return true;
  if ( (req.rule_ID_in==2091) && (req.is_tcp) && src_port_is_http && true )
    return true;
  if ( (req.rule_ID_in==2090) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==2115) && (req.is_tcp) && true && (req.dst_port==6900) )
    return true;
  if ( (req.rule_ID_in==2114) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==2113) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==2112) && (req.is_tcp) && src_port_is_http && true )
    return true;
  if ( (req.rule_ID_in==2111) && (req.is_tcp) && true && (req.dst_port==4000) )
    return true;
  if ( (req.rule_ID_in==2110) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==2108) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==2124) && (req.is_tcp) && true && (req.dst_port==80) )
    return true;
  if ( (req.rule_ID_in==2123) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==2122) && (req.is_tcp) && true && dst_port_is_ftp )
    return true;
  if ( (req.rule_ID_in==2121) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==2120) && (req.is_tcp) && true && (req.dst_port==443) )
    return true;
  if ( (req.rule_ID_in==2119) && (req.is_tcp) && true && (req.dst_port==443) )
    return true;
  if ( (req.rule_ID_in==2146) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==2145) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==2140) && (req.is_tcp) && true && (req.dst_port==80) )
    return true;
  if ( (req.rule_ID_in==2139) && (req.is_tcp) && true && (req.dst_port==21) )
    return true;
  if ( (req.rule_ID_in==2138) && (req.is_tcp) && true && (req.dst_port==80) )
    return true;
  if ( (req.rule_ID_in==2135) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==2134) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==2133) && (req.is_tcp) && true && true )
    return true;
  if ( (req.rule_ID_in==2132) && (req.is_tcp) && true && (req.dst_port==8850) )
    return true;
  if ( (req.rule_ID_in==2151) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==2150) && (req.is_tcp) && true && (req.dst_port==8080) )
    return true;
  if ( (req.rule_ID_in==2149) && (req.is_tcp) && true && (req.dst_port==3900) )
    return true;
  if ( (req.rule_ID_in==2148) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==2179) && (req.is_tcp) && src_port_is_http && true )
    return true;
  if ( (req.rule_ID_in==2178) && (req.is_tcp) && src_port_is_http && true )
    return true;
  if ( (req.rule_ID_in==2177) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==2176) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==2186) && (req.is_tcp) && true && (req.dst_port==80) )
    return true;
  if ( (req.rule_ID_in==2185) && (req.is_tcp) && src_port_is_http && true )
    return true;
  if ( (req.rule_ID_in==2183) && (req.is_tcp) && (req.src_port==128) && true )
    return true;
  if ( (req.rule_ID_in==2181) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==2180) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==2189) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==2188) && (req.is_tcp) && true && ((req.dst_port==80) || (req.dst_port==443)) )
    return true;
  if ( (req.rule_ID_in==2190) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==2208) && (req.is_tcp) && src_port_is_http && true )
    return true;
  if ( (req.rule_ID_in==2207) && (req.is_tcp) && src_port_is_http && true )
    return true;
  if ( (req.rule_ID_in==2206) && (req.is_tcp) && src_port_is_http && true )
    return true;
  if ( (req.rule_ID_in==2205) && (req.is_tcp) && src_port_is_http && true )
    return true;
  if ( (req.rule_ID_in==2203) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==2202) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==2195) && (req.is_tcp) && src_port_is_http && true )
    return true;
  if ( (req.rule_ID_in==2194) && (req.is_tcp) && src_port_is_http && true )
    return true;
  if ( (req.rule_ID_in==2225) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==2217) && (req.is_tcp) && true && (req.dst_port==80) )
    return true;
  if ( (req.rule_ID_in==2216) && (req.is_tcp) && true && (req.dst_port==80) )
    return true;
  if ( (req.rule_ID_in==2214) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==2213) && (req.is_tcp) && true && (req.dst_port==8000) )
    return true;
  if ( (req.rule_ID_in==2211) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==2210) && (req.is_tcp) && true && (req.dst_port>=1024) )
    return true;
  if ( (req.rule_ID_in==2209) && (req.is_tcp) && true && (req.dst_port==80) )
    return true;
  if ( (req.rule_ID_in==2228) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==2232) && (req.is_tcp) && true && ((req.dst_port>=1600) && (req.dst_port<=1604)) )
    return true;
  if ( (req.rule_ID_in==2231) && (req.is_tcp) && true && ((req.dst_port>=1600) && (req.dst_port<=1604)) )
    return true;
  if ( (req.rule_ID_in==2230) && (req.is_tcp) && ((req.src_port>=1600) && (req.src_port<=1604)) && true )
    return true;
  if ( (req.rule_ID_in==2237) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==2248) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==2247) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==2245) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==2255) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==2254) && (req.is_tcp) && true && (req.dst_port==2698) )
    return true;
  if ( (req.rule_ID_in==2263) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==2262) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==2275) && (req.is_tcp) && true && (req.dst_port==1337) )
    return true;
  if ( (req.rule_ID_in==2274) && (req.is_tcp) && true && (req.dst_port==1337) )
    return true;
  if ( (req.rule_ID_in==2273) && (req.is_tcp) && true && (req.dst_port==1337) )
    return true;
  if ( (req.rule_ID_in==2272) && (req.is_tcp) && true && (req.dst_port==1337) )
    return true;
  if ( (req.rule_ID_in==2271) && (req.is_tcp) && true && (req.dst_port==1337) )
    return true;
  if ( (req.rule_ID_in==2270) && (req.is_tcp) && true && (req.dst_port==1337) )
    return true;
  if ( (req.rule_ID_in==2269) && (req.is_tcp) && true && (req.dst_port==1337) )
    return true;
  if ( (req.rule_ID_in==2268) && (req.is_tcp) && true && (req.dst_port==1337) )
    return true;
  if ( (req.rule_ID_in==2267) && (req.is_tcp) && true && (req.dst_port==1337) )
    return true;
  if ( (req.rule_ID_in==2276) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==2283) && (req.is_tcp) && src_port_is_http && true )
    return true;
  if ( (req.rule_ID_in==2282) && (!req.is_tcp) && true && (req.dst_port==53) )
    return true;
  if ( (req.rule_ID_in==2286) && (req.is_tcp) && (req.src_port==9005) && true )
    return true;
  if ( (req.rule_ID_in==2285) && (req.is_tcp) && true && (req.dst_port==82) )
    return true;
  if ( (req.rule_ID_in==2296) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==2290) && (req.is_tcp) && true && (req.dst_port==443) )
    return true;
  if ( (req.rule_ID_in==2289) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==2288) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==2287) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==2300) && (req.is_tcp) && true && (req.dst_port==8766) )
    return true;
  if ( (req.rule_ID_in==2297) && (req.is_tcp) && true && (req.dst_port==21) )
    return true;
  if ( (req.rule_ID_in==2332) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==2330) && (req.is_tcp) && true && (req.dst_port==80) )
    return true;
  if ( (req.rule_ID_in==2328) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==2327) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==2326) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==2325) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==2323) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==2322) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==2321) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==2320) && (req.is_tcp) && src_port_is_http && true )
    return true;
  if ( (req.rule_ID_in==2319) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==2318) && (req.is_tcp) && true && (req.dst_port==89) )
    return true;
  if ( (req.rule_ID_in==2317) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==2316) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==2315) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==2314) && (req.is_tcp) && true && (req.dst_port==48919) )
    return true;
  if ( (req.rule_ID_in==2313) && (req.is_tcp) && true && true )
    return true;
  if ( (req.rule_ID_in==2338) && (req.is_tcp) && true && (req.dst_port==443) )
    return true;
  if ( (req.rule_ID_in==2343) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==2342) && (req.is_tcp) && true && (req.dst_port==443) )
    return true;
  if ( (req.rule_ID_in==2352) && (req.is_tcp) && true && true )
    return true;
  if ( (req.rule_ID_in==2351) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==2350) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==2349) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==2348) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==2347) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==2346) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==2345) && (req.is_tcp) && true && (req.dst_port==21) )
    return true;
  if ( (req.rule_ID_in==2344) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==2354) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==2353) && (req.is_tcp) && true && (req.dst_port==5013) )
    return true;
  if ( (req.rule_ID_in==2007) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==2373) && (req.is_tcp) && true && true )
    return true;
  if ( (req.rule_ID_in==2372) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==2371) && (!req.is_tcp) && true && ((req.dst_port==16464) || (req.dst_port==16465) || (req.dst_port==16470) || (req.dst_port==16471)) )
    return true;
  if ( (req.rule_ID_in==2370) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==2369) && (req.is_tcp) && true && ((req.dst_port==25) || (req.dst_port==465) || (req.dst_port==587)) )
    return true;
  if ( (req.rule_ID_in==2368) && (req.is_tcp) && true && (req.dst_port==2145) )
    return true;
  if ( (req.rule_ID_in==2367) && (req.is_tcp) && true && (req.dst_port==1433) )
    return true;
  if ( (req.rule_ID_in==2365) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==2364) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==2363) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==2362) && (req.is_tcp) && true && (req.dst_port==5655) )
    return true;
  if ( (req.rule_ID_in==2361) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==2360) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==2381) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==2380) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==2379) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==2378) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==2377) && (req.is_tcp) && true && (req.dst_port==8082) )
    return true;
  if ( (req.rule_ID_in==2374) && (req.is_tcp) && true && true )
    return true;
  if ( (req.rule_ID_in==2391) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==2382) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==2403) && (req.is_tcp) && true && (req.dst_port==5000) )
    return true;
  if ( (req.rule_ID_in==2402) && (req.is_tcp) && true && ((req.dst_port==9003) || (req.dst_port==9400)) )
    return true;
  if ( (req.rule_ID_in==2401) && (req.is_tcp) && ((req.src_port==9003) || (req.src_port==9400)) && true )
    return true;
  if ( (req.rule_ID_in==2397) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==2395) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==2394) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==2393) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==2410) && (req.is_tcp) && src_port_is_http && true )
    return true;
  if ( (req.rule_ID_in==2409) && (req.is_tcp) && true && (req.dst_port==8080) )
    return true;
  if ( (req.rule_ID_in==2408) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==2407) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==2406) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==2405) && (req.is_tcp) && true && true )
    return true;
  if ( (req.rule_ID_in==2404) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==2423) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==2422) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==2421) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==2419) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==2417) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==2411) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==2428) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==2427) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==2426) && (req.is_tcp) && true && (req.dst_port==3001) )
    return true;
  if ( (req.rule_ID_in==2425) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==2424) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==2439) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==2434) && (req.is_tcp) && true && (req.dst_port==86) )
    return true;
  if ( (req.rule_ID_in==2433) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==2432) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==2431) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==2441) && (req.is_tcp) && true && (req.dst_port==8080) )
    return true;
  if ( (req.rule_ID_in==2450) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==2449) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==2451) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==2456) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==2455) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==2454) && (req.is_tcp) && true && ((req.dst_port==1177) || (req.dst_port==81)) )
    return true;
  if ( (req.rule_ID_in==2453) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==2452) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==2466) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==2481) && (req.is_tcp) && true && ((req.dst_port==80) || (req.dst_port==8080) || (req.dst_port==443)) )
    return true;
  if ( (req.rule_ID_in==2476) && (req.is_tcp) && true && (req.dst_port==1337) )
    return true;
  if ( (req.rule_ID_in==2474) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==2484) && (req.is_tcp) && true && (req.dst_port==21) )
    return true;
  if ( (req.rule_ID_in==2486) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==2493) && (req.is_tcp) && true && true )
    return true;
  if ( (req.rule_ID_in==2492) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==2491) && (req.is_tcp) && true && true )
    return true;
  if ( (req.rule_ID_in==2490) && (req.is_tcp) && true && true )
    return true;
  if ( (req.rule_ID_in==2489) && (req.is_tcp) && true && true )
    return true;
  if ( (req.rule_ID_in==2488) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==2501) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==2500) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==2499) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==2511) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==2508) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==2507) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==2506) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==2503) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==2502) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==2522) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==2521) && (req.is_tcp) && true && (req.dst_port==21) )
    return true;
  if ( (req.rule_ID_in==2520) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==2519) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==2518) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==2517) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==2514) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==2512) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==2523) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==2524) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==2533) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==2532) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==2531) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==2529) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==2534) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==2548) && (req.is_tcp) && true && true )
    return true;
  if ( (req.rule_ID_in==2547) && (req.is_tcp) && true && ((req.dst_port==587) || (req.dst_port==2525)) )
    return true;
  if ( (req.rule_ID_in==2546) && (req.is_tcp) && true && ((req.dst_port==587) || (req.dst_port==2525)) )
    return true;
  if ( (req.rule_ID_in==2545) && (req.is_tcp) && true && ((req.dst_port==80) || (req.dst_port==443)) )
    return true;
  if ( (req.rule_ID_in==2560) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==2559) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==2558) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==2557) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==2555) && (req.is_tcp) && true && (req.dst_port==5222) )
    return true;
  if ( (req.rule_ID_in==2554) && (req.is_tcp) && src_port_is_http && true )
    return true;
  if ( (req.rule_ID_in==2553) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==2551) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==2550) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==2571) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==2570) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==2569) && (req.is_tcp) && true && (req.dst_port==443) )
    return true;
  if ( (req.rule_ID_in==2584) && (req.is_tcp) && src_port_is_http && true )
    return true;
  if ( (req.rule_ID_in==2583) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==2582) && (req.is_tcp) && src_port_is_http && true )
    return true;
  if ( (req.rule_ID_in==2581) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==2580) && (req.is_tcp) && true && (req.dst_port==443) )
    return true;
  if ( (req.rule_ID_in==2579) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==2578) && (req.is_tcp) && true && true )
    return true;
  if ( (req.rule_ID_in==2577) && (req.is_tcp) && true && true )
    return true;
  if ( (req.rule_ID_in==2576) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==2597) && (req.is_tcp) && true && (req.dst_port==2010) )
    return true;
  if ( (req.rule_ID_in==2596) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==2595) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==2594) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==2593) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==2589) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==2588) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==2587) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==2586) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==2614) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==2620) && (req.is_tcp) && true && true )
    return true;
  if ( (req.rule_ID_in==2619) && (req.is_tcp) && true && (req.dst_port==23) )
    return true;
  if ( (req.rule_ID_in==2618) && (req.is_tcp) && true && true )
    return true;
  if ( (req.rule_ID_in==2638) && (req.is_tcp) && true && true )
    return true;
  if ( (req.rule_ID_in==2637) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==2636) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==2635) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==2634) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==2633) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==2632) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==2630) && (req.is_tcp) && true && true )
    return true;
  if ( (req.rule_ID_in==2628) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==2626) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==2625) && (req.is_tcp) && true && (req.dst_port==8010) )
    return true;
  if ( (req.rule_ID_in==2624) && (req.is_tcp) && true && ((req.dst_port==139) || (req.dst_port==445)) )
    return true;
  if ( (req.rule_ID_in==2623) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==2622) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==2621) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==2653) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==2652) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==2651) && (req.is_tcp) && src_port_is_http && true )
    return true;
  if ( (req.rule_ID_in==2650) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==2647) && (req.is_tcp) && true && (req.dst_port==443) )
    return true;
  if ( (req.rule_ID_in==2645) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==2643) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==2642) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==2667) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==2666) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==2665) && (req.is_tcp) && true && (req.dst_port==53) )
    return true;
  if ( (req.rule_ID_in==2664) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==2663) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==2658) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==2657) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==2656) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==2655) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==2654) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==2672) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==2671) && (req.is_tcp) && true && (req.dst_port==6667) )
    return true;
  if ( (req.rule_ID_in==2670) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==2669) && (req.is_tcp) && true && true )
    return true;
  if ( (req.rule_ID_in==2686) && (req.is_tcp) && true && true )
    return true;
  if ( (req.rule_ID_in==2685) && (req.is_tcp) && true && true )
    return true;
  if ( (req.rule_ID_in==2684) && (req.is_tcp) && true && ((req.dst_port==53) || (req.dst_port==80) || (req.dst_port==443) || (req.dst_port==5432)) )
    return true;
  if ( (req.rule_ID_in==2683) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==2692) && (req.is_tcp) && true && true )
    return true;
  if ( (req.rule_ID_in==2691) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==2690) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==2699) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==2698) && (req.is_tcp) && true && (req.dst_port==587) )
    return true;
  if ( (req.rule_ID_in==2697) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==2696) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==2695) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==2694) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==2693) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==2702) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==2701) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==2700) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==2718) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==2713) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==2709) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==2734) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==2733) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==2726) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==2725) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==2724) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==2723) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==2722) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==2721) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==2720) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==2746) && (req.is_tcp) && true && (req.dst_port==9999) )
    return true;
  if ( (req.rule_ID_in==2745) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==2743) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==2741) && (req.is_tcp) && true && (req.dst_port==443) )
    return true;
  if ( (req.rule_ID_in==2740) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==2739) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==2738) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==2751) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==2748) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==2754) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==2752) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==2757) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==2756) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==2763) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==2762) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==2759) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==2813) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==2812) && (req.is_tcp) && true && (req.dst_port==443) )
    return true;
  if ( (req.rule_ID_in==2811) && (req.is_tcp) && true && (req.dst_port>=1024) )
    return true;
  if ( (req.rule_ID_in==2810) && (req.is_tcp) && true && (req.dst_port==205) )
    return true;
  if ( (req.rule_ID_in==2808) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==2807) && (req.is_tcp) && true && true )
    return true;
  if ( (req.rule_ID_in==2806) && (!req.is_tcp) && true && true )
    return true;
  if ( (req.rule_ID_in==2803) && (req.is_tcp) && true && true )
    return true;
  if ( (req.rule_ID_in==2802) && (req.is_tcp) && true && true )
    return true;
  if ( (req.rule_ID_in==2801) && (req.is_tcp) && true && (req.dst_port==443) )
    return true;
  if ( (req.rule_ID_in==2800) && (req.is_tcp) && true && (req.dst_port==443) )
    return true;
  if ( (req.rule_ID_in==2795) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==2794) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==2792) && (req.is_tcp) && (req.src_port==172) && true )
    return true;
  if ( (req.rule_ID_in==2791) && (req.is_tcp) && true && (req.dst_port==172) )
    return true;
  if ( (req.rule_ID_in==2789) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==2766) && (req.is_tcp) && true && (req.dst_port==1863) )
    return true;
  if ( (req.rule_ID_in==2765) && (req.is_tcp) && true && (req.dst_port==1604) )
    return true;
  if ( (req.rule_ID_in==2816) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==2814) && (req.is_tcp) && src_port_is_http && true )
    return true;
  if ( (req.rule_ID_in==2829) && (req.is_tcp) && true && true )
    return true;
  if ( (req.rule_ID_in==2828) && (req.is_tcp) && true && (req.dst_port==21) )
    return true;
  if ( (req.rule_ID_in==2824) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==2843) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==2842) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==2841) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==2840) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==2853) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==2852) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==2851) && (req.is_tcp) && true && true )
    return true;
  if ( (req.rule_ID_in==2850) && (req.is_tcp) && src_port_is_http && true )
    return true;
  if ( (req.rule_ID_in==2849) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==2848) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==2847) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==2846) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==2845) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==2859) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==2858) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==2857) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==2864) && (req.is_tcp) && true && true )
    return true;
  if ( (req.rule_ID_in==2860) && (req.is_tcp) && true && (req.dst_port==8080) )
    return true;
  if ( (req.rule_ID_in==2885) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==2879) && (req.is_tcp) && true && (req.dst_port==6667) )
    return true;
  if ( (req.rule_ID_in==2878) && (req.is_tcp) && true && (req.dst_port==2015) )
    return true;
  if ( (req.rule_ID_in==2876) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==2875) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==2874) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==2871) && (req.is_tcp) && true && (req.dst_port==9090) )
    return true;
  if ( (req.rule_ID_in==2870) && (req.is_tcp) && true && (req.dst_port==8080) )
    return true;
  if ( (req.rule_ID_in==2887) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==2886) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==2902) && (req.is_tcp) && src_port_is_http && true )
    return true;
  if ( (req.rule_ID_in==2901) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==2900) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==2899) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==2898) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==2891) && (req.is_tcp) && (req.src_port==9999) && true )
    return true;
  if ( (req.rule_ID_in==2890) && (req.is_tcp) && true && (req.dst_port==9999) )
    return true;
  if ( (req.rule_ID_in==2905) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==2904) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==2911) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==2915) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==2914) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==2913) && (req.is_tcp) && (req.src_port==80) && true )
    return true;
  if ( (req.rule_ID_in==2921) && (req.is_tcp) && src_port_is_http && true )
    return true;
  if ( (req.rule_ID_in==2920) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==2919) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==2917) && (req.is_tcp) && true && ((req.dst_port==25) || (req.dst_port==2525) || (req.dst_port==587)) )
    return true;
  if ( (req.rule_ID_in==2916) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==2929) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==2928) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==2927) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==2926) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==2925) && (req.is_tcp) && src_port_is_http && true )
    return true;
  if ( (req.rule_ID_in==2943) && (req.is_tcp) && true && true )
    return true;
  if ( (req.rule_ID_in==2942) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==2941) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==2940) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==2937) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==2936) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==2935) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==2934) && (req.is_tcp) && true && true )
    return true;
  if ( (req.rule_ID_in==2954) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==2953) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==2952) && (req.is_tcp) && true && (req.dst_port==5551) )
    return true;
  if ( (req.rule_ID_in==2951) && (req.is_tcp) && true && (req.dst_port==587) )
    return true;
  if ( (req.rule_ID_in==2950) && (req.is_tcp) && true && (req.dst_port==587) )
    return true;
  if ( (req.rule_ID_in==2949) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==2956) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==2955) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==2972) && (req.is_tcp) && true && true )
    return true;
  if ( (req.rule_ID_in==2968) && (req.is_tcp) && true && true )
    return true;
  if ( (req.rule_ID_in==2967) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==2982) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==2979) && (req.is_tcp) && true && ((req.dst_port==25) || (req.dst_port==587)) )
    return true;
  if ( (req.rule_ID_in==2978) && (req.is_tcp) && true && ((req.dst_port==25) || (req.dst_port==587)) )
    return true;
  if ( (req.rule_ID_in==2977) && (req.is_tcp) && true && ((req.dst_port==25) || (req.dst_port==587)) )
    return true;
  if ( (req.rule_ID_in==2976) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==2975) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==2974) && (req.is_tcp) && true && true )
    return true;
  if ( (req.rule_ID_in==3013) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==3012) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==3011) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==3018) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==3015) && (req.is_tcp) && true && (req.dst_port==3373) )
    return true;
  if ( (req.rule_ID_in==3076) && (req.is_tcp) && true && true )
    return true;
  if ( (req.rule_ID_in==3075) && (req.is_tcp) && true && true )
    return true;
  if ( (req.rule_ID_in==3074) && (req.is_tcp) && true && true )
    return true;
  if ( (req.rule_ID_in==3073) && (req.is_tcp) && true && true )
    return true;
  if ( (req.rule_ID_in==3072) && (req.is_tcp) && true && true )
    return true;
  if ( (req.rule_ID_in==3064) && (req.is_tcp) && true && (req.dst_port==8080) )
    return true;
  if ( (req.rule_ID_in==3033) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==3032) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==3031) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==3089) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==3085) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==3084) && (req.is_tcp) && true && (req.dst_port==8080) )
    return true;
  if ( (req.rule_ID_in==3081) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==3080) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==3079) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==3078) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==3077) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==3111) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==3110) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==3108) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==3107) && (req.is_tcp) && src_port_is_http && true )
    return true;
  if ( (req.rule_ID_in==3093) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==3116) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==3115) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==3117) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==3123) && (req.is_tcp) && true && (req.dst_port==443) )
    return true;
  if ( (req.rule_ID_in==3122) && (req.is_tcp) && true && (req.dst_port==443) )
    return true;
  if ( (req.rule_ID_in==3121) && (req.is_tcp) && true && ((req.dst_port==443) || (req.dst_port==446) || (req.dst_port==447)) )
    return true;
  if ( (req.rule_ID_in==3120) && (req.is_tcp) && true && true )
    return true;
  if ( (req.rule_ID_in==3128) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==3127) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==3126) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==3137) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==3136) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==3135) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==3134) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==3133) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==3153) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==3152) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==3151) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==3150) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==3149) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==3148) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==3161) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==3160) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==3159) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==3158) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==3157) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==3173) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==3172) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==3171) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==3170) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==3169) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==3168) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==3167) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==3166) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==3165) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==3177) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==3176) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==3174) && (req.is_tcp) && true && true )
    return true;
  if ( (req.rule_ID_in==3182) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==3181) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==3180) && (req.is_tcp) && true && (req.dst_port==21) )
    return true;
  if ( (req.rule_ID_in==3179) && (req.is_tcp) && true && true )
    return true;
  if ( (req.rule_ID_in==3188) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==3187) && (req.is_tcp) && true && true )
    return true;
  if ( (req.rule_ID_in==3198) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==3196) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==3195) && (req.is_tcp) && true && ((req.dst_port==139) || (req.dst_port==445)) )
    return true;
  if ( (req.rule_ID_in==3194) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==3222) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==3221) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==3220) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==3219) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==3218) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==3217) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==3216) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==3215) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==3213) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==3212) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==3211) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==3210) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==3209) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==3208) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==3207) && (req.is_tcp) && true && true )
    return true;
  if ( (req.rule_ID_in==3238) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==3237) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==3236) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==3235) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==3234) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==3233) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==3232) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==3231) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==3230) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==3229) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==3228) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==3227) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==3226) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==3225) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==3224) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==3241) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==3240) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==3239) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==3261) && (req.is_tcp) && (req.src_port==1433) && true )
    return true;
  if ( (req.rule_ID_in==3259) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==3258) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==3257) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==3256) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==3255) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==3254) && (req.is_tcp) && src_port_is_http && true )
    return true;
  if ( (req.rule_ID_in==3253) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==3266) && (req.is_tcp) && true && (req.dst_port==8000) )
    return true;
  if ( (req.rule_ID_in==3263) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==3262) && (req.is_tcp) && src_port_is_http && true )
    return true;
  if ( (req.rule_ID_in==3278) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==3277) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==3276) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==3300) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==3299) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==3298) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==3288) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==3287) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==3286) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==3285) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==3312) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==3311) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==3310) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==3309) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==3330) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==3329) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==3328) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==3327) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==3326) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==3325) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==3324) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==3323) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==3322) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==3321) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==3317) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==3316) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==3315) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==3313) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==3335) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==3334) && (req.is_tcp) && true && (req.dst_port==9000) )
    return true;
  if ( (req.rule_ID_in==3333) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==3332) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==3331) && (req.is_tcp) && true && true )
    return true;
  if ( (req.rule_ID_in==3343) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==3342) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==3341) && (req.is_tcp) && true && true )
    return true;
  if ( (req.rule_ID_in==3340) && (req.is_tcp) && true && true )
    return true;
  if ( (req.rule_ID_in==3339) && (req.is_tcp) && true && true )
    return true;
  if ( (req.rule_ID_in==3349) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==3348) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==3347) && (req.is_tcp) && true && (req.dst_port==443) )
    return true;
  if ( (req.rule_ID_in==3346) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==3373) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==3372) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==3371) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==3370) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==3369) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==3368) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==3376) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==3375) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==2051) && (req.is_tcp) && src_port_is_http && true )
    return true;
  if ( (req.rule_ID_in==2050) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==1198) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==3395) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==3381) && (req.is_tcp) && true && true )
    return true;
  if ( (req.rule_ID_in==3380) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==3410) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==3409) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==3408) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==3425) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==3424) && (req.is_tcp) && true && (req.dst_port==587) )
    return true;
  if ( (req.rule_ID_in==3423) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==3422) && (req.is_tcp) && true && (req.dst_port==1433) )
    return true;
  if ( (req.rule_ID_in==3421) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==3420) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==3418) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==3417) && (req.is_tcp) && true && (req.dst_port==4000) )
    return true;
  if ( (req.rule_ID_in==3416) && (req.is_tcp) && true && (req.dst_port==1010) )
    return true;
  if ( (req.rule_ID_in==3415) && (req.is_tcp) && true && (req.dst_port==1991) )
    return true;
  if ( (req.rule_ID_in==3414) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==3429) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==3428) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==3426) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==3482) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==3481) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==3480) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==3479) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==3478) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==3477) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==3476) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==3471) && (req.is_tcp) && true && true )
    return true;
  if ( (req.rule_ID_in==3469) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==3467) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==3466) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==3465) && (req.is_tcp) && true && ((req.dst_port==25) || (req.dst_port==465) || (req.dst_port==587) || (req.dst_port==2525) || (req.dst_port==2526)) )
    return true;
  if ( (req.rule_ID_in==3463) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==3460) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==3490) && (req.is_tcp) && (req.src_port==21) && true )
    return true;
  if ( (req.rule_ID_in==3489) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==3486) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==3485) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==3483) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==3495) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==3494) && (req.is_tcp) && true && ((req.dst_port>=1024) && (req.dst_port<=65535)) )
    return true;
  if ( (req.rule_ID_in==3493) && (req.is_tcp) && true && (req.dst_port==8585) )
    return true;
  if ( (req.rule_ID_in==3492) && (req.is_tcp) && true && (req.dst_port==3330) )
    return true;
  if ( (req.rule_ID_in==3491) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==3501) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==3500) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==3499) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==3498) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==3497) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==3503) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==3510) && (req.is_tcp) && true && true )
    return true;
  if ( (req.rule_ID_in==3509) && (req.is_tcp) && true && true )
    return true;
  if ( (req.rule_ID_in==3508) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==3507) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==3512) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==3526) && (req.is_tcp) && true && (req.dst_port==3502) )
    return true;
  if ( (req.rule_ID_in==3525) && (req.is_tcp) && true && true )
    return true;
  if ( (req.rule_ID_in==3524) && (req.is_tcp) && true && true )
    return true;
  if ( (req.rule_ID_in==3523) && (req.is_tcp) && true && true )
    return true;
  if ( (req.rule_ID_in==3522) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==3521) && (req.is_tcp) && true && (req.dst_port==21) )
    return true;
  if ( (req.rule_ID_in==3520) && (req.is_tcp) && (req.src_port==443) && true )
    return true;
  if ( (req.rule_ID_in==3540) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==3539) && (req.is_tcp) && true && (req.dst_port==58275) )
    return true;
  if ( (req.rule_ID_in==3538) && (req.is_tcp) && true && (req.dst_port==15525) )
    return true;
  if ( (req.rule_ID_in==3537) && (req.is_tcp) && true && (req.dst_port==15525) )
    return true;
  if ( (req.rule_ID_in==3536) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==3535) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==3534) && (req.is_tcp) && true && (req.dst_port==9003) )
    return true;
  if ( (req.rule_ID_in==3533) && (req.is_tcp) && true && (req.dst_port==25565) )
    return true;
  if ( (req.rule_ID_in==3532) && (req.is_tcp) && true && true )
    return true;
  if ( (req.rule_ID_in==3531) && (req.is_tcp) && true && true )
    return true;
  if ( (req.rule_ID_in==3530) && (req.is_tcp) && true && true )
    return true;
  if ( (req.rule_ID_in==3529) && (req.is_tcp) && true && true )
    return true;
  if ( (req.rule_ID_in==3543) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==3542) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==3577) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==3563) && (req.is_tcp) && src_port_is_http && true )
    return true;
  if ( (req.rule_ID_in==3592) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==3591) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==3590) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==3605) && (req.is_tcp) && src_port_is_http && true )
    return true;
  if ( (req.rule_ID_in==3601) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==3600) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==3598) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==3597) && (req.is_tcp) && true && (req.dst_port==8889) )
    return true;
  if ( (req.rule_ID_in==3596) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==3594) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==3608) && (req.is_tcp) && true && true )
    return true;
  if ( (req.rule_ID_in==3607) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==3606) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==3621) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==3618) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==3617) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==3616) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==3615) && (req.is_tcp) && true && (req.dst_port==1433) )
    return true;
  if ( (req.rule_ID_in==3622) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==3635) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==3634) && (req.is_tcp) && true && (req.dst_port==6666) )
    return true;
  if ( (req.rule_ID_in==3626) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==3625) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==3659) && (req.is_tcp) && src_port_is_http && true )
    return true;
  if ( (req.rule_ID_in==3658) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==3673) && (req.is_tcp) && true && (req.dst_port==443) )
    return true;
  if ( (req.rule_ID_in==3672) && (req.is_tcp) && true && (req.dst_port==443) )
    return true;
  if ( (req.rule_ID_in==3660) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==3713) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==3712) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==3707) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==3706) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==3725) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==3723) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==3733) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==3761) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==3762) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==3764) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==3763) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==3780) && (req.is_tcp) && ((req.src_port==3030) || (req.src_port==1150)) && true )
    return true;
  if ( (req.rule_ID_in==3779) && (req.is_tcp) && true && (req.dst_port==81) )
    return true;
  if ( (req.rule_ID_in==3774) && (req.is_tcp) && ((req.src_port==1234) || (req.src_port==3340) || (req.src_port==3433) || (req.src_port==33911) || (req.src_port==64111)) && true )
    return true;
  if ( (req.rule_ID_in==3770) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==3769) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==3768) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==3767) && (req.is_tcp) && src_port_is_http && true )
    return true;
  if ( (req.rule_ID_in==3795) && (req.is_tcp) && true && true )
    return true;
  if ( (req.rule_ID_in==3794) && (req.is_tcp) && (req.src_port==443) && true )
    return true;
  if ( (req.rule_ID_in==3804) && (req.is_tcp) && true && (req.dst_port==21) )
    return true;
  if ( (req.rule_ID_in==3803) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==3802) && (req.is_tcp) && true && true )
    return true;
  if ( (req.rule_ID_in==3817) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==3815) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==3814) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==3813) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==3841) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==3840) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==3839) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==3838) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==3837) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==3828) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==3827) && (req.is_tcp) && (req.src_port==81) && true )
    return true;
  if ( (req.rule_ID_in==3822) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==3842) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==3858) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==3871) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==3870) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==3869) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==3879) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==3878) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==3872) && (req.is_tcp) && true && (req.dst_port==443) )
    return true;
  if ( (req.rule_ID_in==3883) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==3897) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==3896) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==3894) && (req.is_tcp) && true && (req.dst_port==20) )
    return true;
  if ( (req.rule_ID_in==3893) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==3892) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==3891) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==3890) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==3889) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==3909) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==3908) && (req.is_tcp) && true && dst_port_is_ftp )
    return true;
  if ( (req.rule_ID_in==3907) && (req.is_tcp) && true && dst_port_is_ftp )
    return true;
  if ( (req.rule_ID_in==3906) && (req.is_tcp) && true && dst_port_is_ftp )
    return true;
  if ( (req.rule_ID_in==3916) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==3915) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==3914) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==3913) && (req.is_tcp) && true && (req.dst_port==1777) )
    return true;
  if ( (req.rule_ID_in==3912) && (req.is_tcp) && (req.src_port==1777) && true )
    return true;
  if ( (req.rule_ID_in==3911) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==3910) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==3951) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==3942) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==3921) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==3920) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==3953) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==3952) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==3955) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==3956) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==3958) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==3971) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==3968) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==3989) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==3988) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==3987) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==3992) && (req.is_tcp) && true && ((req.dst_port==80) || (req.dst_port==443)) )
    return true;
  if ( (req.rule_ID_in==4059) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==4058) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==4057) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==4043) && (req.is_tcp) && true && (req.dst_port==45678) )
    return true;
  if ( (req.rule_ID_in==4042) && (req.is_tcp) && true && (req.dst_port==18892) )
    return true;
  if ( (req.rule_ID_in==4041) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==4040) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==4039) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==4038) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==4037) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==4036) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==4035) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==4034) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==4033) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==4032) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==4031) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==4030) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==4029) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==4028) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==3993) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==4076) && (req.is_tcp) && (req.src_port==8080) && true )
    return true;
  if ( (req.rule_ID_in==4072) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==4067) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==4086) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==4119) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==4118) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==4117) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==4116) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==4111) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==4110) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==4109) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==4155) && (req.is_tcp) && true && (req.dst_port==6667) )
    return true;
  if ( (req.rule_ID_in==4154) && (req.is_tcp) && (req.src_port==6667) && true )
    return true;
  if ( (req.rule_ID_in==4153) && (req.is_tcp) && src_port_is_http && true )
    return true;
  if ( (req.rule_ID_in==4152) && (req.is_tcp) && src_port_is_http && true )
    return true;
  if ( (req.rule_ID_in==4147) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==4146) && (req.is_tcp) && true && (req.dst_port==443) )
    return true;
  if ( (req.rule_ID_in==4145) && (req.is_tcp) && src_port_is_http && true )
    return true;
  if ( (req.rule_ID_in==4144) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==4158) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==4156) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==4170) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==4166) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==4175) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==4174) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==4180) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==4179) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==4178) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==4177) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==4218) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==4190) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==4230) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==4229) && (req.is_tcp) && src_port_is_http && true )
    return true;
  if ( (req.rule_ID_in==4226) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==4238) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==4249) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==4246) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==4291) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==4290) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==4289) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==4286) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==4285) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==4305) && (req.is_tcp) && true && true )
    return true;
  if ( (req.rule_ID_in==4304) && (req.is_tcp) && src_port_is_http && true )
    return true;
  if ( (req.rule_ID_in==4326) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==4328) && (req.is_tcp) && (req.src_port==2556) && true )
    return true;
  if ( (req.rule_ID_in==4330) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==4329) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==4362) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==4380) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==4383) && (req.is_tcp) && true && true )
    return true;
  if ( (req.rule_ID_in==4382) && (req.is_tcp) && true && true )
    return true;
  if ( (req.rule_ID_in==4381) && (req.is_tcp) && true && true )
    return true;
  if ( (req.rule_ID_in==4389) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==4388) && (req.is_tcp) && (req.src_port==4043) && true )
    return true;
  if ( (req.rule_ID_in==4384) && (req.is_tcp) && src_port_is_http && true )
    return true;
  if ( (req.rule_ID_in==4392) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==4391) && (req.is_tcp) && true && (req.dst_port==21) )
    return true;
  if ( (req.rule_ID_in==4390) && (req.is_tcp) && true && (req.dst_port==21) )
    return true;
  if ( (req.rule_ID_in==4437) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==4434) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==4433) && (!req.is_tcp) && true && true )
    return true;
  if ( (req.rule_ID_in==4432) && (!req.is_tcp) && true && true )
    return true;
  if ( (req.rule_ID_in==4431) && (!req.is_tcp) && true && true )
    return true;
  if ( (req.rule_ID_in==4430) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==4443) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==4442) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==4441) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==4440) && (req.is_tcp) && src_port_is_http && true )
    return true;
  if ( (req.rule_ID_in==4439) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==4450) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==4449) && (req.is_tcp) && src_port_is_http && true )
    return true;
  if ( (req.rule_ID_in==4448) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==4447) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==4446) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==4457) && (req.is_tcp) && src_port_is_http && true )
    return true;
  if ( (req.rule_ID_in==4456) && (req.is_tcp) && true && true )
    return true;
  if ( (req.rule_ID_in==4455) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==4454) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==4453) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==4469) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==4468) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==4467) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==4466) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==4465) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==4463) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==4478) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==4479) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==4505) && (req.is_tcp) && true && (req.dst_port>=2012) )
    return true;
  if ( (req.rule_ID_in==4503) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==4480) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==4559) && (req.is_tcp) && src_port_is_http && true )
    return true;
  if ( (req.rule_ID_in==4558) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==4550) && (req.is_tcp) && true && ((req.dst_port==25) || (req.dst_port==587)) )
    return true;
  if ( (req.rule_ID_in==4549) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==4548) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==4547) && (req.is_tcp) && true && true )
    return true;
  if ( (req.rule_ID_in==4546) && (!req.is_tcp) && true && (req.dst_port==6892) )
    return true;
  if ( (req.rule_ID_in==4570) && (req.is_tcp) && true && true )
    return true;
  if ( (req.rule_ID_in==4569) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==4600) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==4584) && (req.is_tcp) && true && (req.dst_port==80) )
    return true;
  if ( (req.rule_ID_in==4583) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==4602) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==4601) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==4608) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==4607) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==4603) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==4615) && (req.is_tcp) && true && true )
    return true;
  if ( (req.rule_ID_in==4617) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==4616) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==4624) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==4623) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==4622) && (req.is_tcp) && src_port_is_http && true )
    return true;
  if ( (req.rule_ID_in==4621) && (req.is_tcp) && true && true )
    return true;
  if ( (req.rule_ID_in==4620) && (req.is_tcp) && true && true )
    return true;
  if ( (req.rule_ID_in==4659) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==4663) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==4660) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==4668) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==4667) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==4680) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==4675) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==4674) && (req.is_tcp) && true && ((req.dst_port==25) || (req.dst_port==587)) )
    return true;
  if ( (req.rule_ID_in==4673) && (req.is_tcp) && true && ((req.dst_port==25) || (req.dst_port==587)) )
    return true;
  if ( (req.rule_ID_in==4684) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==4687) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==4730) && (req.is_tcp) && true && true )
    return true;
  if ( (req.rule_ID_in==4729) && (req.is_tcp) && true && true )
    return true;
  if ( (req.rule_ID_in==4728) && (req.is_tcp) && true && true )
    return true;
  if ( (req.rule_ID_in==4727) && (req.is_tcp) && true && true )
    return true;
  if ( (req.rule_ID_in==4726) && (req.is_tcp) && true && true )
    return true;
  if ( (req.rule_ID_in==4725) && (req.is_tcp) && true && (req.dst_port>=9000) )
    return true;
  if ( (req.rule_ID_in==4724) && (req.is_tcp) && true && true )
    return true;
  if ( (req.rule_ID_in==4723) && (req.is_tcp) && true && true )
    return true;
  if ( (req.rule_ID_in==4738) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==4736) && (req.is_tcp) && (req.src_port==5050) && true )
    return true;
  if ( (req.rule_ID_in==4732) && (req.is_tcp) && src_port_is_http && true )
    return true;
  if ( (req.rule_ID_in==4748) && (req.is_tcp) && src_port_is_http && true )
    return true;
  if ( (req.rule_ID_in==4744) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==4743) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==4756) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==4769) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==4764) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==4774) && (req.is_tcp) && true && (req.dst_port==900) )
    return true;
  if ( (req.rule_ID_in==4771) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==4804) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==4803) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==4802) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==4801) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==4800) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==4799) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==4798) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==4807) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==4809) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==4812) && (req.is_tcp) && true && ((req.dst_port==25) || (req.dst_port==587)) )
    return true;
  if ( (req.rule_ID_in==4830) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==4827) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==4824) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==4822) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==4821) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==4832) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==4831) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==4841) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==4838) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==4837) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==4881) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==4880) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==4879) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==4877) && (req.is_tcp) && true && (req.dst_port==1395) )
    return true;
  if ( (req.rule_ID_in==4876) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==4875) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==4874) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==4873) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==4872) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==4867) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==4892) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==4890) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==4894) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==4893) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==4897) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==4896) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==4895) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==4898) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==4901) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==4904) && (!req.is_tcp) && true && (req.dst_port==4444) )
    return true;
  if ( (req.rule_ID_in==4903) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==4902) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==4929) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==4928) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==4939) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==4936) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==4934) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==4941) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==4940) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==4944) && (req.is_tcp) && true && (dst_port_is_http || req.dst_port==8000) )
    return true;
  if ( (req.rule_ID_in==4943) && (req.is_tcp) && true && ((req.dst_port==8088) || (req.dst_port==18001) || (req.dst_port==18088)) )
    return true;
  if ( (req.rule_ID_in==4953) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==4952) && (req.is_tcp) && true && (req.dst_port==23) )
    return true;
  if ( (req.rule_ID_in==4951) && (req.is_tcp) && true && ((req.dst_port==23) || (req.dst_port==2323) || (req.dst_port==5555) || (req.dst_port==7547)) )
    return true;
  if ( (req.rule_ID_in==4950) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==4949) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==4948) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==4961) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==4958) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==4957) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==4956) && (req.is_tcp) && true && true )
    return true;
  if ( (req.rule_ID_in==4979) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==4977) && (req.is_tcp) && true && (req.dst_port==23) )
    return true;
  if ( (req.rule_ID_in==4976) && (req.is_tcp) && true && (req.dst_port==23) )
    return true;
  if ( (req.rule_ID_in==4975) && (req.is_tcp) && true && (req.dst_port==23) )
    return true;
  if ( (req.rule_ID_in==4974) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==4982) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==4981) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==5009) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==5025) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==5024) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==5032) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==5030) && (req.is_tcp) && true && true )
    return true;
  if ( (req.rule_ID_in==5029) && (req.is_tcp) && true && true )
    return true;
  if ( (req.rule_ID_in==5028) && (req.is_tcp) && true && true )
    return true;
  if ( (req.rule_ID_in==5027) && (req.is_tcp) && true && (req.dst_port==12421) )
    return true;
  if ( (req.rule_ID_in==5042) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==5046) && (req.is_tcp) && true && ((req.dst_port==15963) || (req.dst_port==1114) || (req.dst_port==9999) || (req.dst_port==80) || (req.dst_port==81) || (req.dst_port==1177) || (req.dst_port==1100)) )
    return true;
  if ( (req.rule_ID_in==5045) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==5044) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==5054) && (req.is_tcp) && true && true )
    return true;
  if ( (req.rule_ID_in==5053) && (req.is_tcp) && true && true )
    return true;
  if ( (req.rule_ID_in==5052) && (req.is_tcp) && true && true )
    return true;
  if ( (req.rule_ID_in==5051) && (req.is_tcp) && true && true )
    return true;
  if ( (req.rule_ID_in==5050) && (req.is_tcp) && true && true )
    return true;
  if ( (req.rule_ID_in==5049) && (req.is_tcp) && true && true )
    return true;
  if ( (req.rule_ID_in==5064) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==5067) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==5066) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==5095) && (req.is_tcp) && true && (req.dst_port==31337) )
    return true;
  if ( (req.rule_ID_in==5105) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==5104) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==5111) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==5110) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==5120) && (req.is_tcp) && src_port_is_http && true )
    return true;
  if ( (req.rule_ID_in==5119) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==5118) && (req.is_tcp) && src_port_is_http && true )
    return true;
  if ( (req.rule_ID_in==5132) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==5131) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==5130) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==5129) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==5128) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==5127) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==5125) && (req.is_tcp) && src_port_is_http && true )
    return true;
  if ( (req.rule_ID_in==5141) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==5140) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==5151) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==5150) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==5149) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==5148) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==5146) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==5183) && (req.is_tcp) && src_port_is_http && true )
    return true;
  if ( (req.rule_ID_in==5182) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==5181) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==5177) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==5176) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==5175) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==5174) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==5170) && (req.is_tcp) && true && (req.dst_port==443) )
    return true;
  if ( (req.rule_ID_in==5168) && (req.is_tcp) && (req.src_port==6667) && true )
    return true;
  if ( (req.rule_ID_in==5167) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==5166) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==5165) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==5164) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==5186) && (req.is_tcp) && src_port_is_http && true )
    return true;
  if ( (req.rule_ID_in==5217) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==5228) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==5227) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==5226) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==5224) && (req.is_tcp) && ((req.src_port==4431) || (req.src_port==4432) || (req.src_port==4433)) && true )
    return true;
  if ( (req.rule_ID_in==5223) && (req.is_tcp) && ((req.src_port==4431) || (req.src_port==4432) || (req.src_port==4433)) && true )
    return true;
  if ( (req.rule_ID_in==5221) && (req.is_tcp) && true && (req.dst_port==8888) )
    return true;
  if ( (req.rule_ID_in==5220) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==5219) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==5232) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==5231) && (req.is_tcp) && true && true )
    return true;
  if ( (req.rule_ID_in==5247) && (!req.is_tcp) && (req.src_port==53) && true )
    return true;
  if ( (req.rule_ID_in==5246) && (req.is_tcp) && (req.src_port==53) && true )
    return true;
  if ( (req.rule_ID_in==5243) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==5302) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==5301) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==5300) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==5299) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==5298) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==5297) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==5296) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==5295) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==5294) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==5293) && (req.is_tcp) && true && (req.dst_port==18080) )
    return true;
  if ( (req.rule_ID_in==5292) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==5306) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==5312) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==5311) && (req.is_tcp) && true && true )
    return true;
  if ( (req.rule_ID_in==5310) && (req.is_tcp) && true && true )
    return true;
  if ( (req.rule_ID_in==5309) && (req.is_tcp) && true && true )
    return true;
  if ( (req.rule_ID_in==5313) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==5314) && (req.is_tcp) && true && ((req.dst_port==23) || (req.dst_port==2323) || (req.dst_port==5555) || (req.dst_port==7547)) )
    return true;
  if ( (req.rule_ID_in==5315) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==5317) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==5316) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==5328) && (req.is_tcp) && (req.src_port==443) && true )
    return true;
  if ( (req.rule_ID_in==5327) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==5351) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==5350) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==5349) && (req.is_tcp) && true && (req.dst_port==799) )
    return true;
  if ( (req.rule_ID_in==5347) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==5346) && (req.is_tcp) && true && ((req.dst_port==995) || (req.dst_port==80) || (req.dst_port==53) || (req.dst_port==443)) )
    return true;
  if ( (req.rule_ID_in==5360) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==5359) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==5358) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==5365) && (req.is_tcp) && true && (req.dst_port==445) )
    return true;
  if ( (req.rule_ID_in==5364) && (req.is_tcp) && (req.src_port==445) && true )
    return true;
  if ( (req.rule_ID_in==5379) && (req.is_tcp) && true && ((req.dst_port==995) || (req.dst_port==80) || (req.dst_port==53) || (req.dst_port==443)) )
    return true;
  if ( (req.rule_ID_in==5378) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==5377) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==5376) && (req.is_tcp) && true && (req.dst_port==799) )
    return true;
  if ( (req.rule_ID_in==5375) && (req.is_tcp) && true && (dst_port_is_http || req.dst_port==53) )
    return true;
  if ( (req.rule_ID_in==5381) && (req.is_tcp) && src_port_is_http && true )
    return true;
  if ( (req.rule_ID_in==5380) && (req.is_tcp) && src_port_is_http && true )
    return true;
  if ( (req.rule_ID_in==5386) && (req.is_tcp) && src_port_is_http && true )
    return true;
  if ( (req.rule_ID_in==5385) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==5384) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==5382) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==5424) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==5423) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==5422) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==5421) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==5420) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==5441) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==5439) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==5438) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==5434) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==5433) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==5432) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==5431) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==5448) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==5447) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==5446) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==5527) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==5522) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==5521) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==5517) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==5513) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==5512) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==5511) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==5495) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==5493) && (req.is_tcp) && src_port_is_http && true )
    return true;
  if ( (req.rule_ID_in==5492) && (req.is_tcp) && src_port_is_http && true )
    return true;
  if ( (req.rule_ID_in==5489) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==5488) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==5482) && (req.is_tcp) && true && true )
    return true;
  if ( (req.rule_ID_in==5481) && (req.is_tcp) && true && true )
    return true;
  if ( (req.rule_ID_in==5480) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==5460) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==5455) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==5452) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==5544) && (req.is_tcp) && true && (req.dst_port==7080) )
    return true;
  if ( (req.rule_ID_in==5558) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==5554) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==5574) && (req.is_tcp) && true && (req.dst_port==443) )
    return true;
  if ( (req.rule_ID_in==5567) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==5566) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==5565) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==5578) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==5577) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==5581) && (req.is_tcp) && true && (req.dst_port==2008) )
    return true;
  if ( (req.rule_ID_in==5589) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==5597) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==5596) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==5593) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==5592) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==5591) && (req.is_tcp) && true && (req.dst_port==443) )
    return true;
  if ( (req.rule_ID_in==5590) && (req.is_tcp) && true && (req.dst_port==8001) )
    return true;
  if ( (req.rule_ID_in==5602) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==5601) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==5600) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==5607) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==5605) && (req.is_tcp) && src_port_is_http && true )
    return true;
  if ( (req.rule_ID_in==5604) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==5603) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==5620) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==5619) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==5638) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==5637) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==5636) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==5635) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==5634) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==5633) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==5632) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==5631) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==5630) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==5629) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==5628) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==5627) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==5626) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==5625) && (req.is_tcp) && ((req.src_port==443) || (req.src_port==447) || (req.src_port==449)) && true )
    return true;
  if ( (req.rule_ID_in==5624) && (req.is_tcp) && ((req.src_port==443) || (req.src_port==447) || (req.src_port==449)) && true )
    return true;
  if ( (req.rule_ID_in==5623) && (req.is_tcp) && ((req.src_port==443) || (req.src_port==447) || (req.src_port==449)) && true )
    return true;
  if ( (req.rule_ID_in==5622) && (req.is_tcp) && ((req.src_port==443) || (req.src_port==447) || (req.src_port==449)) && true )
    return true;
  if ( (req.rule_ID_in==5621) && (!req.is_tcp) && true && (req.dst_port==53) )
    return true;
  if ( (req.rule_ID_in==5646) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==5645) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==5642) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==5641) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==5658) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==5657) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==5656) && (req.is_tcp) && true && (req.dst_port==6280) )
    return true;
  if ( (req.rule_ID_in==5666) && (!req.is_tcp) && true && (req.dst_port==53) )
    return true;
  if ( (req.rule_ID_in==5665) && (req.is_tcp) && (req.src_port==443) && true )
    return true;
  if ( (req.rule_ID_in==5664) && (req.is_tcp) && (req.src_port==443) && true )
    return true;
  if ( (req.rule_ID_in==5660) && (req.is_tcp) && true && true )
    return true;
  if ( (req.rule_ID_in==5659) && (req.is_tcp) && true && true )
    return true;
  if ( (req.rule_ID_in==5672) && (req.is_tcp) && true && (req.dst_port==7878) )
    return true;
  if ( (req.rule_ID_in==5671) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==5670) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==5669) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==5668) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==5667) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==5673) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==5682) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==5679) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==5678) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==5677) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==5686) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==5683) && (req.is_tcp) && (req.src_port==8888) && true )
    return true;
  if ( (req.rule_ID_in==5707) && (req.is_tcp) && src_port_is_http && true )
    return true;
  if ( (req.rule_ID_in==5706) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==5704) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==5703) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==5702) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==5701) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==5700) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==5699) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==5698) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==5697) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==5696) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==5693) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==5692) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==5691) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==5690) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==5689) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==5688) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==5687) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==5715) && (!req.is_tcp) && true && (req.dst_port==53) )
    return true;
  if ( (req.rule_ID_in==5714) && (!req.is_tcp) && true && (req.dst_port==53) )
    return true;
  if ( (req.rule_ID_in==5713) && (!req.is_tcp) && true && (req.dst_port==53) )
    return true;
  if ( (req.rule_ID_in==5712) && (!req.is_tcp) && true && (req.dst_port==53) )
    return true;
  if ( (req.rule_ID_in==5711) && (!req.is_tcp) && true && (req.dst_port==53) )
    return true;
  if ( (req.rule_ID_in==5710) && (!req.is_tcp) && true && (req.dst_port==53) )
    return true;
  if ( (req.rule_ID_in==5709) && (!req.is_tcp) && true && (req.dst_port==53) )
    return true;
  if ( (req.rule_ID_in==5708) && (!req.is_tcp) && true && (req.dst_port==53) )
    return true;
  if ( (req.rule_ID_in==5729) && (req.is_tcp) && true && true )
    return true;
  if ( (req.rule_ID_in==5758) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==5757) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==5756) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==5749) && (req.is_tcp) && true && (req.dst_port==443) )
    return true;
  if ( (req.rule_ID_in==5748) && (req.is_tcp) && true && (req.dst_port==443) )
    return true;
  if ( (req.rule_ID_in==5747) && (req.is_tcp) && true && (req.dst_port==443) )
    return true;
  if ( (req.rule_ID_in==5746) && (req.is_tcp) && true && (req.dst_port==443) )
    return true;
  if ( (req.rule_ID_in==5740) && (req.is_tcp) && true && (req.dst_port==22) )
    return true;
  if ( (req.rule_ID_in==5737) && (req.is_tcp) && src_port_is_http && true )
    return true;
  if ( (req.rule_ID_in==5736) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==5735) && (req.is_tcp) && src_port_is_http && true )
    return true;
  if ( (req.rule_ID_in==5762) && (req.is_tcp) && ( ((req.src_port>=6660) && (req.src_port<=6669)) || (req.src_port==7000) ) && true )
    return true;
  if ( (req.rule_ID_in==5769) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==5768) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==5766) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==5778) && (req.is_tcp) && true && true )
    return true;
  if ( (req.rule_ID_in==5777) && (req.is_tcp) && true && true )
    return true;
  if ( (req.rule_ID_in==5776) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==5775) && (req.is_tcp) && src_port_is_http && true )
    return true;
  if ( (req.rule_ID_in==5774) && (req.is_tcp) && src_port_is_http && true )
    return true;
  if ( (req.rule_ID_in==5773) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==5772) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==5771) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==5770) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==5779) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==5800) && (!req.is_tcp) && true && (req.dst_port==6892) )
    return true;
  if ( (req.rule_ID_in==5805) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==5801) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==5815) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==5814) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==5812) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==5809) && (req.is_tcp) && src_port_is_http && true )
    return true;
  if ( (req.rule_ID_in==5808) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==5817) && (!req.is_tcp) && true && (req.dst_port==1502) )
    return true;
  if ( (req.rule_ID_in==5836) && (req.is_tcp) && src_port_is_http && true )
    return true;
  if ( (req.rule_ID_in==5835) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==5834) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==5833) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==5832) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==5831) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==5830) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==5829) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==5828) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==5827) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==5826) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==5825) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==5824) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==5823) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==5850) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==5864) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==5863) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==5862) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==5861) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==5860) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==5859) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==5858) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==5866) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==5871) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==5885) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==5884) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==5882) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==5881) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==5880) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==5879) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==5886) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==5890) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==5905) && (req.is_tcp) && true && (dst_port_is_http || (req.dst_port>=1025)) )
    return true;
  if ( (req.rule_ID_in==5902) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==5900) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==5899) && (req.is_tcp) && true && (req.dst_port>=1025) )
    return true;
  if ( (req.rule_ID_in==5898) && (req.is_tcp) && (req.src_port>=1025) && true )
    return true;
  if ( (req.rule_ID_in==5897) && (req.is_tcp) && (req.src_port>=1025) && true )
    return true;
  if ( (req.rule_ID_in==5896) && (req.is_tcp) && (req.src_port>=1025) && true )
    return true;
  if ( (req.rule_ID_in==5895) && (req.is_tcp) && true && (req.dst_port>=1025) )
    return true;
  if ( (req.rule_ID_in==5908) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==5917) && (req.is_tcp) && true && ((req.dst_port==8043) || (req.dst_port==8080) || (req.dst_port==8843)) )
    return true;
  if ( (req.rule_ID_in==5916) && (req.is_tcp) && true && ((req.dst_port==8043) || (req.dst_port==8080) || (req.dst_port==8843)) )
    return true;
  if ( (req.rule_ID_in==5915) && (req.is_tcp) && true && ((req.dst_port==8043) || (req.dst_port==8080) || (req.dst_port==8843)) )
    return true;
  if ( (req.rule_ID_in==5914) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==5928) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==5927) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==5924) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==5953) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==5952) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==5947) && (req.is_tcp) && src_port_is_http && true )
    return true;
  if ( (req.rule_ID_in==5946) && (!req.is_tcp) && (req.src_port==53) && true )
    return true;
  if ( (req.rule_ID_in==5945) && (!req.is_tcp) && true && (req.dst_port==53) )
    return true;
  if ( (req.rule_ID_in==5968) && (!req.is_tcp) && true && (req.dst_port==53) )
    return true;
  if ( (req.rule_ID_in==5967) && (!req.is_tcp) && true && (req.dst_port==53) )
    return true;
  if ( (req.rule_ID_in==5966) && (!req.is_tcp) && true && (req.dst_port==53) )
    return true;
  if ( (req.rule_ID_in==5965) && (!req.is_tcp) && true && (req.dst_port==53) )
    return true;
  if ( (req.rule_ID_in==5964) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==5963) && (req.is_tcp) && true && true )
    return true;
  if ( (req.rule_ID_in==5962) && (req.is_tcp) && true && true )
    return true;
  if ( (req.rule_ID_in==5961) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==5957) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==5956) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==5955) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==5954) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==5973) && (req.is_tcp) && true && true )
    return true;
  if ( (req.rule_ID_in==5970) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==5969) && (req.is_tcp) && true && ((req.dst_port==2050) || (req.dst_port==7020) || (req.dst_port==7628)) )
    return true;
  if ( (req.rule_ID_in==5975) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==5985) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==5984) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==5983) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==5982) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==5980) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==5979) && (req.is_tcp) && true && true )
    return true;
  if ( (req.rule_ID_in==5978) && (req.is_tcp) && true && true )
    return true;
  if ( (req.rule_ID_in==5977) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==5976) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==5988) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==5992) && (req.is_tcp) && true && (req.dst_port==443) )
    return true;
  if ( (req.rule_ID_in==5991) && (req.is_tcp) && true && (req.dst_port==8888) )
    return true;
  if ( (req.rule_ID_in==5990) && (req.is_tcp) && (req.src_port==8888) && true )
    return true;
  if ( (req.rule_ID_in==5989) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==5993) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==6031) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==6030) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==6029) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==6028) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==6027) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==6023) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==6022) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==6020) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==6011) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==6007) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==6040) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==6039) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==6038) && (req.is_tcp) && true && dst_port_is_ftp )
    return true;
  if ( (req.rule_ID_in==6037) && (req.is_tcp) && true && dst_port_is_ftp )
    return true;
  if ( (req.rule_ID_in==6036) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==6035) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==6045) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==6060) && (req.is_tcp) && true && dst_port_is_file_data )
    return true;
  if ( (req.rule_ID_in==6055) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==6054) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==6053) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==6052) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==6051) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==6050) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==6049) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==6048) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==6047) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==6078) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==6077) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==6076) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==6075) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==6074) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==6073) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==6072) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==6071) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==6066) && (req.is_tcp) && src_port_is_http && true )
    return true;
  if ( (req.rule_ID_in==6065) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==6093) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==6091) && (req.is_tcp) && true && (req.dst_port==443) )
    return true;
  if ( (req.rule_ID_in==6090) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==6089) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==6088) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==6087) && (req.is_tcp) && true && true )
    return true;
  if ( (req.rule_ID_in==6122) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==6121) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==6120) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==6119) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==6118) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==6117) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==6116) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==6115) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==6114) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==6113) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==6112) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==6111) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==6110) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==6109) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==6108) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==6107) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==6106) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==6105) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==6132) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==6131) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==6128) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==6127) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==6147) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==6161) && (req.is_tcp) && true && true )
    return true;
  if ( (req.rule_ID_in==6160) && (req.is_tcp) && true && true )
    return true;
  if ( (req.rule_ID_in==6158) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==6157) && (req.is_tcp) && true && dst_port_is_file_data )
    return true;
  if ( (req.rule_ID_in==6174) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==6173) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==6170) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==6169) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==6168) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==6167) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==6166) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==6165) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==6164) && (req.is_tcp) && true && ((req.dst_port==443) || (req.dst_port==8443)) )
    return true;
  if ( (req.rule_ID_in==6190) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==6189) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==6188) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==6185) && (req.is_tcp) && true && true )
    return true;
  if ( (req.rule_ID_in==6182) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==6180) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==6192) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==6195) && (req.is_tcp) && true && (req.dst_port==20480) )
    return true;
  if ( (req.rule_ID_in==6194) && (req.is_tcp) && (req.src_port==20480) && true )
    return true;
  if ( (req.rule_ID_in==6193) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==6198) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==6197) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==6215) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==6212) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==6207) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==6201) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==6221) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==6220) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==6219) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==6218) && (req.is_tcp) && ((req.src_port==443) || (req.src_port==447) || (req.src_port==449)) && true )
    return true;
  if ( (req.rule_ID_in==6217) && (req.is_tcp) && true && (req.dst_port==443) )
    return true;
  if ( (req.rule_ID_in==6216) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==6224) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==6223) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==6222) && (req.is_tcp) && true && true )
    return true;
  if ( (req.rule_ID_in==6229) && (req.is_tcp) && true && (dst_port_is_http || (req.dst_port==1337) || (req.dst_port==5156)) )
    return true;
  if ( (req.rule_ID_in==6228) && (req.is_tcp) && true && (dst_port_is_http || (req.dst_port==3000) || (req.dst_port==5156) || (req.dst_port==7218)) )
    return true;
  if ( (req.rule_ID_in==6227) && (req.is_tcp) && true && ((req.dst_port==1433) || (req.dst_port==5003)) )
    return true;
  if ( (req.rule_ID_in==6235) && (req.is_tcp) && true && true )
    return true;
  if ( (req.rule_ID_in==6234) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==6233) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==6230) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==6236) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==6242) && (req.is_tcp) && true && true )
    return true;
  if ( (req.rule_ID_in==6241) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==6240) && (req.is_tcp) && src_port_is_http && true )
    return true;
  if ( (req.rule_ID_in==6239) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==6238) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==6247) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==6246) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==6245) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==6244) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==6243) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==6264) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==6263) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==6271) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==6280) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==6279) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==6277) && (req.is_tcp) && true && true )
    return true;
  if ( (req.rule_ID_in==6276) && (req.is_tcp) && true && true )
    return true;
  if ( (req.rule_ID_in==6275) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==6274) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==6272) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==6302) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==6301) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==6300) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==6298) && (req.is_tcp) && src_port_is_http && true )
    return true;
  if ( (req.rule_ID_in==6297) && (req.is_tcp) && src_port_is_http && true )
    return true;
  if ( (req.rule_ID_in==6296) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==6295) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==6294) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==6291) && (req.is_tcp) && true && true )
    return true;
  if ( (req.rule_ID_in==6290) && (req.is_tcp) && true && true )
    return true;
  if ( (req.rule_ID_in==6289) && (req.is_tcp) && true && true )
    return true;
  if ( (req.rule_ID_in==6288) && (req.is_tcp) && true && true )
    return true;
  if ( (req.rule_ID_in==6287) && (req.is_tcp) && true && true )
    return true;
  if ( (req.rule_ID_in==6286) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==6285) && (req.is_tcp) && true && true )
    return true;
  if ( (req.rule_ID_in==6309) && (req.is_tcp) && true && true )
    return true;
  if ( (req.rule_ID_in==6308) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==6307) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==6306) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==6305) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==6316) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==6313) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==6317) && (req.is_tcp) && true && true )
    return true;
  if ( (req.rule_ID_in==6330) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==6329) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==6328) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==6327) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==6326) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==6325) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==6324) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==6323) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==6322) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==6319) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==6318) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==6348) && (req.is_tcp) && true && (req.dst_port==443) )
    return true;
  if ( (req.rule_ID_in==6343) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==6342) && (req.is_tcp) && true && true )
    return true;
  if ( (req.rule_ID_in==6357) && (req.is_tcp) && true && (req.dst_port==443) )
    return true;
  if ( (req.rule_ID_in==6356) && (req.is_tcp) && true && (req.dst_port==443) )
    return true;
  if ( (req.rule_ID_in==6355) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==6354) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==6353) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==6361) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==6360) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==6366) && (req.is_tcp) && src_port_is_http && true )
    return true;
  if ( (req.rule_ID_in==6365) && (!req.is_tcp) && true && (req.dst_port==6901) )
    return true;
  if ( (req.rule_ID_in==6364) && (req.is_tcp) && src_port_is_http && true )
    return true;
  if ( (req.rule_ID_in==6363) && (req.is_tcp) && src_port_is_http && true )
    return true;
  if ( (req.rule_ID_in==6372) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==6377) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==6380) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==6387) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==6385) && (req.is_tcp) && true && true )
    return true;
  if ( (req.rule_ID_in==6383) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==6382) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==6381) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==6389) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==6397) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==6407) && (req.is_tcp) && true && true )
    return true;
  if ( (req.rule_ID_in==6406) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==6405) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==6404) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==6402) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==6401) && (req.is_tcp) && src_port_is_http && true )
    return true;
  if ( (req.rule_ID_in==6400) && (req.is_tcp) && true && (req.dst_port==1700) )
    return true;
  if ( (req.rule_ID_in==6418) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==6417) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==6412) && (req.is_tcp) && true && (req.dst_port==5416) )
    return true;
  if ( (req.rule_ID_in==6427) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==6426) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==6425) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==6424) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==6423) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==6422) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==6421) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==6420) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==6419) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==6432) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==6431) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==6451) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==6450) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==6448) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==6447) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==6446) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==6445) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==6483) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==6480) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==6479) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==6478) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==6477) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==6476) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==6470) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==6469) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==6468) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==6467) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==6466) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==6465) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==6464) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==6463) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==6462) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==6461) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==6460) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==6459) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==6458) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==6457) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==6493) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==6492) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==6491) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==6490) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==6489) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==6488) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==6487) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==6486) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==6485) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==6499) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==6498) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==6497) && (req.is_tcp) && true && (req.dst_port==27) )
    return true;
  if ( (req.rule_ID_in==6496) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==6495) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==6508) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==6507) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==6506) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==6520) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==6519) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==6518) && (req.is_tcp) && true && (req.dst_port==8852) )
    return true;
  if ( (req.rule_ID_in==6517) && (req.is_tcp) && true && (req.dst_port==8852) )
    return true;
  if ( (req.rule_ID_in==6516) && (req.is_tcp) && true && (req.dst_port==8852) )
    return true;
  if ( (req.rule_ID_in==6515) && (req.is_tcp) && true && (req.dst_port==8852) )
    return true;
  if ( (req.rule_ID_in==6514) && (req.is_tcp) && true && (req.dst_port==8852) )
    return true;
  if ( (req.rule_ID_in==6513) && (req.is_tcp) && true && (req.dst_port==8694) )
    return true;
  if ( (req.rule_ID_in==6512) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==6511) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==6510) && (req.is_tcp) && true && ((req.dst_port==22) || (req.dst_port==23)) )
    return true;
  if ( (req.rule_ID_in==6528) && (req.is_tcp) && src_port_is_http && true )
    return true;
  if ( (req.rule_ID_in==6527) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==6526) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==6524) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==6523) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==6522) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==6521) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==6543) && (req.is_tcp) && true && true )
    return true;
  if ( (req.rule_ID_in==6542) && (req.is_tcp) && (req.src_port==443) && true )
    return true;
  if ( (req.rule_ID_in==6541) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==6540) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==6549) && (!req.is_tcp) && true && (req.dst_port==53) )
    return true;
  if ( (req.rule_ID_in==6556) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==6555) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==6554) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==6553) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==6552) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==6551) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==6557) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==6560) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==6559) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==6562) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==6561) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==6569) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==6568) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==6567) && (req.is_tcp) && src_port_is_http && true )
    return true;
  if ( (req.rule_ID_in==6566) && (req.is_tcp) && true && (dst_port_is_http || req.dst_port==6500) )
    return true;
  if ( (req.rule_ID_in==6565) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==6564) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==6563) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==6577) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==6576) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==6575) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==6574) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==6573) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==6572) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==6594) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==6593) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==6592) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==6591) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==6590) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==6586) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==6585) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==6584) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==6583) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==6600) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==6599) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==6627) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==6626) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==6640) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==6639) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==6638) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==6652) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==6651) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==6671) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==6670) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==6669) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==6668) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==6667) && (req.is_tcp) && true && (dst_port_is_http || req.dst_port==8880) )
    return true;
  if ( (req.rule_ID_in==6682) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==6681) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==6680) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==6677) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==6676) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==6675) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==6674) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==6703) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==6702) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==6701) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==6700) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==6699) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==6698) && (req.is_tcp) && true && (req.dst_port==443) )
    return true;
  if ( (req.rule_ID_in==6697) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==6696) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==6695) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==6694) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==6693) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==6692) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==6691) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==6690) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==6689) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==6686) && (req.is_tcp) && true && ((req.dst_port==443) || (req.dst_port==3606)) )
    return true;
  if ( (req.rule_ID_in==6685) && (req.is_tcp) && true && ((req.dst_port==443) || (req.dst_port==3606)) )
    return true;
  if ( (req.rule_ID_in==6684) && (req.is_tcp) && true && ((req.dst_port==443) || (req.dst_port==3606)) )
    return true;
  if ( (req.rule_ID_in==6683) && (req.is_tcp) && true && ((req.dst_port==443) || (req.dst_port==3606)) )
    return true;
  if ( (req.rule_ID_in==6713) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==6710) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==6709) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==6720) && (req.is_tcp) && true && true )
    return true;
  if ( (req.rule_ID_in==6719) && (req.is_tcp) && (req.src_port==443) && true )
    return true;
  if ( (req.rule_ID_in==6718) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==6722) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==6738) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==6737) && (req.is_tcp) && true && (dst_port_is_http || req.dst_port==4444) )
    return true;
  if ( (req.rule_ID_in==6736) && (req.is_tcp) && true && (dst_port_is_http || req.dst_port==4444) )
    return true;
  if ( (req.rule_ID_in==6735) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==6734) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==6733) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==6732) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==6731) && (req.is_tcp) && true && true )
    return true;
  if ( (req.rule_ID_in==6730) && (req.is_tcp) && true && true )
    return true;
  if ( (req.rule_ID_in==6729) && (req.is_tcp) && true && true )
    return true;
  if ( (req.rule_ID_in==6768) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==6774) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==6780) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==6779) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==6778) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==6777) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==6812) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==6811) && (req.is_tcp) && true && (req.dst_port==443) )
    return true;
  if ( (req.rule_ID_in==6810) && (req.is_tcp) && true && (req.dst_port==443) )
    return true;
  if ( (req.rule_ID_in==6809) && (req.is_tcp) && true && (req.dst_port==443) )
    return true;
  if ( (req.rule_ID_in==6808) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==6815) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==6819) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==6818) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==6817) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==6816) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==6832) && (req.is_tcp) && true && ((req.dst_port==139) || (req.dst_port==445)) )
    return true;
  if ( (req.rule_ID_in==6831) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==6830) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==6837) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==6836) && (!req.is_tcp) && true && (req.dst_port==53) )
    return true;
  if ( (req.rule_ID_in==6850) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==6849) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==6848) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==6847) && (req.is_tcp) && (req.src_port==443) && true )
    return true;
  if ( (req.rule_ID_in==6846) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==6845) && (req.is_tcp) && (req.src_port==443) && true )
    return true;
  if ( (req.rule_ID_in==6844) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==6843) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==6842) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==6841) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==6840) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==6839) && (req.is_tcp) && (req.src_port==443) && true )
    return true;
  if ( (req.rule_ID_in==6862) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==6861) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==6860) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==6859) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==6858) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==6857) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==6856) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==6855) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==6854) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==6853) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==6884) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==6883) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==6881) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==6880) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==6878) && (req.is_tcp) && (req.src_port==443) && true )
    return true;
  if ( (req.rule_ID_in==6877) && (req.is_tcp) && (req.src_port==443) && true )
    return true;
  if ( (req.rule_ID_in==6876) && (req.is_tcp) && (req.src_port==443) && true )
    return true;
  if ( (req.rule_ID_in==6875) && (req.is_tcp) && (req.src_port==443) && true )
    return true;
  if ( (req.rule_ID_in==6874) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==6873) && (req.is_tcp) && (req.src_port==443) && true )
    return true;
  if ( (req.rule_ID_in==6872) && (req.is_tcp) && (req.src_port==443) && true )
    return true;
  if ( (req.rule_ID_in==6871) && (req.is_tcp) && (req.src_port==443) && true )
    return true;
  if ( (req.rule_ID_in==6870) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==6866) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==6865) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==6888) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==6887) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==6886) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==6885) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==6893) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==6892) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==6891) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==6898) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==6919) && (req.is_tcp) && true && true )
    return true;
  if ( (req.rule_ID_in==6904) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==6903) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==6902) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==6901) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==6949) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==6948) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==6947) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==6946) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==6945) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==6944) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==6943) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==6942) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==6941) && (req.is_tcp) && true && ((req.dst_port==20) || (req.dst_port==21) || (req.dst_port==25)) )
    return true;
  if ( (req.rule_ID_in==6940) && (req.is_tcp) && true && (req.dst_port==4444) )
    return true;
  if ( (req.rule_ID_in==6939) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==6959) && (req.is_tcp) && src_port_is_http && true )
    return true;
  if ( (req.rule_ID_in==6958) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==6957) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==6956) && (req.is_tcp) && src_port_is_http && true )
    return true;
  if ( (req.rule_ID_in==6968) && (req.is_tcp) && src_port_is_http && true )
    return true;
  if ( (req.rule_ID_in==6967) && (req.is_tcp) && src_port_is_http && true )
    return true;
  if ( (req.rule_ID_in==6966) && (req.is_tcp) && src_port_is_http && true )
    return true;
  if ( (req.rule_ID_in==6965) && (req.is_tcp) && true && (req.dst_port==8393) )
    return true;
  if ( (req.rule_ID_in==6964) && (req.is_tcp) && true && (req.dst_port==8393) )
    return true;
  if ( (req.rule_ID_in==6976) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==6975) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==6974) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==6991) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==6990) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==6989) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==6988) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==6987) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==6986) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==6985) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==6984) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==6983) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==7019) && (req.is_tcp) && true && true )
    return true;
  if ( (req.rule_ID_in==7018) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==7017) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==7004) && (req.is_tcp) && true && true )
    return true;
  if ( (req.rule_ID_in==6993) && (req.is_tcp) && true && (req.dst_port==11000) )
    return true;
  if ( (req.rule_ID_in==6992) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==7023) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==7030) && (req.is_tcp) && true && (req.dst_port==8852) )
    return true;
  if ( (req.rule_ID_in==7025) && (req.is_tcp) && true && true )
    return true;
  if ( (req.rule_ID_in==7043) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==7042) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==7040) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==7038) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==7037) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==7036) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==7035) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==7034) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==7033) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==7055) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==7054) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==7053) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==7047) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==7046) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==7045) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==7044) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==7075) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==7074) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==7073) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==7072) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==7086) && (req.is_tcp) && true && (req.dst_port==3000) )
    return true;
  if ( (req.rule_ID_in==7085) && (req.is_tcp) && true && (req.dst_port==3000) )
    return true;
  if ( (req.rule_ID_in==7084) && (req.is_tcp) && true && (req.dst_port==3000) )
    return true;
  if ( (req.rule_ID_in==7083) && (req.is_tcp) && true && (req.dst_port==3000) )
    return true;
  if ( (req.rule_ID_in==7099) && (req.is_tcp) && true && (req.dst_port==445) )
    return true;
  if ( (req.rule_ID_in==7098) && (req.is_tcp) && true && (req.dst_port==445) )
    return true;
  if ( (req.rule_ID_in==7097) && (!req.is_tcp) && true && (req.dst_port==53) )
    return true;
  if ( (req.rule_ID_in==7096) && (!req.is_tcp) && true && (req.dst_port==53) )
    return true;
  if ( (req.rule_ID_in==7125) && (req.is_tcp) && true && true )
    return true;
  if ( (req.rule_ID_in==7124) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==7123) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==7122) && (req.is_tcp) && src_port_is_http && true )
    return true;
  if ( (req.rule_ID_in==7121) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==7120) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==7119) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==7118) && (!req.is_tcp) && true && (req.dst_port==443) )
    return true;
  if ( (req.rule_ID_in==7154) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==7153) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==7152) && (req.is_tcp) && true && true )
    return true;
  if ( (req.rule_ID_in==7151) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==7150) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==7149) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==7148) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==7147) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==7146) && (req.is_tcp) && true && (req.dst_port==22222) )
    return true;
  if ( (req.rule_ID_in==7145) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==7144) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==7143) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==7142) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==7141) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==7140) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==7139) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==7138) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==7137) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==7136) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==7135) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==7158) && (req.is_tcp) && true && true )
    return true;
  if ( (req.rule_ID_in==7169) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==7168) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==7173) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==7171) && (req.is_tcp) && true && (dst_port_is_http || req.dst_port==443) )
    return true;
  if ( (req.rule_ID_in==7170) && (req.is_tcp) && true && (dst_port_is_http || req.dst_port==443) )
    return true;
  if ( (req.rule_ID_in==7177) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==7176) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==7175) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==7174) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==7197) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==7192) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==7191) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==7190) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==7189) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==7188) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==7187) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==7186) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==7185) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==7203) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==7202) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==7220) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==7219) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==7218) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==7217) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==7214) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==7213) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==7226) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==7225) && (req.is_tcp) && true && true )
    return true;
  if ( (req.rule_ID_in==7224) && (req.is_tcp) && true && true )
    return true;
  if ( (req.rule_ID_in==7223) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==7234) && (!req.is_tcp) && true && (req.dst_port==53) )
    return true;
  if ( (req.rule_ID_in==7233) && (!req.is_tcp) && true && (req.dst_port==53) )
    return true;
  if ( (req.rule_ID_in==7232) && (!req.is_tcp) && true && (req.dst_port==53) )
    return true;
  if ( (req.rule_ID_in==7231) && (!req.is_tcp) && true && (req.dst_port==53) )
    return true;
  if ( (req.rule_ID_in==7230) && (!req.is_tcp) && true && (req.dst_port==53) )
    return true;
  if ( (req.rule_ID_in==7229) && (!req.is_tcp) && true && (req.dst_port==53) )
    return true;
  if ( (req.rule_ID_in==7228) && (!req.is_tcp) && true && (req.dst_port==53) )
    return true;
  if ( (req.rule_ID_in==7227) && (!req.is_tcp) && true && (req.dst_port==53) )
    return true;
  if ( (req.rule_ID_in==498) && (req.is_tcp) && (req.src_port==21) && true )
    return true;
  if ( (req.rule_ID_in==499) && (req.is_tcp) && (req.src_port==21) && true )
    return true;
  if ( (req.rule_ID_in==967) && (req.is_tcp) && src_port_is_http && true )
    return true;
  if ( (req.rule_ID_in==2224) && (req.is_tcp) && src_port_is_http && true )
    return true;
  if ( (req.rule_ID_in==3022) && (req.is_tcp) && true && true )
    return true;
  if ( (req.rule_ID_in==1652) && (req.is_tcp) && src_port_is_http && true )
    return true;
  if ( (req.rule_ID_in==1444) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==1382) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==1381) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==1375) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==1342) && (!req.is_tcp) && true && (req.dst_port==53) )
    return true;
  if ( (req.rule_ID_in==1341) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==1297) && (req.is_tcp) && src_port_is_http && true )
    return true;
  if ( (req.rule_ID_in==1283) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==1279) && (req.is_tcp) && src_port_is_http && true )
    return true;
  if ( (req.rule_ID_in==1244) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==1233) && (req.is_tcp) && src_port_is_http && true )
    return true;
  if ( (req.rule_ID_in==1219) && (req.is_tcp) && src_port_is_http && true )
    return true;
  if ( (req.rule_ID_in==1197) && (req.is_tcp) && src_port_is_http && true )
    return true;
  if ( (req.rule_ID_in==1167) && (req.is_tcp) && src_port_is_http && true )
    return true;
  if ( (req.rule_ID_in==1063) && (req.is_tcp) && src_port_is_http && true )
    return true;
  if ( (req.rule_ID_in==1062) && (req.is_tcp) && src_port_is_http && true )
    return true;
  if ( (req.rule_ID_in==1013) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==988) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==987) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==986) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==985) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==983) && (req.is_tcp) && src_port_is_http && true )
    return true;
  if ( (req.rule_ID_in==982) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==981) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==980) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==958) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==957) && (req.is_tcp) && src_port_is_http && true )
    return true;
  if ( (req.rule_ID_in==953) && (req.is_tcp) && src_port_is_http && true )
    return true;
  if ( (req.rule_ID_in==952) && (req.is_tcp) && src_port_is_http && true )
    return true;
  if ( (req.rule_ID_in==944) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==938) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==927) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==926) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==925) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==924) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==923) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==922) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==921) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==920) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==919) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==918) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==917) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==915) && (req.is_tcp) && src_port_is_http && true )
    return true;
  if ( (req.rule_ID_in==914) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==913) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==902) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==874) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==873) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==863) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==861) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==860) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==859) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==856) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==842) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==841) && (!req.is_tcp) && true && (req.dst_port==137) )
    return true;
  if ( (req.rule_ID_in==835) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==800) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==792) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==733) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==680) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==651) && (req.is_tcp) && src_port_is_http && true )
    return true;
  if ( (req.rule_ID_in==630) && (req.is_tcp) && src_port_is_http && true )
    return true;
  if ( (req.rule_ID_in==338) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==285) && (req.is_tcp) && true && (req.dst_port==21) )
    return true;
  if ( (req.rule_ID_in==277) && (req.is_tcp) && true && true )
    return true;
  if ( (req.rule_ID_in==136) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==130) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==126) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==124) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==123) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==120) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==119) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==115) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==92) && (req.is_tcp) && true && (req.dst_port==456) )
    return true;
  if ( (req.rule_ID_in==91) && (req.is_tcp) && true && (req.dst_port==456) )
    return true;
  if ( (req.rule_ID_in==90) && (req.is_tcp) && (req.src_port==456) && true )
    return true;
  if ( (req.rule_ID_in==89) && (req.is_tcp) && true && (req.dst_port==456) )
    return true;
  if ( (req.rule_ID_in==76) && (req.is_tcp) && true && (req.dst_port==456) )
    return true;
  if ( (req.rule_ID_in==70) && (req.is_tcp) && true && (req.dst_port==135) )
    return true;
  if ( (req.rule_ID_in==69) && (req.is_tcp) && true && (req.dst_port==445) )
    return true;
  if ( (req.rule_ID_in==68) && (req.is_tcp) && true && (req.dst_port==445) )
    return true;
  if ( (req.rule_ID_in==67) && (req.is_tcp) && true && (req.dst_port==445) )
    return true;
  if ( (req.rule_ID_in==64) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==62) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==61) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==57) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==56) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==53) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==52) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==51) && (req.is_tcp) && true && true )
    return true;
  if ( (req.rule_ID_in==50) && (req.is_tcp) && true && true )
    return true;
  if ( (req.rule_ID_in==49) && (req.is_tcp) && true && true )
    return true;
  if ( (req.rule_ID_in==48) && (req.is_tcp) && true && (req.dst_port==868) )
    return true;
  if ( (req.rule_ID_in==47) && (req.is_tcp) && (req.src_port==868) && true )
    return true;
  if ( (req.rule_ID_in==46) && (req.is_tcp) && (req.src_port==868) && true )
    return true;
  if ( (req.rule_ID_in==45) && (req.is_tcp) && (req.src_port==868) && true )
    return true;
  if ( (req.rule_ID_in==44) && (req.is_tcp) && (req.src_port==868) && true )
    return true;
  if ( (req.rule_ID_in==43) && (req.is_tcp) && true && (req.dst_port==10050) )
    return true;
  if ( (req.rule_ID_in==42) && (req.is_tcp) && true && (req.dst_port==10050) )
    return true;
  if ( (req.rule_ID_in==41) && (req.is_tcp) && true && (req.dst_port==10050) )
    return true;
  if ( (req.rule_ID_in==40) && (req.is_tcp) && true && (req.dst_port==10050) )
    return true;
  if ( (req.rule_ID_in==19) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==17) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==16) && (req.is_tcp) && true && (req.dst_port==21) )
    return true;
  if ( (req.rule_ID_in==15) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==13) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==1426) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==1424) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==1422) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==1471) && (req.is_tcp) && src_port_is_http && true )
    return true;
  if ( (req.rule_ID_in==1470) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==1475) && (req.is_tcp) && src_port_is_http && true )
    return true;
  if ( (req.rule_ID_in==1495) && (req.is_tcp) && src_port_is_http && true )
    return true;
  if ( (req.rule_ID_in==1494) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==1497) && (req.is_tcp) && src_port_is_http && true )
    return true;
  if ( (req.rule_ID_in==1505) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==1504) && (req.is_tcp) && src_port_is_http && true )
    return true;
  if ( (req.rule_ID_in==1718) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==1834) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==1886) && (req.is_tcp) && src_port_is_http && true )
    return true;
  if ( (req.rule_ID_in==1885) && (req.is_tcp) && src_port_is_http && true )
    return true;
  if ( (req.rule_ID_in==1884) && (req.is_tcp) && src_port_is_http && true )
    return true;
  if ( (req.rule_ID_in==1882) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==1994) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==2057) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==2144) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==2143) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==2226) && (req.is_tcp) && src_port_is_http && true )
    return true;
  if ( (req.rule_ID_in==2251) && (req.is_tcp) && src_port_is_http && true )
    return true;
  if ( (req.rule_ID_in==2250) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==2298) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==2383) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==2429) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==2460) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==2467) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==2617) && (req.is_tcp) && src_port_is_http && true )
    return true;
  if ( (req.rule_ID_in==2719) && (req.is_tcp) && true && true )
    return true;
  if ( (req.rule_ID_in==3154) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==3175) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==3197) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==3338) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==1725) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==3506) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==3505) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==3511) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==3844) && (req.is_tcp) && src_port_is_http && true )
    return true;
  if ( (req.rule_ID_in==4367) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==4387) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==4386) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==4385) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==4412) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==4411) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==4410) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==4409) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==4408) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==4407) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==4406) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==4436) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==4477) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==4476) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==4475) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==4474) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==4473) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==4472) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==4471) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==4470) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==4551) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==4666) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==4665) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==4733) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==4755) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==4765) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==4763) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==4762) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==4760) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==4759) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==4778) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==4777) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==4776) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==4775) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==4789) && (req.is_tcp) && true && (req.dst_port==443) )
    return true;
  if ( (req.rule_ID_in==4779) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==4818) && (!req.is_tcp) && (req.src_port==53) && true )
    return true;
  if ( (req.rule_ID_in==4817) && (!req.is_tcp) && (req.src_port==53) && true )
    return true;
  if ( (req.rule_ID_in==4816) && (!req.is_tcp) && (req.src_port==53) && true )
    return true;
  if ( (req.rule_ID_in==4815) && (!req.is_tcp) && (req.src_port==53) && true )
    return true;
  if ( (req.rule_ID_in==4823) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==4836) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==4835) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==4834) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==4871) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==4870) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==4869) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==4868) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==5068) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==5218) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==5416) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==5415) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==5532) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==5531) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==5530) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==5508) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==5487) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==5546) && (req.is_tcp) && true && (req.dst_port==445) )
    return true;
  if ( (req.rule_ID_in==5545) && (req.is_tcp) && true && (req.dst_port==445) )
    return true;
  if ( (req.rule_ID_in==5562) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==5583) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==5676) && (req.is_tcp) && true && (req.dst_port==445) )
    return true;
  if ( (req.rule_ID_in==5675) && (req.is_tcp) && true && (req.dst_port==445) )
    return true;
  if ( (req.rule_ID_in==5674) && (req.is_tcp) && true && (req.dst_port==445) )
    return true;
  if ( (req.rule_ID_in==5759) && (req.is_tcp) && ((req.src_port==139) || (req.src_port==445)) && true )
    return true;
  if ( (req.rule_ID_in==5869) && (req.is_tcp) && true && (req.dst_port==445) )
    return true;
  if ( (req.rule_ID_in==5868) && (req.is_tcp) && true && (req.dst_port==445) )
    return true;
  if ( (req.rule_ID_in==5867) && (req.is_tcp) && true && (req.dst_port==445) )
    return true;
  if ( (req.rule_ID_in==5883) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==5925) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==6162) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==6177) && (!req.is_tcp) && true && (req.dst_port==53) )
    return true;
  if ( (req.rule_ID_in==6181) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==6191) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==6226) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==6225) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==6231) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==6281) && (req.is_tcp) && true && (req.dst_port==445) )
    return true;
  if ( (req.rule_ID_in==6299) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==6310) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==6331) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==6410) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==6409) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==6408) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==6416) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==6415) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==6414) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==6413) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==6548) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==6571) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==6570) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==6596) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==6631) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==6630) && (req.is_tcp) && src_port_is_http && true )
    return true;
  if ( (req.rule_ID_in==6625) && (req.is_tcp) && src_port_is_http && true )
    return true;
  if ( (req.rule_ID_in==6624) && (req.is_tcp) && src_port_is_http && true )
    return true;
  if ( (req.rule_ID_in==6623) && (req.is_tcp) && src_port_is_http && true )
    return true;
  if ( (req.rule_ID_in==6622) && (req.is_tcp) && src_port_is_http && true )
    return true;
  if ( (req.rule_ID_in==6621) && (req.is_tcp) && src_port_is_http && true )
    return true;
  if ( (req.rule_ID_in==6664) && (req.is_tcp) && true && true )
    return true;
  if ( (req.rule_ID_in==6663) && (req.is_tcp) && true && true )
    return true;
  if ( (req.rule_ID_in==6662) && (req.is_tcp) && true && true )
    return true;
  if ( (req.rule_ID_in==6659) && (req.is_tcp) && true && true )
    return true;
  if ( (req.rule_ID_in==6658) && (req.is_tcp) && true && true )
    return true;
  if ( (req.rule_ID_in==6657) && (req.is_tcp) && true && true )
    return true;
  if ( (req.rule_ID_in==6656) && (req.is_tcp) && true && true )
    return true;
  if ( (req.rule_ID_in==6648) && (req.is_tcp) && true && (req.dst_port==445) )
    return true;
  if ( (req.rule_ID_in==6679) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==6688) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==6687) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==6712) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==6711) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==6724) && (req.is_tcp) && true && (req.dst_port==445) )
    return true;
  if ( (req.rule_ID_in==6723) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==6882) && (req.is_tcp) && src_port_is_http && true )
    return true;
  if ( (req.rule_ID_in==6867) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==6938) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==6937) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==6954) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==6962) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==6961) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==6970) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==6969) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==6982) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==6981) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==6980) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==7021) && (req.is_tcp) && true && (req.dst_port==445) )
    return true;
  if ( (req.rule_ID_in==7020) && (req.is_tcp) && true && (req.dst_port==445) )
    return true;
  if ( (req.rule_ID_in==7081) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==7080) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==7079) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==7094) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==7093) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==7092) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==7091) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==7090) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==7089) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==7088) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==7087) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==7082) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==7117) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==7116) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==7104) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==7103) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==7102) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==7172) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==7195) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==7194) && (req.is_tcp) && src_port_is_http && true )
    return true;
  if ( (req.rule_ID_in==7204) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==7201) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==7200) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==7216) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==7222) && (req.is_tcp) && ((req.src_port==443) || (req.src_port==447) || (req.src_port==449)) && true )
    return true;
  if ( (req.rule_ID_in==7221) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==532) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==523) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==483) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==478) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==55) && (req.is_tcp) && true && (req.dst_port==4563) )
    return true;
  if ( (req.rule_ID_in==54) && (req.is_tcp) && true && (req.dst_port==4563) )
    return true;
  if ( (req.rule_ID_in==1915) && (req.is_tcp) && true && (req.dst_port==20) )
    return true;
  if ( (req.rule_ID_in==3496) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==4231) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==4768) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==4767) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==4766) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==4758) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==5241) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==6582) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==7133) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==7159) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==7167) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==7178) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==7) && (req.is_tcp) && true && (req.dst_port==445) )
    return true;
  if ( (req.rule_ID_in==8) && (req.is_tcp) && true && (req.dst_port==445) )
    return true;
  if ( (req.rule_ID_in==151) && (req.is_tcp) && true && ((req.dst_port==139) || (req.dst_port==445)) )
    return true;
  if ( (req.rule_ID_in==150) && (req.is_tcp) && true && ((req.dst_port==139) || (req.dst_port==445)) )
    return true;
  if ( (req.rule_ID_in==177) && (req.is_tcp) && true && (req.dst_port==445) )
    return true;
  if ( (req.rule_ID_in==335) && (req.is_tcp) && true && ((req.dst_port==139) || (req.dst_port==445)) )
    return true;
  if ( (req.rule_ID_in==369) && (req.is_tcp) && true && ((req.dst_port==139) || (req.dst_port==445)) )
    return true;
  if ( (req.rule_ID_in==223) && (req.is_tcp) && true && ((req.dst_port==139) || (req.dst_port==445)) )
    return true;
  if ( (req.rule_ID_in==205) && (req.is_tcp) && true && ((req.dst_port==139) || (req.dst_port==445)) )
    return true;
  if ( (req.rule_ID_in==204) && (req.is_tcp) && true && ((req.dst_port==139) || (req.dst_port==445)) )
    return true;
  if ( (req.rule_ID_in==6504) && (req.is_tcp) && true && ((req.dst_port==139) || (req.dst_port==445)) )
    return true;
  if ( (req.rule_ID_in==4164) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==4811) && (req.is_tcp) && (req.src_port==3240) && true )
    return true;
  if ( (req.rule_ID_in==4810) && (req.is_tcp) && (req.src_port==3240) && true )
    return true;
  if ( (req.rule_ID_in==4954) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==4964) && (req.is_tcp) && true && true )
    return true;
  if ( (req.rule_ID_in==4963) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==4962) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==5107) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==810) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==2281) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==3541) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==2599) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==2598) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==2641) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==2640) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==2639) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==3708) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==5135) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==5062) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==5287) && (req.is_tcp) && (req.src_port==443) && true )
    return true;
  if ( (req.rule_ID_in==5842) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==5841) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==5840) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==5839) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==5838) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==5837) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==5854) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==12) && (req.is_tcp) && true && (req.dst_port==515) )
    return true;
  if ( (req.rule_ID_in==5352) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==5283) && (req.is_tcp) && true && (req.dst_port==445) )
    return true;
  if ( (req.rule_ID_in==5202) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==5199) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==5196) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==866) && (req.is_tcp) && true && ((req.dst_port==139) || (req.dst_port==445)) )
    return true;
  if ( (req.rule_ID_in==834) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==1453) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==2568) && (req.is_tcp) && true && (req.dst_port==88) )
    return true;
  if ( (req.rule_ID_in==2797) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==2782) && (!req.is_tcp) && (req.src_port==4433) && true )
    return true;
  if ( (req.rule_ID_in==2781) && (req.is_tcp) && true && (req.dst_port==443) )
    return true;
  if ( (req.rule_ID_in==2780) && (req.is_tcp) && true && (req.dst_port==443) )
    return true;
  if ( (req.rule_ID_in==2779) && (req.is_tcp) && true && (req.dst_port==443) )
    return true;
  if ( (req.rule_ID_in==2778) && (req.is_tcp) && true && (req.dst_port==443) )
    return true;
  if ( (req.rule_ID_in==2777) && (req.is_tcp) && (req.src_port==443) && true )
    return true;
  if ( (req.rule_ID_in==2776) && (req.is_tcp) && (req.src_port==443) && true )
    return true;
  if ( (req.rule_ID_in==2775) && (req.is_tcp) && (req.src_port==443) && true )
    return true;
  if ( (req.rule_ID_in==2774) && (req.is_tcp) && true && (req.dst_port==443) )
    return true;
  if ( (req.rule_ID_in==2773) && (req.is_tcp) && (req.src_port==443) && true )
    return true;
  if ( (req.rule_ID_in==2772) && (req.is_tcp) && (req.src_port==443) && true )
    return true;
  if ( (req.rule_ID_in==2771) && (req.is_tcp) && (req.src_port==443) && true )
    return true;
  if ( (req.rule_ID_in==2770) && (req.is_tcp) && (req.src_port==443) && true )
    return true;
  if ( (req.rule_ID_in==2769) && (req.is_tcp) && (req.src_port==443) && true )
    return true;
  if ( (req.rule_ID_in==2873) && (req.is_tcp) && true && (req.dst_port==443) )
    return true;
  if ( (req.rule_ID_in==3140) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==3163) && (req.is_tcp) && true && ((req.dst_port==139) || (req.dst_port==445)) )
    return true;
  if ( (req.rule_ID_in==3242) && (req.is_tcp) && true && (req.dst_port==443) )
    return true;
  if ( (req.rule_ID_in==3275) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==3367) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==3359) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==2035) && (req.is_tcp) && true && ((req.dst_port==137) || (req.dst_port==139)) )
    return true;
  if ( (req.rule_ID_in==1740) && (req.is_tcp) && true && ((req.dst_port==137) || (req.dst_port==139)) )
    return true;
  if ( (req.rule_ID_in==801) && (req.is_tcp) && true && ((req.dst_port==138) || (req.dst_port==139) || (req.dst_port==445)) )
    return true;
  if ( (req.rule_ID_in==541) && (req.is_tcp) && true && (req.dst_port==3389) )
    return true;
  if ( (req.rule_ID_in==222) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==249) && (req.is_tcp) && src_port_is_http && true )
    return true;
  if ( (req.rule_ID_in==179) && (req.is_tcp) && true && (req.dst_port==445) )
    return true;
  if ( (req.rule_ID_in==159) && (req.is_tcp) && true && ((req.dst_port==139) || (req.dst_port==445)) )
    return true;
  if ( (req.rule_ID_in==3436) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==3551) && (req.is_tcp) && true && (req.dst_port==3389) )
    return true;
  if ( (req.rule_ID_in==3655) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==3651) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==3758) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==3751) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==3704) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==3949) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==3946) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==3941) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==3938) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==3937) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==3935) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==3934) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==4023) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==4019) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==4015) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==4013) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==4139) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==4138) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==4136) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==4135) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==4205) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==4204) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==4197) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==4196) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==4325) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==4317) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==4315) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==4311) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==4306) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==4426) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==4425) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==4422) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==4419) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==4417) && (req.is_tcp) && ((req.src_port==135) || (req.src_port==139) || (req.src_port==445) || (req.src_port==49154)) && true )
    return true;
  if ( (req.rule_ID_in==4416) && (req.is_tcp) && true && ((req.dst_port==135) || (req.dst_port==139) || (req.dst_port==445) || (req.dst_port==49154)) )
    return true;
  if ( (req.rule_ID_in==4415) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==4414) && (req.is_tcp) && true && ((req.dst_port==139) || (req.dst_port==445)) )
    return true;
  if ( (req.rule_ID_in==4522) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==4520) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==4516) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==4514) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==4512) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==4509) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==4508) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==4638) && (!req.is_tcp) && (req.src_port==137) && (req.dst_port==137) )
    return true;
  if ( (req.rule_ID_in==4634) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==4633) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==4632) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==4628) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==4627) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==4700) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==4698) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==4693) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==4689) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==4688) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==4796) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==4795) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==4786) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==4784) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==4783) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==4780) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==4839) && (req.is_tcp) && (req.src_port==2049) && true )
    return true;
  if ( (req.rule_ID_in==4857) && (req.is_tcp) && true && (req.dst_port==389) )
    return true;
  if ( (req.rule_ID_in==4856) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==4852) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==4851) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==4850) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==4845) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==4927) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==4924) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==4923) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==4922) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==4920) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==4919) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==4918) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==4917) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==4916) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==4912) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==4910) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==4959) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==5004) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==5001) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==5000) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==4997) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==4993) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==4992) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==4990) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==5059) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==5093) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==5080) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==5078) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==5286) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==5284) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==5279) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==5278) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==5276) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==5274) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==5263) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==5262) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==5261) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==4611) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==4533) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==5341) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==5337) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==5334) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==5333) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==5329) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==5322) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==5281) && (req.is_tcp) && true && (req.dst_port==445) )
    return true;
  if ( (req.rule_ID_in==5353) && (req.is_tcp) && true && (req.dst_port==445) )
    return true;
  if ( (req.rule_ID_in==5368) && (req.is_tcp) && (req.src_port==445) && true )
    return true;
  if ( (req.rule_ID_in==5367) && (req.is_tcp) && true && (req.dst_port==445) )
    return true;
  if ( (req.rule_ID_in==5383) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==5396) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==5395) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==5394) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==5393) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==5392) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==5389) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==5414) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==5451) && (req.is_tcp) && true && (req.dst_port==445) )
    return true;
  if ( (req.rule_ID_in==5516) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==5496) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==5477) && (req.is_tcp) && true && (req.dst_port==445) )
    return true;
  if ( (req.rule_ID_in==5476) && (req.is_tcp) && true && (req.dst_port==445) )
    return true;
  if ( (req.rule_ID_in==5475) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==5609) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==5651) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==5724) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==5786) && (req.is_tcp) && true && ((req.dst_port==139) || (req.dst_port==445)) )
    return true;
  if ( (req.rule_ID_in==5904) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==5901) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==5892) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==5943) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==5942) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==5939) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==5936) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==6018) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==6013) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==6006) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==6083) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==6126) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==6124) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==6104) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==6103) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==6096) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==6094) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==6163) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==6172) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==6171) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==6187) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==6186) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==6214) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==6208) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==6206) && (req.is_tcp) && (req.src_port==53) && true )
    return true;
  if ( (req.rule_ID_in==6346) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==6345) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==6344) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==6386) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==6388) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==6411) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==6455) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==6503) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==6539) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==6532) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==6531) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==6661) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==6660) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==6654) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==6653) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==6650) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==6649) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==6716) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==6767) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==6766) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==6765) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==6764) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==6759) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==6758) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==6749) && (req.is_tcp) && true && (req.dst_port==445) )
    return true;
  if ( (req.rule_ID_in==6813) && (!req.is_tcp) && true && (req.dst_port==67) )
    return true;
  if ( (req.rule_ID_in==6835) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==6834) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==6828) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==6934) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==6932) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==6931) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==6930) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==6918) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==6917) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==6915) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==6911) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==6907) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==6936) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==6935) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==7022) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==6994) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==7024) && (req.is_tcp) && true && (req.dst_port==3389) )
    return true;
  if ( (req.rule_ID_in==7041) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==7049) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==7134) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==7115) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==7114) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==7113) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==7111) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==7110) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==7196) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==7199) && (req.is_tcp) && true && (req.dst_port==445) )
    return true;
  if ( (req.rule_ID_in==7198) && (req.is_tcp) && true && (req.dst_port==445) )
    return true;
  if ( (req.rule_ID_in==7212) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==7210) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==7209) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==7208) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==7205) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==1130) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==1131) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==1129) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==2556) && (req.is_tcp) && true && dst_port_is_ftp )
    return true;
  if ( (req.rule_ID_in==3818) && (req.is_tcp) && (req.src_port==23) && true )
    return true;
  if ( (req.rule_ID_in==4248) && (req.is_tcp) && true && true )
    return true;
  if ( (req.rule_ID_in==5189) && (req.is_tcp) && true && (req.dst_port==55443) )
    return true;
  if ( (req.rule_ID_in==5374) && (req.is_tcp) && true && true )
    return true;
  if ( (req.rule_ID_in==5373) && (req.is_tcp) && true && true )
    return true;
  if ( (req.rule_ID_in==5372) && (req.is_tcp) && true && true )
    return true;
  if ( (req.rule_ID_in==5371) && (req.is_tcp) && true && true )
    return true;
  if ( (req.rule_ID_in==5821) && (req.is_tcp) && src_port_is_http && true )
    return true;
  if ( (req.rule_ID_in==5820) && (req.is_tcp) && src_port_is_http && true )
    return true;
  if ( (req.rule_ID_in==5819) && (req.is_tcp) && src_port_is_http && true )
    return true;
  if ( (req.rule_ID_in==5818) && (req.is_tcp) && src_port_is_http && true )
    return true;
  if ( (req.rule_ID_in==6278) && (req.is_tcp) && src_port_is_http && true )
    return true;
  if ( (req.rule_ID_in==6429) && (req.is_tcp) && src_port_is_http && true )
    return true;
  if ( (req.rule_ID_in==6428) && (req.is_tcp) && src_port_is_http && true )
    return true;
  if ( (req.rule_ID_in==4905) && (!req.is_tcp) && true && (req.dst_port==53) )
    return true;
  if ( (req.rule_ID_in==5462) && (req.is_tcp) && true && (req.dst_port==143) )
    return true;
  if ( (req.rule_ID_in==5457) && (req.is_tcp) && true && (req.dst_port==445) )
    return true;
  if ( (req.rule_ID_in==5456) && (req.is_tcp) && true && (req.dst_port==445) )
    return true;
  if ( (req.rule_ID_in==3697) && (req.is_tcp) && (req.src_port==1900) && true )
    return true;
  if ( (req.rule_ID_in==199) && (req.is_tcp) && true && (req.dst_port==110) )
    return true;
  if ( (req.rule_ID_in==2249) && (req.is_tcp) && true && (req.dst_port==20171) )
    return true;
  if ( (req.rule_ID_in==2266) && (!req.is_tcp) && true && (req.dst_port==52302) )
    return true;
  if ( (req.rule_ID_in==2648) && (req.is_tcp) && true && (req.dst_port==12401) )
    return true;
  if ( (req.rule_ID_in==1225) && (req.is_tcp) && true && ((req.dst_port==12397) || (req.dst_port==12399)) )
    return true;
  if ( (req.rule_ID_in==5242) && (!req.is_tcp) && true && (req.dst_port==20010) )
    return true;
  if ( (req.rule_ID_in==5308) && (!req.is_tcp) && true && (req.dst_port==260) )
    return true;
  if ( (req.rule_ID_in==5307) && (!req.is_tcp) && true && (req.dst_port==260) )
    return true;
  if ( (req.rule_ID_in==4806) && (!req.is_tcp) && true && (req.dst_port==161) )
    return true;
  if ( (req.rule_ID_in==10) && (req.is_tcp) && true && (req.dst_port==23) )
    return true;
  if ( (req.rule_ID_in==9) && (req.is_tcp) && true && (req.dst_port==23) )
    return true;
  if ( (req.rule_ID_in==626) && (req.is_tcp) && (req.src_port==23) && true )
    return true;
  if ( (req.rule_ID_in==2933) && (req.is_tcp) && true && (req.dst_port==23) )
    return true;
  if ( (req.rule_ID_in==937) && (req.is_tcp) && (req.src_port==2000) && true )
    return true;
  if ( (req.rule_ID_in==698) && (req.is_tcp) && (req.src_port==5038) && true )
    return true;
  if ( (req.rule_ID_in==2197) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==2196) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==344) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==278) && (req.is_tcp) && true && true )
    return true;
  if ( (req.rule_ID_in==171) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==141) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==140) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==127) && (req.is_tcp) && true && true )
    return true;
  if ( (req.rule_ID_in==1699) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==1698) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==1711) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==1723) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==1722) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==1849) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==1848) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==1847) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==1858) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==2355) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==2973) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==3021) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==3023) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==3094) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==4227) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==4573) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==4572) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==4571) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==5875) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==6196) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==6315) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==6314) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==6352) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==6351) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==5877) && (req.is_tcp) && true && true )
    return true;
  if ( (req.rule_ID_in==2839) && (req.is_tcp) && true && (req.dst_port==80) )
    return true;
  if ( (req.rule_ID_in==5878) && (req.is_tcp) && true && true )
    return true;
  if ( (req.rule_ID_in==5926) && (req.is_tcp) && true && true )
    return true;
  if ( (req.rule_ID_in==5960) && (req.is_tcp) && true && true )
    return true;
  if ( (req.rule_ID_in==5959) && (req.is_tcp) && true && (req.dst_port==443) )
    return true;
  if ( (req.rule_ID_in==5958) && (req.is_tcp) && (req.src_port==443) && true )
    return true;
  if ( (req.rule_ID_in==6021) && (req.is_tcp) && true && true )
    return true;
  if ( (req.rule_ID_in==6059) && (req.is_tcp) && (req.src_port==443) && true )
    return true;
  if ( (req.rule_ID_in==6058) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==6057) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==6056) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==6070) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==6069) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==6068) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==6067) && (req.is_tcp) && true && (req.dst_port==443) )
    return true;
  if ( (req.rule_ID_in==6739) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==6770) && (req.is_tcp) && true && true )
    return true;
  if ( (req.rule_ID_in==102) && (req.is_tcp) && true && ((req.dst_port>=16800) && (req.dst_port<=17000)) )
    return true;
  if ( (req.rule_ID_in==103) && (req.is_tcp) && ((req.src_port>=16800) && (req.src_port<=17000)) && true )
    return true;
  if ( (req.rule_ID_in==131) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==3082) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==4625) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==736) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==558) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==477) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==1473) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==1472) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==1503) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==1502) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==1501) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==1500) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==1474) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==476) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==4907) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==5251) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==5260) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==5259) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==5653) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==5986) && (req.is_tcp) && true && ((req.dst_port==10001) || (req.dst_port==10002)) )
    return true;
  if ( (req.rule_ID_in==6369) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==6379) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==6378) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==2981) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==2980) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==230) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==229) && (req.is_tcp) && (req.src_port==143) && true )
    return true;
  if ( (req.rule_ID_in==4739) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==5782) && (req.is_tcp) && ((req.src_port==110) || (req.src_port==143)) && true )
    return true;
  if ( (req.rule_ID_in==5781) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==7105) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==3557) && (req.is_tcp) && true && ((req.dst_port>=1024) && (req.dst_port<=5000)) )
    return true;
  if ( (req.rule_ID_in==2818) && (req.is_tcp) && true && (req.dst_port==3306) )
    return true;
  if ( (req.rule_ID_in==234) && (req.is_tcp) && (req.src_port>=1024) && true )
    return true;
  if ( (req.rule_ID_in==6978) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==6977) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==1334) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==1273) && (req.is_tcp) && (req.src_port==443) && true )
    return true;
  if ( (req.rule_ID_in==1096) && (req.is_tcp) && true && (dst_port_is_http || req.dst_port==5555) )
    return true;
  if ( (req.rule_ID_in==1071) && (req.is_tcp) && true && ((req.dst_port==5001) || (req.dst_port==5002)) )
    return true;
  if ( (req.rule_ID_in==1068) && (req.is_tcp) && true && (req.dst_port==3000) )
    return true;
  if ( (req.rule_ID_in==1067) && (req.is_tcp) && true && (req.dst_port==3000) )
    return true;
  if ( (req.rule_ID_in==1066) && (req.is_tcp) && true && (req.dst_port==3000) )
    return true;
  if ( (req.rule_ID_in==1064) && (req.is_tcp) && true && (req.dst_port==3000) )
    return true;
  if ( (req.rule_ID_in==276) && (req.is_tcp) && true && (req.dst_port==2400) )
    return true;
  if ( (req.rule_ID_in==275) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==274) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==273) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==240) && (req.is_tcp) && (req.src_port==41523) && true )
    return true;
  if ( (req.rule_ID_in==20) && (req.is_tcp) && true && (req.dst_port==13724) )
    return true;
  if ( (req.rule_ID_in==1467) && (!req.is_tcp) && true && (req.dst_port==623) )
    return true;
  if ( (req.rule_ID_in==1469) && (req.is_tcp) && (req.src_port==8575) && true )
    return true;
  if ( (req.rule_ID_in==2048) && (req.is_tcp) && true && (req.dst_port==2400) )
    return true;
  if ( (req.rule_ID_in==2182) && (req.is_tcp) && true && ((req.dst_port==19985) || (req.dst_port==19988)) )
    return true;
  if ( (req.rule_ID_in==2238) && (req.is_tcp) && true && ((req.dst_port==21) || (req.dst_port==25) || (req.dst_port==443) || (req.dst_port==465) || (req.dst_port==636) || (req.dst_port==992) || (req.dst_port==993) || (req.dst_port==995) || (req.dst_port==2484)) )
    return true;
  if ( (req.rule_ID_in==2240) && (req.is_tcp) && true && ((req.dst_port==21) || (req.dst_port==25) || (req.dst_port==443) || (req.dst_port==465) || (req.dst_port==636) || (req.dst_port==992) || (req.dst_port==993) || (req.dst_port==995) || (req.dst_port==2484)) )
    return true;
  if ( (req.rule_ID_in==2239) && (req.is_tcp) && true && ((req.dst_port==21) || (req.dst_port==25) || (req.dst_port==443) || (req.dst_port==465) || (req.dst_port==636) || (req.dst_port==992) || (req.dst_port==993) || (req.dst_port==995) || (req.dst_port==2484)) )
    return true;
  if ( (req.rule_ID_in==2246) && (req.is_tcp) && true && (req.dst_port==443) )
    return true;
  if ( (req.rule_ID_in==2261) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==2264) && (req.is_tcp) && ((req.src_port==21) || (req.src_port==25) || (req.src_port==443) || (req.src_port==465) || (req.src_port==636) || (req.src_port==992) || (req.src_port==993) || (req.src_port==995) || (req.src_port==2484)) && true )
    return true;
  if ( (req.rule_ID_in==2291) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==2324) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==2376) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==2420) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==2458) && (req.is_tcp) && true && (req.dst_port==443) )
    return true;
  if ( (req.rule_ID_in==2457) && (req.is_tcp) && true && (req.dst_port==443) )
    return true;
  if ( (req.rule_ID_in==2473) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==2472) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==2528) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==2662) && (!req.is_tcp) && true && ((req.dst_port==696) || (req.dst_port==7426)) )
    return true;
  if ( (req.rule_ID_in==2747) && (req.is_tcp) && true && (req.dst_port==40003) )
    return true;
  if ( (req.rule_ID_in==2755) && (!req.is_tcp) && true && ((req.dst_port==696) || (req.dst_port==7426)) )
    return true;
  if ( (req.rule_ID_in==2768) && (!req.is_tcp) && true && ((req.dst_port==696) || (req.dst_port==7426)) )
    return true;
  if ( (req.rule_ID_in==2817) && (!req.is_tcp) && true && ((req.dst_port==696) || (req.dst_port==7426)) )
    return true;
  if ( (req.rule_ID_in==2855) && (!req.is_tcp) && true && ((req.dst_port==696) || (req.dst_port==7426)) )
    return true;
  if ( (req.rule_ID_in==3131) && (req.is_tcp) && true && (req.dst_port==3465) )
    return true;
  if ( (req.rule_ID_in==2749) && (req.is_tcp) && true && (req.dst_port>=1024) )
    return true;
  if ( (req.rule_ID_in==2201) && (req.is_tcp) && true && (req.dst_port==5555) )
    return true;
  if ( (req.rule_ID_in==2200) && (req.is_tcp) && true && (req.dst_port==5555) )
    return true;
  if ( (req.rule_ID_in==2199) && (req.is_tcp) && true && (req.dst_port==5555) )
    return true;
  if ( (req.rule_ID_in==2198) && (req.is_tcp) && true && (req.dst_port==5555) )
    return true;
  if ( (req.rule_ID_in==2109) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==1835) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==1685) && (req.is_tcp) && true && (req.dst_port>=1024) )
    return true;
  if ( (req.rule_ID_in==1623) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==1566) && (req.is_tcp) && true && (req.dst_port>=1024) )
    return true;
  if ( (req.rule_ID_in==1565) && (req.is_tcp) && true && (req.dst_port>=1024) )
    return true;
  if ( (req.rule_ID_in==1564) && (req.is_tcp) && true && (req.dst_port>=1024) )
    return true;
  if ( (req.rule_ID_in==1563) && (req.is_tcp) && true && (req.dst_port>=1024) )
    return true;
  if ( (req.rule_ID_in==1562) && (req.is_tcp) && true && (req.dst_port>=1024) )
    return true;
  if ( (req.rule_ID_in==1513) && (req.is_tcp) && true && (req.dst_port>=1024) )
    return true;
  if ( (req.rule_ID_in==1499) && (req.is_tcp) && true && (req.dst_port>=1024) )
    return true;
  if ( (req.rule_ID_in==1488) && (req.is_tcp) && true && (req.dst_port>=1024) )
    return true;
  if ( (req.rule_ID_in==1478) && (req.is_tcp) && true && (req.dst_port>=1024) )
    return true;
  if ( (req.rule_ID_in==1468) && (req.is_tcp) && true && (req.dst_port>=1024) )
    return true;
  if ( (req.rule_ID_in==1463) && (req.is_tcp) && true && (req.dst_port>=1024) )
    return true;
  if ( (req.rule_ID_in==1448) && (req.is_tcp) && true && (req.dst_port>=1024) )
    return true;
  if ( (req.rule_ID_in==1447) && (req.is_tcp) && true && (req.dst_port>=1024) )
    return true;
  if ( (req.rule_ID_in==1446) && (req.is_tcp) && true && (req.dst_port>=1024) )
    return true;
  if ( (req.rule_ID_in==1352) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==1351) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==1065) && (req.is_tcp) && true && (req.dst_port==3000) )
    return true;
  if ( (req.rule_ID_in==624) && (req.is_tcp) && true && (req.dst_port==8300) )
    return true;
  if ( (req.rule_ID_in==623) && (req.is_tcp) && true && (req.dst_port==8300) )
    return true;
  if ( (req.rule_ID_in==429) && (req.is_tcp) && true && (req.dst_port==1500) )
    return true;
  if ( (req.rule_ID_in==239) && (req.is_tcp) && (req.src_port==41523) && true )
    return true;
  if ( (req.rule_ID_in==238) && (req.is_tcp) && true && (req.dst_port==50000) )
    return true;
  if ( (req.rule_ID_in==237) && (req.is_tcp) && true && (req.dst_port==631) )
    return true;
  if ( (req.rule_ID_in==233) && (req.is_tcp) && true && ( ((req.dst_port>=5900) && (req.dst_port<=5999)) || (req.dst_port==5800) ) )
    return true;
  if ( (req.rule_ID_in==27) && (req.is_tcp) && true && ( ((req.dst_port>=5900) && (req.dst_port<=5999)) || (req.dst_port==5800) ) )
    return true;
  if ( (req.rule_ID_in==3657) && (req.is_tcp) && true && (req.dst_port==8045) )
    return true;
  if ( (req.rule_ID_in==3656) && (req.is_tcp) && true && (req.dst_port==8045) )
    return true;
  if ( (req.rule_ID_in==3735) && (req.is_tcp) && true && (req.dst_port==51000) )
    return true;
  if ( (req.rule_ID_in==3963) && (req.is_tcp) && true && true )
    return true;
  if ( (req.rule_ID_in==3962) && (req.is_tcp) && true && true )
    return true;
  if ( (req.rule_ID_in==3964) && (req.is_tcp) && true && (dst_port_is_http || (req.dst_port==1099) || (req.dst_port==6099) || (req.dst_port==7001)) )
    return true;
  if ( (req.rule_ID_in==4079) && (req.is_tcp) && true && ((req.dst_port==22) || (req.dst_port==23)) )
    return true;
  if ( (req.rule_ID_in==4143) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==4142) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==4141) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==4157) && (req.is_tcp) && (req.src_port==22) && true )
    return true;
  if ( (req.rule_ID_in==4182) && (!req.is_tcp) && true && (req.dst_port==123) )
    return true;
  if ( (req.rule_ID_in==4181) && (!req.is_tcp) && true && (req.dst_port==123) )
    return true;
  if ( (req.rule_ID_in==3991) && (!req.is_tcp) && true && (req.dst_port==500) )
    return true;
  if ( (req.rule_ID_in==4236) && (!req.is_tcp) && true && (req.dst_port==500) )
    return true;
  if ( (req.rule_ID_in==691) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==4375) && (req.is_tcp) && true && (req.dst_port==6379) )
    return true;
  if ( (req.rule_ID_in==4504) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==4609) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==4672) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==4813) && (req.is_tcp) && true && (req.dst_port==11460) )
    return true;
  if ( (req.rule_ID_in==4825) && (req.is_tcp) && true && true )
    return true;
  if ( (req.rule_ID_in==4887) && (!req.is_tcp) && true && ((req.dst_port==500) || (req.dst_port==848) || (req.dst_port==4500) || (req.dst_port==4848)) )
    return true;
  if ( (req.rule_ID_in==4886) && (!req.is_tcp) && true && ((req.dst_port==500) || (req.dst_port==848) || (req.dst_port==4500) || (req.dst_port==4848)) )
    return true;
  if ( (req.rule_ID_in==4885) && (!req.is_tcp) && ((req.src_port==500) || (req.src_port==848) || (req.src_port==4500) || (req.src_port==4848)) && true )
    return true;
  if ( (req.rule_ID_in==4900) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==4925) && (req.is_tcp) && true && (req.dst_port==11460) )
    return true;
  if ( (req.rule_ID_in==4908) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==4906) && (req.is_tcp) && true && (req.dst_port==11460) )
    return true;
  if ( (req.rule_ID_in==4969) && (!req.is_tcp) && true && (req.dst_port==53) )
    return true;
  if ( (req.rule_ID_in==5031) && (req.is_tcp) && true && (req.dst_port==11460) )
    return true;
  if ( (req.rule_ID_in==5096) && (req.is_tcp) && true && (req.dst_port==30024) )
    return true;
  if ( (req.rule_ID_in==5108) && (req.is_tcp) && ((req.src_port==3301) || (req.src_port==3302)) && true )
    return true;
  if ( (req.rule_ID_in==5236) && (req.is_tcp) && true && (req.dst_port==4786) )
    return true;
  if ( (req.rule_ID_in==5235) && (req.is_tcp) && true && (req.dst_port==4786) )
    return true;
  if ( (req.rule_ID_in==5234) && (req.is_tcp) && true && (req.dst_port==4786) )
    return true;
  if ( (req.rule_ID_in==5233) && (req.is_tcp) && true && (req.dst_port==4786) )
    return true;
  if ( (req.rule_ID_in==5256) && (req.is_tcp) && true && true )
    return true;
  if ( (req.rule_ID_in==5255) && (req.is_tcp) && true && true )
    return true;
  if ( (req.rule_ID_in==5254) && (req.is_tcp) && true && true )
    return true;
  if ( (req.rule_ID_in==5253) && (req.is_tcp) && true && true )
    return true;
  if ( (req.rule_ID_in==5252) && (req.is_tcp) && true && true )
    return true;
  if ( (req.rule_ID_in==2253) && (req.is_tcp) && (req.src_port==1194) && true )
    return true;
  if ( (req.rule_ID_in==2252) && (req.is_tcp) && (req.src_port==1194) && true )
    return true;
  if ( (req.rule_ID_in==5323) && (req.is_tcp) && true && (req.dst_port==389) )
    return true;
  if ( (req.rule_ID_in==5348) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==5363) && (req.is_tcp) && true && (req.dst_port==10051) )
    return true;
  if ( (req.rule_ID_in==5436) && (!req.is_tcp) && (req.src_port==123) && true )
    return true;
  if ( (req.rule_ID_in==5534) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==5468) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==5461) && (req.is_tcp) && true && ((req.dst_port==1556) || (req.dst_port==13720)) )
    return true;
  if ( (req.rule_ID_in==5458) && (req.is_tcp) && true && (req.dst_port==9000) )
    return true;
  if ( (req.rule_ID_in==5065) && (req.is_tcp) && true && (req.dst_port==50021) )
    return true;
  if ( (req.rule_ID_in==5586) && (!req.is_tcp) && true && (req.dst_port==500) )
    return true;
  if ( (req.rule_ID_in==3741) && (req.is_tcp) && true && (req.dst_port==5159) )
    return true;
  if ( (req.rule_ID_in==3740) && (req.is_tcp) && (req.src_port==6780) && true )
    return true;
  if ( (req.rule_ID_in==3739) && (req.is_tcp) && true && (req.dst_port==6780) )
    return true;
  if ( (req.rule_ID_in==3738) && (req.is_tcp) && true && (req.dst_port==8011) )
    return true;
  if ( (req.rule_ID_in==5765) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==5889) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==5909) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==5918) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==5951) && (req.is_tcp) && true && ((req.dst_port==8094) || (req.dst_port==8096) || (req.dst_port==8097) || (req.dst_port==8098) || (req.dst_port==9121)) )
    return true;
  if ( (req.rule_ID_in==6080) && (req.is_tcp) && true && (req.dst_port==7001) )
    return true;
  if ( (req.rule_ID_in==6079) && (req.is_tcp) && true && (req.dst_port==7001) )
    return true;
  if ( (req.rule_ID_in==6081) && (req.is_tcp) && true && (req.dst_port==5432) )
    return true;
  if ( (req.rule_ID_in==6084) && (req.is_tcp) && true && (req.dst_port==4786) )
    return true;
  if ( (req.rule_ID_in==6086) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==6085) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==6203) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==6202) && (req.is_tcp) && true && (req.dst_port==25) )
    return true;
  if ( (req.rule_ID_in==6502) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==6579) && (req.is_tcp) && true && (req.dst_port==7001) )
    return true;
  if ( (req.rule_ID_in==6578) && (req.is_tcp) && true && (req.dst_port==7001) )
    return true;
  if ( (req.rule_ID_in==6814) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==6838) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==6869) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==6868) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==6896) && (req.is_tcp) && true && (req.dst_port==4840) )
    return true;
  if ( (req.rule_ID_in==6895) && (req.is_tcp) && true && (req.dst_port==4840) )
    return true;
  if ( (req.rule_ID_in==6973) && (req.is_tcp) && true && ((req.dst_port>=3900) && (req.dst_port<=3999)) )
    return true;
  if ( (req.rule_ID_in==6972) && (req.is_tcp) && true && ((req.dst_port>=3300) && (req.dst_port<=3399)) )
    return true;
  if ( (req.rule_ID_in==5187) && (req.is_tcp) && ((req.src_port==139) || (req.src_port==445)) && true )
    return true;
  if ( (req.rule_ID_in==5816) && (req.is_tcp) && true && (req.dst_port==445) )
    return true;
  if ( (req.rule_ID_in==6728) && (req.is_tcp) && true && (req.dst_port==445) )
    return true;
  if ( (req.rule_ID_in==4369) && (req.is_tcp) && true && (req.dst_port==5054) )
    return true;
  if ( (req.rule_ID_in==4368) && (req.is_tcp) && true && (req.dst_port==5054) )
    return true;
  if ( (req.rule_ID_in==1378) && (req.is_tcp) && true && (req.dst_port==50000) )
    return true;
  if ( (req.rule_ID_in==1199) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==533) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==428) && (req.is_tcp) && src_port_is_http && true )
    return true;
  if ( (req.rule_ID_in==358) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==235) && (req.is_tcp) && src_port_is_http && true )
    return true;
  if ( (req.rule_ID_in==1579) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==1625) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==1704) && (!req.is_tcp) && true && (req.dst_port==7329) )
    return true;
  if ( (req.rule_ID_in==1703) && (!req.is_tcp) && true && (req.dst_port==7329) )
    return true;
  if ( (req.rule_ID_in==1702) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==1965) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==2001) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==2004) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==2078) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==2088) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==2192) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==2204) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==2357) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==2388) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==2418) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==2430) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==2440) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==2465) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==2464) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==2552) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==2750) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==2882) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==2877) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==3010) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==3156) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==3283) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==3318) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==3377) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==2029) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==2003) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==1933) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==1892) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==1888) && (req.is_tcp) && true && (req.dst_port==7071) )
    return true;
  if ( (req.rule_ID_in==1883) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==1729) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==1441) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==864) && (req.is_tcp) && true && (req.dst_port==383) )
    return true;
  if ( (req.rule_ID_in==231) && (req.is_tcp) && true && (req.dst_port==3128) )
    return true;
  if ( (req.rule_ID_in==3454) && (req.is_tcp) && true && ((req.dst_port==52869) || (req.dst_port==49152)) )
    return true;
  if ( (req.rule_ID_in==3488) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==3487) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==3517) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==3516) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==3515) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==3514) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==3816) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==3950) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==4048) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==4075) && (req.is_tcp) && true && dst_port_is_file_data )
    return true;
  if ( (req.rule_ID_in==4125) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==4221) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==4220) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==4219) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==4239) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==4293) && (req.is_tcp) && true && (dst_port_is_http || (req.dst_port==1099) || (req.dst_port==6099) || (req.dst_port==7001)) )
    return true;
  if ( (req.rule_ID_in==4292) && (req.is_tcp) && true && (dst_port_is_http || (req.dst_port==1099) || (req.dst_port==6099) || (req.dst_port==7001)) )
    return true;
  if ( (req.rule_ID_in==4563) && (req.is_tcp) && true && ((req.dst_port==8088) || (req.dst_port==8089)) )
    return true;
  if ( (req.rule_ID_in==4552) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==4543) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==4626) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==4662) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==4661) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==4664) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==4671) && (req.is_tcp) && src_port_is_file_data && true )
    return true;
  if ( (req.rule_ID_in==4670) && (req.is_tcp) && true && (req.dst_port==8445) )
    return true;
  if ( (req.rule_ID_in==4735) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==4752) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==4751) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==4757) && (req.is_tcp) && true && true )
    return true;
  if ( (req.rule_ID_in==4819) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==4814) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==4833) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==4935) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==4980) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==5037) && (req.is_tcp) && true && ((req.dst_port==5555) || (req.dst_port==7547)) )
    return true;
  if ( (req.rule_ID_in==5055) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==5058) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==5063) && (req.is_tcp) && true && (req.dst_port==7001) )
    return true;
  if ( (req.rule_ID_in==5103) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==5109) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==5155) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==5157) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==5171) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==5185) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==5190) && (req.is_tcp) && true && (req.dst_port==55443) )
    return true;
  if ( (req.rule_ID_in==5225) && (req.is_tcp) && true && (req.dst_port==55443) )
    return true;
  if ( (req.rule_ID_in==5244) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==5250) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==5258) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==5305) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==5344) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==5366) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==5427) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==5533) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==5529) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==5528) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==5526) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==5490) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==5485) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==5484) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==5483) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==5469) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==5467) && (req.is_tcp) && (req.src_port==8750) && true )
    return true;
  if ( (req.rule_ID_in==5454) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==5115) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==5114) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==5113) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==5112) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==5587) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==5606) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==5617) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==5647) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==5648) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==5662) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==5661) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==5681) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==5680) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==5685) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==5684) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==5780) && (req.is_tcp) && true && (req.dst_port==37215) )
    return true;
  if ( (req.rule_ID_in==5804) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==5803) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==5813) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==5811) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==5810) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==5822) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==5851) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==5853) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==5865) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==5891) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==5913) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==5912) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==5920) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==5948) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==5972) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==5987) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==5981) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==6044) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==6043) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==6041) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==6046) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==6082) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==6130) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==6129) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==6156) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==6176) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==6175) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==6184) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==6183) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==6303) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==6312) && (req.is_tcp) && true && (req.dst_port==7001) )
    return true;
  if ( (req.rule_ID_in==6311) && (req.is_tcp) && true && (req.dst_port==7001) )
    return true;
  if ( (req.rule_ID_in==6332) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==6340) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==6362) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==6376) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==6375) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==6471) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==6484) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==6494) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==6509) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==6547) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==6588) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==6665) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==6672) && (req.is_tcp) && true && (req.dst_port==50000) )
    return true;
  if ( (req.rule_ID_in==6833) && (req.is_tcp) && true && ((req.dst_port==8500) || (req.dst_port==8501)) )
    return true;
  if ( (req.rule_ID_in==6852) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==6851) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==6879) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==6950) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==6953) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==6955) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==6971) && (req.is_tcp) && true && dst_port_is_file_data )
    return true;
  if ( (req.rule_ID_in==6979) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==7039) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==7101) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==7100) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==7157) && (req.is_tcp) && true && ((req.dst_port==11002) || (req.dst_port==11004) || (req.dst_port==11006)) )
    return true;
  if ( (req.rule_ID_in==7193) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==7235) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==1) && (req.is_tcp) && (req.src_port==1433) && true )
    return true;
  if ( (req.rule_ID_in==180) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==221) && (req.is_tcp) && true && (req.dst_port==1433) )
    return true;
  if ( (req.rule_ID_in==293) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==292) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==1486) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==2137) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==2136) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==723) && (req.is_tcp) && ((req.src_port==1315) || (req.src_port==2315)) && true )
    return true;
  if ( (req.rule_ID_in==291) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==224) && (req.is_tcp) && true && (req.dst_port==50000) )
    return true;
  if ( (req.rule_ID_in==144) && (req.is_tcp) && true && (req.dst_port==50000) )
    return true;
  if ( (req.rule_ID_in==128) && (req.is_tcp) && true && (req.dst_port==7210) )
    return true;
  if ( (req.rule_ID_in==87) && (req.is_tcp) && true && (req.dst_port==21064) )
    return true;
  if ( (req.rule_ID_in==6899) && (req.is_tcp) && true && dst_port_is_http )
    return true;
  if ( (req.rule_ID_in==7236) && (req.is_tcp) && true && true )
    return true;
  return false;
}

bool is_http(ap_uint<16> port){
  if ((port==36) || (port==80) || (port==81) || (port==82) || (port==83) || (port==84) || (port==85) || (port==86) || (port==87) || (port==88) || (port==89) || (port==90) || (port==311) || (port==383) || (port==555) || (port==591) || (port==593) || (port==631) || (port==801) || (port==808) || (port==818) || (port==901) || (port==972) || (port==1158) || (port==1220) || (port==1414) || (port==1533) || (port==1741) || (port==1812) || (port==1830) || (port==1942) || (port==2231) || (port==2301) || (port==2381) || (port==2578) || (port==2809) || (port==2980) || (port==3029) || (port==3037) || (port==3057) || (port==3128) || (port==3443) || (port==3702) || (port==4000) || (port==4343) || (port==4848) || (port==5000) || (port==5117) || (port==5250) || (port==5450) || (port==5600) || (port==5814) || (port==6080) || (port==6173) || (port==6988) || (port==7000) || (port==7001) || (port==7005) || (port==7071) || (port==7144) || (port==7145) || (port==7510) || (port==7770) || (port==7777) || (port==7778) || (port==7779) || (port==8000) || (port==8001) || (port==8008) || (port==8014) || (port==8015) || (port==8020) || (port==8028) || (port==8040) || (port==8080) || (port==8081) || (port==8082) || (port==8085) || (port==8088) || (port==8090) || (port==8118) || (port==8123) || (port==8180) || (port==8181) || (port==8182) || (port==8222) || (port==8243) || (port==8280) || (port==8300) || (port==8333) || (port==8344) || (port==8400) || (port==8443) || (port==8500) || (port==8509) || (port==8787) || (port==8800) || (port==8888) || (port==8899) || (port==8983) || (port==9000) || (port==9002) || (port==9060) || (port==9080) || (port==9090) || (port==9091) || (port==9111) || (port==9290) || (port==9443) || (port==9447) || (port==9710) || (port==9788) || (port==9999) || (port==10000) || (port==11371) || (port==12601) || (port==13014) || (port==15489) || (port==19980) || (port==29991) || (port==33300) || (port==34412) || (port==34443) || (port==34444) || (port==40007) || (port==41080) || (port==44449) || (port==50000) || (port==50002) || (port==51423) || (port==53331) || (port==55252) || (port==55555) || (port==56712)){
    return true;
  } else {
    return false;
  }

}