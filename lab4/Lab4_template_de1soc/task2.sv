module task2(input logic clk, input logic rst_n,
            input logic valid, output logic ready,
            input logic [23:0] key,
            output logic [7:0] em_addr, input logic [7:0] em_rddata,
            output logic [7:0] dm_addr, input logic [7:0] dm_rddata, 
            output logic [7:0] dm_wrdata, output logic dm_wren);

    enum {INIT, PROCESSING_T1, PROCESSING_T2A, PROCESSING_T2B} init_state;

    reg valid_t1, valid_t2a, valid_t2b;
    wire ready_t1, ready_t2a, ready_t2b;
    wire s_wren_t1, s_wren_t2a, s_wren_t2b;
    wire [7:0] s_addr_t1, s_addr_t2a, s_addr_t2b, s_wrdata_t1, s_wrdata_t2a, s_wrdata_t2b;

    wire wren = (init_state == PROCESSING_T1) ? s_wren_t1 :
                (init_state == PROCESSING_T2A) ? s_wren_t2a   :
                (init_state == PROCESSING_T2B) ? s_wren_t2b :
                1'b0;

    wire [7:0] addr = (init_state == PROCESSING_T1) ? s_addr_t1 :
                      (init_state == PROCESSING_T2A) ? s_addr_t2a   :
                      (init_state == PROCESSING_T2B) ? s_addr_t2b :
                      8'b0;

    wire [7:0] wrdata = (init_state == PROCESSING_T1) ? s_wrdata_t1 :
                        (init_state == PROCESSING_T2A) ? s_wrdata_t2a   :
                        (init_state == PROCESSING_T2B) ? s_wrdata_t2b :
                        8'b0;

    wire [7:0] s_rddata;    


    //whenever reset is deasserted, set enable to 1
    always_ff @(posedge clk or negedge rst_n) begin
        if(!rst_n) begin
            valid_t1 <= 1'b0;
            valid_t2a <= 1'b0;
            valid_t2b <= 1'b0;
            ready <= 1'b1;
            init_state <= INIT;
        end else begin
            case(init_state)
                INIT: begin
                        valid_t2a <= 1'b0;
                        valid_t2b <= 1'b0;
                        if(ready && ready_t1 && valid) begin
                            valid_t1 <= 1'b1;
                            ready <= 1'b0;
                            init_state <= PROCESSING_T1;
                        end
                    end
                PROCESSING_T1: begin
                        valid_t1 <= 1'b0;
                        if(ready_t1 && ready_t2a && !valid_t1) begin
                            valid_t2a <= 1'b1;
                            init_state <= PROCESSING_T2A;
                        end
                    end
                PROCESSING_T2A: begin
                        valid_t2a <= 1'b0;
                        if(ready_t2a && ready_t2b && !valid_t2a) begin
                            valid_t2b <= 1'b1;
                            init_state <= PROCESSING_T2B;
                        end
                    end
                PROCESSING_T2B: begin
                        valid_t2b <= 1'b0;
                        if(ready_t2b && !valid_t2b) begin
                            ready <= 1'b1;
                            init_state <= INIT;
                        end
                    end
            endcase // init_state
        end
    end

    s_mem s(.address(addr), .clock(clk), .data(wrdata), .wren(wren), .q(s_rddata));

    task1 t1(.clk(clk), .rst_n(rst_n), .valid(valid_t1), .ready(ready_t1), .addr(s_addr_t1),
           .wrdata(s_wrdata_t1), .wren(s_wren_t1));

    task2a t2a(.clk(clk), .rst_n(rst_n), .valid(valid_t2a), .ready(ready_t2a), .key(key), .addr(s_addr_t2a),
          .rddata(s_rddata), .wrdata(s_wrdata_t2a), .wren(s_wren_t2a));

    task2b t2b(.clk(clk), .rst_n(rst_n), .valid(valid_t2b), .ready(ready_t2b), .key(key),
            .s_addr(s_addr_t2b), .s_rddata(s_rddata), .s_wrdata(s_wrdata_t2b), .s_wren(s_wren_t2b),
            .em_addr(em_addr), .em_rddata(em_rddata),
            .dm_addr(dm_addr), .dm_rddata(dm_rddata), .dm_wrdata(dm_wrdata), .dm_wren(dm_wren));

endmodule
