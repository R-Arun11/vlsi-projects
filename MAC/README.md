# 4×4 Pipelined Wallace Tree Multiplier

## Project Overview

This project implements a 4-bit by 4-bit Wallace Tree Multiplier using Verilog HDL. The design features a Full Adder and Half Adder based Wallace reduction stage, followed by a Carry Lookahead Adder (CLA) for the final addition. The multiplier is pipelined for improved performance at the cost of latency. The project was simulated and verified using ModelSim.

The Wallace Tree architecture is well known for its high speed multiplication, especially suitable for digital signal processing (DSP) and arithmetic heavy applications.

---

## Features

- **Inputs:**  
  - `a [3:0]`: 4-bit multiplicand  
  - `b [3:0]`: 4-bit multiplier  

- **Output:**  
  - `prod [7:0]`: 8-bit product  

- **Design Highlights:**  
  - Full Adder and Half Adder based product reduction  
  - Final stage 8-bit CLA  
  - Three stage pipelined architecture   
  - Fully synthesized and simulated in ModelSim

---

## Output

### ✅ **Console Output (Simulation)**

