//
//  Widget.swift
//  widgetsb
//
//  Created by EnchantCode on 2024/02/23.
//

import Foundation

/// ウィジェットモデルクラス
final class Widget {
    
    /// ウィジェットウィンドウの状態
    private (set) public var windowState: WidgetWindowState
    
    /// ウィジェットウィンドウの表示内容
    private (set) public var content: WidgetContent
    
    /// エンコード/デコードの際に使われるキー
    private enum CodingKeys: String, CodingKey {
        case windowState
        case content
        case contentType
    }
    
    init(windowState: WidgetWindowState, content: WidgetContent) {
        self.windowState = windowState
        self.content = content
    }

}

extension Widget: Codable {
    
    convenience init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        let windowState = try values.decode(WidgetWindowState.self, forKey: .windowState)
        
        // 表示内容(WidgetContent)はそれ単体ではデコードできないので、まず型名を取得
        let contentTypeName = try values.decode(String.self, forKey: .contentType)
        let contentType: WidgetContent.Type
        switch contentTypeName {
            // TODO: WidgetContentサブクラス時に実装
            /*
        case .init(describing: ShellWidgetInfo.self):
            contentType = ShellWidgetInfo.self
             */
        default:
            throw DecodingError.dataCorrupted(.init(codingPath: [CodingKeys.contentType], debugDescription: "unknown type of WidgetContent subclass: \"\(contentTypeName)\""))
        }
        
        // 型名から得られた型オブジェクトをもとに表示内容をデコード
        let info = try values.decode(contentType, forKey: .content)
        
        self.init(windowState: windowState, content: content)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(windowState, forKey: .windowState)
        try container.encode(content, forKey: .content)
        
        // ウィジェット表示内容の型名もエンコードする
        try container.encode(String(describing: type(of: content)), forKey: .contentType)
    }
    
}
