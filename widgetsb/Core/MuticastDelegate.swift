//
//  MuticastDelegate.swift
//  widgetsb
//
//  Created by EnchantCode on 2024/02/20.
//

/// In MVC, Model can monitor multiple Views. The class MulticastDelegate provides the way to notify model modification to multiple Views.
/// Mainly referenced: https://github.com/yurybuslovsky/MulticastDelegate

import Foundation

final class MulticastDelegate<T> {
    /// デリゲートリスト
    private let delegates: NSHashTable<AnyObject> = .weakObjects()
    
    /// デリゲートを追加する
    /// - Parameter delegate: デリゲート
    func addDelegate(_ delegate: T) {
        delegates.add(delegate as AnyObject)
    }
    
    /// デリゲートを削除する
    /// - Parameter delegate: デリゲート
    func removeDelegate(_ delegate: T){
        for delegate in delegates.allObjects.reversed() {
            if delegate === delegate as AnyObject {
                delegates.remove(delegate)
            }
        }
    }
    
    /// 登録されているデリゲートに同じ処理を適用
    /// - Parameter code: 処理
    func invoke(_ code: (T) -> Void){
        for delegate in delegates.allObjects.reversed() {
            code(delegate as! T)
        }
    }
    
}

