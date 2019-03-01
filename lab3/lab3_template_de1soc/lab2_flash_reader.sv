module lab2_flash_reader(
    input clk,
    input rst_n,
    input pause,
    input direction,
    input restart,
    input [31:0]flash_mem_readdata,
    input flash_mem_readdatavalid,
    input flash_mem_waitrequest,
    output flash_mem_read,
    output [22:0] flash_mem_address,
    output [15:0] sample
);
enum {INIT, WAIT_READ, WAIT} state;
logic [31:0] START_ADDR = 32'b0;
logic [31:0] address;
logic offset, read;
logic [15:0] audio;
assign flash_mem_address = address;
assign sample = audio;
assign flash_mem_read = read;
always_ff @(posedge clk, negedge rst_n) begin
    if (~rst_n)
        begin
            address <= START_ADDR;
            offset <= 1'b0;
            state <= INIT;
        end
    else begin
        case(state)
            INIT: 
                begin
                    // we restart right before reading
                    if (restart) address <= START_ADDR;
                    if (pause) audio <= 16'b0;
                    else
                        begin
                            read <= 1'b1;
                            if (~flash_mem_waitrequest) state <= WAIT_READ;
                        end
                end
            WAIT_READ:
                begin
                    if (flash_mem_readdatavalid)
                        begin
                            read <= 1'b0;
                            state <= INIT;
                            audio <= offset ? flash_mem_readdata[31:16] : flash_mem_readdata[15:0];
                            if (direction & offset)address <= address + 23'b1;
                            else if (~direction & ~offset) address <= address - 23'b1; 
                            offset <= ~offset;
                        end
                end
        endcase
    end
end

endmodule