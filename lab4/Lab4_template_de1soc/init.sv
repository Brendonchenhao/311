
	module init(input logic clk, input logic rst_n,
            input logic en, output logic rdy,
            output logic [7:0] addr, output logic [7:0] wrdata, output logic wren);

	enum {INIT, ASSIGN} current_state;

	reg [7:0] counter;

    /*
	always_comb
		if (current_state == INIT)
			rdy = 1'b1;
		else
			rdy = 1'b0;
    */

	// your code here
	always_ff @(posedge clk or negedge rst_n) begin
		if(~rst_n) begin
			//SAME AS INIT
			begin
 				addr <= 8'b0; //initialize i to 0
 				wrdata <= 8'b0; //initialize s[0] to 0
 				counter <= 8'b1; //set the counter to the first value required in the ASSIGN step
 				current_state <= INIT;
 				wren <= 0;
 				rdy <= 1;
 				/*
	 			if(en == 1'b1) begin
	 				rdy <= 0; //we are not gonna be ready on next step
	 			end else begin
		 			rdy <= 1;  //don't write anything here
	 			end
	 			*/
 			end
		end else begin
			 case (current_state)
			 	INIT: begin
		 				addr <= 8'b0; //initialize i to 0
		 				wrdata <= 8'b0; //initialize s[0] to 0
		 				counter <= 8'b1; //set the counter to the first value required in the ASSIGN step
			 			if(rdy && en) begin
			 				wren <= 1; //start writing the first step
			 				rdy <= 0; //next step ready should go down
			 				current_state <= ASSIGN;
			 			end else begin
				 			wren <= 0;  //don't write anything here
				 			rdy <= 1;
			 				current_state <= INIT;
			 			end
		 			end
		 		ASSIGN: begin
	 					//rdy <= 0;
	 					addr <= counter;
	 					wrdata <= counter;
	 					counter <= counter + 1; //increase counter
	 					//wren <= 1; // write to current output
	 					if(counter < 255)
	 						current_state <= ASSIGN;
	 					else
	 						current_state <= INIT;
		 			end

			 endcase // current_state
		end
	end
endmodule: init