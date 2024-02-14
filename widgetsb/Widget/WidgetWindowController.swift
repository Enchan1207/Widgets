//
//  WidgetWindowController.swift
//  widgetsb
//
//  Created by EnchantCode on 2024/02/13.
//

import Cocoa

class WidgetWindowController: NSWindowController {
    
    /// 空のウィジェットウィンドウからウィンドウコントローラを初期化
    convenience init() {
        self.init(widgetWindow: WidgetWindow())
    }
    
    /// ウィジェットウィンドウを渡してウィンドウコントローラを初期化
    /// - Parameter widgetWindow: ウィジェットウィンドウ
    init(widgetWindow: WidgetWindow){
        super.init(window: widgetWindow)
        self.window?.delegate = self
        
        // オブザーバを追加
        NotificationCenter.default.addObserver(self, selector: #selector(onReceiveWidgetSwitchNotification), name: .WidgetDidChangeMode, object: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// ウィジェットモード切替通知を受け取った時の処理
    /// - Parameter notification: 通知
    @objc private func onReceiveWidgetSwitchNotification(_ notification: Notification){
        // userInfoのmodeプロパティに更新後のモードが入っている
        guard let newMode = notification.userInfo?["mode"] as? WidgetMode,
              let widgetWindow = window as? WidgetWindow else {return}
        
        widgetWindow.widgetMode = newMode
    }
}

extension WidgetWindowController: NSWindowDelegate {
    func windowWillClose(_ notification: Notification) {
        // オブザーバを外す
        NotificationCenter.default.removeObserver(self)
    }
}
