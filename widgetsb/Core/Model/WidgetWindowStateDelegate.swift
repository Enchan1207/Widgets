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
    func widget(_ windowState: WidgetWindowState, didChange visibility: WidgetVisibility)
    
    /// フレームが変化した
    /// - Parameters:
    ///   - windowState: ウィジェット状態
    ///   - frame: フレーム
    func widget(_ windowState: WidgetWindowState, didChange frame: NSRect)
    
}
