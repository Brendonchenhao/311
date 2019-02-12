module lab2_controller(
    input CLK_50M,
    input CLK_22K,
    input rst_n,
    input [7:0]kbd_received_ascii_code,
    input kbd_data_ready,
    input flash_mem_readdatavalid,
    input [31:0] flash_mem_readdata,
    input flash_mem_waitrequest,
    output flash_mem_read,
    output [22:0]flash_mem_address,
    output[15:0] audio_data
);
//              state_pause_direction_RESTART_request
// logic [7:0] init        = 8'b0000_0_1_0_0;
enum {KBD_READ, START,STOP, FORWARD, BACKWARD, RESTART} state;

// logic [15:0] sample;
// assign audio_data = sample;


// logic [7:0] KBD_READ    = 8'b0001_0_1_0_0;
// logic [7:0] START       = 8'b0010_0_1_0_1;
// logic [7:0] STOP        = 8'b0011_1_1_0_1;
// logic [7:0] FORWARD     = 8'b0100_0_1_0_1;
// logic [7:0] BACKWARD    = 8'b0101_0_0_0_1;
// logic [7:0] RESTART     = 8'b0110_0_1_1_1;


// logic [7:0] state;
// logic request = state[0]; // default is 0
// logic pause = state[2]; // 0 is START, 1 is pause
// //pause have the h
// logic direction = state[3]; // 0 to BACKWARD, 1 is FORWARD
// logic RESTART = state[1]; // 1 is RESTART 
logic pause,direction,restart;

always_ff @(posedge CLK_50M, negedge rst_n) begin
    if (~rst_n)
    begin
        // after reset, we start reading and set all the direction and such to default, 
        // which is ging forward.
        state <= KBD_READ;
        pause <= 1'b1; // the music is initially paused
        direction <= 1'b1;
        restart <= 1'b0;
        // request <= 1'b0;
    end
    case (state)
        KBD_READ :  
            begin
            // // only need to toggle request once. 
            // request <= 1'b0;
            // after request RESTART, we toggle it
            restart <= 1'b0;
            if (kbd_data_ready)
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
        START:      
            begin
                state <= KBD_READ;
                pause <= 1'b0;
                // request <= 1'b1;
            end
        STOP :
            begin
                state <= KBD_READ;
                pause <= 1'b1;
                // request <= 1'b1;
            end
        FORWARD:
            begin    
                state <= KBD_READ;
                direction <= 1'b1;
            end
        BACKWARD:
            begin    
                state <= KBD_READ;
                direction <= 1'b0;
            end
        RESTART:
            begin    
                state <= KBD_READ;
                restart <= 1'b1;
                direction <= 1'b1;
                pause <= 1'b0;
                // request <= 1'b1;
            end
        // default:    state <= init;
    endcase
end  

reg edge_restart;
edge_detetor ed(restart, CLK_22K, edge_restart);

//TODO: Maybe need edge detectors for the 4 control signals?
lab2_flash_reader fr(
    .clk(CLK_22K), 
    .rst_n(rst_n),
    .pause(pause),
    .direction(direction),
    .restart(edge_restart),
    .flash_mem_address(flash_mem_address),
    .flash_mem_read(flash_mem_read),
    .flash_mem_readdata(flash_mem_readdata),
    .flash_mem_readdatavalid(flash_mem_readdatavalid),
    .flash_mem_waitrequest(flash_mem_waitrequest),
    .sample(audio_data));
endmodule

module edge_detetor(input async_sig, input outclk, output out_sync_sig);
    wire grounded_reset = 1'b0;
    wire vcc = 1'b1;
    wire fdc_top_1_out, fdc_top_2_out, fdc_top_3_out, fdc_1_out;
    ff fdc_top_1(vcc, fdc_top_1_out, async_sig, fdc_1_out);
    ff fdc_top_2(fdc_top_1_out, fdc_top_2_out, outclk, grounded_reset);
    ff fdc_top_3(fdc_top_2_out, fdc_top_3_out, outclk, grounded_reset);
    ff fdc_1(fdc_top_3_out, fdc_1_out, outclk, grounded_reset);
    assign out_sync_sig = fdc_top_3_out;
endmodule


module ff(input D, output logic Q, input clk, input rst);
    always_ff @(posedge clk or posedge rst)
    begin
        if (rst) Q <= 1'b0;
        else Q <= D;
    end
endmodule