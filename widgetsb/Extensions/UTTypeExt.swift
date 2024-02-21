//
//  UTTypeExtension.swift
//  widgetsb
//
//  Created by EnchantCode on 2024/02/19.
//

import Foundation
import UniformTypeIdentifiers

extension UTType {
    
    /// 複数のUTTypeのうちどれかにcomformしているかを返す
    /// - Parameter types: 候補
    /// - Returns: comformしているUTTypeがあるかどうか
    func conformsAny(to types: [UTType]) -> Bool {
        types.map({conforms(to: $0)}).contains(true)
    }
    
}
