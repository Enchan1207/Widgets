//
//  ProcessInfoModel.swift
//  widgetsb
//
//  Created by EnchantCode on 2024/02/15.
//

import Foundation

/// プロセス情報モデル
class ProcessInfoModel: NSObject {
    
    // MARK: - Public properties
    
    /// プロセス情報の配列
    private (set) public var processInfos: [ProcessInfo] = [] {
        didSet{
            delegate?.processInfoDidUpdate()
        }
    }
    
    /// デリゲート
    public weak var delegate: ProcessInfoModelDelegate?
    
    // MARK: - Private properties
    
    /// フェッチするプロセスの最大数
    private var maxProcessCount: UInt = 0
    
    /// プロセスの標準出力
    private var psOutputPipe = Pipe()
    
    // MARK: - Public methods
    
    /// プロセス情報を更新する
    /// - Parameter maxProcessCount: フェッチするプロセスの最大数
    func fetchProcessInfo(maxProcessCount: UInt){
        // 最大数を保持しておく
        self.maxProcessCount = maxProcessCount
        
        // プロセスを準備して実行
        let process = configurePsProcess()
        psOutputPipe = Pipe()
        process.standardOutput = psOutputPipe.fileHandleForWriting
        do {
            try process.run()
        }catch{
            print("An error occured during fetch process information: \(error)")
        }
    }
    
    // MARK: - Private methods
    
    /// psコマンドを実行するプロセスを構成して返す
    /// - Returns: 構成されたProcessオブジェクト
    private func configurePsProcess() -> Process {
        let psProcess = Process()
        let commandPathStr = "/bin/ps"
        let commandURL: URL
        if #available(macOS 13.0, *) {
            commandURL = .init(filePath: commandPathStr)
        } else {
            commandURL = .init(fileURLWithPath: commandPathStr)
        }
        psProcess.executableURL = commandURL
        psProcess.arguments = ["acrx", "-o", "pid, %cpu, %mem, etime, command"]
        psProcess.standardError = nil
        psProcess.standardInput = nil
        psProcess.terminationHandler = onProcessInfoFetched
        return psProcess
    }
    
    /// プロセス情報の収集が完了したときの処理
    /// - Parameter process: プロセスオブジェクト
    private func onProcessInfoFetched(process: Process){
        guard process.terminationStatus == 0 else {
            print("Process returned unexpected termination status: \(process.terminationStatus)")
            return
        }
        
        // パイプを閉じる
        do{
            try psOutputPipe.fileHandleForWriting.close()
        }catch{
            print("An error occured during close stdout pipe: \(error)")
            return
        }
        
        // 出力を取得して文字列に変換
        guard let processOutputData = try? psOutputPipe.fileHandleForReading.readToEnd(),
              let processOutputStr = String(data: processOutputData, encoding: .utf8) else {return}
        
        // ヘッダ行を捨て、先頭から指定個数分のプロセス文字列を取り出す
        let processOutputLines = processOutputStr.split(separator: "\n")
        let fetchCount: Int
        if maxProcessCount < (processOutputLines.count - 1){
            fetchCount = Int(maxProcessCount)
        }else{
            fetchCount = processOutputLines.count - 1
        }
        let targetProcessLines: [String] = processOutputLines[1...fetchCount].map {.init($0)}
        
        // 出力をパースして構造体配列に変換し、更新
        processInfos = targetProcessLines.compactMap({parseInfo($0)})
    }
    
    /// psコマンドの出力をパースしてProcessInfo構造体を生成
    /// - Parameter infoStr: psコマンドの出力文字列
    /// - Returns: 生成結果。失敗した場合はnilが返ります。
    private func parseInfo(_ infoStr: String) -> ProcessInfo? {
        // 空白で区切る
        let pieces = infoStr.split(separator: " ")
        guard pieces.count >= 5 else {return nil}
        
        // 情報を取り出す
        guard let processID = UInt(pieces[0]),
              let cpuUsage = Double(pieces[1]),
              let memoryUsage = Double(pieces[2]),
              let elapsedTime = convertElapsedTimeStr(.init(pieces[3])) else {return nil}
        let commandName = pieces[4...].joined(separator: " ")
        
        return .init(pid: processID, cpuUsage: cpuUsage, memoryUsage: memoryUsage, elapsedTime: elapsedTime, commandName: commandName)
    }
    
    /// psコマンドが出力した経過時間文字列をTimeIntervalに変換する
    /// - Parameter timeStr: 経過時間文字列
    /// - Returns: 変換結果。失敗した場合はnilが返ります。
    private func convertElapsedTimeStr(_ timeStr: String) -> TimeInterval? {
        // :と-で分割し、逆転 最小でも 00:00 最大でも 00-00:00:00 にしかならないはずなので、要素数チェック
        let timeStrComponents = timeStr.components(separatedBy: [":", "-"]).filter{$0.count > 0}.compactMap{UInt($0)}.reversed()
        guard (2...4).contains(timeStrComponents.count) else {return nil}
        
        /**
         * ここではかなり面倒なことをやっている:
         *
         * 変数 timeStrComponents はこの時点で [(秒), (分), (時), (日) ] の順に並んでいる。
         * ここで、このそれぞれについて [1, 60, 3600, 86400] を乗じると、全要素の単位が (秒) となる。
         * あとはそれらを全て足せば (,reduce(0, +)) 経過秒数を取得することができる。
         * ここで、要素を逆転させているのは、timeStrComponents[0] が常に秒数を指すようにするため。
         *
         * DateFormatterでやろうとも考えたが、要素数が不定であるため断念した。
         */
        let multiplier: [UInt] = [1, 60, 3600, 86400]
        let elapsedSeconds = timeStrComponents.enumerated().map{$0.element * multiplier[$0.offset]}.reduce(0, +)
        return .init(elapsedSeconds)
    }
}