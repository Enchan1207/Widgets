//
//  WidgetViewControllerFactory.swift
//  widgetsb
//
//  Created by EnchantCode on 2024/02/20.
//

import Foundation

/// ウィジェットModelからVCを生成するファクトリ
final class WidgetViewControllerFactory {
    
    /// ウィジェット ModelからVCを生成する
    /// - Parameter widget: ウィジェットModelインスタンス
    /// - Returns: 生成結果
    /// - Note: ファクトリが生成方法を知らないなどの場合はnilが返ります。
    static func makeViewController(from widget: WidgetModel) -> WidgetViewController? {
        switch widget.kind {
        case .ShellCommand:
            return ShellCommandViewController(widgetModel: widget)
        case .Media:
            return MediaWidgetViewController(widgetModel: widget)
        }
    }
    
}
