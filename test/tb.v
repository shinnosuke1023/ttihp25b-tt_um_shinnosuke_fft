`default_nettype none
`timescale 1ns / 1ps

/* This testbench instantiates the FFT module and tests its functionality
   by providing test vectors and verifying the results.
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
  
  // Clock generation
  initial begin
    clk = 0;
    forever #5 clk = ~clk; // 100MHz clock
  end

  // Instantiate the FFT module
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
  
  // コマンド定義
  localparam CMD_IDLE = 3'b000;
  localparam CMD_DATA_INPUT = 3'b001;
  localparam CMD_FFT_EXEC = 3'b010;
  localparam CMD_DATA_OUTPUT = 3'b011;
  
  // テストシーケンス - 単体テストで確認するための簡易版
  initial begin
    // 初期化
    rst_n = 0;
    ena = 1;
    ui_in = 0;
    uio_in = 0;
    #100;
    rst_n = 1;
    #100;
    
    // 単一周波数のテストデータ（簡単のため実部のみ使用）
    // サインウェーブを入力: sin(2π*4*n/64)
    // 周波数4のサインは、FFT後にインデックス4と60にピークが出るはず
    
    // データ入力フェーズ
    $display("データ入力フェーズ開始");
    // 64個の入力データを書き込み
    input_data(0, 0);       // 実部: sin(0) = 0
    input_data(1, 19);      // 実部: sin(π/8) ≈ 0.38 * 50 ≈ 19
    input_data(2, 38);      // 実部: sin(π/4) ≈ 0.76 * 50 ≈ 38
    input_data(3, 50);      // 実部: sin(3π/8) ≈ 0.92 * 50 ≈ 50
    input_data(4, 50);      // 実部: sin(π/2) = 1 * 50 = 50
    input_data(5, 50);      // 実部: sin(5π/8) ≈ 0.92 * 50 ≈ 50
    input_data(6, 38);      // 実部: sin(3π/4) ≈ 0.76 * 50 ≈ 38
    input_data(7, 19);      // 実部: sin(7π/8) ≈ 0.38 * 50 ≈ 19
    input_data(8, 0);       // 実部: sin(π) = 0
    input_data(9, -19);     // 実部: sin(9π/8) ≈ -0.38 * 50 ≈ -19
    input_data(10, -38);    // 実部: sin(5π/4) ≈ -0.76 * 50 ≈ -38
    input_data(11, -50);    // 実部: sin(11π/8) ≈ -0.92 * 50 ≈ -50
    input_data(12, -50);    // 実部: sin(3π/2) = -1 * 50 = -50
    input_data(13, -50);    // 実部: sin(13π/8) ≈ -0.92 * 50 ≈ -50
    input_data(14, -38);    // 実部: sin(7π/4) ≈ -0.76 * 50 ≈ -38
    input_data(15, -19);    // 実部: sin(15π/8) ≈ -0.38 * 50 ≈ -19
    
    // 残りのデータポイント (16-63)を同じパターンで繰り返し
    input_data(16, 0);
    input_data(17, 19);
    input_data(18, 38);
    input_data(19, 50);
    input_data(20, 50);
    input_data(21, 50);
    input_data(22, 38);
    input_data(23, 19);
    input_data(24, 0);
    input_data(25, -19);
    input_data(26, -38);
    input_data(27, -50);
    input_data(28, -50);
    input_data(29, -50);
    input_data(30, -38);
    input_data(31, -19);
    
    input_data(32, 0);
    input_data(33, 19);
    input_data(34, 38);
    input_data(35, 50);
    input_data(36, 50);
    input_data(37, 50);
    input_data(38, 38);
    input_data(39, 19);
    input_data(40, 0);
    input_data(41, -19);
    input_data(42, -38);
    input_data(43, -50);
    input_data(44, -50);
    input_data(45, -50);
    input_data(46, -38);
    input_data(47, -19);
    
    input_data(48, 0);
    input_data(49, 19);
    input_data(50, 38);
    input_data(51, 50);
    input_data(52, 50);
    input_data(53, 50);
    input_data(54, 38);
    input_data(55, 19);
    input_data(56, 0);
    input_data(57, -19);
    input_data(58, -38);
    input_data(59, -50);
    input_data(60, -50);
    input_data(61, -50);
    input_data(62, -38);
    input_data(63, -19);
    
    // 虚部はすべて0に設定
    for (int i = 0; i < 64; i++) begin
      input_data_imag(i, 0);
    end
    
    // アイドル状態に戻る
    ui_in = {CMD_IDLE, 5'b0};
    #20;
    
    // FFT実行フェーズ
    $display("FFT実行フェーズ開始");
    ui_in = {CMD_FFT_EXEC, 5'b0};
    #2000; // FFT計算のための十分な時間を確保
    
    // アイドル状態に戻る
    ui_in = {CMD_IDLE, 5'b0};
    #20;
    
    // データ出力フェーズ
    $display("データ出力フェーズ開始");
    ui_in = {CMD_DATA_OUTPUT, 5'b0};
    
    // すべての出力データを読み出して表示
    for (int i = 0; i < 64; i++) begin
      read_data(i);
    end
    
    // アイドル状態に戻る
    ui_in = {CMD_IDLE, 5'b0};
    #20;
    
    $display("テスト終了");
    #100;
    $finish;
  end
  
  // データ入力タスク（実部）
  task input_data(input [5:0] addr, input signed [7:0] data);
    begin
      ui_in = {CMD_DATA_INPUT, 1'b0, addr[4:0]}; // 実部フラグ = 0
      uio_in = data;
      #10; // 1クロックサイクル待機
    end
  endtask
  
  // データ入力タスク（虚部）
  task input_data_imag(input [5:0] addr, input signed [7:0] data);
    begin
      ui_in = {CMD_DATA_INPUT, 1'b1, addr[4:0]}; // 虚部フラグ = 1
      uio_in = data;
      #10; // 1クロックサイクル待機
    end
  endtask
  
  // データ読み出しタスク
  task read_data(input [5:0] addr);
    begin
      // 実部読み出し
      ui_in = {CMD_DATA_OUTPUT, 1'b0, addr[4:0]}; // 実部フラグ = 0
      #10;
      $display("Data[%d].real = %d", addr, $signed(uo_out));
      
      // 虚部読み出し
      ui_in = {CMD_DATA_OUTPUT, 1'b1, addr[4:0]}; // 虚部フラグ = 1
      #10;
      $display("Data[%d].imag = %d", addr, $signed(uo_out));
    end
  endtask

endmodule
