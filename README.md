# AMBA APB Protocol Verification Using SystemVerilog

## 📌 Project Overview

This project focuses on the functional verification of the **AMBA Advanced Peripheral Bus (APB) Protocol** using SystemVerilog. The main objective is to verify APB master-slave communication, read/write transactions, protocol timing, and data integrity through simulation.

## 🎯 Project Objectives

- Understand AMBA APB protocol architecture.
- Verify APB read and write transactions.
- Check Setup and Access phases.
- Verify wait-state handling.
- Validate reset functionality.
- Check protocol timing and signal stability.

## 🔧 Protocol Signals

| Signal | Description |
|---|---|
| PCLK | APB Clock |
| PRESETn | Active-low Reset |
| PADDR | Address Bus |
| PSEL | Peripheral Select |
| PENABLE | Enable Signal |
| PWRITE | Read/Write Control |
| PWDATA | Write Data |
| PRDATA | Read Data |
| PREADY | Transfer Ready |
| PSLVERR | Slave Error |

## 🔄 APB Transfer Phases

**1. Setup Phase**
- PSEL is asserted HIGH.
- PENABLE remains LOW.
- Address and control signals are driven.

**2. Access Phase**
- PSEL and PENABLE are asserted HIGH.
- Data transfer takes place.
- Transfer completes when PREADY is HIGH.

## 🧪 Verification Scenarios

- APB Write Transaction
- APB Read Transaction
- Back-to-Back Transactions
- Wait-State Verification
- Reset Verification
- Address and Data Stability Checks
- Consecutive Read/Write Operations

## 📂 Project Directory Structure

```text
AMBA_APB_Protocol/
│
├── RTL/
│   └── apb_slave.sv
│
├── TB/
│   ├── apb_interface.sv
│   ├── apb_testbench.sv
│   └── apb_test.sv
│
├── Simulation/
│
└── README.md
```

*Note: Update filenames and folders according to your actual project structure.*

## 🛠️ Tools & Technologies

- **HDL:** SystemVerilog
- **Protocol:** AMBA APB
- **Simulator:** QuestaSim
- **Verification:** SystemVerilog Testbench and Assertions

## ▶️ Simulation

Run the following commands in QuestaSim:

```tcl
vlib work
vlog -sv *.sv
vsim -voptargs=+acc work.testbench
add wave -r *
run -all
```

*Adjust the compilation command and top module name according to your project files.*

## 📊 Expected Results

- Successful APB read and write operations.
- Correct Setup and Access phase transitions.
- Proper wait-state handling.
- Stable address and control signals.
- Correct reset behavior.
- No unexpected protocol violations.

## 📚 Learning Outcomes

- Practical understanding of AMBA APB protocol.
- SystemVerilog testbench development.
- Protocol-level functional verification.
- Assertion-based verification fundamentals.
- Simulation and waveform debugging.

## 👨‍💻 Author

**Chirag Dalsaniya**

Aspiring Design Verification Engineer | VLSI


