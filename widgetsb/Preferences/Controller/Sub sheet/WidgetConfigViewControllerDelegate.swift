//
//  WidgetConfigViewControllerDelegate.swift
//  widgetsb
//
//  Created by EnchantCode on 2024/03/01.
//

import Foundation

/// 構成エディタのデリゲート
protocol WidgetConfigViewControllerDelegate: AnyObject {
    
    /// ユーザにより、新しいウィジェットを追加する準備が整った
    /// - Parameters:
    ///   - viewController: 構成エディタインスタンス
    ///   - state: 新しいウィジェットの状態
    ///   - content: 新しいウィジェットのコンテンツ
    func didPrepareNewWidget(_ viewController: WidgetConfigViewController, state: WidgetWindowState, content: WidgetContent)
    
    /// 構成エディタが閉じようとしている
    /// - Parameter viewController: 構成エディタインスタンス
    func willCloseSheet(_ viewController: WidgetConfigViewController)
    
}
