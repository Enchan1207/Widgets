//
//  DraggableImageView.swift
//  widgetsb
//
//  Created by EnchantCode on 2024/02/21.
//

import Cocoa

/// 領域内のマウス操作でウィンドウをドラッグできるImageView
class DraggableImageView: NSImageView {
    override var mouseDownCanMoveWindow: Bool { true }
}
