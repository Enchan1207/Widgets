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
    
    private lazy var processInfoView = ProcessInfoView(frame: self.view.bounds)
    
    // MARK: - Properties
    
    
    // TODO: このあたりを「ウィジェットウィンドウコレクションのModel」としてまとめて持って、preferenceとかから変更できるようにする?
    
    /// 表示内容の更新間隔
    private let updateInterval: Double = 5
    
    /// フェッチするプロセスの最大数
    private var maxProcessCount: UInt = 30
    
    /// 更新を司るタイマ
    private var updateTimer: Timer?
    
    /// プロセス情報Model
    private lazy var processInfoModel = ProcessInfoModel()
    
    // MARK: - View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        processInfoView.autoresizingMask = [.width, .height]
        self.view.addSubview(processInfoView)
        self.processInfoModel.delegate = self
    }
    
    override func viewWillAppear() {
        super.viewWillAppear()
        
        // TODO: タイマはここで制御されるべきなのか? ウィンドウコントローラが持つべきか?
        // タイマを構成
        updateTimer = .scheduledTimer(withTimeInterval: updateInterval, repeats: true, block: { [weak self] _ in
            guard let `self` = self else {return}
            self.processInfoModel.fetchProcessInfo(maxProcessCount: self.maxProcessCount)
        })
    }
    
    override func viewDidDisappear() {
        super.viewDidDisappear()
        
        // タイマを無効化
        updateTimer?.invalidate()
    }
}

extension ProcessMonitorViewController: ProcessInfoModelDelegate {
    
    func processInfoDidUpdate() {
        processInfoView.string = "Hello!\nHello!\nHello!\nHello!\nHello!\n"
    }
}
