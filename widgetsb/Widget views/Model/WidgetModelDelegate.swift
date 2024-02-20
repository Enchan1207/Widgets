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
    ///   - to: 新しい表示状態
    func widget(_ model: WidgetModel, visibilityDidChange to: WidgetModel.Visibility)
    
    /// ウィジェット種別が変化した
    /// - Parameters:
    ///   - model: Widgetモデルのインスタンス
    ///   - to: 新しい種別
    func widget(_ model: WidgetModel, kindDidChange to: WidgetModel.Kind)
    
    /// ウィジェットフレームが変化した
    /// - Parameters:
    ///   - model: Widgetモデルのインスタンス
    ///   - to: 新しいフレーム
    func widget(_ model: WidgetModel, frameDidChange to: NSRect)
    
    /// ウィジェット構成情報が変化した
    /// - Parameters:
    ///   - model: Widgetモデルのインスタンス
    ///   - to: 新しい構成情報
    func widget(_ model: WidgetModel, infoDidChange to: [String: String])
    
}
