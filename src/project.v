/*
 * Copyright (c) 2024 Your Name
 * SPDX-License-Identifier: Apache-2.0
 */

`default_nettype none

module tt_um_shinnosuke_fft (
    input  wire [7:0] ui_in,    // Dedicated inputs
    output wire [7:0] uo_out,   // Dedicated outputs
    input  wire [7:0] uio_in,   // IOs: Input path
    output wire [7:0] uio_out,  // IOs: Output path
    output wire [7:0] uio_oe,   // IOs: Enable path (active high: 0=input, 1=output)
    input  wire       ena,      // always 1 when the design is powered, so you can ignore it
    input  wire       clk,      // clock
    input  wire       rst_n     // reset_n - low to reset
);

  // All output pins must be assigned. If not used, assign to 0.
  assign uo_out  = ui_in + uio_in;  // Example: ou_out is the sum of ui_in and uio_in
  
  parameter WIDTH = 10000;

  reg [WIDTH-1:0] shift_reg0;
  reg [WIDTH-1:0] shift_reg1;
  reg [WIDTH-1:0] shift_reg2;

  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      shift_reg0 <= {{WIDTH{1'b0}}}; // Reset shift register to 0
      shift_reg1 <= {{WIDTH{1'b0}}};
    end else if (ena) begin
      shift_reg0 <= {shift_reg0[WIDTH-2:8], ui_in}; // Shift in ui_in
      shift_reg1 <= {shift_reg1[WIDTH-2:8], uio_in}; // Shift in uio_in
      shift_reg2 <= shift_reg0 * shift_reg1; // Example operation: sum of two shift registers
    end
  end


  assign uio_out = 0;
  assign uio_oe  = 0;

  // List all unused inputs to prevent warnings
  // wire _unused = &{ena, clk, rst_n, 1'b0};

endmodule
