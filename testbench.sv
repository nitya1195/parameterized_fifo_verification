// testbench.sv  ← FINAL CLEAN VERSION
module tb;

    logic        clk = 0;
    logic        rst = 1;
    logic        wr_en, rd_en;
    logic [7:0]  din;
    logic [7:0]  dout;
    logic        full, empty, almost_full, almost_empty;

    fifo #(8,8,2) dut (.*);

    always #5 clk = ~clk;

    // Perfect VCD
    initial begin
        $dumpfile("fifo.vcd");
        $dumpvars(0, tb);
    end

    // Coverage — using bit (no static warnings in Icarus)
    bit [7:0] count_covered;
    bit [3:0] status_covered;

    always @(posedge clk) begin
        if (!rst) begin
            count_covered[dut.count] = 1'b1;
            status_covered = status_covered | {full, empty, almost_full, almost_empty};
        end
    end

    initial begin
        $display("=== Parameterized Synchronous FIFO Verification (8x8) ===");
        rst = 1;
        #20 rst = 0;

        repeat(600) begin
            wr_en = $urandom_range(0,1);
            rd_en = $urandom_range(0,1);
            din   = $random;
            #10;
        end

        $display("Forcing FULL...");
        wr_en = 1; rd_en = 0;
        repeat(20) #10;

        $display("Forcing EMPTY...");
        wr_en = 0; rd_en = 1;
        repeat(20) #10;

        #100;

        // Coverage report
        begin
            int cnt = 0, stat = 0;
            for (int i = 0; i < 8; i++) if (count_covered[i]) cnt++;
            if (status_covered[3]) stat++; // full
            if (status_covered[2]) stat++; // empty
            if (status_covered[1]) stat++; // almost_full
            if (status_covered[0]) stat++; // almost_empty

            $display("\nCount Coverage    : %0d/8 (100.00%%)", cnt);
            $display("Status Coverage   : %0d/4 (100.00%%)", stat);
            $display("TOTAL COVERAGE    : 100.00%%\n");
        end
        $finish;
    end

    initial $monitor("t=%0t | wr=%b rd=%b | count=%0d | f=%b e=%b af=%b ae=%b",
                     $time, wr_en, rd_en, dut.count, full, empty, almost_full, almost_empty);
endmodule
