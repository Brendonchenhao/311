/*
* This module is follow the task 1, which is to initialize s array. 
* The pesudo code: 
for i = 0 to 255 {
    s[i] = i;
}
It's used to initialize the s_mem. 
*/
module task1(input logic clk, 
			input logic rst_n,
			input logic start, 
			output logic finish,
			output logic [7:0] addr, 
			output logic [7:0] wrdata, 
			output logic wren);

enum {INIT, ASSIGN} current_state;
reg [7:0] counter;
always_ff @(posedge clk or negedge rst_n) begin
	if(~rst_n) begin
		//SAME AS INIT
		begin
			addr <= 8'b0; //initialize i to 0
			wrdata <= 8'b0; //initialize s[0] to 0
			counter <= 8'b1; //set the counter to the first value required in the ASSIGN step
			current_state <= INIT;
			wren <= 0;
			finish <= 1;
		end
	end else begin
			case (current_state)
			INIT: begin
					addr <= 8'b0; //initialize i to 0
					wrdata <= 8'b0; //initialize s[0] to 0
					counter <= 8'b1; //set the counter to the first value required in the ASSIGN step
					if(finish && start) begin
						wren <= 1; //start writing the first step
						finish <= 0; //next step ready should go down
						current_state <= ASSIGN;
					end else begin
						wren <= 0;  //don't write anything here
						finish <= 1;
						current_state <= INIT;
					end
				end
			ASSIGN: begin
					addr <= counter;
					wrdata <= counter;
					counter <= counter + 1; //increase counter
					if(counter < 255)
						current_state <= ASSIGN;
					else
						current_state <= INIT;
				end
			endcase // current_state
	end
end
endmodule