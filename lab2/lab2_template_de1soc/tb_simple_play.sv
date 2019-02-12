//~ `New testbench
`timescale  1ns / 1ps

module tb_simple_play;

// lab2_controller Parameters
parameter PERIOD  = 10;


// lab2_controller Inputs
reg   CLK_50M                              = 0 ;
reg   CLK_22K                              = 0 ;
reg   [7:0]  kbd_received_ascii_code       = 0 ;
reg   kbd_data_ready                       = 0 ;
reg   flash_mem_readdatavalid              = 0 ;
reg   [31:0]  flash_mem_readdata           = 0 ;
reg   flash_mem_waitrequest                = 0 ;

// lab2_controller Outputs
wire  flash_mem_read                       ;
wire  [22:0]  flash_mem_address            ;
wire  [15:0]  audio_data                   ;

initial
begin
    forever #(PERIOD)  CLK_22K=~CLK_22K;
end
initial
begin
    forever #(PERIOD/6)  CLK_50M=~CLK_50M;
end

simple_play  u_simple_play(
    .CLK_50M                  ( CLK_50M                        ),
    .CLK_22K                  ( CLK_22K                        ),
    .kbd_received_ascii_code  ( kbd_received_ascii_code  [7:0]  ),
    .kbd_data_ready           ( kbd_data_ready                  ),
    .flash_mem_readdatavalid  ( flash_mem_readdatavalid         ),
    .flash_mem_readdata       ( flash_mem_readdata       [31:0] ),
    .flash_mem_waitrequest    ( flash_mem_waitrequest           ),

    .flash_mem_read           ( flash_mem_read                  ),
    .flash_mem_address        ( flash_mem_address        [22:0] ),
    .audio_data               ( audio_data               [15:0] )
);

initial
begin
// test what happen if there is no command. By default pause is 0, so we should be playing. 
    #30;
    flash_mem_readdatavalid = 1'b1;
    flash_mem_readdata = {16'b10, 16'b1};
    // assert (u_simple_play.fr.address == 23'b0);
    // nothing should happen during, since it started paused
    #100;

// start
    kbd_data_ready = 1'b1;
    kbd_received_ascii_code = 8'h45;
    #10;
    kbd_data_ready = 1'b0;
    #500;

// stop
    kbd_data_ready = 1'b1;
    kbd_received_ascii_code = 8'h44;
    #10;
    kbd_data_ready = 1'b0;
    #100;

    // start again
    kbd_data_ready = 1'b1;
    kbd_received_ascii_code = 8'h45;
    #10;
    kbd_data_ready = 1'b0;
    #100;

    // run it backwards
    kbd_data_ready = 1'b1;
    kbd_received_ascii_code = 8'h42;
    #10;
    kbd_data_ready = 1'b0;
    #100;
    // kbd_received_ascii_code = 8'h46;

    // restart
    kbd_data_ready = 1'b1;
    kbd_received_ascii_code = 8'h52;
    #10;
    kbd_data_ready = 1'b0;
    #100;

    #500;

        // start again
    kbd_data_ready = 1'b1;
    kbd_received_ascii_code = 8'h45;
    #10;
    kbd_data_ready = 1'b0;
    #400;


    // run it forwards
    kbd_data_ready = 1'b1;
    kbd_received_ascii_code = 8'h46;
    #10;
    kbd_data_ready = 1'b0;
    #700;
    $stop;
end

endmodule