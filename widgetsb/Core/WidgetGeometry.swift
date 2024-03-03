//
//  WidgetGeometry.swift
//  widgetsb
//
//  Created by EnchantCode on 2024/03/03.
//

import Foundation

/// ウィジェットのサイズやインセットを表現するための値
enum WidgetGeometry: Codable {
    
    /// ピクセル単位
    case Pixel(_ value: Int)
    
    /// ディスプレイ比率単位
    case Screen(_ ratio: Double)
    
    /// ゼロ
    static var zero: WidgetGeometry {.Pixel(0)}
    
    /// 実際のピクセル値に変換
    var toPixel: Int { WidgetGeometryConverter.convertPixel(from: self) }
    
}
