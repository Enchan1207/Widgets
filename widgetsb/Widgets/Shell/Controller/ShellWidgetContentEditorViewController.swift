//
//  ShellWidgetContentEditorViewController.swift
//  widgetsb
//
//  Created by EnchantCode on 2024/02/29.
//

import Cocoa

/// ShellWidgetContentの設定画面を提供するビューコントローラ
class ShellWidgetContentEditorViewController: NSViewController {
    
    private weak var shellWidgetContent: ShellWidgetContent?

    override var nibName: NSNib.Name? { "ShellWidgetContentEditorView" }
    
    init(shellWidgetContent: ShellWidgetContent? = nil) {
        self.shellWidgetContent = shellWidgetContent
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
