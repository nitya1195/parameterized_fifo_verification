/ testbench.sv
module tb;

    // DUT ports
    reg clk = 0;
    reg rst = 1;
    reg wr_en;
    reg rd_en;
    reg [7:0] din;
    wire [7:0] dout;
    wire full, empty, almost_full, almost_empty;

    // Instantiate parameterized FIFO (DEPTH=8, WIDTH=8, ALMOST=2)
    fifo #(8,8,2) dut (
        .clk(clk),
        .rst(rst),
        .wr_en(wr_en),
        .rd_en(rd_en),
        .din(din),
        .dout(dout),
        .full(full),
        .empty(empty),
        .almost_full(almost_full),
        .almost_empty(almost_empty)
    );

    // Clock generation
    always #5 clk = ~clk;

    // VCD dump
    initial begin
        $dumpfile("fifo.vcd");
        $dumpvars(0, tb);
    end

    // --------------------------------------------------------------
    // Coverage variables (declared as static, initialized cleanly → no warnings)
    // --------------------------------------------------------------
    static reg [7:0] count_covered;
    static reg [3:0] status_covered;

    initial begin
        count_covered  = 8'b0;
        status_covered = 4'b0;
    end

    // --------------------------------------------------------------
    // Sample coverage on every clock edge (after reset is de-asserted)
    // --------------------------------------------------------------
    always @(posedge clk) begin
        if (!rst) begin
            count_covered[dut.count] = 1'b1;                                          // covers 0 to 8
            status_covered = status_covered | {full, empty, almost_full, almost_empty};
        end
    end

    // --------------------------------------------------------------
    // Main stimulus
    // --------------------------------------------------------------
    initial begin
        $display("=== Parameterized FIFO Verification (8x8) ===");

        // Reset pulse
        rst = 1;
        #15 rst = 0;

        // Random read/write for good mixing
        repeat(500) begin
            wr_en = $random;
            rd_en = $random;
            din   = $random;
            #10;
        end

        // Force full condition to guarantee full & almost_full are hit
        $display("Forcing full condition to hit full & almost_full flags...");
        wr_en = 1;
        rd_en = 0;
        repeat(15) #10;

        #100;

        $display("Final count = %0d", dut.count);

        // --------------------- Coverage Report ---------------------
        begin
            integer i, covered_cnt = 0, covered_stat = 0;
            real pct_cnt, pct_stat;

            for (i = 0; i < 8; i = i + 1)
                if (count_covered[i]) covered_cnt++;

            if (status_covered[3]) covered_stat++; // full
            if (status_covered[2]) covered_stat++; // empty
            if (status_covered[1]) covered_stat++; // almost_full
            if (status_covered[0]) covered_stat++; // almost_empty

            pct_cnt  = (covered_cnt * 100.0) / 8;
            pct_stat = (covered_stat * 100.0) / 4;

            $display("Count Coverage   : %0d/8  (%.2f%%)", covered_cnt, pct_cnt);
            $display("Status Coverage  : %0d/4  (%.2f%%)", covered_stat, pct_stat);
            $display("TOTAL COVERAGE   : %.2f%%", (pct_cnt + pct_stat)/2);
        end

        $finish;
    end

    // Optional monitor (nice to see activity)
    initial $monitor("t=%0t | wr=%b rd=%b | count=%0d | full=%b empty=%b af=%b ae=%b",
                     $time, wr_en, rd_en, dut.count, full, empty, almost_full, almost_empty);

endmodule
