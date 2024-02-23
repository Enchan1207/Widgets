//
//  ShellCommandModelDelegate.swift
//  widgetsb
//
//  Created by EnchantCode on 2024/02/15.
//

import Foundation

/// ProcessInfoモデルのデリゲート
protocol ShellCommandModelDelegate: AnyObject {
    
    /// プロセスが終了した
    /// - Parameters:
    ///   - model: ShellCommandモデルのインスタンス
    ///   - output: 標準出力
    func shellCommand(_ model: ShellCommandModel, processDidTerminate output: Data?)
    
    /// プロセスを実行できなかった
    /// - Parameters:
    ///   - model: ShellCommandモデルのインスタンス
    ///   - error: 発生したエラー
    func shellCommand(_ model: ShellCommandModel, processDidFail error: Error)
    
}
