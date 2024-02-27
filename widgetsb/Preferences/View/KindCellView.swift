//
//  KindCellView.swift
//  widgetsb
//
//  Created by EnchantCode on 2024/02/27.
//

import Cocoa

class KindCellView: NSTableCellView, PreferenceCellView {
    
    @IBOutlet weak var kindField: NSTextField!
    
    func configure(with widget: Widget) {
        kindField.stringValue = widget.content.shortDescription
    }
    
}
