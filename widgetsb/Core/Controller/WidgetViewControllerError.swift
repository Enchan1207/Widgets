//
//  WidgetViewControllerError.swift
//  widgetsb
//
//  Created by EnchantCode on 2024/02/21.
//

import Foundation

/// ウィジェットVC初期化時のエラー
enum WidgetVCInitializationError: Error {
    
    /// 構成情報が不十分
    case InsufficientWidgetInfo(message: String)
    
    /// サポートされていない型のVC
    case UnsupportedViewControllerType(message: String)
    
}
