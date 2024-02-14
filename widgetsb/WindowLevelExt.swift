//
//  WindowLevelExt.swift
//  widgetsb
//
//  Created by EnchantCode on 2024/02/14.
//

import Cocoa


extension NSWindow.Level {
    
    /// デスクトップアイコンより奥を表すウィンドウレベル
    public static let desktopIcon = NSWindow.Level(rawValue: Int(CGWindowLevelForKey(.desktopIconWindow)))
    
}
