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
    @IBOutlet weak var horizontalAlignSelector: NSSegmentedControl! {
        didSet {
            guard let horizontalAlignment = widgetWindowState?.horizontalAlignment else {return}
            horizontalAlignSelector.selectedSegment = horizontalAlignment.toSegmentIndex
        }
    }
    
    /// 水平方向アライメントラベル
    @IBOutlet weak var horizontalAlignmentLabel: NSTextField! {
        didSet {
            guard let horizontalAlignment = widgetWindowState?.horizontalAlignment else {return}
            horizontalAlignmentLabel.stringValue = horizontalAlignment.rawValue
        }
    }
    
    /// 垂直方向アライメントセレクタ
    @IBOutlet weak var verticalAlignSelector: NSSegmentedControl! {
        didSet {
            guard let verticalAlignment = widgetWindowState?.verticalAlignment else {return}
            verticalAlignSelector.selectedSegment = verticalAlignment.toSegmentIndex
        }
    }
    
    /// 垂直方向アライメントラベル
    @IBOutlet weak var verticalAlignmentLabel: NSTextField! {
        didSet {
            guard let verticalAlignment = widgetWindowState?.verticalAlignment else {return}
            verticalAlignmentLabel.stringValue = verticalAlignment.rawValue
        }
    }
    
    /// 幅フィールド
    @IBOutlet weak var widthField: NSTextField! {
        didSet {
            widthField.tag = GeometryTag.width.rawValue
            widthField.formatter = configureNumberFormatter()
        }
    }
    
    /// 幅単位セレクタ
    @IBOutlet weak var widthUnitSelector: NSComboBox! {
        didSet {
            widthUnitSelector.usesDataSource = true
            widthUnitSelector.delegate = self
            widthUnitSelector.dataSource = self
            widthUnitSelector.tag = GeometryTag.width.rawValue
        }
    }
    
    /// 高さフィールド
    @IBOutlet weak var heightField: NSTextField! {
        didSet {
            heightField.tag = GeometryTag.height.rawValue
            heightField.formatter = configureNumberFormatter()
        }
    }
    
    /// 高さ単位セレクタ
    @IBOutlet weak var heightUnitSelector: NSComboBox! {
        didSet {
            heightUnitSelector.usesDataSource = true
            heightUnitSelector.delegate = self
            heightUnitSelector.dataSource = self
            heightUnitSelector.tag = GeometryTag.height.rawValue
        }
    }
    
    /// x方向インセットフィールド
    @IBOutlet weak var insetXField: NSTextField! {
        didSet {
            insetXField.tag = GeometryTag.insetX.rawValue
            insetXField.formatter = configureNumberFormatter()
        }
    }
    
    /// x方向単位セレクタ
    @IBOutlet weak var insetXUnitSelector: NSComboBox! {
        didSet {
            insetXUnitSelector.usesDataSource = true
            insetXUnitSelector.delegate = self
            insetXUnitSelector.dataSource = self
            insetXUnitSelector.tag = GeometryTag.insetX.rawValue
        }
    }
    
    /// y方向インセットフィールド
    @IBOutlet weak var insetYField: NSTextField! {
        didSet {
            insetYField.tag = GeometryTag.insetY.rawValue
            insetYField.formatter = configureNumberFormatter()
        }
    }
    
    /// y方向単位セレクタ
    @IBOutlet weak var insetYUnitSelector: NSComboBox! {
        didSet {
            insetYUnitSelector.usesDataSource = true
            insetYUnitSelector.delegate = self
            insetYUnitSelector.dataSource = self
            insetYUnitSelector.tag = GeometryTag.insetY.rawValue
        }
    }
    
    // MARK: - Properties
    
    private enum GeometryTag: Int {
        case width = 0
        case height = 1
        case insetX = 2
        case insetY = 3
    }
    
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
        
        if let widgetWindowState = widgetWindowState {
            updateGeometryUI(to: .width, from: widgetWindowState.windowWidth)
            updateGeometryUI(to: .height, from: widgetWindowState.windowHeight)
            updateGeometryUI(to: .insetX, from: widgetWindowState.insetX)
            updateGeometryUI(to: .insetY, from: widgetWindowState.insetY)
        }
    }
    
    // MARK: - GUI actions
    
    @IBAction func didHorizontalSelectionChange(_ sender: Any) {
        guard let horizontalAlignment = WidgetHorizontalAlignment.fromSegmentIndex(horizontalAlignSelector.selectedSegment) else {return}
        horizontalAlignmentLabel.stringValue = horizontalAlignment.rawValue
        widgetWindowState?.horizontalAlignment = horizontalAlignment
    }
    
    @IBAction func didVerticalSelectionChange(_ sender: Any) {
        guard let verticalAlignment = WidgetVerticalAlignment.fromSegmentIndex(verticalAlignSelector.selectedSegment) else {return}
        verticalAlignmentLabel.stringValue = verticalAlignment.rawValue
        widgetWindowState?.verticalAlignment = verticalAlignment
    }
    
    @IBAction func didValueFieldChange(_ sender: NSTextField) {
        // どのフィールドから送られてきたものかを特定し、ジオメトリを生成して割り当て
        guard let fieldTag = GeometryTag(rawValue: sender.tag) else {return}
        let newGeometry = createGeometry(from: fieldTag)
        updateGeometryModel(to: fieldTag, with: newGeometry)
    }
    
    // MARK: - Private methods
    
    /// ジオメトリの値をGUIに反映する
    /// - Parameters:
    ///   - tag: 反映先
    ///   - from: 反映するジオメトリの値
    private func updateGeometryUI(to tag: GeometryTag, from: WidgetGeometry){
        let valueField: NSTextField
        let targetUnitSelector: NSComboBox
        switch tag {
        case .width:
            valueField = widthField
            targetUnitSelector = widthUnitSelector
        case .height:
            valueField = heightField
            targetUnitSelector = heightUnitSelector
        case .insetX:
            valueField = insetXField
            targetUnitSelector = insetXUnitSelector
        case .insetY:
            valueField = insetYField
            targetUnitSelector = insetYUnitSelector
        }
        
        switch from {
        case .Pixel(let n):
            valueField.intValue = .init(n)
            targetUnitSelector.selectItem(at: 0)
        case .Screen(let n):
            valueField.doubleValue = n
            targetUnitSelector.selectItem(at: 1)
        }
    }
    
    /// 現在のGUIに設定されている値からジオメトリを生成
    /// - Parameter from: GUIを表すタグ
    /// - Returns:生成されたジオメトリ
    private func createGeometry(from tag: GeometryTag) -> WidgetGeometry {
        let valueField: NSTextField
        let targetUnitSelector: NSComboBox
        switch tag {
        case .width:
            valueField = widthField
            targetUnitSelector = widthUnitSelector
        case .height:
            valueField = heightField
            targetUnitSelector = heightUnitSelector
        case .insetX:
            valueField = insetXField
            targetUnitSelector = insetXUnitSelector
        case .insetY:
            valueField = insetYField
            targetUnitSelector = insetYUnitSelector
        }
        let selectedUnitIndex = targetUnitSelector.indexOfSelectedItem
        
        let geometry: WidgetGeometry = selectedUnitIndex == 0 ? .Pixel(.init(valueField.intValue)) : .Screen(valueField.doubleValue)
        return geometry
    }
    
    /// 指定されたタグが示すジオメトリの値を設定
    /// - Parameters:
    ///   - tag: タグ
    ///   - geometry: 設定するジオメトリの値
    private func updateGeometryModel(to tag: GeometryTag, with geometry: WidgetGeometry){
        guard let widgetWindowState = widgetWindowState else {return}
        switch tag {
        case .width:
            widgetWindowState.windowWidth = geometry
        case .height:
            widgetWindowState.windowHeight = geometry
        case .insetX:
            widgetWindowState.insetX = geometry
        case .insetY:
            widgetWindowState.insetY = geometry
        }
    }
    
    /// フィールド用の数値フォーマッタを構成する
    /// - Returns: フォーマッタ
    private func configureNumberFormatter() -> NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.allowsFloats = true
        return formatter
    }
}

