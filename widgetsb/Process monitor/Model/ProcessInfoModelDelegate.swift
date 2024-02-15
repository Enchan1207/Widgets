//
//  ProcessInfoModelDelegate.swift
//  widgetsb
//
//  Created by EnchantCode on 2024/02/15.
//

import Foundation

/// ProcessInfoモデルのデリゲート
protocol ProcessInfoModelDelegate: AnyObject {
    
    /// プロセス情報が更新された
    func processInfoDidUpdate()
    
}
