//
//  WidgetGeometryConverter.swift
//  widgetsb
//
//  Created by EnchantCode on 2024/03/03.
//

import Cocoa

/// ウィジェット座標系の変換
final class WidgetGeometryConverter {
    
    /// ウィジェットジオメトリが表す実際のピクセル数を計算して返す
    /// - Parameter from: ジオメトリ
    /// - Returns: 計算結果
    static func convertPixel(from: WidgetGeometry) -> Int {
        switch from {
        case .Pixel(let n):
            n
        case .Screen(let ratio):
            .init(NSScreen.main!.frame.width * ratio)
        }
    }
    
    /// ウィジェットの縦横アライメントから、与えられたウィンドウが配置されるべき原点を返す
    /// - Parameters:
    ///   - halign: 水平アライメント
    ///   - valign: 垂直アライメント
    ///   - window: 配置するウィンドウ
    /// - Returns: 計算された原点
    static func getWindowOrigin(halign: WidgetHorizontalAlignment, valign: WidgetVerticalAlignment, for window: NSWindow) -> NSPoint {
        // 画面フレームを取得しておく
        let screenFrame = NSScreen.main!.frame
        
        // x座標を計算
        let originX: CGFloat
        switch halign {
        case .Left:
            originX = screenFrame.minX
        case .Center:
            originX = screenFrame.midX - (window.frame.width) / 2
        case .Right:
            originX = screenFrame.maxX - window.frame.width
        }
        
        // y座標を計算
        let originY: CGFloat
        switch valign {
        case .Top:
            originY = screenFrame.maxY - window.frame.height
        case .Middle:
            originY = screenFrame.midY - (window.frame.height) / 2
        case .Bottom:
            originY = screenFrame.minY
        }
        
        return .init(x: originX, y: originY)
    }
    
}
