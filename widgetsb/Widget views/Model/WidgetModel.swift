//
//  WidgetModel.swift
//  widgetsb
//
//  Created by EnchantCode on 2024/02/20.
//

import Foundation

/// ウィジェットの表示状態、扱うコンテンツを管理するモデル
final class WidgetModel {
    
    /// ウィジェットの種類
    enum Kind: Codable {
        
        /// シェルコマンド (与えられたコマンドを定期的に実行し結果を出力する)
        case ShellCommand
        
        /// メディア (動画・画像を表示する)
        case Media
    }
    
    /// ウィジェット表示状態
    enum Visibility: Codable {
        /// 表示
        case Show
        
        /// 非表示
        case Hide
    }
    
    private enum CodingKeys: String, CodingKey {
        case visibility
        case kind
        case frame
        case info
    }
    
    // MARK: - Properties
    
    // TODO: 通知センタをやめてマルチキャストデリゲートを検討
    
    /// モデルの変化を受け取るための通知センタ
    let notificationCenter: NotificationCenter
    
    /// ウィジェット表示状態
    var visibility: Visibility {
        didSet{
            notificationCenter.post(name: .WidgetDidChangeVisibility, object: nil)
        }
    }
    
    /// ウィジェット種別
    var kind: Kind {
        didSet{
            notificationCenter.post(name: .WidgetDidChangeKind, object: nil)
        }
    }
    
    /// ウィジェットフレーム
    var frame: NSRect {
        didSet{
            notificationCenter.post(name: .WidgetDidChangeFrame, object: nil)
        }
    }
    
    /// ウィジェット構成情報
    var info: [String: String] {
        didSet{
            notificationCenter.post(name: .WidgetDidChangeInfo, object: nil)
        }
    }
    
    // MARK: - Initialiers
    
    /// WidgetModelオブジェクトを初期化
    /// - Parameters:
    ///   - visibility: ウィジェット表示状態
    ///   - kind: ウィジェットの種類
    ///   - frame: ウィジェットウィンドウの枠
    ///   - info: ウィジェット構成情報
    init(visibility: Visibility, kind: Kind, frame: NSRect = .zero, info: [String : String] = [:]) {
        self.notificationCenter = .init()
        self.kind = kind
        self.frame = frame
        self.info = info
        self.visibility = visibility
    }

}

extension WidgetModel: Codable {
    
    convenience init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        let visibility = try values.decode(Visibility.self, forKey: .visibility)
        let kind = try values.decode(Kind.self, forKey: .kind)
        let frame = try values.decode(NSRect.self, forKey: .frame)
        let info = try values.decode([String: String].self, forKey: .info)
        self.init(visibility: visibility, kind: kind, frame: frame, info: info)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(visibility, forKey: .visibility)
        try container.encode(kind, forKey: .kind)
        try container.encode(frame, forKey: .frame)
        try container.encode(info, forKey: .info)
    }
    
}
