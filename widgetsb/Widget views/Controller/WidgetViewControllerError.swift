//
//  WidgetViewControllerError.swift
//  widgetsb
//
//  Created by EnchantCode on 2024/02/21.
//

import Foundation

extension WidgetViewController {
    
    /// ウィジェットVC初期化時のエラー
    enum InitializationError: Error {
        
        /// 構成情報が不十分
        case InsufficientWidgetInfo(message: String)
        
    }

}
