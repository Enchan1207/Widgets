//
//  ShellWidgetContent.swift
//  widgetsb
//
//  Created by EnchantCode on 2024/02/23.
//

import Foundation

/// シェルウィジェットの表示内容
final class ShellWidgetContent: WidgetContent {
    
    /// 表示内容の変更を通知するデリゲート
    private (set) public var delegates: MulticastDelegate<WidgetContentDelegate>
    
    var shortDescription: String { "Shell" }
    
    var longDescription: String { "Widget that provide shell script output. content updates periodically." }
    
    /// 表示する最大行数
    var maxLines: Int {
        didSet {
            delegates.invoke({$0.widget(self, didChange: \ShellWidgetContent.maxLines)})
        }
    }
    
    /// 更新間隔
    var updateInterval: Double {
        didSet {
            delegates.invoke({$0.widget(self, didChange: \ShellWidgetContent.updateInterval)})
        }
    }
    
    /// エンコード/デコードの際に使われるキー
    private enum CodingKeys: String, CodingKey {
        case maxLines
        case updateInterval
    }
    
    init(maxLines: Int, updateInterval: Double) {
        self.delegates = .init()
        self.maxLines = maxLines
        self.updateInterval = updateInterval
    }
    
}

extension ShellWidgetContent: Codable {
    
    convenience init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        let maxLines = try values.decode(Int.self, forKey: .maxLines)
        let updateInterval = try values.decode(Double.self, forKey: .updateInterval)
        self.init(maxLines: maxLines, updateInterval: updateInterval)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(maxLines, forKey: .maxLines)
        try container.encode(updateInterval, forKey: .updateInterval)
    }
    
}
