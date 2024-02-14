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
        
        // ウィジェットモード切替通知を受け取る
        NotificationCenter.default.addObserver(self, selector: #selector(onReceiveWidgetSwitchNotification), name: .WidgetDidChangeMode, object: nil)
        
    }
    
    deinit{
        // オブザーバを外す
        NotificationCenter.default.removeObserver(self)
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
    
    /// ウィジェットモード切替通知を受け取った時の処理
    /// - Parameter notification: 通知
    @objc private func onReceiveWidgetSwitchNotification(_ notification: Notification){
        // userInfoのmodeプロパティに更新後のモードが入っている
        guard let newMode = notification.userInfo?["mode"] as? WidgetMode else {return}
        newMode == .Edittable ? activate() : deactivate()
    }
    
    /// ウィジェットを編集・移動可能な状態にする
    private func activate(){
        // ウィンドウを手前に移動
        self.level = .normal
        
        // タイトルバーを表示し、マウスイベントを受け取るようにする
        self.styleMask.insert(.titled)
        self.ignoresMouseEvents = false
        
        // メインウィンドウになる
        self.becomeMain()
    }
    
    /// ウィジェットを背景に移動する
    private func deactivate(){
        // キーウィンドウ・メインウィンドウから外れる
        self.resignKey()
        self.resignMain()
        
        // タイトルバーを外し、マウスイベントを無視する
        self.styleMask.remove(.titled)
        self.ignoresMouseEvents = true
        
        // ウィンドウを奥に移動する
        self.level = .desktopIcon
    }
    
}
