//
//  WidgetWindowController.swift
//  widgetsb
//
//  Created by EnchantCode on 2024/02/13.
//

import Cocoa

class WidgetWindowController: NSWindowController {
    
    // MARK: - Properties
    
    /// モード切替オブザーバの状態
    private var isObserved = false {
        didSet{
            // 値が変化していなければ何もしない
            guard oldValue != isObserved else {return}
            
            if isObserved {
                NotificationCenter.default.addObserver(self, selector: #selector(onReceiveWidgetSwitchNotification), name: .WidgetDidChangeMode, object: nil)
            }else{
                NotificationCenter.default.removeObserver(self)
            }
        }
    }
    
    // MARK: - Initializers
    
    /// 空のウィジェットウィンドウからウィンドウコントローラを初期化
    convenience init() {
        self.init(widgetWindow: WidgetWindow())
    }
    
    /// ウィジェットウィンドウを渡してウィンドウコントローラを初期化
    /// - Parameter widgetWindow: ウィジェットウィンドウ
    init(widgetWindow: WidgetWindow){
        super.init(window: widgetWindow)
        self.window?.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Overridden methods
    
    override func showWindow(_ sender: Any?) {
        super.showWindow(sender)
        isObserved = true
    }
    
    // MARK: - Private methods
    
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
        isObserved = false
    }
}
