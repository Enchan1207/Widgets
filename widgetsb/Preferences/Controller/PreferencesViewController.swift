//
//  PreferencesViewController.swift
//  widgetsb
//
//  Created by EnchantCode on 2024/02/27.
//

import Cocoa

class PreferencesViewController: NSViewController {

    // MARK: - GUI components
    
    /// ウィジェットリスト
    @IBOutlet weak var widgetsListView: NSTableView! {
        didSet {
            self.widgetsListView.delegate = self
            self.widgetsListView.dataSource = self
        }
    }
    
    /// 追加ボタン
    @IBOutlet weak var addButton: NSButton!
    
    /// 削除ボタン
    @IBOutlet weak var removeButton: NSButton! {
        didSet{
            removeButton.isEnabled = false
        }
    }
    
    /// ウィジェット編集ボタン
    @IBOutlet weak var configureButton: NSButton! {
        didSet{
            configureButton.isEnabled = false
        }
    }
    
    // MARK: - Properties
    
    override var nibName: NSNib.Name? { "PreferencesView" }
    
    /// ウィジェットコレクション
    private weak var widgetCollection: WidgetCollection?
    
    // MARK: - Initializers
    
    init(widgetCollection: WidgetCollection){
        self.widgetCollection = widgetCollection
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.widgetCollection?.delegate = self
    }
    
    // MARK: - GUI actions
    
    @IBAction func onClickAdd(_ sender: Any) {
        // TODO: 構成ダイアログを出す
        widgetCollection?.addWidget(.init(windowState: .init(visibility: .Show, frame: .init(origin: .zero, size: .init(width: 100, height: 200))), content: ShellWidgetContent(maxLines: 30, updateInterval: 2)))
    }
    
    @IBAction func onClickRemove(_ sender: Any) {
        guard widgetsListView.selectedRow >= 0 else {return}
        widgetCollection?.removeWidget(at: widgetsListView.selectedRow)
    }
    
    @IBAction func onClickEdit(_ sender: Any) {
        self.presentAsSheet(WidgetConfigViewController())
    }
    
    @objc private func onClickVisibie(_ sender: NSButton){
        // クリックされたチェックボックスが属する行を取得
        let selectedIndex = widgetsListView.row(for: sender)
        guard selectedIndex >= 0 else {return}
        
        // 反映
        widgetCollection?.widgets[selectedIndex].windowState.visibility = sender.state == .on ? .Show : .Hide
    }
    
    @IBAction func onClickQuit(_ sender: Any) {
        NSApp.terminate(nil)
    }
    
}

extension PreferencesViewController: WidgetCollectionDelegate {
    
    func widgetCollection(_ collection: WidgetCollection, didAddAt index: Int) {
        widgetsListView.beginUpdates()
        widgetsListView.insertRows(at: [index], withAnimation: .slideUp)
        widgetsListView.endUpdates()
    }
    
    func widgetCollection(_ collection: WidgetCollection, shouldRemoveAt index: Int) -> Bool {
        // 削除ダイアログを表示する
        let deletionAlert = NSAlert()
        deletionAlert.messageText = "Remove this widget?"
        deletionAlert.informativeText = "You can also hide it instead of removing it."
        deletionAlert.addButton(withTitle: "Cancel")
        deletionAlert.buttons[0].tag = NSApplication.ModalResponse.cancel.rawValue
        deletionAlert.addButton(withTitle: "Remove")
        deletionAlert.buttons[1].hasDestructiveAction = true
        
        let response = deletionAlert.runModal()
        return response != .cancel
    }
    
    func widgetCollection(_ collection: WidgetCollection, willRemoveAt index: Int) {
        widgetsListView.beginUpdates()
        widgetsListView.removeRows(at: [index], withAnimation: .slideUp)
        widgetsListView.endUpdates()
    }
    
}

extension PreferencesViewController: NSTableViewDelegate {
    
    func tableViewSelectionDidChange(_ notification: Notification) {
        let isRowSelected = widgetsListView.selectedRow >= 0
        removeButton.isEnabled = isRowSelected
        configureButton.isEnabled = isRowSelected
    }
    
}

extension PreferencesViewController: NSTableViewDataSource {
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        // rowインデックスに対応するwidgetオブジェクトを取得
        guard let targetWidget = widgetCollection?.widgets[nullable: row] else {return nil}
        
        // カラム識別子からセルビューを生成、ウィジェットの参照を渡してセルを構成
        guard let cell = tableView.makeView(withIdentifier: tableColumn!.identifier, owner: nil) as? NSTableCellView else {return nil}
        (cell as? PreferenceCellView)?.configure(with: targetWidget)
        
        // 表示切り替えセルならアクションを設定
        if let cell = cell as? VisibilityCellView {
            cell.visibilityButton.target = self
            cell.visibilityButton.action = #selector(onClickVisibie)
        }
        
        return cell
    }
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return widgetCollection?.widgets.count ?? 0
    }
    
}

