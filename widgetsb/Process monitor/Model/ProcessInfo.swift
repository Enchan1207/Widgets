//
//  ProcessInfo.swift
//  widgetsb
//
//  Created by EnchantCode on 2024/02/15.
//

import Foundation


/// プロセスの情報
struct ProcessInfo {
    
    /// PID
    let pid: UInt
    
    /// CPU使用率
    let cpuUsage: Double
    
    /// メモリ使用率
    let memoryUsage: Double
    
    /// プロセス実行後の経過時間
    let elapsedTime: TimeInterval
    
    /// プロセスが実行しているコマンドの名称
    let commandName: String
}
