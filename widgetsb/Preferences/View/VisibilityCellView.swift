//
//  VisibilityCellView.swift
//  widgetsb
//
//  Created by EnchantCode on 2024/02/27.
//

import Cocoa

class VisibilityCellView: NSTableCellView, PreferenceCellView {
    
    @IBOutlet weak var visibilityButton: NSButton!
    
    func configure(with widget: Widget) {
        visibilityButton.state = widget.windowState.visibility == .Show ? .on : .off
    }
    
}
