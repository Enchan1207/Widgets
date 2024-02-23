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

    // TODO: 設定画面実装時に追加
    /*
    /// 設定VCの型
    var widgetPreferencesViewControllerType: WidgetPreferencesViewController.Type { get }
     */

}
