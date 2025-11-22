module fifo #(
    parameter int DEPTH = 8,
    parameter int WIDTH = 8,
    parameter int ALMOST = 2
)(
    input  logic             clk,
    input  logic             rst,
    input  logic             wr_en,
    input  logic             rd_en,
    input  logic [WIDTH-1:0] din,
    output logic [WIDTH-1:0] dout,
    output logic             full,          // ← removed the stray comma before this line
    output logic             empty,
    output logic             almost_full,
    output logic             almost_empty
);

    logic [WIDTH-1:0] mem [0:DEPTH-1];
    logic [$clog2(DEPTH):0] wr_ptr, rd_ptr, count;

    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            wr_ptr <= 0;
            rd_ptr <= 0;
            count  <= 0;
            dout   <= 0;
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
                default: count <= count;
            endcase
        end
    end

    assign full         = (count == DEPTH);
    assign empty        = (count == 0);
    assign almost_full  = (count >= DEPTH - ALMOST);
    assign almost_empty = (count <= ALMOST);

endmodule
