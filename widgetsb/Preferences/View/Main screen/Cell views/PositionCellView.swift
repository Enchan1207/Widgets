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
    
    private weak var widget: Widget?
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        
        if let state = widget?.windowState {
            anchorImageView.image = .init(systemSymbolName: getSymbolName(from: state), accessibilityDescription: getAlignmentDescription(from: state))
            anchorInfoField.stringValue = "Position: \(getAlignmentDescription(from: state))"
            insetInfoField.stringValue = "Inset: \(getInsetDecription(from: state))"
        }
    }
    
    func configure(with widget: Widget) {
        self.widget = widget
    }
    
    /// 方向に対応するアイコン名を生成
    /// - Parameter state: ウィジェット状態
    /// - Returns: シンボル名
    private func getSymbolName(from state: WidgetWindowState) -> String {
        switch (state.horizontalAlignment, state.verticalAlignment) {
            
        case (.Left, .Top):
            "square.grid.3x3.topleft.filled"
            
        case (.Center, .Top):
            "square.grid.3x3.topmiddle.filled"
            
        case (.Right, .Top):
            "square.grid.3x3.topright.filled"
            
        case (.Left, .Middle):
            "square.grid.3x3.middleleft.filled"
            
        case (.Center, .Middle):
            "square.grid.3x3.middle.filled"
            
        case (.Right, .Middle):
            "square.grid.3x3.middleright.filled"
            
        case (.Left, .Bottom):
            "square.grid.3x3.bottomleft.filled"
            
        case (.Center, .Bottom):
            "square.grid.3x3.bottommiddle.filled"
            
        case (.Right, .Bottom):
            "square.grid.3x3.bottomright.filled"
            
        case (_, _):
            "square.grid.3x3"
        }
    }
    
    /// 方向に対応するキャプション文字列を生成
    /// - Parameter state: ウィジェット状態
    /// - Returns: キャプション文字列
    private func getAlignmentDescription(from state: WidgetWindowState) -> String {
        switch (state.horizontalAlignment, state.verticalAlignment) {
            
        case (.Left, .Top):
            "Up left"
            
        case (.Center, .Top):
            "Up"
            
        case (.Right, .Top):
            "Up right"
            
        case (.Left, .Middle):
            "Left"
            
        case (.Center, .Middle):
            "Center"
            
        case (.Right, .Middle):
            "Right"
            
        case (.Left, .Bottom):
            "Down left"
            
        case (.Center, .Bottom):
            "Down"
            
        case (.Right, .Bottom):
            "Down right"
            
        case (_, _):
            ""
        }
    }
    
    /// インセット量を表すキャプション文字列を生成
    /// - Parameter state: ウィジェット状態
    /// - Returns: キャプション文字列
    private func getInsetDecription(from state: WidgetWindowState) -> String {
        switch (state.insetX, state.insetY) {
        case (.Pixel(let xPixel), .Pixel(let yPixel)):
            "\(xPixel)px x \(yPixel)px"
            
        case (.Pixel(let xPixel), .Screen(let yScreen)):
            "\(xPixel)px x \(yScreen)%"
            
        case (.Screen(let xScreen), .Pixel(let yPixel)):
            "\(xScreen)% x \(yPixel)px"
            
        case (.Screen(let xScreen), .Screen(let yScreen)):
            "\(xScreen)% x \(yScreen)%"
            
        case (_, _):
            ""
        }
    }
    
}
