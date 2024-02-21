//
//  WidgetModelDelegate.swift
//  widgetsb
//
//  Created by EnchantCode on 2024/02/20.
//

import Foundation

/// Widgetモデルのデリゲート
protocol WidgetModelDelegate {
    
    /// ウィジェット表示状態が変化した
    /// - Parameters:
    ///   - model: Widgetモデルのインスタンス
    ///   - visibility: 表示状態
    func widget(_ model: WidgetModel, didChange visibility: WidgetModel.Visibility)
    
    /// ウィジェットフレームが変化した
    /// - Parameters:
    ///   - model: Widgetモデルのインスタンス
    ///   - frame: フレーム
    func widget(_ model: WidgetModel, didChange frame: NSRect)
    
    /// ウィジェット構成情報が変化した
    /// - Parameters:
    ///   - model: Widgetモデルのインスタンス
    ///   - info: 構成情報
    func widget(_ model: WidgetModel, didChange info: [String: String])
    
}
