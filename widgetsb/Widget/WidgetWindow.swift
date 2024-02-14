//
//  WidgetWindow.swift
//  widgetsb
//
//  Created by EnchantCode on 2024/02/13.
//

import Cocoa


/// ウィジェット用の透明なウィンドウ
class WidgetWindow: NSWindow {
    
    /// ウィンドウの状態を設定・取得
    var widgetMode: WidgetMode = .Edittable {
        didSet{
            DispatchQueue.main.async {[weak self] in
                guard let `self` = self else {return}
                widgetMode == .Edittable ? activate() : deactivate()
            }
        }
    }
    
    override init(contentRect: NSRect, styleMask style: NSWindow.StyleMask, backing backingStoreType: NSWindow.BackingStoreType, defer flag: Bool) {
        super.init(contentRect: contentRect, styleMask: style, backing: backingStoreType, defer: flag)
        
        // 透明なウィンドウを構成
        configureTransparentWindow()
    }
    
    /// ウィンドウの透明化
    private func configureTransparentWindow(){
        self.styleMask = [.fullSizeContentView, .borderless, .titled, .closable, .resizable] // スタイルマスクを設定
        
        self.hasShadow = false // ウィンドウは影を持たない
        self.isOpaque = false // ウィンドウは半透明でない
        self.invalidateShadow() // ウィンドウの影を無効化
        
        self.backgroundColor = .clear // 背景色を透明に
        
        self.titlebarSeparatorStyle = .none // タイトルバーとウィンドウとの間の区切り線を表示しない
        self.titlebarAppearsTransparent = true // タイトルバーを透明にする
        self.titleVisibility = .hidden // タイトルを表示しない
        
        self.isMovableByWindowBackground = true // ウィンドウ領域をドラッグすることで移動できるようにする
        
    }
    
    /// ウィジェットを編集・移動可能な状態にする
    private func activate(){
        // ウィンドウを手前に移動
        self.level = .normal
        
        // タイトルバーを表示
        self.styleMask.insert(.titled)
        
        // 徐々に透明度を下げていく
        NSAnimationContext.runAnimationGroup { [weak self] context in
            guard let blurView = (self?.contentView as? WidgetBackgroundView)?.blurView else {return}
            context.duration = 0.5
            blurView.animator().alphaValue = 1.0
        } completionHandler: { [weak self] in
            // 完全に表示されたらマウスイベントを受け付け、メインウィンドウに切り替える
            self?.ignoresMouseEvents = false
            self?.orderFront(nil)
            self?.becomeMain()
        }
    }
    
    /// ウィジェットを背景に移動する
    private func deactivate(){
        // キーウィンドウ・メインウィンドウから外れる
        self.resignKey()
        self.resignMain()
        
        // タイトルバーを外し、マウスイベントを無視する
        self.styleMask.remove(.titled)
        self.ignoresMouseEvents = true
        
        // 徐々に透明度を上げていく
        NSAnimationContext.runAnimationGroup { [weak self] context in
            guard let blurView = (self?.contentView as? WidgetBackgroundView)?.blurView else {return}
            context.duration = 0.5
            blurView.animator().alphaValue = 0.0
        } completionHandler: { [weak self] in
            // 完全に透明になったらウィンドウを奥に移動する
            self?.orderBack(nil)
            self?.level = .desktopIcon
        }
    }
    
}
