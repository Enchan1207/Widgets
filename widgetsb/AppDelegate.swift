//
//  AppDelegate.swift
//  widgetsb
//
//  Created by EnchantCode on 2024/02/13.
//

import Cocoa

@main
class AppDelegate: NSObject, NSApplicationDelegate {
    
    /// コンテントビューコントローラを持つウィジェットウィンドウコントローラ
    private let xibWidgetWindowController = WidgetWindowController(widgetWindow: WidgetWindow(contentViewController: WidgetViewController()))
    
    private let menuBarItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)
    
    private var widgetMode: WidgetMode = .Edittable {
        didSet{
            // ボタンの状態を更新
            updateMenuBarButton()
            
            // 各ウィンドウに通知
            NotificationCenter.default.post(name: .WidgetDidChangeMode, object: nil, userInfo: ["mode": widgetMode])
        }
    }
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // メニューバーボタンを構成
        configureMenuBarButton()
        
        // ウィンドウを表示
        xibWidgetWindowController.showWindow(self)
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
    
    func configureMenuBarButton(){
        guard let button = menuBarItem.button else {return}
        button.action = #selector(onClickMenuBarButton)
        updateMenuBarButton()
    }
    
    func updateMenuBarButton(){
        guard let button = menuBarItem.button else {return}
        let buttonSymbolName = widgetMode == .Edittable ? "list.bullet.rectangle.fill" : "list.bullet.rectangle"
        button.image = .init(systemSymbolName: buttonSymbolName, accessibilityDescription: "widget mode switcher")
    }
    
    @objc func onClickMenuBarButton(){
        // モードを切り替える
        widgetMode = widgetMode == .Edittable ? .Fixed : .Edittable
    }
    
}
