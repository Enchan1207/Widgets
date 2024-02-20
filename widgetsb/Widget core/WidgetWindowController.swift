//
//  WidgetWindowController.swift
//  widgetsb
//
//  Created by EnchantCode on 2024/02/13.
//

import Cocoa

/// ウィジェットウィンドウコントローラ
class WidgetWindowController: NSWindowController {
    
    // MARK: - Properties
    
    /// モード切替オブザーバの状態
    private var isObserved = false {
        didSet{
            // 値が変化していなければ何もしない
            guard oldValue != isObserved else {return}
            
            if isObserved {
                NotificationCenter.default.addObserver(self, selector: #selector(onReceiveWidgetSwitchNotification), name: .WidgetWindowDidChangeMode, object: nil)
            }else{
                NotificationCenter.default.removeObserver(self)
            }
        }
    }
    
    /// ウィジェットModel
    private let widgetModel: WidgetModel
    
    // MARK: - Initializers
    
    /// 空のウィジェットウィンドウからウィンドウコントローラを初期化
    /// - Parameter model: ウィジェットモデル
    convenience init(model: WidgetModel) {
        self.init(window: .init(), model: model)
    }
    
    /// ウィジェットウィンドウを渡してウィンドウコントローラを初期化
    /// - Parameter window: ウィジェットウィンドウ
    /// - Parameter model: ウィジェットモデル
    init(window: WidgetWindow, model: WidgetModel){
        self.widgetModel = model
        super.init(window: window)
        self.window?.delegate = self
        self.widgetModel.multicastDelegate.addDelegate(self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        self.widgetModel.multicastDelegate.removeDelegate(self)
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

extension WidgetWindowController: WidgetModelDelegate {
    // TODO: まともに実装する (VCへの通知など…)
    
    func widget(_ model: WidgetModel, visibilityDidChange to: WidgetModel.Visibility) {
        print("WidgetWindow #\(hashValue): widget visibility was modified")
    }
    
    func widget(_ model: WidgetModel, kindDidChange to: WidgetModel.Kind) {
        print("WidgetWindow #\(hashValue): widget kind was modified")
    }
    
    func widget(_ model: WidgetModel, frameDidChange to: NSRect) {
        print("WidgetWindow #\(hashValue): widget frame was modified")
    }
    
    func widget(_ model: WidgetModel, infoDidChange to: [String : String]) {
        print("WidgetWindow #\(hashValue): widget info was modified")
    }
}
