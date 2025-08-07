# crc16_dft_scan_timing

# 🔍 crc16_dft_scan_timing (Verilog + STIL)

This project demonstrates how to **add scan chain logic** to a 16-bit CRC (Cyclic Redundancy Check) circuit for **observability of internal states** using **DFT (Design for Testability)** techniques. The scan chain is used to shift out CRC register bits after data processing, enabling external testers to validate intermediate results and debug hardware.

---

## 📁 Project Structure

```

├── crc16\_scan.v               # Design: CRC16 with scan chain output
├── testbench\_scan.sv          # Testbench: applies inputs and shifts out CRC bits via scan
├── scan\_crc16.csv             # Output: time-stamped CRC values and scan\_out bits
├── csv\_to\_stil\_scan.py        # Python: converts CSV to STIL pattern file
├── scan\_crc16.stil            # Final STIL file for ATE pattern application
├── waveform.png               # Screenshot of GTKWave simulation
└── README.md                  # Project documentation

````

---

## 🧪 Simulation Flow

1. **Run the testbench:**

```bash
iverilog -g2012 crc16_scan.v testbench_scan.sv
vvp a.out
````

2. **View waveform with GTKWave (optional):**

```bash
gtkwave dump.vcd
```

3. **CSV output:**

```
Time_ns,Data_in,CRC_out,ScanOut
20000,A5A5,FFFE,1
40000,1234,EFDD,1
...
```

4. **Convert to STIL:**

```bash
python csv_to_stil_scan.py scan_crc16.csv scan_crc16.stil
```

---

## 📷 Waveform (GTKWAVE View)

Below is the waveform showing scan chain readout of internal CRC register bits using GTKWave:

![CRC SCAN](./crc_scan.PNG)

The `scan_en` signal is asserted high to shift out internal CRC bits.

The `scan_out` line shows the serialized CRC register output, one bit per cycle.

This provides **observability** into the CRC internals for DFT/debug purposes.


---


## 🔧 Key Features

* **Scan chain readout** of CRC register (1-bit shift at a time)
* Verilog/SystemVerilog implementation
* Time-stamped waveform + CSV logging
* STIL pattern generation for ATE usage
* Clean automation pipeline from RTL → STIL

---

## 🎯 Use Cases

* ✔️ DFT insertion and validation
* ✔️ Internal register observability
* ✔️ ATE pattern development for scan-based designs
* ✔️ Educational projects on scan chain and CRC logic

---

## 📎 Related Projects

* 🔗 [CRC16 Fault Injection](https://github.com/mstarefinaktar/crc16_fault_injection)
* 🔗 [CRC16 Fault Sweep](https://github.com/mstarefinaktar/crc16_fault_sweep)

---

## 📄 License

MIT License – Free to use in academic, research, or commercial projects with attribution.

