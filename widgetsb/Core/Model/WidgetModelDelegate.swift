//
//  WidgetModelDelegate.swift
//  widgetsb
//
//  Created by EnchantCode on 2024/02/20.
//

import Foundation

/// ウィジェットモデルのデリゲート
protocol WidgetModelDelegate {
    
    /// 表示状態が変化した
    /// - Parameters:
    ///   - model: ウィジェットモデル
    ///   - visibility: 表示状態
    func widget(_ model: WidgetModel, didChange visibility: WidgetModel.Visibility)
    
    /// フレームが変化した
    /// - Parameters:
    ///   - model: ウィジェットモデル
    ///   - frame: フレーム
    func widget(_ model: WidgetModel, didChange frame: NSRect)
    
    /// 構成情報が変化した
    /// - Parameters:
    ///   - model: ウィジェットモデル
    ///   - info: 構成情報
    func widget(_ model: WidgetModel, didChange info: [String: String])
    
}
