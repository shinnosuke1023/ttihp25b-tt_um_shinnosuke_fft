# SPDX-FileCopyrightText: © 2024 Tiny Tapeout
# SPDX-License-Identifier: Apache-2.0

import cocotb
from cocotb.clock import Clock
from cocotb.triggers import ClockCycles, RisingEdge, Timer
import numpy as np
import math
import logging

# コマンド定義
CMD_IDLE = 0
CMD_DATA_INPUT = 1
CMD_FFT_EXEC = 2
CMD_DATA_OUTPUT = 3

@cocotb.test()
async def test_fft_functionality(dut):
    """FFT機能のテスト"""
    dut._log.info("FFTモジュールのテスト開始")

    # クロックの設定 (10 MHz)
    clock = Clock(dut.clk, 100, units="ns")  
    cocotb.start_soon(clock.start())

    # リセット
    dut._log.info("リセット実行")
    dut.ena.value = 1
    dut.ui_in.value = 0
    dut.uio_in.value = 0
    dut.rst_n.value = 0
    await ClockCycles(dut.clk, 10)
    dut.rst_n.value = 1
    await ClockCycles(dut.clk, 5)

    dut._log.info("データ入力フェーズ開始")
    
    # テスト用の入力データ生成（単一周波数のサイン波）
    freq = 4  # 周波数成分
    amplitude = 50  # 振幅
    n_points = 64  # データ点数
    
    # NumPyを使って正弦波を生成
    t = np.arange(n_points)
    signal_real = np.round(amplitude * np.sin(2 * np.pi * freq * t / n_points)).astype(int)
    signal_imag = np.zeros(n_points).astype(int)
    
    # 入力データの表示
    dut._log.info(f"入力データ（実部） = {signal_real}")
    
    # データの入力
    for i in range(n_points):
        # 実部データの入力
        dut.ui_in.value = (CMD_DATA_INPUT << 5) | (0 << 4) | (i & 0x1F)  # コマンド・実部フラグ・アドレス
        dut.uio_in.value = int(signal_real[i]) & 0xFF  # 8ビット幅に切り詰め
        await ClockCycles(dut.clk, 1)
        
        # 虚部データの入力（すべて0）
        dut.ui_in.value = (CMD_DATA_INPUT << 5) | (1 << 4) | (i & 0x1F)  # コマンド・虚部フラグ・アドレス
        dut.uio_in.value = 0
        await ClockCycles(dut.clk, 1)
    
    # アイドルに戻す
    dut.ui_in.value = CMD_IDLE << 5
    await ClockCycles(dut.clk, 5)
    
    dut._log.info("FFT実行フェーズ開始")
    # FFT実行コマンド
    dut.ui_in.value = CMD_FFT_EXEC << 5
    
    # FFT計算が完了するまで待機
    # 注: 実際には完了信号を監視すべきですが、簡易版では十分な時間を待ちます
    await ClockCycles(dut.clk, 300)  # 十分な時間を確保
    
    # アイドルに戻す
    dut.ui_in.value = CMD_IDLE << 5
    await ClockCycles(dut.clk, 5)
    
    dut._log.info("データ出力フェーズ開始")
    
    # 出力データを保存するための配列
    fft_result_real = np.zeros(n_points)
    fft_result_imag = np.zeros(n_points)
    
    # データの出力と表示
    for i in range(n_points):
        # 実部データの読み出し
        dut.ui_in.value = (CMD_DATA_OUTPUT << 5) | (0 << 4) | (i & 0x1F)
        await ClockCycles(dut.clk, 2)  # 安定するまで待機
        real_val = dut.uo_out.value.signed_integer
        fft_result_real[i] = real_val
        
        # 虚部データの読み出し
        dut.ui_in.value = (CMD_DATA_OUTPUT << 5) | (1 << 4) | (i & 0x1F)
        await ClockCycles(dut.clk, 2)  # 安定するまで待機
        imag_val = dut.uo_out.value.signed_integer
        fft_result_imag[i] = imag_val
    
    # 結果の出力
    dut._log.info("FFT結果:")
    for i in range(n_points):
        magnitude = math.sqrt(fft_result_real[i]**2 + fft_result_imag[i]**2)
        dut._log.info(f"FFT[{i}] = {fft_result_real[i]} + j{fft_result_imag[i]}, |FFT| = {magnitude}")
    
    # 周波数成分のチェック - 入力が周波数4の正弦波なので、インデックス4と60（-4）にピークが来るはず
    max_indices = np.argsort(np.sqrt(fft_result_real**2 + fft_result_imag**2))[-2:]
    dut._log.info(f"最大振幅のインデックス: {max_indices}")
    
    # 簡易的な検証（最も強い2つの周波数成分が4と60（-4）であることを確認）
    # 注：実際の実装では、厳密な検証が必要かもしれません
    expected_indices = {4, 60}  # 周波数4とその共役である-4（=60）
    assert set(max_indices) == expected_indices, f"期待されるピーク周波数が検出されませんでした。検出: {max_indices}, 期待: {expected_indices}"
    
    dut._log.info("FFTテスト成功！")
