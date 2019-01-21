
module test(input Clock_1Hz, output[7:0] LEDR_Shift);
reg shift_left;
reg [7:0] LED;
reg [2:0] rst_pipe = 3'b11;
wire reset = rst_pipe[2];

assign LEDR_Shift = LED;

always @(posedge Clock_1Hz) 
begin
    rst_pipe <= {rst_pipe, 1'b0};
    if (reset) begin
        {shift_left, LED} <= {1'b0, 8'b00000001};
    end
    else begin
    casex ({shift_left, LED[7], LED[0]})
      3'b110:{shift_left, LED} <= {1'b0, 8'b01000000};
      3'b001:{shift_left, LED} <= {1'b1, 8'b00000010};
      3'b1xx:{shift_left, LED} <= {shift_left, LED << 1};
      3'b0xx:{shift_left, LED} <= {shift_left, LED >> 1};
      default: {shift_left, LED} <= {1'b1, {7{1'b0}}, 1'b1};
    endcase
    end

end



endmodule