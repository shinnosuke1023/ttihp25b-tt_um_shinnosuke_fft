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
  // assign uo_out  = ui_in + uio_in;  // Example: ou_out is the sum of ui_in and uio_in
  wire [3:0] in1, in2;
  assign in1 = ui_in[3:0];
  assign in2 = ui_in[7:4];

  wire [7:0] multiply1, multiply2, multiply3, multiply4, multiply5, multiply6, multiply7, multiply8, multiply9, multiply10, 
             multiply11, multiply12, multiply13, multiply14, multiply15, multiply16;
  assign multiply1 = in1 * in2;
  assign multiply2 = in1 * in2;
  assign multiply3 = in1 * in2;
  assign multiply4 = in1 * in2;
  assign multiply5 = in1 * in2;
  assign multiply6 = in1 * in2;
  assign multiply7 = in1 * in2;
  assign multiply8 = in1 * in2;
  assign multiply9 = in1 * in2;
  assign multiply10 = in1 * in2;
  assign multiply11 = in1 * in2;
  assign multiply12 = in1 * in2;
  assign multiply13 = in1 * in2;
  assign multiply14 = in1 * in2;
  assign multiply15 = in1 * in2;
  assign multiply16 = in1 * in2;
  wire [7:0] sum11, sum12, sum13, sum14, sum15, sum16, sum17, sum18;
  assign sum11 = multiply1 + multiply2;
  assign sum12 = multiply3 + multiply4;
  assign sum13 = multiply5 + multiply6;
  assign sum14 = multiply7 + multiply8;
  assign sum15 = multiply9 + multiply10;
  assign sum16 = multiply11 + multiply12;
  assign sum17 = multiply13 + multiply14;
  assign sum18 = multiply15 + multiply16;
  wire [7:0] sum21, sum22, sum23, sum24;
  assign sum21 = sum11 + sum12;
  assign sum22 = sum13 + sum14;
  assign sum23 = sum15 + sum16;
  assign sum24 = sum17 + sum18;
  wire [7:0] sum31, sum32;
  assign sum31 = sum21 + sum22;
  assign sum32 = sum23 + sum24;
  wire [7:0] sum41;
  assign sum41 = sum31 + sum32;
  assign uo_out = sum41;


  parameter WIDTH = 10000;

  reg [WIDTH-1:0] shift_reg;

  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      shift_reg <= {{WIDTH{1'b0}}}; // Reset the shift register to all zeros
    end else if (ena) begin
      shift_reg <= {shift_reg[WIDTH-2:0], ui_in}; // Shift in the ui_in value
    end
  end


  assign uio_out = 0;
  assign uio_oe  = 0;

  // List all unused inputs to prevent warnings
  // wire _unused = &{ena, clk, rst_n, 1'b0};

endmodule
