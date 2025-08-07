import pandas as pd

# Load CSV
csv_file = "crc16_scan_output.csv"
df = pd.read_csv(csv_file)

# Output STIL file
stil_file = "crc16_scan_output.stil"

with open(stil_file, "w") as f:
    f.write("STIL 1.0;\n\n")

    # Signals
    f.write("Signals {\n")
    f.write("  clk, reset, enable, scan_en, scan_in, scan_out;\n")
    f.write("};\n\n")

    # Waveform table
    f.write("WaveformTable basic_wave {\n")
    f.write("  Period 10000;\n\n")
    f.write("  Waveforms {\n")
    f.write("    \"W1\" {\n")
    f.write("      clk     : P P;\n")
    f.write("      reset   : L;\n")
    f.write("      enable  : L;\n")
    f.write("      scan_en : H;\n")
    f.write("      scan_in : X;\n")
    f.write("      scan_out: C;\n")
    f.write("    }\n")
    f.write("  }\n")
    f.write("}\n\n")

    # Patterns
    f.write("Pattern Scan_Chain_Readout {\n")
    f.write("  WaveformTable basic_wave;\n\n")
    f.write("  PatternBurst {\n")

    for _, row in df.iterrows():
        scan_out = str(row['ScanOut']) if pd.notna(row['ScanOut']) else "X"
        f.write("    V {\n")
        f.write("      clk     = L;\n")
        f.write("      reset   = L;\n")
        f.write("      enable  = L;\n")
        f.write("      scan_en = H;\n")
        f.write("      scan_in = 0;\n")
        f.write(f"      scan_out = {scan_out};\n")
        f.write("    };\n")

    f.write("  }\n")
    f.write("}\n")

print(f"✅ STIL file generated as: {stil_file}")
