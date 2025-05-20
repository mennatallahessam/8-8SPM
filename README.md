# Digital Design I Spring 2025
# Project 2: 8x8 bit Signed Serial-Parallel Multiplier


## Students:
* Farida Elanany
* Mahinour Abdelgawad
* Mennatallah Essam

## Link to Block Diagram [here](https://app.diagrams.net/#G1yU9CX1pHeDyyBbw5YY_na6BGPlWHbJZb#%7B%22pageId%22%3A%22zd0p5imB0dmylxvy01kr%22%7D)


## Project Overview

This project implements an 8-bit **signed multiplier** in Verilog. The system accepts two 8-bit signed inputs (`X` and `Y`), computes their product using a **Serial Parallel Multiplier (SPM)** module, and displays the result on a **4-digit 7-segment display** using a scrollable interface.



## Features

- **Serial Parallel Multiplier (SPM):** Multiplies two 8-bit signed numbers.
- **Signed Number Handling:** Detects sign and converts inputs to absolute values for multiplication.
- **Binary to BCD Conversion:** Uses the Double Dabble algorithm to convert the 16-bit product for 7-segment display.
- **7-Segment Display Control:** Displays 3 digits at a time with scrolling capability.
- **Button Debouncing and Detection:** Ensures clean input signals for starting, resetting, and scrolling.
- **Clock Dividers:** Generates slower clocks for debouncing and display multiplexing.


## Project Structure

### `topModule.v`
Main module that integrates all submodules:
- Processes inputs including sign detection and 2's complement conversion
- Controls multiplication start and reset signals
- Instantiates multiplier (`SPM`) and display controller (`ScrollController`)

### `SPM.v`
Sequential parallel multiplier:
- Performs bit-by-bit multiplication over multiple clock cycles
- Outputs 16-bit product and a finish signal when multiplication is done

### `DoubleDabble.v`
Binary to BCD converter:
- Implements the Double Dabble (shift-add-3) algorithm
- Outputs five BCD digits representing the binary product

### `ScrollController.v`
Manages digit scrolling and multiplexing on the 7-segment display:
- Scrolls through result digits using left/right buttons (`BTNL`, `BTNR`)
- Controls digit selection and display timing
- Interfaces with `SevenSegmentDisplayController` for segment driving

### `SevenSegmentDisplayController.v`
Controls the 7-segment displays:
- Drives individual segments and anodes
- Displays digits and the sign indicator (dash) for negative results

### `pushButton_detector.v`
Debounces push buttons and detects rising edges to generate single-cycle pulses.

### `clock_divider.v`
Generates slower clocks required for button debouncing and display refreshing.


## How It Works

1. **Inputs:**  
   User provides two 8-bit inputs `X` and `Y` using the switches on the FPGA board. If any of them is negative, the user provides the 2's complement of the negative value.

2. **Start:**  
   Pressing `BTNC` triggers the multiplication.

3. **Sign Handling:**  
   If either input is negative, the system takes its two’s complement.

4. **Multiplication:**  
   The SPM module computes the product, setting `finish` once complete.

5. **Output Display:**  
   16-bit product is converted into BCD using `DoubleDabble` Scrollable 7-segment output displays the signed product using `ScrollController`.



## Requirements

- Basys3 FPGA board
- Vivado for synthesis, implementation, and bitstream generation.