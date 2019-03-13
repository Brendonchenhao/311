module arc4(input logic clk, input logic rst_n,
            input logic en, output logic rdy,
            input logic [23:0] key,
            output logic [7:0] ct_addr, input logic [7:0] ct_rddata,
            output logic [7:0] pt_addr, input logic [7:0] pt_rddata, output logic [7:0] pt_wrdata, output logic pt_wren);

    enum {INIT, PROCESSING_INIT, PROCESSING_KSA, PROCESSING_PRGA} init_state;

    reg en_init, en_ksa, en_prga;
    wire rdy_init, rdy_ksa, rdy_prga;
    wire s_wren_init, s_wren_ksa, s_wren_prga;
    wire [7:0] s_addr_init, s_addr_ksa, s_addr_prga,
               s_wrdata_init, s_wrdata_ksa, s_wrdata_prga;

    wire wren = (init_state == PROCESSING_INIT) ? s_wren_init :
                (init_state == PROCESSING_KSA) ? s_wren_ksa   :
                (init_state == PROCESSING_PRGA) ? s_wren_prga :
                1'b0;

    wire [7:0] addr = (init_state == PROCESSING_INIT) ? s_addr_init :
                      (init_state == PROCESSING_KSA) ? s_addr_ksa   :
                      (init_state == PROCESSING_PRGA) ? s_addr_prga :
                      8'b0;

    wire [7:0] wrdata = (init_state == PROCESSING_INIT) ? s_wrdata_init :
                        (init_state == PROCESSING_KSA) ? s_wrdata_ksa   :
                        (init_state == PROCESSING_PRGA) ? s_wrdata_prga :
                        8'b0;

    wire [7:0] s_rddata;    


    //whenever reset is deasserted, set enable to 1
    always_ff @(posedge clk or negedge rst_n) begin
        if(!rst_n) begin
            en_init <= 1'b0;
            en_ksa <= 1'b0;
            en_prga <= 1'b0;
            rdy <= 1'b1;
            init_state <= INIT;
        end else begin
            case(init_state)
                INIT: begin
                        en_ksa <= 1'b0;
                        en_prga <= 1'b0;
                        if(rdy && rdy_init && en) begin
                            en_init <= 1'b1;
                            rdy <= 1'b0;
                            init_state <= PROCESSING_INIT;
                        end
                    end
                PROCESSING_INIT: begin
                        en_init <= 1'b0;
                        if(rdy_init && rdy_ksa && !en_init) begin
                            en_ksa <= 1'b1;
                            init_state <= PROCESSING_KSA;
                        end
                    end
                PROCESSING_KSA: begin
                        en_ksa <= 1'b0;
                        if(rdy_ksa && rdy_prga && !en_ksa) begin
                            en_prga <= 1'b1;
                            init_state <= PROCESSING_PRGA;
                        end
                    end
                PROCESSING_PRGA: begin
                        en_prga <= 1'b0;
                        if(rdy_prga && !en_prga) begin
                            rdy <= 1'b1;
                            init_state <= INIT;
                        end
                    end
            endcase // init_state
        end
    end

    s_mem s(.address(addr), .clock(clk), .data(wrdata), .wren(wren), .q(s_rddata));

    init i(.clk(clk), .rst_n(rst_n), .en(en_init), .rdy(rdy_init), .addr(s_addr_init),
           .wrdata(s_wrdata_init), .wren(s_wren_init));

    ksa k(.clk(clk), .rst_n(rst_n), .en(en_ksa), .rdy(rdy_ksa), .key(key), .addr(s_addr_ksa),
          .rddata(s_rddata), .wrdata(s_wrdata_ksa), .wren(s_wren_ksa));

    prga p(.clk(clk), .rst_n(rst_n), .en(en_prga), .rdy(rdy_prga), .key(key),
            .s_addr(s_addr_prga), .s_rddata(s_rddata), .s_wrdata(s_wrdata_prga), .s_wren(s_wren_prga),
            .ct_addr(ct_addr), .ct_rddata(ct_rddata),
            .pt_addr(pt_addr), .pt_rddata(pt_rddata), .pt_wrdata(pt_wrdata), .pt_wren(pt_wren));

    // your code here

endmodule: arc4
