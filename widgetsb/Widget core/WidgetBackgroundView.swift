//
//  WidgetBackgroundView.swift
//  widgetsb
//
//  Created by EnchantCode on 2024/02/14.
//

import Cocoa

/// ウィジェット背景ビュー
class WidgetBackgroundView: NSView {
    
    let blurView = NSVisualEffectView()
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        configure()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configure()
    }
    
    /// blurビューの構成
    private func configure(){
        blurView.frame = self.frame
        blurView.material = .hudWindow
        blurView.blendingMode = .behindWindow
        blurView.state = .active
        blurView.autoresizingMask = [.width, .height]
        self.addSubview(blurView, positioned: .below, relativeTo: self)
    }
    
}
