module crack(input logic clk, input logic rst_n,
             input logic en, output logic rdy,
             output logic [23:0] key, output logic key_valid,
             output logic [7:0] ct_addr, input logic [7:0] ct_rddata,
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

    reg en_arc, rdy_arc, pt_wren;
    reg [7:0] pt_addr, pt_wrdata, pt_rddata;

    pt_mem s(.address(pt_addr), .clock(clk), .data(pt_wrdata), .wren(pt_wren), .q(pt_rddata));
    arc4 a4(.clk(clk), .rst_n(rst_n),
            .en(en_arc), .rdy(rdy_arc),
            .key(key),
            .ct_addr(ct_addr), .ct_rddata(ct_rddata),
            .pt_addr(pt_addr), .pt_rddata(pt_rddata), .pt_wrdata(pt_wrdata), .pt_wren(pt_wren));

    reg invalid;

    always_ff @(posedge clk or negedge rst_n) begin
    	if(~rst_n) begin
    		key <= 24'b0;
    		key_valid <= 1'b0;
            invalid <= 1'b0;
    		rdy <= 1'b1;
    		current_state <= INIT;
    	end else begin
    		case(current_state)
    			INIT: begin
    					//if enable, reset the key and start all over
	    		 		if(en) begin
	    		 			key <= 24'b0;
	    		 		    key_valid <= 1'b0;
	    		 			rdy <= 1'b0;  		 			
	    		 			current_state <= START_CRACKING;
	    		 		end
					end
				START_CRACKING: begin
						if(rdy_arc) begin
							en_arc <= 1;
                            invalid <= 1'b0; //current key is still valid until proven wrong
							current_state <= WHILE_CRACKING;
						end
					end
				WHILE_CRACKING: begin
						en_arc <= 0;
                        //are we about to write to PT? then check if the result is invalid
                        if(pt_wren && !invalid &&  !(( pt_wrdata >= 'd97 && pt_wrdata <= 'd122 ) || pt_wrdata == 'd32)  )
                            invalid <= 1'b1;
						//have we obtained a result yet?
						if(rdy_arc && !en_arc) begin
							current_state <= CHECK_RESULT;
						end
					end
				CHECK_RESULT: begin
                        //valid result
						if(!invalid) begin
                            key_valid <= 1'b1;
                            rdy <= 1'b1;
                            current_state <= INIT;
                        end else begin
                            //if invalid result, check if we can increase the key
                            if(key < 'hFFFFFF) begin
                                key <= key + 1;
                                current_state <= START_CRACKING;
                            end else begin
                                rdy <= 1'b1;
                                current_state <= INIT;
                            end
                        end
					end

    		endcase // current_state
    	end
    end

endmodule: crack
