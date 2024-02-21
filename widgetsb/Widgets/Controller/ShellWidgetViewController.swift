//
//  ShellWidgetViewController.swift
//  widgetsb
//
//  Created by EnchantCode on 2024/02/15.
//

import Cocoa

final class ShellWidgetViewController: NSViewController {
    
    // MARK: - GUI Components
    
    @IBOutlet weak var processOutputView: GradientTextView! {
        didSet {
            processOutputView.autoresizingMask = [.width, .height]
        }
    }
    
    // MARK: - Properties
    
    override var nibName: NSNib.Name? { "ShellWidgetView" }
    
    /// コマンド実行間隔
    private var updateInterval: Double = 0
    
    /// 最大行数
    private var maxLineCount: Int = 0
    
    /// 更新を司るタイマ
    private var updateTimer: Timer?
    
    /// シェルコマンドモデル
    private var shellCommandModel: ShellCommandModel
    
    // MARK: - Initializers
    
    init(widgetModel: WidgetModel, nibName: NSNib.Name? = nil, bundle: Bundle? = nil) throws {
        
        // TODO: 文字色やフォントも構成情報からいじれるように
        
        // 更新間隔を設定
        guard let updateInterval = Double(widgetModel.info["update_interval"] ?? ""), updateInterval > 0 else {
            throw WidgetVCInitializationError.InsufficientWidgetInfo(message: "required key \"update_interval\" not found or it has invalid value (expects positive number greater than 0)")
        }
        self.updateInterval = updateInterval
        
        // 最大行数を設定
        guard let maxLineCount = Int(widgetModel.info["max_lines"] ?? ""), maxLineCount >= 0 else {
            throw WidgetVCInitializationError.InsufficientWidgetInfo(message: "required key \"max_lines\" not found or it has invalid value (expects positive integer greater than or equal to 0)")
        }
        self.maxLineCount = maxLineCount
        
        self.shellCommandModel = .init()
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
    
    override func viewDidDisappear() {
        super.viewDidDisappear()
        
        // タイマを無効化
        updateTimer?.invalidate()
    }
    
    // MARK: - Priate methods
    
    /// コマンド更新タイマを構成する
    private func configureUpdateTimer(){
        // 一旦今のタイマを止める
        updateTimer?.invalidate()
        
        // 更新間隔ゼロならタイマを動かさない
        guard updateInterval > 0 else {return}
        
        // 構成
        updateTimer = .scheduledTimer(withTimeInterval: updateInterval, repeats: true, block: { [weak self] _ in
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

extension ShellWidgetViewController: WidgetViewController {
    
    func widget(_ model: WidgetModel, didChange info: [String : String]) {
        // 情報に従ってメンバを更新
        if let maxLineCount = Int(info["max_lines"] ?? ""), maxLineCount >= 0 {
            self.maxLineCount = maxLineCount
        }
        if let updateInterval = Double(info["update_interval"] ?? ""), updateInterval > 0 {
            self.updateInterval = updateInterval
        }
        
        // コマンド実行タイマを再構成
        configureUpdateTimer()
    }
    
}
