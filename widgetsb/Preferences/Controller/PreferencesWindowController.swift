//
//  PreferencesWindowController.swift
//  widgetsb
//
//  Created by EnchantCode on 2024/02/24.
//

import Cocoa

class PreferencesWindowController: NSWindowController {
    
    // MARK: - GUI components
    
    
    // MARK: - Properties
    
    override var windowNibName: NSNib.Name? { "PreferencesWindow" }
    
    /// ウィジェットコレクション
    private weak var widgetCollection: WidgetCollection?
    
    /// 設定画面が表示されているかどうか
    private var isShown = false
    
    // MARK: - Initializers
    
    init(widgetCollection: WidgetCollection){
        self.widgetCollection = widgetCollection
        super.init(window: nil)
        self.window?.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View lifecycle

    override func windowDidLoad() {
        super.windowDidLoad()
        self.widgetCollection?.delegate = self
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

extension PreferencesWindowController: WidgetCollectionDelegate {
    
    func widgetCollection(_ collection: WidgetCollection, didAdd widget: Widget) {
        
    }
    
    func widgetCollection(_ collection: WidgetCollection, shouldRemove widget: Widget) -> Bool {
        // TODO: 削除前にダイアログを出す
        return true
    }
    
    func widgetCollection(_ collection: WidgetCollection, willRemove widget: Widget) {
        
    }
    
}
