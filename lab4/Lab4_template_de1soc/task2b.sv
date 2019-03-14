/*
* compute one byte per character in the encrypted message. You will build this in Task 2
* we define each memory as: 
working memory: wm(s)
decrypted message: dm
encrypted message: em
*/
module task2b(
			input logic clk, 
			input logic rst_n,
            input logic valid, 
			output logic ready,
            input logic [23:0] key,
            output logic [7:0] s_addr, input logic [7:0] s_rddata, output logic [7:0] s_wrdata, output logic s_wren,
            output logic [7:0] ct_addr, input logic [7:0] ct_rddata,
            output logic [7:0] pt_addr, input logic [7:0] pt_rddata, output logic [7:0] pt_wrdata, output logic pt_wren);

	enum {INIT, WAIT_FOR_CT_AND_I, READ_J, SWAP_J, READ_F_AND_STORE_CT, SWAP_I, READ_I_AND_SET_PT} current_state;

	reg [7:0] j;
    reg [7:0] i;
    reg [7:0] k;
    reg [7:0] temp_i;
    reg [7:0] temp_j;
    reg [7:0] temp_cipher;
    reg [7:0] temp_f;
    // reg [7:0] message_length;
    // reg length_obtained;
    reg pick_temp_f;

    wire [7:0] new_i = (i + 1) % 256;
    wire [7:0] new_j = (j + s_rddata) % 256;
    wire [7:0] new_k = k + 1;
    wire [7:0] f = (temp_i + s_rddata) % 256; 

    always_ff @(posedge clk or negedge rst_n) begin
    	if(~rst_n) begin
    		//similar to init
    		i <= 8'b1;
    		j <= 8'b0;
    		k <= 8'b0;
    		ready <= 1;
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
			    		s_wren <= 0;
			    		s_addr <= 1; //read from S[1] to get initial S[i]
			    		ct_addr <= 0; //read initial value of ciphertext to find size of string
			    		pt_wren <= 0;
			    		pt_addr <= 0; //later we will start writing to plaintext

	    				if(ready && valid) begin	    					
	    					ready <= 0; //not ready anymore
	    					current_state <= WAIT_FOR_CT_AND_I;
	    				end else begin
	    					ready <= 1;
	    					current_state <= INIT;
	    				end
    				end
    			WAIT_FOR_CT_AND_I: begin
    					pt_wren <= 0;
    					current_state <= READ_J;
					end
				READ_J: begin
                        j <= new_j;
                        temp_i <= s_rddata; //store the value read from S[i]
                        s_addr <= new_j; //get S[new_j]
                        s_wren <= 0;
                        current_state <= SWAP_J;  
						//also, start reading the next ciphertext (with an offset of 1 because ct[0] contains the length)
					end
    			SWAP_J: begin
    					s_addr <= j; //update S[j]
    					s_wrdata <= temp_i; // S[j] = previously read S[i] which was stored in temp_i
    					s_wren <= 1;
    					current_state <= READ_F_AND_STORE_CT;
    				end
    			READ_F_AND_STORE_CT: begin
                        // since we have to wait for writing, we can set up the read f for the next memory operation
    					temp_j <= s_rddata; //previously read S[j] from last state
    					s_addr <= f; //f = (temp_i + s_rddata) % 256; 
    					if(f == i)
    						pick_temp_f <= 1; 
    					s_wren <= 0;
    					temp_cipher <= ct_rddata;
    					current_state <= SWAP_I;
    				end
    			SWAP_I: begin
    					s_addr <= i; //update S[i]
    					s_wrdata <= temp_j; //S[i] = last read S[j]
    					if(pick_temp_f)
    						temp_f <= temp_j;
    					s_wren <= 1;
    					current_state <= READ_I_AND_SET_PT;
    				end
    			READ_I_AND_SET_PT: begin
    					i <= new_i; //increase i by 1
    					k <= new_k; //increase k by 1
    					s_addr <= new_i; //read S[i] at the new location
    				    s_wren <= 0;
    				    //set the plain text to f[k] (in s_rdddata) xor ciphertext[k] (in temp_cipher)
    				    pt_addr <= k;
    				    if(pick_temp_f && k != 0) begin
    				    	pt_wrdata <= temp_f ^ temp_cipher;
    				    	pick_temp_f <= 0;
    				    end 
						else
    				    pt_wrdata <= s_rddata ^ temp_cipher;

						pt_wren <= 1;

    				    if(new_k < 32) begin // we know that the message length is 32
							current_state <= WAIT_FOR_CT_AND_I;    
                            ct_addr <= k + 1; // read the next key	
                            end			
						else
							current_state <= INIT;
    				end
    		endcase // current_state
    	end
    end

endmodule
