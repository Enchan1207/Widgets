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
    private let widgetKindTypes: [WidgetContent.Type]
    
    /// デリゲート
    weak var delegate: WidgetKindSelectorDelegate?
    
    // MARK: - Initializers
    
    init(widgetKindTypes: [WidgetContent.Type]){
        self.widgetKindTypes = widgetKindTypes
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
