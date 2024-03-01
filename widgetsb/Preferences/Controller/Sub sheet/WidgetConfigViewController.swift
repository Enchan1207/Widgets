//
//  WidgetConfigViewController.swift
//  widgetsb
//
//  Created by EnchantCode on 2024/02/27.
//

import Cocoa

class WidgetConfigViewController: NSViewController {
    
    // MARK: - GUI components
    
    /// サブシート群を制御するコントローラ
    @IBOutlet weak var pageController: WidgetConfigPageController! {
        didSet {
            pageController.selectedIndex = 0
            pageController.arrangedObjects = pageIdentifiers
        }
    }
    
    /// サブシートを表示するビュー
    @IBOutlet weak var configView: NSView!
    
    /// 「次へ」ボタン
    @IBOutlet weak var nextButton: NSButton! {
        didSet{
            nextButton.isEnabled = false
        }
    }
    
    /// 「キャンセル」ボタン
    @IBOutlet weak var cancelButton: NSButton!
    
    // MARK: - Properties
    
    override var nibName: NSNib.Name? { "WidgetConfigView" }
    
    /// ページ識別子
    private enum PageIdentifier: NSPageController.ObjectIdentifier {
        /// 種別セレクタ
        case KindSelector
        
        /// 表示内容エディタ
        case ContentEditor
        
        /// ウィジェットアンカーエディタ
        case AnchorEditor
    }
    
    /// ページ識別子のリスト
    private let pageIdentifiers: [PageIdentifier]
    
    /// 現在選択されているウィジェットの型
    private var currentWidgetKindType: WidgetContent.Type? {
        didSet {
            nextButton.isEnabled = currentWidgetKindType != nil
        }
    }
    
    /// デリゲート
    weak var delegate: WidgetConfigViewControllerDelegate?
    
    /// コンフィグシートが保持しているウィンドウ状態インスタンス
    private var currentWidgetWindowState: WidgetWindowState
    
    /// コンフィグシートが保持しているウィジェットコンテンツインスタンス
    private var currentWidgetContent: WidgetContent?
    
    // MARK: - Initializers
    
    /// 内部ベースイニシャライザ
    /// - Parameters:
    ///   - pageIdentifiers: ページ識別子のリスト
    ///   - widgetState: ウィジェット状態
    ///   - widgetContent: ウィジェットコンテンツ
    private init(pageIdentifiers: [PageIdentifier], widgetState: WidgetWindowState?, widgetContent: WidgetContent?){
        self.pageIdentifiers = pageIdentifiers
        self.currentWidgetWindowState = widgetState ?? .init(visibility: .Show, frame: .init(origin: .zero, size: .init(width: 400, height: 300)))
        self.currentWidgetContent = widgetContent
        if let widgetContent = widgetContent {
            self.currentWidgetKindType = type(of: widgetContent)
        } else {
            self.currentWidgetKindType = nil
        }
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("config vc deinitiailized")
    }
    
    // MARK: - View lifecycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - GUI actions
    
    @IBAction func onClickNext(_ sender: Any) {
        // 現在のページが最終ページならシートを閉じ、デリゲートに通知する
        guard pageController.selectedIndex < pageIdentifiers.count - 1 else {
            self.delegate?.didPrepareNewWidget(self, state: currentWidgetWindowState, content: currentWidgetContent!)
            dismiss(nil)
            return
        }
        
        // 次のページへ移動する
        NSAnimationContext.runAnimationGroup { [weak self] context in
            guard let `self` = self else {return}
            context.duration = 1.0
            let nextIndex = pageController.selectedIndex + 1
            pageController.animator().selectedIndex = nextIndex
            
            // 移動後のページが最終ページなら、ラベルを「Finish」に変更する
            if nextIndex == pageIdentifiers.count - 1 {
                nextButton.title  = "Finish"
            }
        } completionHandler: { [weak self] in
            guard let `self` = self else {return}
            self.pageController.completeTransition()
        }
    }
    
