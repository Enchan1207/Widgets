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
    static func makeViewController(from content: WidgetContent) -> NSViewController {
        let widgetViewController: NSViewController
        switch content.self {
        case is WelcomeWidgetContent:
            widgetViewController = WelcomeWidgetViewController(widgetContent: content as! WelcomeWidgetContent)
        case is ShellWidgetContent:
            widgetViewController = ShellWidgetViewController(widgetContent: content as! ShellWidgetContent)
        case is MediaWidgetContent:
            widgetViewController = MediaWidgetViewController(widgetContent: content as! MediaWidgetContent)
        default:
            widgetViewController = FallbackWidgetViewController(fallbackReason: WidgetVCInitializationError.UnsupportedViewControllerType(message: "Unsupported type: \(content.self)"))
        }
        return widgetViewController
    }
    
}
