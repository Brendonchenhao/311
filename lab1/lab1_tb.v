`timescale  1ns / 1ps

module tb_test;

// test Parameters
parameter PERIOD  = 10;


// test Inputs
reg clk = 0 ;
wire [7:0] LEDR_Shift;
// test Outputs

initial
begin
    forever #(PERIOD/2)  clk=~clk;
end

test  dut (
    .Clock_1Hz( clk   ),
    .LEDR_Shift (LEDR_Shift)
);

initial
begin
    

    #(PERIOD);

     #(PERIOD);
      #(PERIOD);
       #(PERIOD);
        #(PERIOD);

         #(PERIOD);
          #(PERIOD);
           #(PERIOD);
    #(PERIOD);
    #(PERIOD);
    #(PERIOD);
    #(PERIOD);
    #(PERIOD);
    #(PERIOD);
        #(PERIOD);
    #(PERIOD);
    #(PERIOD);
    #(PERIOD);
    #(PERIOD);
    #(PERIOD);    #(PERIOD);
    #(PERIOD);
    #(PERIOD);
    #(PERIOD);
    #(PERIOD);
    #(PERIOD);    #(PERIOD);
    #(PERIOD);
    #(PERIOD);
    #(PERIOD);
    #(PERIOD);
    #(PERIOD);    #(PERIOD);
    #(PERIOD);
    #(PERIOD);
    #(PERIOD);
    #(PERIOD);
    #(PERIOD);

    $stop;
end


endmodule