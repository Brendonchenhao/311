module question_7(input async_sig, input outclk, output out_sync_sig);
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