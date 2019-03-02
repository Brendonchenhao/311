module simple_play(
    input CLK_50M,
    input CLK_22K,
    input [7:0]kbd_received_ascii_code,
    input kbd_data_ready,
    input flash_mem_readdatavalid,
    input [31:0] flash_mem_readdata,
    input flash_mem_waitrequest,
    output flash_mem_read,
    output [22:0]flash_mem_address,
    output[15:0] audio_data
);

logic [22:0] address;
logic [31:0] audio_sample;
logic pause, direction,  read_pulse, restart, read;
// the edge detector generator. This is used for sync the two clocks, to avoid 
// timing violation when the two clocks are not synced
pos_edge_det ed(CLK_22K, CLK_50M, read_pulse);
assign flash_mem_read = read;
assign flash_mem_address = address;
assign audio_data = audio_sample;

// The states for Keyboard reading. 
enum {INIT, KBD_READ, START,STOP, FORWARD, BACKWARD, RESTART} state;
always_ff @(posedge CLK_50M) begin
    case (state)
        // the reset state. 
        INIT: 
            begin
                // after reset, we start reading and set all the direction and such to default, 
                // which is ging forward.
                state <= KBD_READ;
                pause <= 1'b1; // the music is initially paused
                direction <= 1'b1;
                restart <= 1'b0;
                // request <= 1'b0;
            end
        // this is the main keyboard input control state. 
        // Base on different output, we will change the pause, direction and restart signals
        KBD_READ :  
            begin
            // only need to toggle request once. 
            // request <= 1'b0;
            // after request RESTART, we toggle it
            if (kbd_data_ready)
                restart <= 1'b0;
                begin
                    // after getting kbd we find which action to follow. 
                    case (kbd_received_ascii_code)
                        8'h45: state <= START;
                        8'h44: state <= STOP;
                        8'h42: state <= BACKWARD;
                        8'h46: state <= FORWARD;
                        8'h52: state <= RESTART;
                        // default?
                    endcase
                end
            end
        // this state will change the pause bit and let the music play. 
        START:      
            begin
                state <= KBD_READ;
                pause <= 1'b0;
            end
        // this state will pause the mucis by toggle the pause bit.
        STOP :
            begin
                state <= KBD_READ;
                pause <= 1'b1;
            end
        FORWARD:
            begin    
                state <= KBD_READ;
                // we defined forward as direction = 1
                direction <= 1'b1;
            end
        BACKWARD:
            begin    
                state <= KBD_READ;
                //we define backwards as direction = 0
                direction <= 1'b0;
            end
        RESTART:
            begin    
                state <= KBD_READ;
                restart <= 1'b1;
                pause <= 1'b0;
                // request <= 1'b1;
            end
        default:    state <= INIT;
    endcase
end
// these are the controlling states for the main controller
enum { INIT_CONTROL, READ, FIRST_HALF, WAIT_READ, SECOND_HALF, UPDATE_ADDRESS } controller_state;

always_ff @(posedge CLK_50M) begin
    case (controller_state)
        // the reset state. We should only enter this once. 
        INIT_CONTROL: 
        begin
            address <= 23'b0;
            controller_state <= READ;
        end
        // the read state can wait on whether the pause or the read_pulse, 
        // which is used to sync the 50M clock and 22K clock. 
        READ: 
        begin
            if (pause) audio_sample <= 16'b0;
            else if (read_pulse)
            begin
                read <= 1'b1;
                if (~flash_mem_waitrequest) controller_state <= FIRST_HALF;
            end
        end
        FIRST_HALF: 
        begin
            // wait until the 
            if (flash_mem_readdatavalid)
            begin
                read <= 1'b0;
                if (direction) audio_sample <= flash_mem_readdata[15:0];
                else audio_sample <= flash_mem_readdata[31:16];
                controller_state <= WAIT_READ;
            end
        end
        WAIT_READ: 
        begin
            if (pause) audio_sample <= 16'b0;
            else if(read_pulse) controller_state <= SECOND_HALF;
        end
        SECOND_HALF:
        begin
            if (direction) audio_sample <= flash_mem_readdata[31:16];
            else audio_sample <= flash_mem_readdata[15:0];
            controller_state <= UPDATE_ADDRESS;
        end
        // this state is where we update the address 
        UPDATE_ADDRESS: 
        begin
            // restart will set the address to different location
            if (restart) 
            begin
                // if we restart forward, we want to start at the 0, else just start at the end
                if (direction)address <= 23'b0;
                else address <= 23'h7FFFF;
            end
            else
            begin
                // We want to stop when reached the end of address. 
                if(direction && (address == 23'h7FFFF)) address <= 23'h7FFFF;
                else if(~direction && (address == 23'b0)) address <= 23'b0;
                else if (direction) address <= address + 23'b1;
                else address <= address - 23'b1;
                // if(direction && (address != 23'h7FFFF)) address <= address + 23'b1;
                // else if(~direction && (address != 23'b0)) address <= address - 23'b1;
                // else if (direction) address <= 23'b0;
                // else address <= 23'h7FFFF;
            end
            // we reiterate the the reading state, and wait for read pulse
            controller_state <= READ;
        end
        default: controller_state <= INIT_CONTROL;
    endcase
end
endmodule

