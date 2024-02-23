//
//  WidgetCollection.swift
//  widgetsb
//
//  Created by EnchantCode on 2024/02/23.
//

import Foundation

/// ウィジェットコレクション
final class WidgetCollection {
    
    // MARK: - Properties
    
    private (set) public var widgets: [Widget]
    
    private var widgetWindowControllers: [WidgetWindowController]
    
    weak var delegate: WidgetCollectionDelegate?
    
    /// エンコード/デコードの際に使われるキー
    private enum CodingKeys: String, CodingKey {
        case widgets
    }
    
    // MARK: - Initializers
    
    init(widgets: [Widget]){
        self.widgets = widgets
        self.widgetWindowControllers = widgets.compactMap({.init(widget: $0)})
    }
    
    // MARK: - Public methods
    
    /// コレクションが持つすべてのウィジェットを表示する
    /// - Note: 非表示にマークされているウィジェットは表示されません。
    func showWidgets(){
        self.widgetWindowControllers.forEach({$0.showWindow(nil)})
    }
    
    /// すべてのウィジェットを閉じる
    func closeWindows(){
        self.widgetWindowControllers.forEach({$0.close()})
    }
    
    /// ウィジェットを追加する
    /// - Parameter widget: 追加するウィジェット
    func addWidget(_ widget: Widget){
        // WC生成
        let windowController = WidgetWindowController(widget: widget)
        self.widgets.append(widget)
        self.widgetWindowControllers.append(windowController)
        
        // 生成したWCを表示
        windowController.showWindow(nil)
        
        // 追加後にデリゲートに通知
        self.delegate?.widgetCollection(self, didAdd: widget)
    }
    
    /// ウィジェットを削除する
    /// - Parameter at: インデックス
    func removeWidget(at: Int){
        // デリゲートが設定されている場合は削除可能か調べる そうでなければ普通に消す
        let canRemove: Bool
        if let delegate = self.delegate {
            canRemove = delegate.widgetCollection(self, shouldRemove: widgets[at])
        }else{
            canRemove = true
        }
        guard canRemove else {return}
        
        // 削除前にデリゲートに通知
        self.delegate?.widgetCollection(self, willRemove: widgets[at])
        self.widgets.remove(at: at)
    }
    
}


extension WidgetCollection: Codable {
    
    convenience init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        let widgets = try values.decode([Widget].self, forKey: .widgets)
        self.init(widgets: widgets)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(widgets, forKey: .widgets)
    }
    
}
