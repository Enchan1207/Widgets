//
//  PreferenceCellView.swift
//  widgetsb
//
//  Created by EnchantCode on 2024/02/27.
//

import Foundation

/// 設定画面のテーブルセル
protocol PreferenceCellView {
    
    /// ウィジェットの情報をもとにセルを構成する
    /// - Parameter widget: セルに対応するウィジェット
    func configure(with widget: Widget)
    
}
