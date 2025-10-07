# Vending Machine

## Project Overview

This project implements a coin-based Vending Machine using Verilog HDL. The machine accepts coins, allows product selection, returns change, and manages inventory. It uses a Moore Finite State Machine (FSM) architecture for state transitions based on coin inputs, product selection, and cancellation requests.

The vending machine supports three products (`A`, `B`, and `C`) with different prices and provides accurate change return. Each input is synchronized with a clock signal, making it suitable for FPGA or ASIC implementation. The design was tested and simulated using ModelSim.

---

## Features

- **Inputs:**
  - `clk`: System clock  
  - `rst`: Active-high reset  
  - `cancel`: Cancel request — returns remaining balance  
  - `coin_input [1:0]`: Represents coin inserted  
    - `00`: No coin  
    - `01`: ₹5  
    - `10`: ₹10  
  - `product_select [1:0]`: Product selection  
    - `00`: Product A  
    - `01`: Product B  
    - `10`: Product C

- **Outputs:**
  - `dispense_A`: Dispense signal for Product A  
  - `dispense_B`: Dispense signal for Product B  
  - `dispense_C`: Dispense signal for Product C  
  - `change_return [5:0]`: Amount of change returned (in rupees)

- **Product Pricing:**
  - Product A: ₹5  
  - Product B: ₹10  
  - Product C: ₹15

- **Finite State Machine (FSM):**
  - States represent the total value of coins inserted (₹0 to ₹20)
  - Transitions depend on coin input, cancel, and product selection

- **Other Functionalities:**
  - Tracks remaining product inventory (stock management)
  - Handles cancel operation at any time
  - Returns remaining balance as change when cancel is pressed

---

## Output

**Console Output:**

**Waveform Output:**

![Vending Machine Waveform](VMopwave.png)

---

## Contents

- `vending_machine.v` – Verilog RTL code of the vending machine  
- `vending_machine_tb.v` – Verilog testbench simulating different use cases  
- `VMopwave.png` – Screenshot of waveform output from ModelSim  
- `README.md` – This file

