//
//  WidgetAnchorEditorDelegate.swift
//  widgetsb
//
//  Created by EnchantCode on 2024/02/29.
//

import Foundation

protocol WidgetAnchorEditorDelegate: AnyObject {
    
    /// アンカーエディタ内で構成が変更されたときに呼ばれる
    /// - Parameters:
    ///   - editor: アンカーエディタインスタンス
    ///   - widgetWindowState: 構成
    func anchorEditor(_ editor: WidgetAnchorEditorViewController, didChange widgetWindowState: WidgetWindowState)
    
}
