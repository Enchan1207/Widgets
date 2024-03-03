//
//  PositionCellView.swift
//  widgetsb
//
//  Created by EnchantCode on 2024/02/27.
//

import Cocoa

class PositionCellView: NSTableCellView, PreferenceCellView {

    @IBOutlet weak var anchorImageView: NSImageView!
    
    @IBOutlet weak var anchorInfoField: NSTextField!
    
    @IBOutlet weak var insetInfoField: NSTextField!
    
    func configure(with widget: Widget) {
        anchorInfoField.stringValue = "Widget anchor is now developing"
    }
    
}
