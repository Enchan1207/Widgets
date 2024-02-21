//
//  FallbackWidgetViewController.swift
//  widgetsb
//
//  Created by EnchantCode on 2024/02/21.
//

import Cocoa

final class FallbackWidgetViewController: WidgetViewController {
    
    // MARK: - GUI Components
    
    @IBOutlet weak var errorIcon: NSImageView!
    
    @IBOutlet weak var errorLabel: NSTextField!
    
    // MARK: - Properties
    
    override var nibName: NSNib.Name? { "FallbackWidgetView" }
    
    private let fallbackReason: Error
    
    // MARK: - Initializers
    
    /// 失敗要因を渡してVCを初期化
    /// - Parameter error: VC初期化に失敗した原因
    init(fallbackReason error: Error){
        self.fallbackReason = error
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View lifecycle
    
    override func viewDidLoad() {
        configureErrorInfoViews(error: fallbackReason)
    }
    
    // MARK: - Private methods
    
    private func configureErrorInfoViews(error: Error){
        // 既知のエラーなら警告、そうでなければエラーアイコンを表示する
        setErrorIcon(isErrorExpected: error is WidgetViewController.InitializationError)
        
        // メッセージを取り出して割り当てる
        switch error {
        case WidgetViewController.InitializationError.InsufficientWidgetInfo(let message):
            errorLabel.stringValue = message
        default:
            errorLabel.stringValue = "Unexpected error: \(error.localizedDescription)"
        }
    }
    
    private func setErrorIcon(isErrorExpected: Bool){
        // エラーの深刻度に応じて異なる画像を用意
        let imageName: String = isErrorExpected ? "exclamationmark.triangle.fill" : "exclamationmark.circle.fill"
        guard let iconImage = NSImage(systemSymbolName: imageName, accessibilityDescription: "error icon") else {return}
        
        // OSが対応していればマルチカラー版を適用
        var symbolConfig = NSImage.SymbolConfiguration(textStyle: .largeTitle, scale: .large)
        if #available(macOS 12.0, *) {
            symbolConfig = symbolConfig.applying(.preferringMulticolor())
        }
        
        // 割り当て
        errorIcon.image = iconImage.withSymbolConfiguration(symbolConfig)
    }
    
}
