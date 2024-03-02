//
//  WidgetAnchorEditorViewController.swift
//  widgetsb
//
//  Created by EnchantCode on 2024/02/29.
//

import Cocoa

/// ウィジェットアンカーエディタ
class WidgetAnchorEditorViewController: NSViewController {
    
    // MARK: - GUI components
    
    /// 水平方向アライメントセレクタ
    @IBOutlet weak var horizontalAlignSelector: NSSegmentedControl!
    
    /// 水平方向アライメントラベル
    @IBOutlet weak var horizontalAlignmentLabel: NSTextField!
    
    /// 垂直方向アライメントセレクタ
    @IBOutlet weak var verticalAlignSelector: NSSegmentedControl!
    
    /// 垂直方向アライメントラベル
    @IBOutlet weak var verticalAlignmentLabel: NSTextField!
    
    /// x方向インセットフィールド
    @IBOutlet weak var insetXField: NSTextField! {
        didSet {
            let formatter = NumberFormatter()
            formatter.numberStyle = .decimal
            // formatter.allowsFloats = false
            insetXField.formatter = formatter
        }
    }
    
    /// x方向単位セレクタ
    @IBOutlet weak var insetXUnitSelector: NSComboBox! {
        didSet {
            insetXUnitSelector.usesDataSource = true
            insetXUnitSelector.delegate = self
            insetXUnitSelector.dataSource = self
        }
    }
    
    /// y方向インセットフィールド
    @IBOutlet weak var insetYField: NSTextField! {
        didSet {
            let formatter = NumberFormatter()
            formatter.numberStyle = .decimal
            // formatter.allowsFloats = false
            insetYField.formatter = formatter
        }
    }
    
    /// y方向単位セレクタ
    @IBOutlet weak var insetYUnitSelector: NSComboBox! {
        didSet {
            insetYUnitSelector.usesDataSource = true
            insetYUnitSelector.delegate = self
            insetYUnitSelector.dataSource = self
        }
    }
    
    // MARK: - Properties
    
    private weak var widgetWindowState: WidgetWindowState?
    
    override var nibName: NSNib.Name? { "WidgetAnchorEditorView" }
    
    /// デリゲート
    weak var delegate: WidgetAnchorEditorDelegate?

    // MARK: - Initializers
    
    init(widgetWindowState: WidgetWindowState? = nil) {
        self.widgetWindowState = widgetWindowState
        super.init(nibName: nil, bundle: nil)
        self.widgetWindowState?.delegates.addDelegate(self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        widgetWindowState?.delegates.removeDelegate(self)
    }
    
    // MARK: - View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - GUI actions
    
    @IBAction func didHorizontalSelectionChange(_ sender: Any) {
        print(horizontalAlignSelector.selectedSegment)
    }
    
    @IBAction func didVerticalSelectionChange(_ sender: Any) {
        print(verticalAlignSelector.selectedSegment)
    }
    
}

extension WidgetAnchorEditorViewController: NSComboBoxDelegate {
    
}

extension WidgetAnchorEditorViewController: NSComboBoxDataSource {
    
    func numberOfItems(in comboBox: NSComboBox) -> Int {
        return 2
    }
    
    func comboBox(_ comboBox: NSComboBox, objectValueForItemAt index: Int) -> Any? {
        return ["px", "%"][nullable: index]
    }
    
}

extension WidgetAnchorEditorViewController: WidgetWindowStateDelegate {
    
    func widget(_ windowState: WidgetWindowState, didChange visibility: WidgetVisibility) {
        print("\(#file) \(visibility)")
    }
    
    func widget(_ windowState: WidgetWindowState, didChange frame: NSRect) {
        print("\(#file) \(frame)")
    }
    
}
