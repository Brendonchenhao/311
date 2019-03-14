module task2(input logic clk, input logic rst_n,
            input logic valid, output logic ready,
            input logic [23:0] key,
            output logic [7:0] ct_addr, input logic [7:0] ct_rddata,
            output logic [7:0] pt_addr, input logic [7:0] pt_rddata, output logic [7:0] pt_wrdata, output logic pt_wren);

    enum {INIT, PROCESSING_INIT, PROCESSING_KSA, PROCESSING_PRGA} init_state;

    reg valid_init, valid_ksa, valid_prga;
    wire ready_init, ready_ksa, ready_prga;
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
            valid_init <= 1'b0;
            valid_ksa <= 1'b0;
            valid_prga <= 1'b0;
            ready <= 1'b1;
            init_state <= INIT;
        end else begin
            case(init_state)
                INIT: begin
                        valid_ksa <= 1'b0;
                        valid_prga <= 1'b0;
                        if(ready && ready_init && valid) begin
                            valid_init <= 1'b1;
                            ready <= 1'b0;
                            init_state <= PROCESSING_INIT;
                        end
                    end
                PROCESSING_INIT: begin
                        valid_init <= 1'b0;
                        if(ready_init && ready_ksa && !valid_init) begin
                            valid_ksa <= 1'b1;
                            init_state <= PROCESSING_KSA;
                        end
                    end
                PROCESSING_KSA: begin
                        valid_ksa <= 1'b0;
                        if(ready_ksa && ready_prga && !valid_ksa) begin
                            valid_prga <= 1'b1;
                            init_state <= PROCESSING_PRGA;
                        end
                    end
                PROCESSING_PRGA: begin
                        valid_prga <= 1'b0;
                        if(ready_prga && !valid_prga) begin
                            ready <= 1'b1;
                            init_state <= INIT;
                        end
                    end
            endcase // init_state
        end
    end

    s_mem s(.address(addr), .clock(clk), .data(wrdata), .wren(wren), .q(s_rddata));

    task1 t1(.clk(clk), .rst_n(rst_n), .valid(valid_init), .ready(ready_init), .addr(s_addr_init),
           .wrdata(s_wrdata_init), .wren(s_wren_init));

    task2a t2a(.clk(clk), .rst_n(rst_n), .valid(valid_ksa), .ready(ready_ksa), .key(key), .addr(s_addr_ksa),
          .rddata(s_rddata), .wrdata(s_wrdata_ksa), .wren(s_wren_ksa));

    task2b t2b(.clk(clk), .rst_n(rst_n), .valid(valid_prga), .ready(ready_prga), .key(key),
            .s_addr(s_addr_prga), .s_rddata(s_rddata), .s_wrdata(s_wrdata_prga), .s_wren(s_wren_prga),
            .ct_addr(ct_addr), .ct_rddata(ct_rddata),
            .pt_addr(pt_addr), .pt_rddata(pt_rddata), .pt_wrdata(pt_wrdata), .pt_wren(pt_wren));

endmodule
