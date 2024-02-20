//
//  NotificationNameExt.swift
//  widgetsb
//
//  Created by EnchantCode on 2024/02/14.
//

import Foundation

extension Notification.Name {
    
    /// ウィジェットウィンドウの表示モードが切り替わった
    static let WidgetWindowDidChangeMode = Notification.Name("WidgetWindowDidChangeMode")
    
    /// ウィジェット表示状態が変更された
    static let WidgetDidChangeVisibility = Notification.Name("WidgetDidChangeVisibility")
    
    /// ウィジェット種別が変更された
    static let WidgetDidChangeKind = Notification.Name("WidgetDidChangeKind")
    
    /// ウィジェットフレームが変更された
    static let WidgetDidChangeFrame = Notification.Name("WidgetDidChangeFrame")
    
    /// ウィジェット構成情報が変更された
    static let WidgetDidChangeInfo = Notification.Name("WidgetDidChangeInfo")
    
}
