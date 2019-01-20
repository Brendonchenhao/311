`timescale 1ns / 1ps
module Generate_Arbitrary_Divided_Clk32(inclk,outclk,outclk_Not,div_clk_count,Reset);
// divide the clk based on given clk
//example: given 50 * 10^6 Hz, divided by 32'h61h6 (24998) into 1 *10^3 Hz. Therefore, 1 * 10^3 * 25 * 10^3 * 2 = 50 * 10 ^6
// which measn the clock was divided by two. 
    input inclk;
	 input Reset;
    output outclk;
	 output outclk_Not;
	 input[31:0] div_clk_count;
	 
	 var_clk_div32 Div_Clk(.inclk(inclk),.outclk(outclk),
	 .outclk_not(outclk_Not),.clk_count(div_clk_count),.Reset(Reset));

endmodule
