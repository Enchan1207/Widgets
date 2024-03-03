//
//  WidgetAlignment.swift
//  widgetsb
//
//  Created by EnchantCode on 2024/03/03.
//

import Foundation

/// ウィジェットウィンドウの水平方向のアライメント
enum WidgetHorizontalAlignment: String, Codable {
    /// 左
    case Left
    
    /// 中央
    case Center
    
    /// 右
    case Right
}


/// ウィジェットウィンドウの垂直方向のアライメント
enum WidgetVerticalAlignment: String, Codable {
    /// 上端
    case Top
    
    /// 中央
    case Middle
    
    /// 下端
    case Bottom
}
