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
    private weak var widgetModel: WidgetModel?
    
    // MARK: - Initializers
    
    /// 空のウィジェットウィンドウからウィンドウコントローラを初期化
    /// - Parameter model: ウィジェットモデル
    /// - Note: 渡されたモデルをもとにView
    init(model: WidgetModel) {
        // モデルを渡し、新規ウィジェットウィンドウを生成してsuper.init
        self.widgetModel = model
        super.init(window: WidgetWindow())
        
        // ファクトリを用いてWidgetModelからVCを生成し、contentVCに割り当て
        self.contentViewController = WidgetViewControllerFactory.makeViewController(from: model)
        self.window!.setFrame(model.frame, display: true)
        
        // ウィンドウのデリゲート、モデルのデリゲートを自身に設定
        self.window?.delegate = self
        self.widgetModel?.multicastDelegate.addDelegate(self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        self.widgetModel?.multicastDelegate.removeDelegate(self)
    }
    
    // MARK: - Overridden methods
    
    override func showWindow(_ sender: Any?) {
        super.showWindow(sender)
        isObserved = true
    }
    
    // MARK: - Public methods
    
    /// ウィジェットウィンドウを表示
    func showWindowIfNeeded(){
        guard widgetModel?.visibility == .Show else {return}
        self.showWindow(nil)
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
    
    func widget(_ model: WidgetModel, didChange visibility: WidgetModel.Visibility) {
        switch visibility {
        case .Show:
            self.showWindowIfNeeded()
        case .Hide:
            self.close()
        }
    }
    
    func widget(_ model: WidgetModel, didChange frame: NSRect) {
        self.window?.setFrame(frame, display: true)
    }
    
    func widget(_ model: WidgetModel, didChange info: [String : String]) {
        // 現在のcontentVCに任せられるなら任せる
        guard let widgetViewController = self.contentViewController as? WidgetViewController else {return}
        widgetViewController.widget(model, didChange: info)
    }
}
