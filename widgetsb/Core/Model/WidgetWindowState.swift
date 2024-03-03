//
//  WidgetWindowState.swift
//  widgetsb
//
//  Created by EnchantCode on 2024/02/23.
//

import Foundation

/// ウィジェットウィンドウの状態
final class WidgetWindowState {
    /// デリゲート
    private (set) public var delegates: MulticastDelegate<WidgetWindowStateDelegate>
    
    /// 表示・非表示
    var visibility: WidgetVisibility {
        didSet {
            delegates.invoke({$0.widget(self, didChangeVisibility: visibility)})
        }
    }
    
    /// 水平方向アライメント
    var horizontalAlignment: WidgetHorizontalAlignment {
        didSet {
            delegates.invoke({$0.didChangePositionInfo(self)})
        }
    }
    
    /// 垂直方向アライメント
    var verticalAlignment: WidgetVerticalAlignment {
        didSet {
            delegates.invoke({$0.didChangePositionInfo(self)})
        }
    }
    
    /// ウィンドウ幅
    var windowWidth: WidgetGeometry {
        didSet {
            delegates.invoke({$0.didChangePositionInfo(self)})
        }
    }
    
    /// ウィンドウ高さ
    var windowHeight: WidgetGeometry {
        didSet {
            delegates.invoke({$0.didChangePositionInfo(self)})
        }
    }
    
    /// インセットX
    var insetX: WidgetGeometry {
        didSet {
            delegates.invoke({$0.didChangePositionInfo(self)})
        }
    }
    
    /// インセットY
    var insetY: WidgetGeometry {
        didSet {
            delegates.invoke({$0.didChangePositionInfo(self)})
        }
    }
    
    /// エンコード/デコードの際に使われるキー
    private enum CodingKeys: String, CodingKey {
        case visibility
        case horizontalAlignment
        case verticalAlignment
        case windowWidth
        case windowHeight
        case insetX
        case insetY
    }
    
    init(visibility: WidgetVisibility = .Show,
         horizontalAlignment: WidgetHorizontalAlignment = .Center,
         verticalAlignment: WidgetVerticalAlignment = .Middle,
         windowWidth: WidgetGeometry,
         windowHeight: WidgetGeometry,
         insetX: WidgetGeometry = .zero,
         insetY: WidgetGeometry = .zero) {
        self.delegates = .init()
        self.visibility = visibility
        self.horizontalAlignment = horizontalAlignment
        self.verticalAlignment = verticalAlignment
        self.windowWidth = windowWidth
        self.windowHeight = windowHeight
        self.insetX = insetX
        self.insetY = insetY
    }
}

extension WidgetWindowState: Codable {
    
    convenience init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        let visibility = try values.decode(WidgetVisibility.self, forKey: .visibility)
        let horizontalAlignment = try values.decode(WidgetHorizontalAlignment.self, forKey: .horizontalAlignment)
        let verticalAlignment = try values.decode(WidgetVerticalAlignment.self, forKey: .verticalAlignment)
        let windowWidth = try values.decode(WidgetGeometry.self, forKey: .windowWidth)
        let windowHeight = try values.decode(WidgetGeometry.self, forKey: .windowHeight)
        let insetX = try values.decode(WidgetGeometry.self, forKey: .insetX)
        let insetY = try values.decode(WidgetGeometry.self, forKey: .insetY)
        
        self.init(visibility: visibility, horizontalAlignment: horizontalAlignment, verticalAlignment: verticalAlignment, windowWidth: windowWidth, windowHeight: windowHeight, insetX: insetX, insetY: insetY)
    }
    
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(visibility, forKey: .visibility)
        try container.encode(horizontalAlignment, forKey: .horizontalAlignment)
        try container.encode(verticalAlignment, forKey: .verticalAlignment)
        try container.encode(windowWidth, forKey: .windowWidth)
        try container.encode(windowHeight, forKey: .windowHeight)
        try container.encode(insetX, forKey: .insetX)
        try container.encode(insetY, forKey: .insetY)
    }
}
