
module test(input Clock_1Hz, output[7:0] LEDR_Shift);
reg shift_left;
reg [7:0] LED;
assign LEDR_Shift = LED;
always @(posedge Clock_1Hz) 
begin
    casex ({shift_left, LED[7], LED[0]})
      3'b110:{shift_left, LED} <= {1'b0, 8'b01000000};
      3'b001:{shift_left, LED} <= {1'b1, 8'b00000010};
      3'b1xx: {shift_left, LED} <= {shift_left, LED << 1};
      3'b0xx:{shift_left, LED} <= {shift_left, LED >> 1};
      3'bxxx:{shift_left, LED} <= {1'b0, 8'b00000001};
      default: {shift_left, LED} <= {1'b1, {7{1'b0}}, 1'b1};
    endcase
end



endmodule