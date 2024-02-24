//
//  AppDelegate.swift
//  widgetsb
//
//  Created by EnchantCode on 2024/02/13.
//

import Cocoa

@main
class AppDelegate: NSObject, NSApplicationDelegate {
    
    // MARK: - Properties
    
    /// ウィジェットコレクション
    private let widgetCollection = WidgetCollection(widgets: (try? WidgetStorage.load()) ?? [])
    
    /// 設定画面
    private lazy var preferencesWindowController = PreferencesWindowController(widgetCollection: widgetCollection)
    
    /// メニューバーボタン
    private let menuBarItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)
    
    /// ウィジェットウィンドウの表示モード
    private var widgetMode: WidgetMode = .Edittable {
        didSet{
            // ボタンの状態を更新
            updateMenuBarButton()
            
            // 編集モードに移行したらアプリをアクティベートし、設定画面を表示
            if widgetMode == .Edittable {
                activateApp()
                preferencesWindowController.showWindow(nil)
            }
            
            // 各ウィンドウに通知
            NotificationCenter.default.post(name: .WidgetWindowDidChangeMode, object: nil, userInfo: ["mode": widgetMode])
        }
    }
    
    // MARK: - Public methods
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // メニューバーボタンを構成
        configureMenuBarButton()
        
        // アプリをアクティベート
        activateApp()
        
        // コレクションが持つウィジェットを表示
        widgetCollection.showWidgets()
    }
    
    func applicationWillTerminate(_ aNotification: Notification) {
        // ウィジェットを全て閉じる
        widgetCollection.closeWindows()
        
        // 保存
        try? WidgetStorage.save(widgets: widgetCollection.widgets)
    }
    
    func applicationSupportsSecureRestorableState(_ app: NSApplication) -> Bool {
        return true
    }
    
    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        return false
    }
    
    // MARK: - Private methods
    
    /// アプリケーションをアクティブにする
    private func activateApp(){
        if #available(macOS 14.0, *) {
            NSApp.activate()
        } else {
            NSApp.activate(ignoringOtherApps: true)
        }
    }
    
    /// メニューバーボタンの構成
    private func configureMenuBarButton(){
        guard let button = menuBarItem.button else {return}
        button.action = #selector(onClickMenuBarButton)
        updateMenuBarButton()
    }
    
    /// メニューバーボタンの更新
    private func updateMenuBarButton(){
        guard let button = menuBarItem.button else {return}
        let buttonSymbolName = widgetMode == .Edittable ? "list.bullet.rectangle.fill" : "list.bullet.rectangle"
        button.image = .init(systemSymbolName: buttonSymbolName, accessibilityDescription: "widget mode switcher")
    }
    
    /// メニューバーボタンクリック時の処理
    @objc private func onClickMenuBarButton(){
        widgetMode = widgetMode == .Edittable ? .Fixed : .Edittable
    }
    
}
