//
//  MediaModel.swift
//  widgetsb
//
//  Created by EnchantCode on 2024/02/17.
//

import Foundation

/// メディア(画像や動画)の管理を担うモデル
final class MediaModel {

    // MARK: - Properties
    
    /// デリゲート
    public weak var delegate: MediaModelDelegate?
    
    /// モデルが参照するメディアのURL
    var mediaURL: URL? {
        didSet{
            // デリゲートに通知
            delegate?.media(self, didChangeURL: mediaURL)
        }
    }
    
    // MARK: - Initializers
    
    init(delegate: MediaModelDelegate? = nil, mediaURL: URL? = nil) {
        self.delegate = delegate
        self.mediaURL = mediaURL
    }
    
}
