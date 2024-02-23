//
//  ShellWidgetViewController.swift
//  widgetsb
//
//  Created by EnchantCode on 2024/02/15.
//

import Cocoa

final class ShellWidgetViewController: WidgetViewController {
    
    // MARK: - GUI Components
    
    @IBOutlet weak var processOutputView: GradientTextView! {
        didSet {
            processOutputView.autoresizingMask = [.width, .height]
        }
    }
    
    // MARK: - Properties
    
    override var nibName: NSNib.Name? { "ShellWidgetView" }
    
    /// 更新を司るタイマ
    private var updateTimer: Timer?
    
    /// シェルコマンドモデル
    private var shellCommandModel: ShellCommandModel
    
    // MARK: - Initializers
    
    init(widgetContent: ShellWidgetContent) {
        self.shellCommandModel = .init()
        super.init(widgetContent: widgetContent)
        self.widgetContent?.delegates.addDelegate(self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        updateTimer?.invalidate()
        self.widgetContent?.delegates.removeDelegate(self)
    }
    
    // MARK: - View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        processOutputView.textColor = .green.withAlphaComponent(0.5)
        processOutputView.startPoint = .init(x: 0.5, y: 0.3)
        processOutputView.font = .monospacedSystemFont(ofSize: 14.0, weight: .regular)
        self.shellCommandModel.delegate = self
        
        // 一度実行要求を出してから更新タイマを構成
        self.shellCommandModel.requestForExecution()
        configureUpdateTimer()
    }
    
    // MARK: - Priate methods
    
    /// コマンド更新タイマを構成する
    private func configureUpdateTimer(){
        // 一旦今のタイマを止める
        updateTimer?.invalidate()
        
        // 更新間隔ゼロならタイマを動かさない
        guard let widgetContent = self.widgetContent as? ShellWidgetContent, widgetContent.updateInterval > 0 else {return}
        
        // 構成
        updateTimer = .scheduledTimer(withTimeInterval: widgetContent.updateInterval, repeats: true, block: { [weak self] _ in
            guard let `self` = self else {return}
            self.shellCommandModel.requestForExecution()
        })
    }
    
}

extension ShellWidgetViewController: ShellCommandModelDelegate {
    
    func shellCommand(_ model: ShellCommandModel, processDidTerminate output: Data?) {
        // 終了コードチェック
        guard model.process.terminationStatus == 0, let output = output else {return}
        
        // 文字列に変換
        guard let processOutputString = String(data: output, encoding: .utf8) else {
            processOutputView.string = "Failed to decode process output"
            return
        }
        
        // 必要なら切り捨て 0なら切り捨てない
        let maxLineCount = (self.widgetContent as? ShellWidgetContent)?.maxLines ?? 0
        let truncatedString: String
        if maxLineCount > 0 {
            truncatedString = processOutputString.split(separator: "\n")[0...(maxLineCount - 1)].map{.init($0)}.joined(separator: "\n")
        }else{
            truncatedString = processOutputString
        }
        
        // Viewに反映
        processOutputView.string = truncatedString
    }
    
    func shellCommand(_ model: ShellCommandModel, processDidFail error: Error) {
        processOutputView.string = "An error occured during process execution: \(error)"
    }
    
}

extension ShellWidgetViewController: WidgetContentDelegate {
    func widget(_ widgetContent: WidgetContent, didChange keyPath: AnyKeyPath) {
        
    }
}
