//
//  WidgetWindowStateDelegate.swift
//  widgetsb
//
//  Created by EnchantCode on 2024/02/23.
//

import Foundation

/// ウィジェットウィンドウ状態のデリゲート
protocol WidgetWindowStateDelegate {
    
    /// 表示状態が変化した
    /// - Parameters:
    ///   - windowState: ウィジェット状態
    ///   - visibility: 表示状態
    func widget(_ windowState: WidgetWindowState, didChangeVisibility visibility: WidgetVisibility)
    
    /// ウィジェットの表示位置情報が変化した
    /// - Parameter windowState: ウィジェット状態
    func didChangePositionInfo(_ windowState: WidgetWindowState)
    
}
