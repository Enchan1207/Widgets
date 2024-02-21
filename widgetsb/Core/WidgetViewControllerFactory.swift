//
//  WidgetViewControllerFactory.swift
//  widgetsb
//
//  Created by EnchantCode on 2024/02/20.
//

import Cocoa

/// ウィジェットModelからVCを生成するファクトリ
final class WidgetViewControllerFactory {
    
    /// ウィジェット ModelからVCを生成する
    /// - Parameter widget: ウィジェットModelインスタンス
    /// - Returns: 生成結果
    static func makeViewController(from widget: WidgetModel) -> NSViewController {
        let widgetViewController: NSViewController
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
