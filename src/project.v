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

  // 128個の乗算器を定義
  wire [7:0] multiply1, multiply2, multiply3, multiply4, multiply5, multiply6, multiply7, multiply8, 
             multiply9, multiply10, multiply11, multiply12, multiply13, multiply14, multiply15, multiply16,
             multiply17, multiply18, multiply19, multiply20, multiply21, multiply22, multiply23, multiply24,
             multiply25, multiply26, multiply27, multiply28, multiply29, multiply30, multiply31, multiply32,
             multiply33, multiply34, multiply35, multiply36, multiply37, multiply38, multiply39, multiply40,
             multiply41, multiply42, multiply43, multiply44, multiply45, multiply46, multiply47, multiply48,
             multiply49, multiply50, multiply51, multiply52, multiply53, multiply54, multiply55, multiply56,
             multiply57, multiply58, multiply59, multiply60, multiply61, multiply62, multiply63, multiply64,
             multiply65, multiply66, multiply67, multiply68, multiply69, multiply70, multiply71, multiply72,
             multiply73, multiply74, multiply75, multiply76, multiply77, multiply78, multiply79, multiply80,
             multiply81, multiply82, multiply83, multiply84, multiply85, multiply86, multiply87, multiply88,
             multiply89, multiply90, multiply91, multiply92, multiply93, multiply94, multiply95, multiply96,
             multiply97, multiply98, multiply99, multiply100, multiply101, multiply102, multiply103, multiply104,
             multiply105, multiply106, multiply107, multiply108, multiply109, multiply110, multiply111, multiply112,
             multiply113, multiply114, multiply115, multiply116, multiply117, multiply118, multiply119, multiply120,
             multiply121, multiply122, multiply123, multiply124, multiply125, multiply126, multiply127, multiply128;

  // より複雑な積和演算パターンを実装（128個の乗算器）
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
  assign multiply65 = in1 * in2;
  assign multiply66 = in1 * in2;
  assign multiply67 = in1 * in2;
  assign multiply68 = in1 * in2;
  assign multiply69 = in1 * in2;
  assign multiply70 = in1 * in2;
  assign multiply71 = in1 * in2;
  assign multiply72 = in1 * in2;
  assign multiply73 = in1 * in2;
  assign multiply74 = in1 * in2;
  assign multiply75 = in1 * in2;
  assign multiply76 = in1 * in2;
  assign multiply77 = in1 * in2;
  assign multiply78 = in1 * in2;
  assign multiply79 = in1 * in2;
  assign multiply80 = in1 * in2;
  assign multiply81 = in1 * in2;
  assign multiply82 = in1 * in2;
  assign multiply83 = in1 * in2;
  assign multiply84 = in1 * in2;
  assign multiply85 = in1 * in2;
  assign multiply86 = in1 * in2;
  assign multiply87 = in1 * in2;
  assign multiply88 = in1 * in2;
  assign multiply89 = in1 * in2;
  assign multiply90 = in1 * in2;
  assign multiply91 = in1 * in2;
  assign multiply92 = in1 * in2;
  assign multiply93 = in1 * in2;
  assign multiply94 = in1 * in2;
  assign multiply95 = in1 * in2;
  assign multiply96 = in1 * in2;
  assign multiply97 = in1 * in2;
  assign multiply98 = in1 * in2;
  assign multiply99 = in1 * in2;
  assign multiply100 = in1 * in2;
  assign multiply101 = in1 * in2;
  assign multiply102 = in1 * in2;
  assign multiply103 = in1 * in2;
  assign multiply104 = in1 * in2;
  assign multiply105 = in1 * in2;
  assign multiply106 = in1 * in2;
  assign multiply107 = in1 * in2;
  assign multiply108 = in1 * in2;
  assign multiply109 = in1 * in2;
  assign multiply110 = in1 * in2;
  assign multiply111 = in1 * in2;
  assign multiply112 = in1 * in2;
  assign multiply113 = in1 * in2;
  assign multiply114 = in1 * in2;
  assign multiply115 = in1 * in2;
  assign multiply116 = in1 * in2;
  assign multiply117 = in1 * in2;
  assign multiply118 = in1 * in2;
  assign multiply119 = in1 * in2;
  assign multiply120 = in1 * in2;
  assign multiply121 = in1 * in2;
  assign multiply122 = in1 * in2;
  assign multiply123 = in1 * in2;
  assign multiply124 = in1 * in2;
  assign multiply125 = in1 * in2;
  assign multiply126 = in1 * in2;
  assign multiply127 = in1 * in2;
  assign multiply128 = in1 * in2;
  // 第1レベルの加算（128個 → 64個）
  wire [7:0] sum11, sum12, sum13, sum14, sum15, sum16, sum17, sum18,
             sum19, sum110, sum111, sum112, sum113, sum114, sum115, sum116,
             sum117, sum118, sum119, sum120, sum121, sum122, sum123, sum124,
             sum125, sum126, sum127, sum128, sum129, sum130, sum131, sum132,
             sum133, sum134, sum135, sum136, sum137, sum138, sum139, sum140,
             sum141, sum142, sum143, sum144, sum145, sum146, sum147, sum148,
             sum149, sum150, sum151, sum152, sum153, sum154, sum155, sum156,
             sum157, sum158, sum159, sum160, sum161, sum162, sum163, sum164;
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
  assign sum133 = multiply65 + multiply66;
  assign sum134 = multiply67 + multiply68;
  assign sum135 = multiply69 + multiply70;
  assign sum136 = multiply71 + multiply72;
  assign sum137 = multiply73 + multiply74;
  assign sum138 = multiply75 + multiply76;
  assign sum139 = multiply77 + multiply78;
  assign sum140 = multiply79 + multiply80;
  assign sum141 = multiply81 + multiply82;
  assign sum142 = multiply83 + multiply84;
  assign sum143 = multiply85 + multiply86;
  assign sum144 = multiply87 + multiply88;
  assign sum145 = multiply89 + multiply90;
  assign sum146 = multiply91 + multiply92;
  assign sum147 = multiply93 + multiply94;
  assign sum148 = multiply95 + multiply96;
  assign sum149 = multiply97 + multiply98;
  assign sum150 = multiply99 + multiply100;
  assign sum151 = multiply101 + multiply102;
  assign sum152 = multiply103 + multiply104;
  assign sum153 = multiply105 + multiply106;
  assign sum154 = multiply107 + multiply108;
  assign sum155 = multiply109 + multiply110;
  assign sum156 = multiply111 + multiply112;
  assign sum157 = multiply113 + multiply114;
  assign sum158 = multiply115 + multiply116;
  assign sum159 = multiply117 + multiply118;
  assign sum160 = multiply119 + multiply120;
  assign sum161 = multiply121 + multiply122;
  assign sum162 = multiply123 + multiply124;
  assign sum163 = multiply125 + multiply126;
  assign sum164 = multiply127 + multiply128;
  // 第2レベルの加算（64個 → 32個）
  wire [7:0] sum21, sum22, sum23, sum24, sum25, sum26, sum27, sum28,
             sum29, sum210, sum211, sum212, sum213, sum214, sum215, sum216,
             sum217, sum218, sum219, sum220, sum221, sum222, sum223, sum224,
             sum225, sum226, sum227, sum228, sum229, sum230, sum231, sum232;
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
  assign sum217 = sum133 + sum134;
  assign sum218 = sum135 + sum136;
  assign sum219 = sum137 + sum138;
  assign sum220 = sum139 + sum140;
  assign sum221 = sum141 + sum142;
  assign sum222 = sum143 + sum144;
  assign sum223 = sum145 + sum146;
  assign sum224 = sum147 + sum148;
  assign sum225 = sum149 + sum150;
  assign sum226 = sum151 + sum152;
  assign sum227 = sum153 + sum154;
  assign sum228 = sum155 + sum156;
  assign sum229 = sum157 + sum158;
  assign sum230 = sum159 + sum160;
  assign sum231 = sum161 + sum162;
  assign sum232 = sum163 + sum164;
  // 第3レベルの加算（32個 → 16個）
  wire [7:0] sum31, sum32, sum33, sum34, sum35, sum36, sum37, sum38,
             sum39, sum310, sum311, sum312, sum313, sum314, sum315, sum316;
  assign sum31 = sum21 + sum22;
  assign sum32 = sum23 + sum24;
  assign sum33 = sum25 + sum26;
  assign sum34 = sum27 + sum28;
  assign sum35 = sum29 + sum210;
  assign sum36 = sum211 + sum212;
  assign sum37 = sum213 + sum214;
  assign sum38 = sum215 + sum216;
  assign sum39 = sum217 + sum218;
  assign sum310 = sum219 + sum220;
  assign sum311 = sum221 + sum222;
  assign sum312 = sum223 + sum224;
  assign sum313 = sum225 + sum226;
  assign sum314 = sum227 + sum228;
  assign sum315 = sum229 + sum230;
  assign sum316 = sum231 + sum232;
  // 第4レベルの加算（16個 → 8個）
  wire [7:0] sum41, sum42, sum43, sum44, sum45, sum46, sum47, sum48;
  assign sum41 = sum31 + sum32;
  assign sum42 = sum33 + sum34;
  assign sum43 = sum35 + sum36;
  assign sum44 = sum37 + sum38;
  assign sum45 = sum39 + sum310;
  assign sum46 = sum311 + sum312;
  assign sum47 = sum313 + sum314;
  assign sum48 = sum315 + sum316;

  // 第5レベルの加算（8個 → 4個）
  wire [7:0] sum51, sum52, sum53, sum54;
  assign sum51 = sum41 + sum42;
  assign sum52 = sum43 + sum44;
  assign sum53 = sum45 + sum46;
  assign sum54 = sum47 + sum48;

  // 第6レベルの加算（4個 → 2個）
  wire [7:0] sum61, sum62;
  assign sum61 = sum51 + sum52;
  assign sum62 = sum53 + sum54;

  // 最終レベルの加算（2個 → 1個）
  wire [7:0] sum_final;
  assign sum_final = sum61 + sum62;
  assign uo_out = sum_final;



  assign uio_out = 0;
  assign uio_oe  = 0;

  // List all unused inputs to prevent warnings
  wire _unused = &{ena, clk, rst_n, 1'b0};

endmodule
