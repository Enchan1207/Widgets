//
//  WidgetViewController.swift
//  widgetsb
//
//  Created by EnchantCode on 2024/02/20.
//

import Cocoa

/// ウィジェットVC
protocol WidgetViewController: AnyObject {
    
    /// 構成情報が変化した
    /// - Parameters:
    ///   - model: ウィジェットモデルのインスタンス
    ///   - info: 構成情報
    func widget(_ model: WidgetModel, didChange info: [String: String])
    
}
