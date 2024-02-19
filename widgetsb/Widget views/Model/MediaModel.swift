//
//  MediaModel.swift
//  widgetsb
//
//  Created by EnchantCode on 2024/02/17.
//

import Foundation

/// メディア(画像や動画)の管理を担うモデル
class MediaModel: NSObject {
    
    /// デリゲート
    public weak var delegate: MediaModelDelegate?
    
    /// モデルが参照するメディアのURL
    var mediaURL: URL? {
        didSet{
            // デリゲートに通知
            delegate?.media(self, didChangeURL: mediaURL)
        }
    }
    
}
