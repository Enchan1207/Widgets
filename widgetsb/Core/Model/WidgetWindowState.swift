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
            delegates.invoke({$0.widget(self, didChange: visibility)})
        }
    }
    
    /// フレーム (ウィンドウの枠)
    var frame: NSRect {
        didSet {
            delegates.invoke({$0.widget(self, didChange: frame)})
        }
    }
    
    /// エンコード/デコードの際に使われるキー
    private enum CodingKeys: String, CodingKey {
        case visibility
        case frame
    }
    
    init(visibility: WidgetVisibility, frame: NSRect) {
        self.delegates = .init()
        self.visibility = visibility
        self.frame = frame
    }
}

extension WidgetWindowState: Codable {
    
    convenience init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        let visibility = try values.decode(WidgetVisibility.self, forKey: .visibility)
        let frame = try values.decode(NSRect.self, forKey: .frame)
        self.init(visibility: visibility, frame: frame)
    }
    
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(visibility, forKey: .visibility)
        try container.encode(frame, forKey: .frame)
    }
}
