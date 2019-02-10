module lab2_controller(
    input CLK_50M,
    input CLK_22K,
    input rst_n,
    input [7:0]kbd_received_ascii_code,
    input kbd_data_reading,
    output[7:0] audio_data
);
//              state_pause_direction_restart_request
logic [7:0] init        = 8'b0000_0_1_0_0;
logic [7:0] kbd_read    = 8'b0001_0_1_0_0;
logic [7:0] start       = 8'b0010_0_1_0_1;
logic [7:0] stop        = 8'b0011_1_1_0_1;
logic [7:0] forward     = 8'b0100_0_1_0_1;
logic [7:0] backward    = 8'b0101_0_0_0_1;
logic [7:0] restart     = 8'b0110_0_1_1_1;


logic [7:0] state;
logic request = state[0]; // default is 0
logic pause = state[2]; // 0 is start, 1 is pause
//pause have the h
logic direction = state[3]; // 0 to backward, 1 is forward
logic restart = state[1]; // 1 is restart 

always_ff @(posedge CLK_50M, negedge rst_n) begin
    if (~rst_n) state <= init;
    case (state)
        init :      state <= kbd_read;
        kbd_read :  if (kbd_data_reading)
                    case (kbd_received_ascii_code)
                        8'h45: state <= start;
                        8'h44: state <= stop;
                        8'h42: state <= backward;
                        8'h46: state <= forward;
                        8'h52: state <= restart;
                        // default?
                    endcase
                // else
                //     state <= init;
        start:      state <= kbd_read;
        stop :      state <= kbd_read;
        forward:    state <= kbd_read;
        backward:   state <= kbd_read;
        restart:    state <= kbd_read;
        // default:    state <= init;
    endcase
end  

endmodule