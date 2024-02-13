//
//  WidgetWindow.swift
//  widgetsb
//
//  Created by EnchantCode on 2024/02/13.
//

import Cocoa


/// ウィジェット用の透明なウィンドウ
class WidgetWindow: NSWindow {
    
    override init(contentRect: NSRect, styleMask style: NSWindow.StyleMask, backing backingStoreType: NSWindow.BackingStoreType, defer flag: Bool) {
        super.init(contentRect: contentRect, styleMask: style, backing: backingStoreType, defer: flag)
        
        // ウィンドウを透明化
        self.styleMask = [.fullSizeContentView, .borderless, .titled, .resizable] // スタイルマスクを設定
        self.hasShadow = false // ウィンドウに影をつけない
        self.isOpaque = false // ウィンドウを透明にする
        self.titlebarSeparatorStyle = .none // タイトルバーとウィンドウとの間の区切り線を表示しない
        self.titlebarAppearsTransparent = true // タイトルバーを透明にする
        self.backgroundColor = .clear // 背景色を透明に
        self.invalidateShadow() // ウィンドウの陰影を無効化する
        self.titleVisibility = .hidden // タイトルを表示しない
        self.isMovableByWindowBackground = true // ウィンドウ領域をドラッグすることで移動できるようにする
    }

}
