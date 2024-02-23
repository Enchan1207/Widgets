//
//  MediaModelDelegate.swift
//  widgetsb
//
//  Created by EnchantCode on 2024/02/17.
//

import Foundation

protocol MediaModelDelegate: AnyObject {
    
    /// モデルの保持するメディアのURLが変わった
    /// - Parameters:
    ///   - model: モデルインスタンス
    ///   - to: 新しく設定されたメディアのURL
    func media(_ model: MediaModel, didChangeURL to: URL?)
    
}
