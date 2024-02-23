//
//  WidgetContentDelegate.swift
//  widgetsb
//
//  Created by EnchantCode on 2024/02/23.
//

import Foundation

/// ウィジェット表示内容のデリゲート
protocol WidgetContentDelegate {
    
    /// 表示内容が変化した
    /// - Parameters:
    ///   - widgetContent: ウィジェット表示内容
    ///   - keyPath: 変化した表示内容を指すKeyPath
    func widget(_ widgetContent: WidgetContent, didChange keyPath: AnyKeyPath)
    
}
