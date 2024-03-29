//
//  ProcessRunner.swift
//  widgetsb
//
//  Created by EnchantCode on 2024/02/15.
//

import Foundation

/// コマンドランナー
final class ProcessRunner {
    
    // MARK: - Public properties
    
    /// デリゲート
    public weak var delegate: ProcessRunnerDelegate?
    
    /// 現在実行中のプロセス
    private (set) public var process = Process()
    
    // MARK: - Private properties
    
    /// プロセスの標準出力
    private var processOutputPipe = Pipe()
    
    // MARK: - Initializers
    
    // TODO: 実行するコマンドをイニシャライザでも挿入できるようにする?
    /*
     init(command: Command){
     ...
     }
     */
    
    // MARK: - Public methods
    
    /// モデルが保持するプロセスの実行を要求する
    ///  - Note: 実行結果はデリゲートメソッド経由で与えられます。
    func requestForExecution(){
        configureProcess()
        processOutputPipe = .init()
        process.standardOutput = processOutputPipe.fileHandleForWriting
        do {
            try process.run()
        }catch{
            print("An error occured during command execution: \(error)")
            
            // デリゲートに通知
            delegate?.runner(self, processDidFail: error)
        }
    }
    
    // MARK: - Private methods
    
    /// プロセスを構成して返す
    /// - Returns: 構成されたProcessオブジェクト
    private func configureProcess() {
        let commandPathStr = "/bin/ps"
        let commandURL: URL
        if #available(macOS 13.0, *) {
            commandURL = .init(filePath: commandPathStr)
        } else {
            commandURL = .init(fileURLWithPath: commandPathStr)
        }
        process = .init()
        process.executableURL = commandURL
        process.arguments = ["acrx", "-o", "pid, %cpu, %mem, etime, command"]
        process.standardError = nil
        process.standardInput = nil
        process.terminationHandler = onProcessTerminated
    }
    
    /// プロセス終了時の処理
    /// - Parameter process: プロセスオブジェクト
    private func onProcessTerminated(process: Process){
        // パイプを閉じる
        do{
            try processOutputPipe.fileHandleForWriting.close()
        }catch{
            print("An error occured during close stdout pipe: \(error)")
        }
        
        // デリゲートに通知
        guard let processOutputData = try? processOutputPipe.fileHandleForReading.readToEnd() else {return}
        delegate?.runner(self, processDidTerminate: processOutputData)
    }
}
