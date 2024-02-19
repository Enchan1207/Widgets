//
//  AppDelegate.swift
//  widgetsb
//
//  Created by EnchantCode on 2024/02/13.
//

import Cocoa

@main
class AppDelegate: NSObject, NSApplicationDelegate {
    
    /// シェルコマンドウィジェットのVC
    private lazy var shellCommandViewController = ShellCommandViewController()
    
    /// シェルコマンドウィジェットのWC
    private let psWidgetWindowController = WidgetWindowController()
    
    /// メディアModel
    // TODO: AppDelegateレベルで気にするべきはウィジェットの構成であり表示内容ではないため、本来ここでこのModelを持つべきではない
    // TODO: issue#6のマルチウィンドウ対応が完了した段階で削除
    private let mediaModel = MediaModel()
    
    /// メディアウィジェットのVC
    private lazy var mediaWidgetViewController = MediaWidgetViewController(mediaModel: mediaModel)
    
    /// メディアウィジェットのWC
    private let mediaWidgetWindowController = WidgetWindowController()
    
    private let menuBarItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)
    
    private var widgetMode: WidgetMode = .Edittable {
        didSet{
            // ボタンの状態を更新
            updateMenuBarButton()
            
            // 編集モードに移行したならアプリをアクティベート
            if widgetMode == .Edittable {
                activateApp()
            }
            
            // 各ウィンドウに通知
            NotificationCenter.default.post(name: .WidgetDidChangeMode, object: nil, userInfo: ["mode": widgetMode])
        }
    }
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        configureMenuBarButton()
        
        // ウィジェットWCにVCを割り当て
        psWidgetWindowController.contentViewController = shellCommandViewController
        mediaWidgetWindowController.contentViewController = mediaWidgetViewController
        
        // ウィジェットを表示
        activateApp()
        psWidgetWindowController.showWindow(self)
        mediaWidgetWindowController.showWindow(self)
        
        // メディアウィジェットの内容を変更
        // TODO: ウィジェットVCが持つ「表示内容を司るModel」を直接書き換えるべきではない ウィジェットWCが持つ「ウィジェットの属性を司るModel」経由で操作するべき
        // TODO: issue#6のマルチウィンドウ対応が完了した段階で削除
        let openPanel = NSOpenPanel()
        openPanel.allowsMultipleSelection = false
        openPanel.canChooseFiles = true
        openPanel.canChooseDirectories = false
        let response = openPanel.runModal()
        if response == .OK, let url = openPanel.url {
            mediaModel.mediaURL = url
        }
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
