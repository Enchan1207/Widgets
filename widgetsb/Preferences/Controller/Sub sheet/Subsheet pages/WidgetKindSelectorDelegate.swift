//
//  WidgetKindSelectorDelegate.swift
//  widgetsb
//
//  Created by EnchantCode on 2024/02/29.
//

import Foundation

/// ウィジェット種別セレクタのデリゲート
protocol WidgetKindSelectorDelegate: AnyObject {
    
    /// ユーザがウィジェット種別を選択した
    /// - Parameters:
    ///   - selector: セレクタVCインスタンス
    ///   - kind: 選択された種別に該当するWidgetContent準拠の型
    func kindSelector(_ selector: WidgetKindSelectorViewController, didSelect kind: WidgetContent.Type)
    
}
