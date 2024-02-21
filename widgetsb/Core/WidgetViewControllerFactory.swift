//
//  WidgetViewControllerFactory.swift
//  widgetsb
//
//  Created by EnchantCode on 2024/02/20.
//

import Cocoa

/// ウィジェットモデルからVCを生成するファクトリ
final class WidgetViewControllerFactory {
    
    /// ウィジェットモデルからVCを生成する
    /// - Parameter widget: ウィジェットモデルインスタンス
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
