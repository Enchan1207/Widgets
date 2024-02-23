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
    
    /// ウィジェット構成情報の格納先
    private var widgetConfigURL: URL {
        // ベースディレクトリはApplication Support
        var appSupportDir = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first!
        
        // バンドル識別子を足す
        let bundleID = Bundle.main.bundleIdentifier!
        if #available(macOS 13.0, *) {
            appSupportDir.append(path: bundleID, directoryHint: .isDirectory)
        } else {
            appSupportDir.appendPathComponent(bundleID)
        }
        
        // ファイル名を足してreturn
        appSupportDir.appendPathComponent("widgetconf.json", conformingTo: .json)
        return appSupportDir
    }
    
    /// ウィジェットコレクション
    private var widgetCollection: WidgetCollection?
    
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
    
    // MARK: - Public methods
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // デフォルト構成をあらかじめ用意しておく
        let defaultWidgetCollection = WidgetCollection(widgets: [
            // TODO: デフォルトウィジェットを用意する
        ])
        widgetCollection = defaultWidgetCollection
        
        // 構成ファイルからのリストアを試みる 構成ファイルがないか、あってもデコードできないか、含まれているウィジェットが一つもなければデフォルト構成を採用する
        do {
            let widgetConfData = try Data(contentsOf: widgetConfigURL)
            let decodedWidgetCollection = try JSONDecoder().decode(WidgetCollection.self, from: widgetConfData)
            if decodedWidgetCollection.widgets.count > 0 {
                widgetCollection = decodedWidgetCollection
                print("Widget configuration loaded. Now \(widgetCollection!.widgets.count) widgets loaded.")
            }else{
                print("Widget configuration loaded, but no widget found. Fallback to default one.")
            }
        } catch {
            print("An error occurred while restoring the configuration: \(error.localizedDescription) Fallback to default one.")
        }

        // メニューバーボタンを構成
        configureMenuBarButton()
        
        // アプリをアクティベート
        activateApp()
        
        // コレクションが持つウィジェットを表示
        widgetCollection!.showWidgets()
    }
    
    func applicationWillTerminate(_ aNotification: Notification) {
        // ウィジェットを全て閉じる
        widgetCollection?.closeWindows()
        
        // ウィジェットコレクションをJSONデコードして保存
        guard widgetCollection != nil else {return}
        do {
            let encodedWidgetCollection = try JSONEncoder().encode(widgetCollection)
            try FileManager.default.createDirectory(at: widgetConfigURL.deletingLastPathComponent(), withIntermediateDirectories: true)
            try encodedWidgetCollection.write(to: widgetConfigURL)
            let widgetConfigPath: String
            if #available(macOS 13.0, *) {
                widgetConfigPath = widgetConfigURL.path()
            } else {
                widgetConfigPath = widgetConfigURL.path
            }
            print("Widget configuration saved at \"\(widgetConfigPath)\".")
        } catch {
            print("Failed to save widget collection data: \(error)")
        }
    }
    
    func applicationSupportsSecureRestorableState(_ app: NSApplication) -> Bool {
        return true
    }
    
    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        return true
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
