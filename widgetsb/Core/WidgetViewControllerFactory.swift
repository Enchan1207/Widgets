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
    static func makeViewController(from widget: WidgetModel) -> WidgetViewController {
        let widgetViewController: WidgetViewController
        do {
            switch widget.kind {
            case .ShellCommand:
                widgetViewController = try ShellWidgetViewController(widgetModel: widget)
            case .Media:
                widgetViewController = try MediaWidgetViewController(widgetModel: widget)
            }
        } catch {
            widgetViewController = FallbackWidgetViewController(fallbackReason: error)
        }
        return widgetViewController
    }
    
}