    @IBAction func onClickCancel(_ sender: Any) {
        dismiss(nil)
    }
    
    // MARK: - Static methods
    
    /// VCを新規ウィジェット追加用に構成する
    /// - Returns: 構成されたVC
    static func widgetAdditionSheet() -> WidgetConfigViewController {
        .init(pageIdentifiers: [.KindSelector, .ContentEditor, .AnchorEditor], widgetState: nil, widgetContent: nil)
    }
    
    /// VCをウィジェットコンテンツ編集用に構成する
    /// - Parameter widgetContent: 編集対象のコンテンツ
    /// - Returns: 構成されたVC
    static func contentModificationSheet(widgetContent: WidgetContent) -> WidgetConfigViewController {
        .init(pageIdentifiers: [.ContentEditor], widgetState: nil, widgetContent: widgetContent)
    }
    
    /// VCをウィジェットアンカー編集用に構成する
    /// - Parameter widgetState: 編集対象のウィジェットアンカー
    /// - Returns: 構成されたVC
    static func stateModificationSheet(widgetState: WidgetWindowState) -> WidgetConfigViewController {
        .init(pageIdentifiers: [.AnchorEditor], widgetState: widgetState, widgetContent: nil)
    }
    
}

extension WidgetConfigViewController: NSPageControllerDelegate {
    
    func pageController(_ pageController: NSPageController, identifierFor object: Any) -> NSPageController.ObjectIdentifier {
        return (object as! PageIdentifier).rawValue
    }
    
    func pageController(_ pageController: NSPageController, viewControllerForIdentifier identifier: NSPageController.ObjectIdentifier) -> NSViewController {
        // 渡された識別子に対応するサブシートVCを生成して返す
        let viewController: NSViewController
        let pageIdentifier = PageIdentifier(rawValue: identifier)!
        switch pageIdentifier {
            
        case .KindSelector:
            viewController = WidgetKindSelectorViewController(widgetKindTypes: [
                ShellWidgetContent.self,
                MediaWidgetContent.self
            ])
            (viewController as! WidgetKindSelectorViewController).delegate = self
            
        case .ContentEditor:
            guard let widgetContent = currentWidgetContent else {fatalError("Widget content instance not set")}
            switch widgetContent {
                
            case let widgetContent as ShellWidgetContent:
                viewController = ShellWidgetContentEditorViewController(shellWidgetContent: widgetContent)
                
            case let widgetContent as MediaWidgetContent:
                viewController = MediaWidgetContentEditorViewController(mediaWidgetContent: widgetContent)
            
            case let widgetContent as WelcomeWidgetContent:
                viewController = WelcomeWidgetContentEditorViewController(welcomeWidgetContent: widgetContent)
                
            default:
                fatalError("Unknown content type: \(widgetContent.self)")
            }
            
        case .AnchorEditor:
            // ウィジェット状態への参照を渡してVC生成
            viewController = WidgetAnchorEditorViewController(widgetWindowState: currentWidgetWindowState)
            (viewController as! WidgetAnchorEditorViewController).delegate = self
        }
        
        return viewController
    }
    
}

extension WidgetConfigViewController: WidgetKindSelectorDelegate {
    
    func kindSelector(_ selector: WidgetKindSelectorViewController, didSelect kind: WidgetContent.Type) {
        currentWidgetKindType = kind
        
        // ユーザが選択した型に基づき、WidgetContentをそのデフォルト構成で生成しておく
        if currentWidgetContent == nil {
            currentWidgetContent = currentWidgetKindType?.initWithDefaultConfiguration()
        }
    }
    
}

extension WidgetConfigViewController: WidgetAnchorEditorDelegate {
    
    func anchorEditor(_ editor: WidgetAnchorEditorViewController, didChange widgetWindowState: WidgetWindowState) {
        currentWidgetWindowState = widgetWindowState
    }
    
}
