module lab4_task2(input logic CLOCK_50, input logic [3:0] KEY, input logic [9:0] SW,
             output logic [6:0] HEX0, output logic [6:0] HEX1, output logic [6:0] HEX2,
             output logic [6:0] HEX3, output logic [6:0] HEX4, output logic [6:0] HEX5,
             output logic [9:0] LEDR);

    reg en;
    wire rdy, pt_wren;
    wire [7:0] ct_addr, pt_addr, ct_rddata, pt_rddata, pt_wrdata;

    //whenever reset is deasserted, set enable to 1
    always_ff @(posedge CLOCK_50 or negedge KEY[3]) begin
    	if(!KEY[3])
    		en <= 1'b1;
    	else
    		en <= 1'b0;
    end

    ct_mem ct(.address(ct_addr), .clock(CLOCK_50), .q(ct_rddata));
    pt_mem pt(.address(pt_addr), .clock(CLOCK_50), .data(pt_wrdata), .wren(pt_wren), .q(pt_rddata));

    arc4 a4(.clk(CLOCK_50), .rst_n(KEY[3]),
            .en(en), .rdy(rdy),
            .key({14'b0, SW}),
            .ct_addr(ct_addr), .ct_rddata(ct_rddata),
            .pt_addr(pt_addr), .pt_rddata(pt_rddata), .pt_wrdata(pt_wrdata), .pt_wren(pt_wren));

endmodule
