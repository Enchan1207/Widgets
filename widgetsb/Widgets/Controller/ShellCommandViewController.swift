//
//  ShellCommandViewController.swift
//  widgetsb
//
//  Created by EnchantCode on 2024/02/15.
//

import Cocoa

final class ShellCommandViewController: WidgetViewController {
    
    // MARK: - GUI Components
    
    @IBOutlet weak var processOutputView: GradientTextView!
    
    // MARK: - Properties
    
    override var nibName: NSNib.Name? { "ShellCommandView" }
    
    /// 表示内容の更新間隔
    private let updateInterval: Double = 5
    
    /// 最大行数
    private let maxLineCount: Int = 30
    
    /// 更新を司るタイマ
    private var updateTimer: Timer?
    
    /// シェルコマンドModel
    private var shellCommandModel: ShellCommandModel
    
    // MARK: - Initializers
    
    override init(widgetModel: WidgetModel, nibName: NSNib.Name? = nil, bundle: Bundle? = nil) throws {
        // TODO: ここでwidgetModelの値をもとにshellCommandModelやupdateInterval、processOutputViewを設定
        self.shellCommandModel = .init()
        try super.init(widgetModel: widgetModel)
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
        processOutputView.autoresizingMask = [.width, .height]
        self.view.addSubview(processOutputView)
        self.shellCommandModel.delegate = self
    }
    
    override func viewWillAppear() {
        super.viewWillAppear()
        
        // 一回実行しておく
        self.shellCommandModel.requestForExecution()

        // タイマを構成
        updateTimer = .scheduledTimer(withTimeInterval: updateInterval, repeats: true, block: { [weak self] _ in
            guard let `self` = self else {return}
            self.shellCommandModel.requestForExecution()
        })
    }
    
    override func viewDidDisappear() {
        super.viewDidDisappear()
        
        // タイマを無効化
        updateTimer?.invalidate()
    }
}

extension ShellCommandViewController: ShellCommandModelDelegate {
    
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
