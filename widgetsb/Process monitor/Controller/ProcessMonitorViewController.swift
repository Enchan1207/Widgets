//
//  ProcessMonitorViewController.swift
//  widgetsb
//
//  Created by EnchantCode on 2024/02/15.
//

import Cocoa

class ProcessMonitorViewController: NSViewController {
    
    @IBOutlet weak var processTextField: NSTextField!
    
    /// 表示内容の更新間隔
    private let updateInterval: Double = 10
    
    /// 更新を司るタイマ
    private var updateTimer: Timer?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear() {
        super.viewWillAppear()
        
        updateTimer = .scheduledTimer(withTimeInterval: updateInterval, repeats: true, block: onUpdate)
    }
    
    override func viewDidDisappear() {
        super.viewDidDisappear()
        
        updateTimer?.invalidate()
    }
    
    
    /// タイマ更新時の処理
    /// - Parameter timer: タイマ
    private func onUpdate(timer: Timer) {
        
        
    }
    
}
