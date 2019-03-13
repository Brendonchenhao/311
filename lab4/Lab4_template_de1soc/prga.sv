module prga(input logic clk, input logic rst_n,
            input logic en, output logic rdy,
            input logic [23:0] key,
            output logic [7:0] s_addr, input logic [7:0] s_rddata, output logic [7:0] s_wrdata, output logic s_wren,
            output logic [7:0] ct_addr, input logic [7:0] ct_rddata,
            output logic [7:0] pt_addr, input logic [7:0] pt_rddata, output logic [7:0] pt_wrdata, output logic pt_wren);

	enum {INIT, WAIT_FOR_CT_AND_I, READ_J, SWAP_J, READ_PAD_AND_STORE_CT, SWAP_I, READ_I_AND_SET_PT} current_state;

	reg [7:0] j;
    reg [7:0] i;
    reg [7:0] k;
    reg [7:0] temp_i;
    reg [7:0] temp_j;
    reg [7:0] temp_cipher;
    reg [7:0] temp_pad;
    reg [7:0] message_length;
    reg length_obtained;
    reg pick_temp_pad;

    wire [7:0] new_i = (i + 1) % 256;
    wire [7:0] new_j = (j + s_rddata) % 256;
    wire [7:0] new_k = k + 1;
    wire [7:0] pad = (temp_i + s_rddata) % 256; 

    always_ff @(posedge clk or negedge rst_n) begin
    	if(~rst_n) begin
    		//similar to init
    		i <= 8'b1;
    		j <= 8'b0;
    		k <= 8'b0;
    		rdy <= 1;
    		length_obtained <= 0; //we will get it soon
    		s_wren <= 0;
    		s_addr <= 1; //read from S[1] to get initial S[i]
    		ct_addr <= 0; //read initial value of ciphertext to find size of string
    		pt_wren <= 0;
    		pt_addr <= 0; //later we will start writing to plaintext
    		current_state <= INIT;
    	end else begin
    		case (current_state)
    			INIT: begin
			    		i <= 8'b1;
			    		j <= 8'b0;
			    		k <= 8'b0;
			    		length_obtained <= 0; //we will get it soon
			    		s_wren <= 0;
			    		s_addr <= 1; //read from S[1] to get initial S[i]
			    		ct_addr <= 0; //read initial value of ciphertext to find size of string
			    		pt_wren <= 0;
			    		pt_addr <= 0; //later we will start writing to plaintext

	    				if(rdy && en) begin	    					
	    					rdy <= 0; //not ready anymore
	    					current_state <= WAIT_FOR_CT_AND_I;
	    				end else begin
	    					rdy <= 1;
	    					current_state <= INIT;
	    				end
    				end
    			WAIT_FOR_CT_AND_I: begin
    					pt_wren <= 0;
    					current_state <= READ_J;
					end
				READ_J: begin
						//first time here? then store the length and do other logic ussing ct_rddata
						if(!length_obtained) begin
							length_obtained <= 1;
							message_length <= ct_rddata;

							//make sure initial length is not zero
							if(k < ct_rddata) begin
								j <= new_j;
								temp_i <= s_rddata; //store the value read from S[i]
								s_addr <= new_j; //get S[new_j]
    							s_wren <= 0;
    							current_state <= SWAP_J;    					
							end else begin
								rdy <= 1;
								current_state <= INIT;
							end
						end else begin
							j <= new_j;
							temp_i <= s_rddata; //store the value read from S[i]
							s_addr <= new_j; //get S[new_j]
							s_wren <= 0;
							current_state <= SWAP_J;   
						end

						//also, start reading the next ciphertext (with an offset of 1 because ct[0] contains the length)
						ct_addr <= k + 1;
					end
    			SWAP_J: begin
    					s_addr <= j; //update S[j]
    					s_wrdata <= temp_i; // S[j] = previously read S[i] which was stored in temp_i
    					s_wren <= 1;
    					current_state <= READ_PAD_AND_STORE_CT;
    				end
    			READ_PAD_AND_STORE_CT: begin
    					temp_j <= s_rddata; //previously read S[j] from last state
    					s_addr <= pad; //pad[k] = s[(s[i]+s[j]) mod 256]
    					if(pad == i)
    						pick_temp_pad <= 1; 
    					s_wren <= 0;
    					temp_cipher <= ct_rddata;
    					current_state <= SWAP_I;
    				end
    			SWAP_I: begin
    					s_addr <= i; //update S[i]
    					s_wrdata <= temp_j; //S[i] = last read S[j]
    					if(pick_temp_pad)
    						temp_pad <= temp_j;
    					s_wren <= 1;
    					current_state <= READ_I_AND_SET_PT;
    				end
    			READ_I_AND_SET_PT: begin
    					i <= new_i; //increase i by 1
    					k <= new_k; //increase k by 1
    					s_addr <= new_i; //read S[i] at the new location
    				    s_wren <= 0;
    				    //set the plain text to pad[k] (in s_rdddata) xor ciphertext[k] (in temp_cipher)
    				    pt_addr <= k;
    				    if(pick_temp_pad && k != 0) begin
    				    	pt_wrdata <= temp_pad ^ temp_cipher;
    				    	pick_temp_pad <= 0;
    				    end else
    				    	pt_wrdata <= s_rddata ^ temp_cipher;
    				    pt_wren <= 1;

    				    if(new_k < message_length)
							current_state <= WAIT_FOR_CT_AND_I;    					
						else
							current_state <= INIT;
    				end
    		endcase // current_state
    	end
    end

endmodule: prga
