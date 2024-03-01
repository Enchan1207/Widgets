//
//  URLExtension.swift
//  widgetsb
//
//  Created by EnchantCode on 2024/03/01.
//

import Foundation

extension URL {
    
    /// ファイルパス表現を返す
    var filePath: String {
        if #available(macOS 13.0, *) {
            self.path(percentEncoded: false)
        } else {
            self.path
        }
    }
    
}
