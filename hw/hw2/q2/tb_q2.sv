//~ `New testbench
`timescale  1ns / 1ps

module tb_fsm;

// fsm Parameters
parameter PERIOD  = 10                   ;
parameter FIRST   = 12'b000_011_010_1_0_0;
parameter SECOND  = 12'b001_101_100_0_1_0;
parameter THIRD   = 12'b010_010_111_1_0_0;
parameter FOURTH  = 12'b011_110_011_0_1_0;
parameter FIFTH   = 12'b100_101_010_1_0_1;

// fsm Inputs
reg   restart                              = 0 ;
reg   clk                                  = 0 ;
reg   rst                                  = 0 ;
reg   pause                                = 0 ;
reg   goto_third                           = 0 ;

// fsm Outputs
wire  [2:0]  out1                          ;
wire  [2:0]  out2                          ;
wire  even                                 ;
wire  odd                                  ;
wire  terminal                             ;


initial
begin
    forever #(PERIOD/2)  clk=~clk;
end



fsm #(
    .FIRST  ( FIRST  ),
    .SECOND ( SECOND ),
    .THIRD  ( THIRD  ),
    .FOURTH ( FOURTH ),
    .FIFTH  ( FIFTH  ))
 u_fsm (
    .restart                 ( restart           ),
    .clk                     ( clk               ),
    .rst                     ( rst               ),
    .pause                   ( pause             ),
    .goto_third              ( goto_third        ),

    .out1                    ( out1        [2:0] ),
    .out2                    ( out2        [2:0] ),
    .even                    ( even              ),
    .odd                     ( odd               ),
    .terminal                ( terminal          )
);

initial
begin
    rst = 1;
    #10;
    rst = 0;
    restart = 0;
    pause = 0;
    assert (u_fsm.state == FIRST) ;
    #10;
    assert (u_fsm.state == SECOND);
    pause = 1;
    #30;
    assert (u_fsm.state == SECOND);
    pause = 0;
    #10;
    assert (u_fsm.state == THIRD);
    #10;
    assert (u_fsm.state == FOURTH);
    restart = 1;
    #10;
    restart = 0;
    assert (u_fsm.state == FIRST);
    #10;
    #10;
    #10;
    assert (u_fsm.state == FOURTH);
    #10;
    assert (u_fsm.state == FIFTH);
    goto_third = 1;
    #10;
    goto_third = 0;
    assert (u_fsm.state == THIRD);
    #100;
    assert (u_fsm.state == FIFTH);

    $stop;
end

endmodule
