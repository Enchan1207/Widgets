//
//  ProcessMonitorViewController.swift
//  widgetsb
//
//  Created by EnchantCode on 2024/02/15.
//

import Cocoa

class ProcessMonitorViewController: NSViewController {
    
    // MARK: - GUI Components
    
    @IBOutlet weak var processTextField: NSTextField!
    
    // MARK: - Properties
    
    /// 表示内容の更新間隔
    private let updateInterval: Double = 10
    
    /// 更新を司るタイマ
    private var updateTimer: Timer?
    
    /// プロセス情報Model
    private weak var processInfoModel: ProcessInfoModel?
    
    // MARK: - Initializers
    
    init(processInfoModel: ProcessInfoModel?){
        self.processInfoModel = processInfoModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear() {
        super.viewWillAppear()
        
        // 一番最初に一回だけ発火し、タイマを構成
        onUpdate(timer: nil)
        updateTimer = .scheduledTimer(withTimeInterval: updateInterval, repeats: true, block: onUpdate)
    }
    
    override func viewDidDisappear() {
        super.viewDidDisappear()
        
        updateTimer?.invalidate()
    }
    
    // MARK: - Private methods
    
    /// タイマ更新時の処理
    /// - Parameter timer: タイマ
    private func onUpdate(timer: Timer?) {
        processTextField.stringValue = "\(Date.timeIntervalBetween1970AndReferenceDate)"
        
    }
    
}
