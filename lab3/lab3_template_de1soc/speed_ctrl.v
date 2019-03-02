// Author: Gaurika Sohnvi
// Email: gaurika1311@gmail.com
// Permission to use granted to Yiyi Yan. 
module speed_ctrl(
	Clock, reset,speed_up, speed_down, CLK_FREQ);

input Clock, reset, speed_up, speed_down;
output [31:0] CLK_FREQ;

parameter IDLE = 3'b001;
parameter speed_up_state = 3'b010;
parameter speed_down_state = 3'b100;

reg [2:0] state;

always @(posedge Clock) begin
	if(reset) begin
		state <= IDLE;
		CLK_FREQ <= 32'h2FA; //Default frequency 33000 KHz
	end	
	case(state)
		IDLE: //Keep default if no KEY's are pressed
			if(speed_up)
				state <= speed_up_state;
			else if(speed_down)
				state <= speed_down_state;
			else
				state <= IDLE;
				
		speed_up_state: //Decrements the time period to increase frequency thus increasing sampling rate of addresses
		begin
			CLK_FREQ <= CLK_FREQ - 2;
			state <= IDLE;
		end
		speed_down_state: //Increments the time period to decrease frequency thus decreasing sampling rate of addresses
		begin
			CLK_FREQ <= CLK_FREQ + 2;
			state <= IDLE;
		end
		default:
		begin
			CLK_FREQ <= 32'h2FA;
			state <= IDLE;
		end	
	endcase

end
endmodule

