//
//  AppDelegate.swift
//  widgetsb
//
//  Created by EnchantCode on 2024/02/13.
//

import Cocoa

@main
class AppDelegate: NSObject, NSApplicationDelegate {
    
    @IBOutlet weak var window: WidgetWindow!
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        window.makeKey()
        window.orderFrontRegardless()
    }
    
    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
    
    func applicationSupportsSecureRestorableState(_ app: NSApplication) -> Bool {
        return true
    }
}
