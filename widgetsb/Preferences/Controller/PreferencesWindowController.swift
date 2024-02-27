//
//  PreferencesWindowController.swift
//  widgetsb
//
//  Created by EnchantCode on 2024/02/24.
//

import Cocoa

class PreferencesWindowController: NSWindowController {
    
    // MARK: - Properties
    
    /// 設定画面が表示されているかどうか
    private var isShown = false
    
    // MARK: - Initializers
    
    init(widgetCollection: WidgetCollection){
        super.init(window: .init())
        self.contentViewController = PreferencesViewController(widgetCollection: widgetCollection)
        
        if let window = self.window {
            window.title = "Widgets preferences"
            window.titlebarAppearsTransparent = true
            window.delegate = self
            window.styleMask = [.titled, .closable]
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View lifecycle
    
    override func windowDidLoad() {
        super.windowDidLoad()
    }
    
    // MARK: - Overridden methods
    
    override func showWindow(_ sender: Any?) {
        if isShown {
            self.window?.becomeMain()
            self.window?.orderFrontRegardless()
        }else{
            self.window?.center()
            super.showWindow(nil)
        }
    }
    
}

extension PreferencesWindowController: NSWindowDelegate {
    
    func windowWillClose(_ notification: Notification) {
        isShown = false
    }
    
}
