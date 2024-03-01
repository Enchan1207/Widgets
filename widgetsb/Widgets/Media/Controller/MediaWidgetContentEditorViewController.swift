//
//  MediaWidgetContentEditorViewController.swift
//  widgetsb
//
//  Created by EnchantCode on 2024/02/29.
//

import Cocoa

/// MediaWidgetContentの設定画面を提供するビューコントローラ
class MediaWidgetContentEditorViewController: NSViewController {
    
    // MARK: - GUI components
    
    @IBOutlet weak var filePathField: NSTextField! {
        didSet {
            updateFilePathField()
        }
    }
    
    // MARK: - Properties

    private weak var mediaWidgetContent: MediaWidgetContent?

    override var nibName: NSNib.Name? { "MediaWidgetContentEditorView" }
    
    // MARK: - Initializers
    
    init(mediaWidgetContent: MediaWidgetContent? = nil) {
        self.mediaWidgetContent = mediaWidgetContent
        super.init(nibName: nil, bundle: nil)
        self.mediaWidgetContent?.delegates.addDelegate(self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        self.mediaWidgetContent?.delegates.removeDelegate(self)
    }
    
    // MARK: - GUI actions
    
    @IBAction func onClickBrowse(_ sender: Any) {
        let openPanel = NSOpenPanel()
        openPanel.canChooseFiles = true
        openPanel.canChooseDirectories = false
        openPanel.allowsMultipleSelection = false
        let response = openPanel.runModal()
        guard response == .OK, let selectedFileURL = openPanel.url else {return}
        mediaWidgetContent?.mediaURL = selectedFileURL
    }
    
    // MARK: - Private methods
    
    private func updateFilePathField(){
        filePathField.stringValue = mediaWidgetContent?.mediaURL?.filePath ?? "(media not set)"
    }
    
}

extension MediaWidgetContentEditorViewController: WidgetContentDelegate {
    
    func widget(_ widgetContent: WidgetContent, didChange keyPath: AnyKeyPath) {
        // 変更内容がメディアURLのそれであることを確認
        guard widgetContent is MediaWidgetContent,
              keyPath == \MediaWidgetContent.mediaURL else {return}
        updateFilePathField()
    }
    
}
