//
//  WidgetCollectionDelegate.swift
//  widgetsb
//
//  Created by EnchantCode on 2024/02/23.
//

import Foundation

/// ウィジェットコレクションのデリゲート
protocol WidgetCollectionDelegate: AnyObject {
    
    /// ウィジェットが追加された
    /// - Parameters:
    ///   - collection: ウィジェットコレクション
    ///   - widget: 追加されたウィジェットインスタンス
    func widgetCollection(_ collection: WidgetCollection, didAdd widget: Widget)
    
    /// ウィジェットを削除して良いか?
    /// - Parameters:
    ///   - collection: ウィジェットコレクション
    ///   - widget: 削除しようとしているインスタンス
    /// - Returns: 削除許可
    func widgetCollection(_ collection: WidgetCollection, shouldRemove widget: Widget) -> Bool
    
    /// ウィジェットが削除される
    /// - Parameters:
    ///   - collection: ウィジェットコレクション
    ///   - widget: 削除されるウィジェットインスタンス
    func widgetCollection(_ collection: WidgetCollection, willRemove widget: Widget)
    
}
