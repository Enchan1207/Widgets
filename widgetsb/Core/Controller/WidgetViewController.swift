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
    
    /// ウィジェットModelへの参照
    private (set) public weak var widgetModel: WidgetModel?
    
    // MARK: - Initializers
    
    /// ウィジェットモデルを渡して初期化
    /// - Parameter widgetModel: ウィジェットModelインスタンス
    /// - Parameter nibName: nibファイル名
    /// - Parameter bundle: nibが属するBundle
    init(widgetModel: WidgetModel, nibName: NSNib.Name? = nil, bundle: Bundle? = nil) throws {
        self.widgetModel = widgetModel
        super.init(nibName: nibName, bundle: bundle)
    }
    
    /// ウィジェットモデルを渡さずに初期化
    /// - Parameters:
    ///   - nibName: nibファイル名
    ///   - bundle: nibが属するBundle
    /// - Note: このイニシャライザはフォールバックVCを生成するためのものです。通常は使用する必要はありません。
    override init(nibName: NSNib.Name?, bundle: Bundle?) {
        super.init(nibName: nibName, bundle: bundle)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
