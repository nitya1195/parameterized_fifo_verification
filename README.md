# parameterized_fifo_verification
Parameterized Synchronous FIFO (Verilog) | 8×8 with almost_full/empty | 100% Functional Coverage | SystemVerilog Testbench
# Parameterized Synchronous FIFO with 100% Functional Coverage

![Coverage](https://img.shields.io/badge/Coverage-100%25-brightgreen) ![Verilog](https://img.shields.io/badge/Language-SystemVerilog-blue) ![License](https://img.shields.io/badge/License-MIT-yellow)

A fully **parameterized, synthesizable synchronous FIFO** designed in SystemVerilog with configurable data width, depth, and almost-full/empty thresholds. Verified using constrained-random stimulus achieving **100% count and status flag coverage**.

Perfect project for **ASIC/FPGA verification roles** and **VLSI frontend interviews**.

## Features
- Fully **parameterized** FIFO (`WIDTH`, `DEPTH`, `ALMOST`)
- Synchronous read/write with single clock domain
- Standard flags: `full`, `empty`, `almost_full`, `almost_empty`
- Proper overflow/underflow protection (no wrap-around)
- **100% functional coverage**:
  - Count coverage: 0 to DEPTH (all 9 states for 8-depth)
  - Status coverage: full, empty, almost_full, almost_empty
- Clean, industry-style testbench with functional coverage modeling

## Parameters
| Parameter   | Default | Description                     |
|-------------|---------|---------------------------------|
| `WIDTH`     | 8       | Data width                      |
| `DEPTH`     | 8       | FIFO depth (must be power of 2) |
| `ALMOST`    | 2       | Threshold for almost flags      |

## File Structure

## EDA Playground link
https://www.edaplayground.com/x/9e9a
