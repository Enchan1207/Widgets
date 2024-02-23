//
//  ProcessRunnerDelegate.swift
//  widgetsb
//
//  Created by EnchantCode on 2024/02/15.
//

import Foundation

/// ProcessInfoモデルのデリゲート
protocol ProcessRunnerDelegate: AnyObject {
    
    /// プロセスが終了した
    /// - Parameters:
    ///   - model: ランナー
    ///   - output: 標準出力
    func runner(_ model: ProcessRunner, processDidTerminate output: Data?)
    
    /// プロセスを実行できなかった
    /// - Parameters:
    ///   - model: ランナー
    ///   - error: 発生したエラー
    func runner(_ model: ProcessRunner, processDidFail error: Error)
    
}
