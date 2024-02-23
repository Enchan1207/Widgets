//
//  WidgetViewController.swift
//  widgetsb
//
//  Created by EnchantCode on 2024/02/20.
//

import Cocoa

/// ウィジェットVC
class WidgetViewController: NSViewController {
    
    // MARK: - Properties
    
    /// 表示内容
    private (set) public weak var widgetContent: WidgetContent?
    
    // MARK: - Initializers
    
    init(widgetContent: WidgetContent) {
        self.widgetContent = widgetContent
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
