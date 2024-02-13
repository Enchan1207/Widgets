//
//  WidgetWindowController.swift
//  widgetsb
//
//  Created by EnchantCode on 2024/02/13.
//

import Cocoa

class WidgetWindowController: NSWindowController {
    
    private let widgetWindow = WidgetWindow()
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.window?.delegate = self
    }
    
    init(){
        super.init(window: widgetWindow)
        self.window?.delegate = self
    }
    
    func activate(){
        (self.window as? WidgetWindow)?.activate()
    }
    
    func deactivate(){
        (self.window as? WidgetWindow)?.deactivate()
    }
}

extension WidgetWindowController: NSWindowDelegate {
    func windowDidBecomeMain(_ notification: Notification) {
        print("became main")
    }
    
    func windowDidResignMain(_ notification: Notification) {
        print("resign main")
    }
}
