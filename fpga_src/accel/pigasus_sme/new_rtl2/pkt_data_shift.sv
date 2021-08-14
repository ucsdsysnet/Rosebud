//Take current pkt and meta data, remove hdr
//Append the last 7 bytes in that flow to current pkt if it is TCP pkt
//Down stream 
`include "struct_s.sv"

module pkt_data_shift (
    input   logic           clk,
    input   logic           rst,
    input   logic           in_pkt_sop,
    input   logic           in_pkt_eop,
    input   logic           in_pkt_valid,
    input   logic [511:0]   in_pkt_data,
    input   logic [5:0]     in_pkt_empty,
    output  logic           in_pkt_ready,
    input   metadata_t      in_meta_data,
    input   logic           in_meta_valid,
    output  logic           in_meta_ready,
    output  logic           out_pkt_sop,
    output  logic           out_pkt_eop,
    output  logic           out_pkt_valid,
    output  logic [511:0]   out_pkt_data,
    output  logic [5:0]     out_pkt_empty,
    input   logic           out_pkt_ready,
    input   logic           out_pkt_almost_full,
    output  metadata_t      out_meta_data,
    output  logic           out_meta_valid,
    input   logic           out_meta_ready,
    input   logic           out_meta_almost_full
);

localparam UDP_HDR_LEN = 42;
localparam TCP_HDR_LEN = 54;
//54 - 7
localparam TCP_RM_LEN = 47;


typedef enum{
    FIRST,
    UDP,
    UDP_LAST,
    SINGLE_UDP,
    TCP,
    TCP_LAST,
    SINGLE_TCP
} state_t;
state_t state;

logic [55:0] last_7_bytes;
logic [15:0] flit_cnt;
logic [511:0] in_pkt_data_r;
logic [5:0] in_pkt_empty_r;
logic proceed;

assign proceed = in_meta_valid & !out_meta_almost_full & !out_pkt_almost_full;
assign in_meta_ready = in_pkt_sop & in_pkt_valid;

always@(*)begin
    in_pkt_ready = 0;
    case(state)
        FIRST:begin
            if(proceed)begin
                in_pkt_ready = 1;
            end
        end
        UDP:begin
            in_pkt_ready = 1;
        end
        UDP_LAST:begin
            if(proceed)begin
                in_pkt_ready = 1;
            end
        end
        SINGLE_UDP:begin
            if(proceed)begin
                in_pkt_ready = 1;
            end
        end
        TCP:begin
            in_pkt_ready = 1;
        end
        TCP_LAST:begin
            if(proceed)begin
                in_pkt_ready = 1;
            end
        end
        SINGLE_TCP:begin
            if(proceed)begin
                in_pkt_ready = 1;
            end
        end
    endcase
end



always@(posedge clk)begin
    if(rst)begin
        out_meta_valid <= 1'b0;
    end else begin
        out_meta_valid <= in_meta_valid & in_meta_ready;
    end
    out_meta_data <= in_meta_data;
end
//always@(posedge clk)begin
//    if(rst)begin
//        flit_cnt <= 0;
//    end else begin
//        if(out_pkt_valid)begin
//            if(out_pkt_eop)begin
//                flit_cnt <= 0;
//            end else begin
//                flit_cnt <= flit_cnt + 1;
//            end
//        end
//    end
//end

//assign out_pkt_sop = out_pkt_valid & (flit_cnt == 0);

always@(posedge clk)begin
    if(rst)begin
        state <= FIRST;
        out_pkt_sop <= 1'b0;
        out_pkt_eop <= 1'b0;
        out_pkt_valid <= 1'b0;
        out_pkt_empty <= 6'b0;
        flit_cnt <= 0;
    end else begin
        case(state)
            FIRST:begin
                out_pkt_sop <= 1'b0;
                out_pkt_eop <= 1'b0;
                out_pkt_valid <= 1'b0;
                out_pkt_empty <= 6'b0;
                flit_cnt <= 0;
                if(proceed & in_pkt_valid & in_pkt_sop)begin
                    //one flit case
                    if (in_pkt_eop)begin
                        if(in_meta_data.prot == PROT_UDP)begin
                            out_pkt_valid <= 1'b1;
                            out_pkt_sop <= 1'b1;
                            out_pkt_eop <= 1'b1;
                            out_pkt_empty <= in_pkt_empty + UDP_HDR_LEN;
                            out_pkt_data <= in_pkt_data << UDP_HDR_LEN*8;
                            state <= FIRST;
                        end else begin
                            out_pkt_valid <= 1'b1;
                            out_pkt_sop <= 1'b1;
                            out_pkt_eop <= 1'b1;
                            out_pkt_empty <= in_pkt_empty + TCP_RM_LEN;
                            out_pkt_data <= {in_meta_data.last_7_bytes,in_pkt_data[79:0],{376{1'b1}}};
                            state <= FIRST;
                        end
                    //multi-flit case
                    end else begin
                        in_pkt_data_r <= in_pkt_data;
                        if(in_meta_data.prot == PROT_UDP)begin
                            state <= UDP;
                        end else begin
                            state <= TCP;
                            last_7_bytes <= in_meta_data.last_7_bytes;
                        end
                    end
                end // else do not pop pkt data
            end
            UDP:begin
                out_pkt_valid <= 1'b0;
                out_pkt_sop <= 1'b0;
                out_pkt_eop <= 1'b0;
                if(in_pkt_valid)begin
                    in_pkt_data_r <= in_pkt_data;
                    out_pkt_valid <= 1'b1;
                    out_pkt_data <= (in_pkt_data_r << UDP_HDR_LEN*8) | (in_pkt_data >> (64-UDP_HDR_LEN)*8);
                    if(in_pkt_eop)begin
                        if(in_pkt_empty+UDP_HDR_LEN > 64)begin
                            out_pkt_eop <= 1'b1;
                            out_pkt_empty <= in_pkt_empty + UDP_HDR_LEN - 64;
                            state <= FIRST;
                            flit_cnt <= 0;
                        end else begin
                            out_pkt_empty <= 6'b0;
                            in_pkt_empty_r <= in_pkt_empty;
                            state <= UDP_LAST;
                            flit_cnt <= flit_cnt + 1;
                        end
                    end else begin
                        out_pkt_empty <= 6'b0;
                        flit_cnt <= flit_cnt + 1;
                    end
                    if(flit_cnt == 0)begin
                        out_pkt_sop <= 1'b1;
                    end
                end
            end
            UDP_LAST:begin
                out_pkt_sop <= 1'b0;
                out_pkt_eop <= 1'b1;
                out_pkt_valid <= 1'b1;
                out_pkt_empty <= in_pkt_empty_r + UDP_HDR_LEN;
                out_pkt_data <= (in_pkt_data_r << UDP_HDR_LEN*8) | ({512{1'b1}} >> (64-UDP_HDR_LEN)*8);
                flit_cnt <= 0;
                if(proceed & in_pkt_valid & in_pkt_sop)begin
                    in_pkt_data_r <= in_pkt_data;
                    in_pkt_empty_r <= in_pkt_empty_r;
                    last_7_bytes <= in_meta_data.last_7_bytes;
                    //one flit case
                    if (in_pkt_eop)begin
                        if(in_meta_data.prot == PROT_UDP)begin
                            state <= SINGLE_UDP;
                        end else begin
                            state <= SINGLE_TCP;
                        end
                    //multi-flit case
                    end else begin
                        if(in_meta_data.prot == PROT_UDP)begin
                            state <= UDP;
                        end else begin
                            state <= TCP;
                            last_7_bytes <= in_meta_data.last_7_bytes;
                        end
                    end
                end else begin
                    //Do not pop the pkt data
                    state <= FIRST;
                end
            end
            SINGLE_UDP:begin
                out_pkt_valid <= 1'b1;
                out_pkt_sop <= 1'b1;
                out_pkt_eop <= 1'b1;
                out_pkt_empty <= in_pkt_empty_r + UDP_HDR_LEN;
                out_pkt_data <= in_pkt_data_r << UDP_HDR_LEN*8;
                flit_cnt <= 0;
                if(proceed & in_pkt_valid & in_pkt_sop)begin
                    in_pkt_data_r <= in_pkt_data;
                    in_pkt_empty_r <= in_pkt_empty_r;
                    last_7_bytes <= in_meta_data.last_7_bytes;
                    //one flit case
                    if (in_pkt_eop)begin
                        if(in_meta_data.prot == PROT_UDP)begin
                            state <= SINGLE_UDP;
                        end else begin
                            state <= SINGLE_TCP;
                        end
                    //multi-flit case
                    end else begin
                        if(in_meta_data.prot == PROT_UDP)begin
                            state <= UDP;
                        end else begin
                            state <= TCP;
                            last_7_bytes <= in_meta_data.last_7_bytes;
                        end
                    end
                end else begin
                    state <= FIRST;
                end
            end
            //remove hdr and append last 7 bytes
            TCP:begin
                out_pkt_valid <= 1'b0;
                out_pkt_sop <= 1'b0;
                out_pkt_eop <= 1'b0;
                if(in_pkt_valid)begin
                    in_pkt_data_r <= in_pkt_data;
                    out_pkt_valid <= 1'b1;
                    if(in_pkt_eop)begin
                        if(in_pkt_empty+TCP_RM_LEN > 64)begin
                            out_pkt_eop <= 1'b1;
                            out_pkt_empty <= in_pkt_empty + TCP_RM_LEN - 64;
                            state <= FIRST;
                            flit_cnt <= 0;
                        end else begin
                            out_pkt_empty <= 6'b0;
                            in_pkt_empty_r <= in_pkt_empty;
                            state <= TCP_LAST;
                            flit_cnt <= flit_cnt + 1;
                        end
                    end else begin
                        out_pkt_empty <= 6'b0;
                        flit_cnt <= flit_cnt + 1;
                    end

                    if((flit_cnt == 0))begin
                        out_pkt_sop <= 1'b1;
                        out_pkt_data <= {last_7_bytes,in_pkt_data_r[79:0],in_pkt_data[511:136]};
                    end else begin
                        out_pkt_data <= {in_pkt_data_r[135:0],in_pkt_data[511:136]};
                    end
                end
            end
            TCP_LAST:begin
                out_pkt_sop <= 1'b0;
                out_pkt_eop <= 1'b1;
                out_pkt_valid <= 1'b1;
                out_pkt_empty <= in_pkt_empty_r + TCP_RM_LEN;
                out_pkt_data <= {in_pkt_data_r[135:0],{376{1'b1}}};
                flit_cnt <= 0;
                if(proceed & in_pkt_valid & in_pkt_sop)begin
                    in_pkt_data_r <= in_pkt_data;
                    in_pkt_empty_r <= in_pkt_empty_r;
                    last_7_bytes <= in_meta_data.last_7_bytes;
                    //one flit case
                    if (in_pkt_eop)begin
                        if(in_meta_data.prot == PROT_UDP)begin
                            state <= SINGLE_UDP;
                        end else begin
                            state <= SINGLE_TCP;
                        end
                    //multi-flit case
                    end else begin
                        if(in_meta_data.prot == PROT_UDP)begin
                            state <= UDP;
                        end else begin
                            state <= TCP;
                            last_7_bytes <= in_meta_data.last_7_bytes;
                        end
                    end
                end else begin
                    state <= FIRST;
                end
            end
            SINGLE_TCP:begin
                out_pkt_valid <= 1'b1;
                out_pkt_sop <= 1'b1;
                out_pkt_eop <= 1'b1;
                out_pkt_empty <= in_pkt_empty_r + TCP_RM_LEN;
                out_pkt_data <= {last_7_bytes,in_pkt_data[79:0],376'b0};
                flit_cnt <= 0;
                if(proceed & in_pkt_valid & in_pkt_sop)begin
                    in_pkt_data_r <= in_pkt_data;
                    in_pkt_empty_r <= in_pkt_empty_r;
                    last_7_bytes <= in_meta_data.last_7_bytes;
                    //one flit case
                    if (in_pkt_eop)begin
                        if(in_meta_data.prot == PROT_UDP)begin
                            state <= SINGLE_UDP;
                        end else begin
                            state <= SINGLE_TCP;
                        end
                    //multi-flit case
                    end else begin
                        if(in_meta_data.prot == PROT_UDP)begin
                            state <= UDP;
                        end else begin
                            state <= TCP;
                            last_7_bytes <= in_meta_data.last_7_bytes;
                        end
                    end
                end else begin
                    state <= FIRST;
                end
            end
        endcase
    end
end

endmodule
