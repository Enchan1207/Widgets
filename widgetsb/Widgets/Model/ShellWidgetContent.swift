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
    
    /// このWidgetContentに紐づけられたViewControllerの型
    var widgetViewControllerType: WidgetViewController.Type { ShellWidgetViewController.self }
    
    /// 実行するコマンドのURL
    var commandURL: URL
    
    /// 表示する最大行数
    var maxLines: Int
    
    /// 更新間隔
    var updateInterval: Double
    
    /// エンコード/デコードの際に使われるキー
    private enum CodingKeys: String, CodingKey {
        case commandURL
        case maxLines
        case updateInterval
    }
    
    init(commandURL: URL, maxLines: Int, updateInterval: Double) {
        self.delegates = .init()
        self.commandURL = commandURL
        self.maxLines = maxLines
        self.updateInterval = updateInterval
    }
    
}

extension ShellWidgetContent: Codable {
    
    convenience init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        let commandURL = try values.decode(URL.self, forKey: .commandURL)
        let maxLines = try values.decode(Int.self, forKey: .maxLines)
        let updateInterval = try values.decode(Double.self, forKey: .updateInterval)
        self.init(commandURL: commandURL, maxLines: maxLines, updateInterval: updateInterval)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(commandURL, forKey: .commandURL)
        try container.encode(maxLines, forKey: .maxLines)
        try container.encode(updateInterval, forKey: .updateInterval)
    }
    
}
