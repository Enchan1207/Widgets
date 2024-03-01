//
//  WidgetKindSelectorViewController.swift
//  widgetsb
//
//  Created by EnchantCode on 2024/02/29.
//

import Cocoa

/// ウィジェット種類セレクタ
class WidgetKindSelectorViewController: NSViewController {
    
    // MARK: - GUI components
    
    /// ウィジェット種類セレクタ
    @IBOutlet weak var kindSelectorBox: NSComboBox! {
        didSet {
            kindSelectorBox.delegate = self
            kindSelectorBox.usesDataSource = true
            kindSelectorBox.dataSource = self
            kindSelectorBox.isEditable = false
        }
    }
    
    /// ウィジェットの説明文
    @IBOutlet weak var descriptionField: NSTextField!
    
    // MARK: - Properties
    
    override var nibName: NSNib.Name? { "WidgetKindSelectorView" }
    
    /// ウィジェット種別のリスト
    private let widgetKindTypes: [WidgetContent.Type] = [
        // TODO: コントローラがこの情報を内部で握っているのはマズいかも (DI? Model追加?)
        ShellWidgetContent.self,
        MediaWidgetContent.self
    ]
    
    /// デリゲート
    weak var delegate: WidgetKindSelectorDelegate?
    
}

extension WidgetKindSelectorViewController: NSComboBoxDelegate {
    
    func comboBoxSelectionDidChange(_ notification: Notification) {
        guard let selectedKindType = widgetKindTypes[nullable: kindSelectorBox.indexOfSelectedItem] else {return}
        
        // 説明文を更新してデリゲートに通知
        descriptionField.stringValue = selectedKindType.longDescription
        self.delegate?.kindSelector(self, didSelect: selectedKindType)
    }
    
}

extension WidgetKindSelectorViewController: NSComboBoxDataSource {
    
    func numberOfItems(in comboBox: NSComboBox) -> Int {
        return widgetKindTypes.count
    }
    
    func comboBox(_ comboBox: NSComboBox, objectValueForItemAt index: Int) -> Any? {
        return widgetKindTypes[nullable: index]?.shortDescription
    }
    
}
