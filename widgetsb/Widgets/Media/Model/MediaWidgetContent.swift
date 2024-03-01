//
//  MediaWidgetContent.swift
//  widgetsb
//
//  Created by EnchantCode on 2024/02/23.
//

import Foundation

/// メディアウィジェットの表示内容
final class MediaWidgetContent: WidgetContent {
    
    /// 表示内容の変更を通知するデリゲート
    private (set) public var delegates: MulticastDelegate<WidgetContentDelegate>
    
    static var shortDescription: String { "Media" }
    
    static var longDescription: String { "Widget that provides media (images, videos, etc)." }
    
    /// メディアのURL
    var mediaURL: URL? {
        didSet {
            delegates.invoke({$0.widget(self, didChange: \MediaWidgetContent.mediaURL)})
        }
    }
    
    /// エンコード/デコードの際に使われるキー
    private enum CodingKeys: String, CodingKey {
        case mediaURL
    }
    
    init(mediaURL: URL?) {
        self.delegates = .init()
        self.mediaURL = mediaURL
    }
    
    static func initWithDefaultConfiguration() -> WidgetContent {
        return MediaWidgetContent(mediaURL: nil)
    }
    
}

extension MediaWidgetContent: Codable {
    
    convenience init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        let mediaURL = try values.decode(URL.self, forKey: .mediaURL)
        self.init(mediaURL: mediaURL)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(mediaURL, forKey: .mediaURL)
    }
    
}
