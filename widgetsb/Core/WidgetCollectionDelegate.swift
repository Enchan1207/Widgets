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
    ///   - index: 追加されたウィジェットのインデックス
    func widgetCollection(_ collection: WidgetCollection, didAddAt index: Int)
    
    /// ウィジェットを削除して良いか?
    /// - Parameters:
    ///   - collection: ウィジェットコレクション
    ///   - index: 削除しようとしているインスタンスのインデックス
    /// - Returns: 削除許可
    func widgetCollection(_ collection: WidgetCollection, shouldRemoveAt index: Int) -> Bool
    
    /// ウィジェットが削除される
    /// - Parameters:
    ///   - collection: ウィジェットコレクション
    ///   - index: 削除されるウィジェットインスタンスのインデックス
    func widgetCollection(_ collection: WidgetCollection, willRemoveAt index: Int)
    
}
