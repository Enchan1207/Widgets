//
//  WidgetContent.swift
//  widgetsb
//
//  Created by EnchantCode on 2024/02/23.
//

import Foundation

/// ウィジェットウィンドウの表示内容
protocol WidgetContent: AnyObject, Codable {
    
    /// デリゲート
    var delegates: MulticastDelegate<WidgetContentDelegate> { get }
    
    /// 表示内容の概要
    static var shortDescription: String { get }
    
    /// 表示内容の詳細
    static var longDescription: String { get }
    
    /// デフォルト構成のインスタンスを生成
    /// - Returns: 生成されたインスタンス
    static func initWithDefaultConfiguration() -> WidgetContent

}
