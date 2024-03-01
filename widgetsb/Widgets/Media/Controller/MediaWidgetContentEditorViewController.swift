//
//  MediaWidgetContentEditorViewController.swift
//  widgetsb
//
//  Created by EnchantCode on 2024/02/29.
//

import Cocoa

/// MediaWidgetContentの設定画面を提供するビューコントローラ
class MediaWidgetContentEditorViewController: NSViewController {

    private weak var mediaWidgetContent: MediaWidgetContent?

    override var nibName: NSNib.Name? { "MediaWidgetContentEditorView" }
    
    init(mediaWidgetContent: MediaWidgetContent? = nil) {
        self.mediaWidgetContent = mediaWidgetContent
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
