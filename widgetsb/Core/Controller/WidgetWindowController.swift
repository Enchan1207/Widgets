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
    
    /// ウィジェット表示状態モデル
    private weak var windowState: WidgetWindowState?
    
    // MARK: - Initializers
    
    /// ウィジェットモデルの情報をもとにウィンドウコントローラを初期化
    /// - Parameter widget: ウィジェットモデル
    /// - Note: 渡されたモデルをもとにView
    init(widget: Widget) {
        // モデルを渡し、新規ウィジェットウィンドウを生成してsuper.init
        self.windowState = widget.windowState
        super.init(window: WidgetWindow())
        
        // ファクトリを用いてWidgetModelからVCを生成し、contentVCに割り当て
        self.contentViewController = WidgetViewControllerFactory.makeViewController(from: widget.content)
        
        // ウィンドウのデリゲート、モデルのデリゲートを自身に設定
        self.window?.delegate = self
        self.windowState?.delegates.addDelegate(self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        self.windowState?.delegates.removeDelegate(self)
    }
    
    // MARK: - Overridden methods
    
    override func showWindow(_ sender: Any?) {
        guard windowState?.visibility == .Show else {return}
        // 位置と寸法を設定
        self.updatePositionAndSize()
        
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
    
    /// ウィンドウ状態に従って位置と寸法を更新
    private func updatePositionAndSize(){
        guard let windowState = self.windowState, let window = self.window else {return}
        
        // リサイズ
        let windowSize = NSSize(width: .init(windowState.windowWidth.toPixel), height: .init(windowState.windowHeight.toPixel))
        window.setContentSize(windowSize)
        
        // 原点移動
        let windowOrigin = WidgetGeometryConverter.getWindowOrigin(halign: windowState.horizontalAlignment, valign: windowState.verticalAlignment, for: window)
        window.setFrameOrigin(windowOrigin)
    }
}

extension WidgetWindowController: NSWindowDelegate {
    func windowWillClose(_ notification: Notification) {
        isObserved = false
    }
}

extension WidgetWindowController: WidgetWindowStateDelegate {
    
    func widget(_ windowState: WidgetWindowState, didChangeVisibility visibility: WidgetVisibility) {
        DispatchQueue.main.async{[weak self] in
            switch visibility {
            case .Show:
                self?.showWindow(nil)
            case .Hide:
                self?.close()
            }
        }
    }
    
    func didChangePositionInfo(_ windowState: WidgetWindowState) {
        updatePositionAndSize()
    }
    
}
