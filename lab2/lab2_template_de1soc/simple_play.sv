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
pos_edge_det ed(CLK_22K, CLK_50M, read_pulse);
assign flash_mem_read = read;
assign flash_mem_address = address;
assign audio_data = audio_sample;
enum {INIT, KBD_READ, START,STOP, FORWARD, BACKWARD, RESTART} state;

always_ff @(posedge CLK_50M) begin
    case (state)
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
        KBD_READ :  
            begin
            // // only need to toggle request once. 
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
        default:    state <= INIT;
    endcase
end

enum { INIT_CONTROL, READ, FIRST_HALF, WAIT_READ, SECOND_HALF, UPDATE_ADDRESS } controller_state;

always_ff @(posedge CLK_50M) begin
    case (controller_state)
        INIT_CONTROL: 
        begin
            address <= 23'b0;
            controller_state <= READ;
        end
        READ: 
        begin
            if (pause) audio_sample <= 16'b0;
            else if (read_pulse)
            begin
                read <= 1;
                if (~flash_mem_waitrequest) controller_state <= FIRST_HALF;
            end
        end
        FIRST_HALF: 
        begin
            if (flash_mem_readdatavalid)
            begin
                read <= 0;
                audio_sample <= flash_mem_readdata[15:0];
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
            audio_sample <= flash_mem_readdata[31:16];
            controller_state <= UPDATE_ADDRESS;
        end
        UPDATE_ADDRESS: 
        begin
            if (restart) 
            begin
                // restart <= 1'b0;
                if(direction) address <= 23'b0;
                else  address <= 23'h7FFFF;
            end
            else
            begin
                if(direction && (address != 23'h7FFFF)) address <= address + 1;
                else if(~direction && (address != 23'b0)) address <= address - 1;
                else if (direction) address <= 23'b0;
                else address <= 23'h7FFFF;
            end
            controller_state <= READ;
        end
        default: controller_state <= INIT_CONTROL;
    endcase
end
endmodule

module pos_edge_det ( input sig,            // Input signal for which positive edge has to be detected
                      input clk,            // Input signal for clock
                      output pe);           // Output signal that gives a pulse when a positive edge occurs
 
    reg   sig_dly;                          // Internal signal to store the delayed version of signal
 
    // This always block ensures that sig_dly is exactly 1 clock behind sig
  always @ (posedge clk) begin
    sig_dly <= sig;
  end
    // Combinational logic where sig is AND with delayed, inverted version of sig
    // Assign statement assigns the evaluated expression in the RHS to the internal net pe
  assign pe = sig & ~sig_dly;            
endmodule 

// enum {INIT, UPDATE, WAIT} address_state;

// always_ff @(posedge CLK_50M) begin
//     case(address_state)
//         INIT: 
//         begin
//             address <= 23'b0;
//             pause <= 1'b1;
//             direction <= 1'b1; // 0 is backwards, 1 is forwared
//         end
//         UPDATE: 
//         begin
//             if (restart) 
//             begin
//                 restart <= 1'b0;
//                 if(direction) address <= 23'b0;
//                 else  address <= 23'h7FFFF;
//             else
//             begin
//                 // if (direction && (address == 23'h7FFFF)) address <= 23'h7FFFF;
//                 if(direction && (address != 23'h7FFFF)) address <= address + 1;
//                 else if(~direction && (address != 23'b0)) address <= address - 1;
//                 address_state <= WAIT;
//             end
//         end
//         WAIT: if(change_address) address_state <= UPDATE;
//         default: address_state <= INIT;
//     endcase
// end
