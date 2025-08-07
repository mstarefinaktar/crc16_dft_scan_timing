`timescale 1ns / 1ps

module crc16_scan (
    input wire clk,
    input wire reset,
    input wire enable,
    input wire scan_en,
    input wire scan_in,
    output wire scan_out,
    input wire [15:0] data_in,
    output reg [15:0] crc_out
);

    reg [15:0] crc_reg;

    integer i;

    // Scan chain logic: shift register for scan access
    reg [15:0] scan_chain;

    assign scan_out = scan_chain[15];  // MSB out

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            crc_reg <= 16'hFFFF;
            scan_chain <= 16'b0;
        end else if (scan_en) begin
            scan_chain <= {scan_chain[14:0], scan_in};
        end else if (enable) begin
            // CRC computation
            crc_reg <= crc_reg;
            for (i = 0; i < 16; i = i + 1) begin
                if ((data_in[i] ^ crc_reg[15]) == 1'b1)
                    crc_reg <= {crc_reg[14:0], 1'b0} ^ 16'h1021;
                else
                    crc_reg <= {crc_reg[14:0], 1'b0};
            end
            scan_chain <= crc_reg;  // Load CRC value into scan chain
        end
    end

    always @(*) begin
        crc_out = crc_reg;
    end

endmodule
