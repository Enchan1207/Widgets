//
//  WidgetAnchorEditorViewController.swift
//  widgetsb
//
//  Created by EnchantCode on 2024/02/29.
//

import Cocoa

class WidgetAnchorEditorViewController: NSViewController {
    
    private weak var widgetWindowState: WidgetWindowState?
    
    override var nibName: NSNib.Name? { "WidgetAnchorEditorView" }
    
    /// デリゲート
    weak var delegate: WidgetAnchorEditorDelegate?

    init(widgetWindowState: WidgetWindowState? = nil) {
        self.widgetWindowState = widgetWindowState
        super.init(nibName: nil, bundle: nil)
        self.widgetWindowState?.delegates.addDelegate(self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        widgetWindowState?.delegates.removeDelegate(self)
    }
    
    override func viewDidLoad() {
    }
    
}

extension WidgetAnchorEditorViewController: WidgetWindowStateDelegate {
    
    func widget(_ windowState: WidgetWindowState, didChange visibility: WidgetVisibility) {
        print("\(#file) \(visibility)")
    }
    
    func widget(_ windowState: WidgetWindowState, didChange frame: NSRect) {
        print("\(#file) \(frame)")
    }
    
}
