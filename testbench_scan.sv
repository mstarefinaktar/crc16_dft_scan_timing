`timescale 1ns / 1ps

module testbench_scan;

    reg clk = 0;
    reg reset = 1;
    reg enable = 0;
    reg scan_en = 0;
    reg scan_in = 0;
    wire scan_out;
    reg [15:0] data_in;
    wire [15:0] crc_out;

    integer csv;

    // Instantiate the DUT
    crc16_scan uut (
        .clk(clk),
        .reset(reset),
        .enable(enable),
        .scan_en(scan_en),
        .scan_in(scan_in),
        .scan_out(scan_out),
        .data_in(data_in),
        .crc_out(crc_out)
    );

    // Clock generation
    always #5 clk = ~clk;

    initial begin
        $dumpfile("dump.vcd");
        $dumpvars(0, testbench_scan);

        csv = $fopen("crc_scan_output.csv", "w");
        $fwrite(csv, "Time_ns,Data_in,CRC_out,ScanOut\n");

        #10 reset = 0;

        // Apply normal CRC input
        apply_input(16'hA5A5);
        apply_input(16'h1234);

        // Enable scan mode and shift out CRC internal register
        scan_chain_read();

        #50 $fclose(csv);
        #10 $finish;
    end

    // Apply input with enable pulse
    task apply_input(input [15:0] din);
        begin
            @(negedge clk);
            data_in = din;
            enable = 1;
            @(negedge clk);
            enable = 0;
            $fwrite(csv, "%0t,%h,%h,%b\n", $time, data_in, crc_out, scan_out);
        end
    endtask

    // Read CRC register via scan chain (MSB first)
    task scan_chain_read;
        integer i;
        begin
            scan_en = 1;
            for (i = 0; i < 16; i = i + 1) begin
                @(negedge clk);
                scan_in = 0;  // input not used, just shifting out
                $fwrite(csv, "%0t,,,%b\n", $time, scan_out);
            end
            scan_en = 0;
        end
    endtask

endmodule