extension WidgetAnchorEditorViewController: NSComboBoxDelegate {
    
    func comboBoxSelectionDidChange(_ notification: Notification) {
        // 単位セレクタからのものであることを確認し、どのセレクタから送られてきたものかを特定
        let unitSelector = notification.object as! NSComboBox
        guard let selectorTag = GeometryTag(rawValue: unitSelector.tag) else {return}
        
        // 新たなジオメトリを生成し、割り当て
        let newGeometry = createGeometry(from: selectorTag)
        updateGeometryModel(to: selectorTag, with: newGeometry)
    }
    
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
    
    func widget(_ windowState: WidgetWindowState, didChangeVisibility visibility: WidgetVisibility) {
        // アンカーエディタでは何もしない
    }
    
    func didChangePositionInfo(_ windowState: WidgetWindowState) {
        // 各UIを更新する
        updateGeometryUI(to: .width, from: windowState.windowWidth)
        updateGeometryUI(to: .height, from: windowState.windowHeight)
        updateGeometryUI(to: .insetX, from: windowState.insetX)
        updateGeometryUI(to: .insetY, from: windowState.insetY)
    }
    
}

fileprivate extension WidgetHorizontalAlignment {
    
    /// segment-controlのインデックスに変換
    var toSegmentIndex: Int { [.Left : 0, .Center : 1, .Right : 2][self]! }
    
    /// segmentインデックスに対応するアライメントを返す
    static func fromSegmentIndex(_ index: Int) -> WidgetHorizontalAlignment? {
        [0: .Left, 1: .Center, 2: .Right][index]
    }
    
}

fileprivate extension WidgetVerticalAlignment {
    
    /// segment-controlのインデックスに変換
    var toSegmentIndex: Int { [.Top : 0, .Middle : 1, .Bottom : 2][self]! }
    
    /// segmentインデックスに対応するアライメントを返す
    static func fromSegmentIndex(_ index: Int) -> WidgetVerticalAlignment? {
        [0: .Top, 1: .Middle, 2: .Bottom][index]
    }
    
}
