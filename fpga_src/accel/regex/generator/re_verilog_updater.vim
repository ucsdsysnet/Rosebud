%s/\(reg\)_\(\d\+\)/state_r[\2]/g
%s/state_r\[\(\d\+\)\] <=/state_n\[\1\] =/g
g/reg state_r/d
%s/always @(posedge clk or negedge rst_n)/always @(*)/g
g/rst_n == 0/.,+2d
g/    end/d
%s/        /    /g
1d
0r re_verilog_updater.hdr
g/assign/ m 15
