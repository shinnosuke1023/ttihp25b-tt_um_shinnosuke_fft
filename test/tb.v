`default_nettype none
`timescale 1ns / 1ps

/* This testbench just instantiates the module and makes some convenient wires
   that can be driven / tested by the cocotb test.py.
*/
module tb ();

  // Dump the signals to a VCD file. You can view it with gtkwave or surfer.
  initial begin
    $dumpfile("tb.vcd");
    $dumpvars(0, tb);
    #1;
  end

  // Wire up the inputs and outputs:
  reg clk;
  reg rst_n;
  reg ena;
  reg [7:0] ui_in;
  reg [7:0] uio_in;
  wire [7:0] uo_out;
  wire [7:0] uio_out;
  wire [7:0] uio_oe;

  // Replace tt_um_example with your module name:
  tt_um_shinnosuke_fft user_project (
      .ui_in  (ui_in),    // Dedicated inputs
      .uo_out (uo_out),   // Dedicated outputs
      .uio_in (uio_in),   // IOs: Input path
      .uio_out(uio_out),  // IOs: Output path
      .uio_oe (uio_oe),   // IOs: Enable path (active high: 0=input, 1=output)
      .ena    (ena),      // enable - goes high when design is selected
      .clk    (clk),      // clock
      .rst_n  (rst_n)     // not reset
  );

  initial begin
    // Initialize inputs
    clk = 0;
    rst_n = 0;
    ena = 0;
    ui_in = 8'h00;
    uio_in = 8'h00;

    // Release reset
    #10 rst_n = 1;

    // Enable the design
    #10 ena = 1;

    // Apply some test inputs
    #10 ui_in = 8'b01101100; // Example input

    #10;
    // Check outputs
    $display("uo_out: %b, uio_out: %b, uio_oe: %b", uo_out, uio_out, uio_oe);

    // Change inputs
    #10 ui_in = 8'b11001100; // Another example input
    #10;
    // Check outputs again
    $display("uo_out: %b, uio_out: %b, uio_oe: %b", uo_out, uio_out, uio_oe);

    // Finish simulation
    #100;
    $finish;
  end


endmodule
