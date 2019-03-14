module task3(input logic clk, 
             input logic rst_n,
             input logic valid, 
             output logic ready,
             output logic [23:0] key, 
             output logic key_valid,
             output logic [7:0] em_addr, 
             input logic [7:0] em_rddata,
             output logic [6:0] HEX0, output logic [6:0] HEX1, output logic [6:0] HEX2,
             output logic [6:0] HEX3, output logic [6:0] HEX4, output logic [6:0] HEX5
             );

    SevenSegmentDisplayDecoder(.nIn(key[23:20]), .ssOut(HEX5));
    SevenSegmentDisplayDecoder(.nIn(key[19:16]), .ssOut(HEX4));
    SevenSegmentDisplayDecoder(.nIn(key[15:12]), .ssOut(HEX3));
    SevenSegmentDisplayDecoder(.nIn(key[11:8]), .ssOut(HEX2));
    SevenSegmentDisplayDecoder(.nIn(key[7:4]), .ssOut(HEX1));
    SevenSegmentDisplayDecoder(.nIn(key[3:0]), .ssOut(HEX0));

    enum {INIT, START_CRACKING, WHILE_CRACKING, CHECK_RESULT} current_state;

    reg valid_arc, ready_arc, dm_wren;
    reg [7:0] dm_addr, dm_wrdata, dm_rddata;

    dm_mem s(.address(dm_addr), .clock(clk), .data(dm_wrdata), .wren(dm_wren), .q(dm_rddata));
    
    task2 t2(.clk(clk), .rst_n(rst_n),
            .valid(valid_arc), .ready(ready_arc),
            .key(key),
            .em_addr(em_addr), .em_rddata(em_rddata),
            .dm_addr(dm_addr), .dm_rddata(dm_rddata), .dm_wrdata(dm_wrdata), .dm_wren(dm_wren));

    reg invalid;

    always_ff @(posedge clk or negedge rst_n) begin
    	if(~rst_n) begin
    		key <= 24'b0;
    		key_valid <= 1'b0;
            invalid <= 1'b0;
    		ready <= 1'b1;
    		current_state <= INIT;
    	end else begin
    		case(current_state)
    			INIT: begin
    					//if enable, reset the key and valid all over
	    		 		if(valid) begin
	    		 			key <= 24'b0;
	    		 		    key_valid <= 1'b0;
	    		 			ready <= 1'b0;  		 			
	    		 			current_state <= START_CRACKING;
	    		 		end
					end
				START_CRACKING: begin
						if(ready_arc) begin
							valid_arc <= 1;
                            invalid <= 1'b0; //current key is still valid until proven wrong
							current_state <= WHILE_CRACKING;
						end
					end
				WHILE_CRACKING: begin
						valid_arc <= 0;
                        //are we about to write to PT? then check if the result is invalid
                        if(dm_wren && !invalid &&  !(( dm_wrdata >= 'd97 && dm_wrdata <= 'd122 ) || dm_wrdata == 'd32)  )
                            invalid <= 1'b1;
						//have we obtained a result yet?
						if(ready_arc && !valid_arc) begin
							current_state <= CHECK_RESULT;
						end
					end
				CHECK_RESULT: begin
                        //valid result
						if(!invalid) begin
                            key_valid <= 1'b1;
                            ready <= 1'b1;
                            current_state <= INIT;
                        end else begin
                            //if invalid result, check if we can increase the key
                            if(key < 'hFFFFFF) begin
                                key <= key + 1;
                                current_state <= START_CRACKING;
                            end else begin
                                ready <= 1'b1;
                                current_state <= INIT;
                            end
                        end
					end

    		endcase // current_state
    	end
    end

endmodule
