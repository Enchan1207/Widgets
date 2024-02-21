//
//  AppDelegate.swift
//  widgetsb
//
//  Created by EnchantCode on 2024/02/13.
//

import Cocoa

@main
class AppDelegate: NSObject, NSApplicationDelegate {
    
    /// ウィジェットモデルの配列
    // TODO: 追加/削除UIをちゃんと作る
    private let widgetModels: [WidgetModel] = [
        .init(visibility: .Show, kind: .ShellCommand, frame: .init(x: 100, y: 100, width: 400, height: 300), info: ["update_interval": "5", "max_lines": "30"]),
        .init(visibility: .Show, kind: .Media, frame: .init(x: 100, y: 100, width: 400, height: 300), info: ["filepath": "/Users/enchantcode/Pictures/icon.jpg"])
    ]
    
    /// WCを保持するリスト
    private var widgetWCs: [WidgetWindowController] = []
    
    /// メニューバーボタン
    private let menuBarItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)
    
    /// ウィジェットウィンドウの表示モード
    private var widgetMode: WidgetMode = .Edittable {
        didSet{
            // ボタンの状態を更新
            updateMenuBarButton()
            
            // 編集モードに移行したならアプリをアクティベート
            if widgetMode == .Edittable {
                activateApp()
            }
            
            // 各ウィンドウに通知
            NotificationCenter.default.post(name: .WidgetWindowDidChangeMode, object: nil, userInfo: ["mode": widgetMode])
        }
    }
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // メニューバーボタンを構成
        configureMenuBarButton()
        
        // ウィジェットモデルの配列からウィジェットWCを生成
        widgetWCs = widgetModels.compactMap({.init(model: $0)})
        
        // アプリをアクティベート
        activateApp()
        
        // ウィンドウを表示
        widgetWCs.forEach({$0.showWindowIfNeeded()})
        
        // TODO: 以下はただのテストコード 実装終了後に消す
        
        // メディアウィジェットの内容を変更
        let openPanel = NSOpenPanel()
        openPanel.allowsMultipleSelection = false
        openPanel.canChooseFiles = true
        openPanel.canChooseDirectories = false
        let response = openPanel.runModal()
        if response == .OK, let url = openPanel.url {
            widgetModels[1].info["filepath"] = url.path
        }
        
        // コマンドウィジェットの内容を変更
        DispatchQueue.global().asyncAfter(deadline: .now().advanced(by: .seconds(2)), execute: {[weak self] in
            self?.widgetModels[0].info["max_lines"] = "2"
        })
    }
    
    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
    
    func applicationSupportsSecureRestorableState(_ app: NSApplication) -> Bool {
        return true
    }
    
    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        return true
    }
    
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
