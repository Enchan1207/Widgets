//
//  WidgetWindow.swift
//  widgetsb
//
//  Created by EnchantCode on 2024/02/13.
//

import Cocoa


/// ウィジェット用の透明なウィンドウ
class WidgetWindow: NSWindow {
    
    private let blurView = NSVisualEffectView()
    
    override init(contentRect: NSRect, styleMask style: NSWindow.StyleMask, backing backingStoreType: NSWindow.BackingStoreType, defer flag: Bool) {
        super.init(contentRect: contentRect, styleMask: style, backing: backingStoreType, defer: flag)
        
        // ウィンドウを透明化
        self.styleMask = [.fullSizeContentView, .borderless, .titled, .closable, .resizable] // スタイルマスクを設定
        self.hasShadow = false // ウィンドウに影をつけない
        self.isOpaque = false // ウィンドウを透明にする
        self.titlebarSeparatorStyle = .none // タイトルバーとウィンドウとの間の区切り線を表示しない
        self.titlebarAppearsTransparent = true // タイトルバーを透明にする
        self.backgroundColor = .clear // 背景色を透明に
        self.invalidateShadow() // ウィンドウの陰影を無効化する
        self.titleVisibility = .hidden // タイトルを表示しない
        self.isMovableByWindowBackground = true // ウィンドウ領域をドラッグすることで移動できるようにする
        
        // ブラービュー初期化
        if let contentView = self.contentView {
            blurView.frame = contentView.frame
            blurView.material = .fullScreenUI
            blurView.blendingMode = .behindWindow
            blurView.state = .active
            blurView.autoresizingMask = [.width, .height]
            contentView.addSubview(blurView)
        }
    }
    
    /// ウィジェットを編集・移動可能な状態にする
    func activate(){
        // ウィンドウを手前に移動
        self.level = .normal
        
        // タイトルを表示
        self.styleMask.insert(.titled)
        
        // 徐々に透明度を下げていく
        NSAnimationContext.runAnimationGroup { [weak self] context in
            context.duration = 0.5
            self?.blurView.animator().alphaValue = 1.0
        } completionHandler: { [weak self] in
            guard let `self` = self else {return}
            
            //　マウスイベントを受け取れるようにする
            self.ignoresMouseEvents = false
            
            // キーウィンドウ・メインウィンドウになる
            self.becomeKey()
            self.becomeMain()
        }
    }
    
    /// ウィジェットを背景に移動する
    func deactivate(){
        // キーウィンドウ・メインウィンドウから外れる
        self.resignKey()
        self.resignMain()
        
        // タイトルを外し、マウスイベントを無視する
        self.styleMask.remove(.titled)
        self.ignoresMouseEvents = true
        
        // 徐々に透明度を上げていく
        NSAnimationContext.runAnimationGroup { [weak self] context in
            context.duration = 0.5
            self?.blurView.animator().alphaValue = 0.0
        } completionHandler: { [weak self] in
            // 完全に透明になったらウィンドウを背景に移動
            self?.level = NSWindow.Level(rawValue: Int(CGWindowLevelForKey(.desktopIconWindow)))
        }
    }
    
}
