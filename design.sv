// Code your design here
module fifo #(
    parameter DEPTH = 8,
    parameter WIDTH = 8,
    parameter ALMOST = 2
)(
    input clk,
    input rst,
    input wr_en,
    input rd_en,
    input [WIDTH-1:0] din,
    output reg [WIDTH-1:0] dout,
    output full,
    output empty,
    output almost_full,
    output almost_empty
);
    reg [WIDTH-1:0] mem [0:DEPTH-1];
    reg [$clog2(DEPTH):0] wr_ptr, rd_ptr, count;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            wr_ptr <= 0;
            rd_ptr <= 0;
            count <= 0;
            dout <= 0;
        end else begin
            if (wr_en && !full) begin
                mem[wr_ptr[$clog2(DEPTH)-1:0]] <= din;
                wr_ptr <= wr_ptr + 1;
            end
            if (rd_en && !empty) begin
                dout <= mem[rd_ptr[$clog2(DEPTH)-1:0]];
                rd_ptr <= rd_ptr + 1;
            end
            case ({wr_en && !full, rd_en && !empty})
                2'b10: count <= count + 1;
                2'b01: count <= count - 1;
                2'b11: count <= count;
                default: count <= count;
            endcase
        end
    end

    assign full = (count == DEPTH);
    assign empty = (count == 0);
    assign almost_full = (count >= DEPTH - ALMOST);
    assign almost_empty = (count <= ALMOST);

    // Assertions (commented for Icarus)
    // assert property (@(posedge clk) disable iff (rst) !(wr_en && full)) else $error("Overflow!");
    // assert property (@(posedge clk) disable iff (rst) !(rd_en && empty)) else $error("Underflow!");
endmodule
