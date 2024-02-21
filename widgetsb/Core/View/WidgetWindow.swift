//
//  WidgetWindow.swift
//  widgetsb
//
//  Created by EnchantCode on 2024/02/13.
//

import Cocoa


/// ウィジェット用の透明なウィンドウ
class WidgetWindow: NSWindow {
    
    // MARK: - Properties
    
    /// ウィンドウの状態を設定・取得
    var widgetMode: WidgetMode = .Edittable {
        didSet{
            DispatchQueue.main.async {[weak self] in
                guard let `self` = self else {return}
                widgetMode == .Edittable ? activate() : deactivate()
            }
        }
    }
    
    // MARK: - Initializers
    
    /// 枠を指定してウィジェットウィンドウを初期化
    init(){
        super.init(contentRect: .zero, styleMask: [.fullSizeContentView, .titled, .resizable], backing: .buffered, defer: true)
        
        self.hasShadow = false // ウィンドウは影を持たない
        self.isOpaque = false // ウィンドウは半透明でない
        self.invalidateShadow() // ウィンドウの影を無効化
        
        self.backgroundColor = .clear // 背景色を透明に
        
        self.titlebarSeparatorStyle = .none // タイトルバーとウィンドウとの間の区切り線を表示しない
        self.titlebarAppearsTransparent = true // タイトルバーを透明にする
        self.titleVisibility = .hidden // タイトルを表示しない
        
        self.isMovableByWindowBackground = true // ウィンドウ領域をドラッグすることで移動できるようにする
    }
    
    // MARK: - Private methods
    
    /// ウィジェットを編集・移動可能な状態にする
    private func activate(){
        // ウィンドウを手前に移動
        self.level = .normal
        self.orderFront(nil)
        
        // タイトルバーを表示
        self.styleMask.insert(.titled)
        
        // 徐々に透明度を下げていく
        NSAnimationContext.runAnimationGroup { [weak self] context in
            guard let blurView = (self?.contentView as? WidgetBackgroundView)?.blurView else {return}
            context.duration = 0.5
            self?.animator().alphaValue = 1.0
            blurView.animator().alphaValue = 1.0
        } completionHandler: { [weak self] in
            // 完全に表示されたらマウスイベントを受け付け、メインウィンドウに切り替える
            self?.ignoresMouseEvents = false
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
            self?.animator().alphaValue = 0.0
            blurView.animator().alphaValue = 0.0
        } completionHandler: { [weak self] in
            // 完全に透明になったらウィンドウを奥に移動して透明度を戻す
            self?.orderBack(nil)
            self?.level = .desktopIcon
            self?.alphaValue = 1.0
        }
    }
    
}
