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
        
        // TODO: docatchじゃなくてFactoryの呼び出し元までthrowしてもいいかも
        let widgetViewController: WidgetViewController
        do {
            switch widget.kind {
            case .ShellCommand:
                widgetViewController = try ShellCommandViewController(widgetModel: widget)
            case .Media:
                widgetViewController = try MediaWidgetViewController(widgetModel: widget)
            }
        } catch WidgetViewController.InitializationError.InsufficientWidgetInfo {
            // TODO: VCの初期化に失敗したときに表示するフォールバックVCを実装する
            widgetViewController = try! .init(widgetModel: .init(visibility: .Hide, kind: .Media))
        } catch {
            // TODO: エラーのパターンマッチめんどくさい(VC生成コード同じの幾つも書きたくない)のでこれもありかなと
            /*
                switch error {
                case WidgetViewController.InitializationError.InsufficientWidgetInfo:
                    print("")
                default:
                    print("")
                }
            */
            
            // TODO: VCの初期化に失敗したときに表示するフォールバックVCを実装する
            widgetViewController = try! .init(widgetModel: .init(visibility: .Hide, kind: .Media))
        }
        return widgetViewController
    }
    
}
