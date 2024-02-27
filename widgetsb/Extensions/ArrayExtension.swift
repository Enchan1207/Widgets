//
//  ArrayExtension.swift
//  widgetsb
//
//  Created by EnchantCode on 2024/02/27.
//

import Foundation

extension Array {
    
    /// 安全に値を取り出す
    subscript (nullable index: Index) -> Element? {
        guard self.indices.contains(index) else {return nil}
        return self[index]
    }
    
}
