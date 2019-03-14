module lab4_task2(input logic CLOCK_50, input logic [3:0] KEY, input logic [9:0] SW,
             output logic [6:0] HEX0, output logic [6:0] HEX1, output logic [6:0] HEX2,
             output logic [6:0] HEX3, output logic [6:0] HEX4, output logic [6:0] HEX5,
             output logic [9:0] LEDR);

    reg valid;
    wire ready, dm_wren;
    wire [7:0] em_addr, dm_addr, em_rddata, dm_rddata, dm_wrdata;

    //whenever reset is deasserted, set enable to 1
    always_ff @(posedge CLOCK_50 or negedge KEY[3]) begin
    	if(!KEY[3])
    		valid <= 1'b1;
    	else
    		valid <= 1'b0;
    end

    em_mem em(.address(em_addr), .clock(CLOCK_50), .q(em_rddata));
    dm_mem dm(.address(dm_addr), .clock(CLOCK_50), .data(dm_wrdata), .wren(dm_wren), .q(dm_rddata));

    task2 t2(.clk(CLOCK_50), .rst_n(KEY[3]),
            .valid(valid), .ready(ready),
            .key({14'b0, SW}), 
            .em_addr(em_addr), .em_rddata(em_rddata),
            .dm_addr(dm_addr), .dm_rddata(dm_rddata), .dm_wrdata(dm_wrdata), .dm_wren(dm_wren));

endmodule
