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

    // MARK: - Initializers
    
    init(widgets: [Widget]){
        // ウィジェットが一つもなければウェルカムウィジェットを表示する
        if widgets.count > 0 {
            self.widgets = widgets
        }else{
            self.widgets = [.init(windowState: .init(visibility: .Show, frame: .init(origin: .zero, size: .init(width: 400, height: 300))), content: WelcomeWidgetContent())]
        }
        
        // ウィンドウコントローラを初期化しておく
        self.widgetWindowControllers = self.widgets.compactMap({.init(widget: $0)})
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
        self.delegate?.widgetCollection(self, didAddAt: widgets.count - 1)
    }
    
    /// ウィジェットを削除する
    /// - Parameter at: インデックス
    func removeWidget(at: Int){
        // デリゲートが設定されている場合は削除可能か調べる そうでなければ普通に消す
        let canRemove: Bool
        if let delegate = self.delegate {
            canRemove = delegate.widgetCollection(self, shouldRemoveAt: at)
        }else{
            canRemove = true
        }
        guard canRemove else {return}
        
        // 削除前にデリゲートに通知
        self.delegate?.widgetCollection(self, willRemoveAt: at)
        
        // ウィンドウを閉じ、WCを削除してからモデルクラスを消す
        self.widgetWindowControllers[at].close()
        self.widgetWindowControllers.remove(at: at)
        self.widgets.remove(at: at)
    }
    
}
