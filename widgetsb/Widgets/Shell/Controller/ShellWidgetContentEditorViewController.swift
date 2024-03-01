//
//  ShellWidgetContentEditorViewController.swift
//  widgetsb
//
//  Created by EnchantCode on 2024/02/29.
//

import Cocoa

/// ShellWidgetContentの設定画面を提供するビューコントローラ
class ShellWidgetContentEditorViewController: NSViewController {
    
    // MARK: - GUI components
    
    @IBOutlet weak var maxLinesField: NSTextField! {
        didSet {
            // フォーマッタを構成
            let formatter = NumberFormatter()
            formatter.numberStyle = .decimal
            formatter.minimum = 0
            formatter.allowsFloats = false
            maxLinesField.formatter = formatter
            
            // モデルクラスから値を受け取れるなら反映する
            guard let maxLines = shellWidgetContent?.maxLines else {return}
            maxLinesField.intValue = .init(maxLines)
        }
    }
    
    @IBOutlet weak var updateIntervalField: NSTextField! {
        didSet {
            // フォーマッタを構成
            let formatter = NumberFormatter()
            formatter.numberStyle = .decimal
            formatter.minimum = 0
            formatter.allowsFloats = true
            updateIntervalField.formatter = formatter
            
            // モデルクラスから値を受け取れるなら反映する
            guard let updateInterval = shellWidgetContent?.updateInterval else {return}
            updateIntervalField.doubleValue = .init(updateInterval)
        }
    }
    
    // MARK: - Properties
    
    private weak var shellWidgetContent: ShellWidgetContent?

    override var nibName: NSNib.Name? { "ShellWidgetContentEditorView" }
    
    // MARK: - Initializers
    
    init(shellWidgetContent: ShellWidgetContent? = nil) {
        self.shellWidgetContent = shellWidgetContent
        super.init(nibName: nil, bundle: nil)
        self.shellWidgetContent?.delegates.addDelegate(self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        self.shellWidgetContent?.delegates.removeDelegate(self)
    }
    
    // MARK: - GUI actions
    
    @IBAction func onMaxLineFieldConfirmed(_ sender: Any) {
        shellWidgetContent?.maxLines = .init(maxLinesField.intValue)
    }
    
    @IBAction func onUpdateIntervalFieldConfirmed(_ sender: Any) {
        shellWidgetContent?.updateInterval = .init(updateIntervalField.doubleValue)
    }
    
}

extension ShellWidgetContentEditorViewController: WidgetContentDelegate {
    
    func widget(_ widgetContent: WidgetContent, didChange keyPath: AnyKeyPath) {
        guard let widgetContent = widgetContent as? ShellWidgetContent else {return}
        
        switch keyPath {
        case \ShellWidgetContent.maxLines:
            maxLinesField.intValue = .init(widgetContent.maxLines)
            break
            
        case \ShellWidgetContent.updateInterval:
            updateIntervalField.doubleValue = .init(widgetContent.updateInterval)
            break
            
        default:
            return
        }
    }
    
}
