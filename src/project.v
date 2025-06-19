/*
 * Copyright (c) 2024 Shinnosuke Tahara
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

  // 制御信号の定義
  wire [2:0] cmd = ui_in[7:5];       // コマンド: 000=アイドル, 001=データ入力, 010=FFT実行, 011=データ出力
  wire [5:0] addr = ui_in[5:0];      // アドレス: 0-63の範囲で64点のデータを指定
  wire [7:0] data_in = uio_in;       // 入力データ: 実部と虚部を交互に入力（ui_in[4]=0なら実部、1なら虚部）

  // 状態の定義
  localparam IDLE = 3'b000;
  localparam DATA_INPUT = 3'b001;
  localparam FFT_EXEC = 3'b010;
  localparam DATA_OUTPUT = 3'b011;
  
  reg [2:0] state;
  reg [2:0] next_state;
  
  // FFTデータ保存用のメモリ (64点 x 複素数(実部・虚部))
  reg signed [7:0] data_real [0:63];
  reg signed [7:0] data_imag [0:63];
  
  // FFT計算用の変数
  reg [5:0] fft_stage;       // FFT計算ステージ (0-5: log2(64)=6ステージ)
  reg [5:0] fft_index;       // FFT計算のインデックス
  reg [5:0] butterfly_idx;   // バタフライ演算のインデックス
  reg [5:0] butterfly_size;  // 現在のステージのバタフライサイズ
  
  // 出力変数
  reg [7:0] output_data;
  reg busy;                  // FFT計算中フラグ
  
  // 出力の割り当て
  assign uo_out = output_data;
  assign uio_out = {busy, 7'b0}; // busy信号を出力
  assign uio_oe = 8'hFF;         // すべてのuio_pinを出力として使用
  
  // タブルテーブル (簡易的なバージョン - 固定小数点表現)
  // sin/cos(2πk/64)の値を保持（実際は詳細に計算すべき）
  reg signed [7:0] cos_table [0:31];
  reg signed [7:0] sin_table [0:31];
  
  // テーブル初期化
  integer i;
  initial begin
    // cosテーブルの初期化（例：64点FFT用のcos値）
    cos_table[0] = 8'd127;  cos_table[1] = 8'd126;  cos_table[2] = 8'd122;  cos_table[3] = 8'd117;
    cos_table[4] = 8'd111;  cos_table[5] = 8'd103;  cos_table[6] = 8'd93;   cos_table[7] = 8'd83;
    cos_table[8] = 8'd71;   cos_table[9] = 8'd59;   cos_table[10] = 8'd46;  cos_table[11] = 8'd33;
    cos_table[12] = 8'd19;  cos_table[13] = 8'd6;   cos_table[14] = -8'd7;  cos_table[15] = -8'd20;
    cos_table[16] = -8'd32; cos_table[17] = -8'd45; cos_table[18] = -8'd57; cos_table[19] = -8'd69;
    cos_table[20] = -8'd81; cos_table[21] = -8'd92; cos_table[22] = -8'd102;cos_table[23] = -8'd110;
    cos_table[24] = -8'd116;cos_table[25] = -8'd122;cos_table[26] = -8'd125;cos_table[27] = -8'd127;
    cos_table[28] = -8'd127;cos_table[29] = -8'd125;cos_table[30] = -8'd122;cos_table[31] = -8'd117;
    
    // sinテーブルの初期化（例：64点FFT用のsin値）
    sin_table[0] = 8'd0;    sin_table[1] = -8'd19;  sin_table[2] = -8'd38;  sin_table[3] = -8'd57;
    sin_table[4] = -8'd74;  sin_table[5] = -8'd89;  sin_table[6] = -8'd103; sin_table[7] = -8'd114;
    sin_table[8] = -8'd122; sin_table[9] = -8'd126; sin_table[10] = -8'd127;sin_table[11] = -8'd126;
    sin_table[12] = -8'd121;sin_table[13] = -8'd114;sin_table[14] = -8'd104;sin_table[15] = -8'd91;
    sin_table[16] = -8'd77; sin_table[17] = -8'd60; sin_table[18] = -8'd42; sin_table[19] = -8'd22;
    sin_table[20] = -8'd3;  sin_table[21] = 8'd16;  sin_table[22] = 8'd35;  sin_table[23] = 8'd53;
    sin_table[24] = 8'd70;  sin_table[25] = 8'd86;  sin_table[26] = 8'd100; sin_table[27] = 8'd112;
    sin_table[28] = 8'd121; sin_table[29] = 8'd126; sin_table[30] = 8'd127; sin_table[31] = 8'd126;
    
    // データメモリの初期化
    for (i = 0; i < 64; i = i + 1) begin
      data_real[i] = 0;
      data_imag[i] = 0;
    end
  end

  // ステートマシン - 状態遷移
  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      state <= IDLE;
    end else if (ena) begin
      state <= next_state;
    end
  end
  
  // 次状態ロジック
  always @(*) begin
    case (state)
      IDLE: begin
        if (cmd == DATA_INPUT) next_state = DATA_INPUT;
        else if (cmd == FFT_EXEC) next_state = FFT_EXEC;
        else if (cmd == DATA_OUTPUT) next_state = DATA_OUTPUT;
        else next_state = IDLE;
      end
      DATA_INPUT: begin
        if (cmd == IDLE) next_state = IDLE;
        else next_state = DATA_INPUT;
      end
      FFT_EXEC: begin
        if (fft_stage == 6 && fft_index == 0) next_state = IDLE;
        else next_state = FFT_EXEC;
      end
      DATA_OUTPUT: begin
        if (cmd == IDLE) next_state = IDLE;
        else next_state = DATA_OUTPUT;
      end
      default: next_state = IDLE;
    endcase
  end
  
  // データ入力ロジック
  always @(posedge clk) begin
    if (state == DATA_INPUT) begin
      if (ui_in[4] == 1'b0) begin
        data_real[addr] <= data_in;
      end else begin
        data_imag[addr] <= data_in;
      end
    end
  end
  
  // FFT計算ロジック (バタフライ演算)
  reg signed [15:0] temp_real, temp_imag; // 計算用の一時変数
  reg signed [7:0] twiddle_real, twiddle_imag; // 回転因子
  reg signed [15:0] product1_real, product1_imag, product2_real, product2_imag; // 複素乗算の中間結果
  
  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      busy <= 1'b0;
      fft_stage <= 0;
      fft_index <= 0;
      butterfly_size <= 1;
    end else if (state == FFT_EXEC) begin
      busy <= 1'b1;
      
      // FFTのバタフライ計算
      if (fft_index == 0) begin
        // 新しいステージの開始
        butterfly_idx <= 0;
        if (fft_stage == 0) begin
          // 初期化（ビットリバース順に並べ替え）
          fft_index <= fft_index + 1;
        end else begin
          // バタフライ計算の準備
          butterfly_size <= (1 << fft_stage);
        end
      end else if (butterfly_idx < 32) begin // 64/2 = 32バタフライ
        // 回転因子（Twiddle Factor）の計算
        // k = butterfy_idxを使用して回転因子のインデックスを決定
        // W_N^k = cos(2πk/N) - j*sin(2πk/N)
        if (fft_stage == 1) begin
          // ステージ1（N=2）の回転因子: k=0のみ
          twiddle_real <= cos_table[0]; // cos(0) = 1
          twiddle_imag <= sin_table[0]; // sin(0) = 0
        end else if (fft_stage == 2) begin
          // ステージ2（N=4）の回転因子: k=0,2
          twiddle_real <= (butterfly_idx[0] == 0) ? cos_table[0] : cos_table[16]; // cos(0), cos(π/2)
          twiddle_imag <= (butterfly_idx[0] == 0) ? sin_table[0] : sin_table[16]; // sin(0), sin(π/2)
        end else if (fft_stage == 3) begin
          // ステージ3（N=8）の回転因子: k=0,4,8,12
          twiddle_real <= cos_table[{butterfly_idx[1:0], 3'b0}];
          twiddle_imag <= sin_table[{butterfly_idx[1:0], 3'b0}];
        end else if (fft_stage == 4) begin
          // ステージ4（N=16）
          twiddle_real <= cos_table[{butterfly_idx[2:0], 2'b0}];
          twiddle_imag <= sin_table[{butterfly_idx[2:0], 2'b0}];
        end else if (fft_stage == 5) begin
          // ステージ5（N=32）
          twiddle_real <= cos_table[{butterfly_idx[3:0], 1'b0}];
          twiddle_imag <= sin_table[{butterfly_idx[3:0], 1'b0}];
        end else begin
          // ステージ6（N=64）
          twiddle_real <= cos_table[butterfly_idx[4:0]];
          twiddle_imag <= sin_table[butterfly_idx[4:0]];
        end
        
        // バタフライ計算の実行
        // バタフライ演算のインデックス計算
        // a_idx = グループ番号 * グループサイズ * 2 + グループ内オフセット
        // b_idx = a_idx + グループサイズ
        // 各ステージでのグループのサイズは butterfly_size
        
        // バタフライ演算: (a, b) => (a+b*W, a-b*W)
        // 複素数乗算: (ar+j*ai)*(br+j*bi) = (ar*br-ai*bi) + j*(ar*bi+ai*br)
        
        // ここでバタフライ計算を実行
        // 簡易的な実装として、各クロックサイクルで1つのバタフライを計算
        
        // 複素数乗算: (data_real[b_idx] + j*data_imag[b_idx]) * (twiddle_real - j*twiddle_imag)
        product1_real <= (data_real[butterfly_idx + 32] * twiddle_real) >>> 7;
        product1_imag <= (data_real[butterfly_idx + 32] * twiddle_imag) >>> 7;
        product2_real <= (data_imag[butterfly_idx + 32] * twiddle_imag) >>> 7;
        product2_imag <= (data_imag[butterfly_idx + 32] * twiddle_real) >>> 7;
        
        // 複素数加減算
        temp_real <= product1_real - product2_real;
        temp_imag <= product1_imag + product2_imag;
        
        // バタフライの最終結果を格納
        data_real[butterfly_idx] <= data_real[butterfly_idx] + temp_real;
        data_imag[butterfly_idx] <= data_imag[butterfly_idx] + temp_imag;
        data_real[butterfly_idx + 32] <= data_real[butterfly_idx] - temp_real;
        data_imag[butterfly_idx + 32] <= data_imag[butterfly_idx] - temp_imag;
        
        // 次のバタフライへ
        butterfly_idx <= butterfly_idx + 1;
      end else begin
        // このステージのすべてのバタフライが完了
        fft_stage <= fft_stage + 1;
        fft_index <= 0;
        
        // 全ステージが完了したらアイドル状態へ
        if (fft_stage == 5) begin // 6ステージ（0-5）で終了
          busy <= 1'b0;
        end
      end
    end else begin
      busy <= 1'b0;
    end
  end
  
  // データ出力ロジック
  always @(posedge clk) begin
    if (state == DATA_OUTPUT) begin
      if (ui_in[4] == 1'b0) begin
        output_data <= data_real[addr];
      end else begin
        output_data <= data_imag[addr];
      end
    end else begin
      output_data <= 8'b0;
    end
  end

  // 未使用入力の警告を防止
  wire _unused = &{ena, 1'b0};

endmodule
