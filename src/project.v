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

  // 64個の乗算器を定義
  wire [7:0] multiply1, multiply2, multiply3, multiply4, multiply5, multiply6, multiply7, multiply8, 
             multiply9, multiply10, multiply11, multiply12, multiply13, multiply14, multiply15, multiply16,
             multiply17, multiply18, multiply19, multiply20, multiply21, multiply22, multiply23, multiply24,
             multiply25, multiply26, multiply27, multiply28, multiply29, multiply30, multiply31, multiply32,
             multiply33, multiply34, multiply35, multiply36, multiply37, multiply38, multiply39, multiply40,
             multiply41, multiply42, multiply43, multiply44, multiply45, multiply46, multiply47, multiply48,
             multiply49, multiply50, multiply51, multiply52, multiply53, multiply54, multiply55, multiply56,
             multiply57, multiply58, multiply59, multiply60, multiply61, multiply62, multiply63, multiply64;

  // より複雑な積和演算パターンを実装
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
  assign multiply17 = in1 * in2;
  assign multiply18 = in1 * in2;
  assign multiply19 = in1 * in2;
  assign multiply20 = in1 * in2;
  assign multiply21 = in1 * in2;
  assign multiply22 = in1 * in2;
  assign multiply23 = in1 * in2;
  assign multiply24 = in1 * in2;
  assign multiply25 = in1 * in2;
  assign multiply26 = in1 * in2;
  assign multiply27 = in1 * in2;
  assign multiply28 = in1 * in2;
  assign multiply29 = in1 * in2;
  assign multiply30 = in1 * in2;
  assign multiply31 = in1 * in2;
  assign multiply32 = in1 * in2;
  assign multiply33 = in1 * in2;
  assign multiply34 = in1 * in2;
  assign multiply35 = in1 * in2;
  assign multiply36 = in1 * in2;
  assign multiply37 = in1 * in2;
  assign multiply38 = in1 * in2;
  assign multiply39 = in1 * in2;
  assign multiply40 = in1 * in2;
  assign multiply41 = in1 * in2;
  assign multiply42 = in1 * in2;
  assign multiply43 = in1 * in2;
  assign multiply44 = in1 * in2;
  assign multiply45 = in1 * in2;
  assign multiply46 = in1 * in2;
  assign multiply47 = in1 * in2;
  assign multiply48 = in1 * in2;
  assign multiply49 = in1 * in2;
  assign multiply50 = in1 * in2;
  assign multiply51 = in1 * in2;
  assign multiply52 = in1 * in2;
  assign multiply53 = in1 * in2;
  assign multiply54 = in1 * in2;
  assign multiply55 = in1 * in2;
  assign multiply56 = in1 * in2;
  assign multiply57 = in1 * in2;
  assign multiply58 = in1 * in2;
  assign multiply59 = in1 * in2;
  assign multiply60 = in1 * in2;
  assign multiply61 = in1 * in2;
  assign multiply62 = in1 * in2;
  assign multiply63 = in1 * in2;
  assign multiply64 = in1 * in2;
  // 第1レベルの加算（64個 → 32個）
  wire [7:0] sum11, sum12, sum13, sum14, sum15, sum16, sum17, sum18,
             sum19, sum110, sum111, sum112, sum113, sum114, sum115, sum116,
             sum117, sum118, sum119, sum120, sum121, sum122, sum123, sum124,
             sum125, sum126, sum127, sum128, sum129, sum130, sum131, sum132;
  assign sum11 = multiply1 + multiply2;
  assign sum12 = multiply3 + multiply4;
  assign sum13 = multiply5 + multiply6;
  assign sum14 = multiply7 + multiply8;
  assign sum15 = multiply9 + multiply10;
  assign sum16 = multiply11 + multiply12;
  assign sum17 = multiply13 + multiply14;
  assign sum18 = multiply15 + multiply16;
  assign sum19 = multiply17 + multiply18;
  assign sum110 = multiply19 + multiply20;
  assign sum111 = multiply21 + multiply22;
  assign sum112 = multiply23 + multiply24;
  assign sum113 = multiply25 + multiply26;
  assign sum114 = multiply27 + multiply28;
  assign sum115 = multiply29 + multiply30;
  assign sum116 = multiply31 + multiply32;
  assign sum117 = multiply33 + multiply34;
  assign sum118 = multiply35 + multiply36;
  assign sum119 = multiply37 + multiply38;
  assign sum120 = multiply39 + multiply40;
  assign sum121 = multiply41 + multiply42;
  assign sum122 = multiply43 + multiply44;
  assign sum123 = multiply45 + multiply46;
  assign sum124 = multiply47 + multiply48;
  assign sum125 = multiply49 + multiply50;
  assign sum126 = multiply51 + multiply52;
  assign sum127 = multiply53 + multiply54;
  assign sum128 = multiply55 + multiply56;
  assign sum129 = multiply57 + multiply58;
  assign sum130 = multiply59 + multiply60;
  assign sum131 = multiply61 + multiply62;
  assign sum132 = multiply63 + multiply64;
  // 第2レベルの加算（32個 → 16個）
  wire [7:0] sum21, sum22, sum23, sum24, sum25, sum26, sum27, sum28,
             sum29, sum210, sum211, sum212, sum213, sum214, sum215, sum216;
  assign sum21 = sum11 + sum12;
  assign sum22 = sum13 + sum14;
  assign sum23 = sum15 + sum16;
  assign sum24 = sum17 + sum18;
  assign sum25 = sum19 + sum110;
  assign sum26 = sum111 + sum112;
  assign sum27 = sum113 + sum114;
  assign sum28 = sum115 + sum116;
  assign sum29 = sum117 + sum118;
  assign sum210 = sum119 + sum120;
  assign sum211 = sum121 + sum122;
  assign sum212 = sum123 + sum124;
  assign sum213 = sum125 + sum126;
  assign sum214 = sum127 + sum128;
  assign sum215 = sum129 + sum130;
  assign sum216 = sum131 + sum132;
  // 第3レベルの加算（16個 → 8個）
  wire [7:0] sum31, sum32, sum33, sum34, sum35, sum36, sum37, sum38;
  assign sum31 = sum21 + sum22;
  assign sum32 = sum23 + sum24;
  assign sum33 = sum25 + sum26;
  assign sum34 = sum27 + sum28;
  assign sum35 = sum29 + sum210;
  assign sum36 = sum211 + sum212;
  assign sum37 = sum213 + sum214;
  assign sum38 = sum215 + sum216;
  // 第4レベルの加算（8個 → 4個）
  wire [7:0] sum41, sum42, sum43, sum44;
  assign sum41 = sum31 + sum32;
  assign sum42 = sum33 + sum34;
  assign sum43 = sum35 + sum36;
  assign sum44 = sum37 + sum38;

  // 第5レベルの加算（4個 → 2個）
  wire [7:0] sum51, sum52;
  assign sum51 = sum41 + sum42;
  assign sum52 = sum43 + sum44;

  // 最終レベルの加算（2個 → 1個）
  wire [7:0] sum_final;
  assign sum_final = sum51 + sum52;
  assign uo_out = sum_final;



  assign uio_out = 0;
  assign uio_oe  = 0;

  // List all unused inputs to prevent warnings
  wire _unused = &{ena, clk, rst_n, 1'b0};

endmodule
