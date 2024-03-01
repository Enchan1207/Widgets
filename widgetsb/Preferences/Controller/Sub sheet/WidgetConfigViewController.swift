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
    
    private let vcs: [NSViewController] = [
        WidgetKindSelectorViewController()
    ]
    
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
    
    /// シートオープン時に与えられたウィンドウ状態
    private weak var currentWidgetWindowState: WidgetWindowState?
    
    ///　シートオープン時に与えられたウィジェットコンテンツ
    private weak var currentWidgetContent: WidgetContent?
    
    // MARK: - Initializers
    
    /// 内部ベースイニシャライザ
    /// - Parameters:
    ///   - pageIdentifiers: ページ識別子のリスト
    ///   - widgetState: ウィジェット状態
    ///   - widgetContent: ウィジェットコンテンツ
    private init(pageIdentifiers: [PageIdentifier], widgetState: WidgetWindowState?, widgetContent: WidgetContent?){
        self.pageIdentifiers = pageIdentifiers
        self.currentWidgetWindowState = widgetState
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
    
    /// ウィジェット追加画面を構成する
    convenience init() {
        self.init(pageIdentifiers: [.KindSelector, .ContentEditor, .AnchorEditor], widgetState: nil, widgetContent: nil)
    }
    
    /// ウィジェットコンテンツ編集画面を構成する
    convenience init(widgetContent: WidgetContent?) {
        self.init(pageIdentifiers: [.ContentEditor], widgetState: nil, widgetContent: widgetContent)
    }
    
    /// ウィジェットアンカー編集画面を構成する
    convenience init(widgetState: WidgetWindowState?) {
        self.init(pageIdentifiers: [.AnchorEditor], widgetState: widgetState, widgetContent: nil)
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
            // TODO: デリゲートに通知
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
        // TODO: デリゲートに通知
        dismiss(nil)
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
            viewController = WidgetKindSelectorViewController()
            (viewController as! WidgetKindSelectorViewController).delegate = self
            
        case .ContentEditor:
            // ウィジェット表示内容の型が与えられている前提で、ウィジェットコンテンツが渡されていればそれを用い、そうでなければデフォルトコンテンツを生成
            // TODO: ここでデフォルト構成を生成しちゃうと面倒なことになる(weakなのでインスタンスが解放される可能性がある)
            guard let widgetKindType = currentWidgetKindType else {fatalError("Content modification requested but member currentWidgetKindType is not set")}
            let widgetContent = currentWidgetContent ?? widgetKindType.initWithDefaultConfiguration()
            
            // TODO: エディタがWidgetContentで型分岐するのは正直どうなの
            switch widgetContent {
                
            case let widgetContent as ShellWidgetContent:
                viewController = ShellWidgetContentEditorViewController(shellWidgetContent: widgetContent)
                
            case let widgetContent as MediaWidgetContent:
                viewController = MediaWidgetContentEditorViewController(mediaWidgetContent: widgetContent)
                
            default:
                fatalError("Unknown content type: \(widgetContent.self)")
            }
            
        case .AnchorEditor:
            // ウィジェット状態への参照を渡してVC生成 状態がなければこの場で作る
            // TODO: ここでデフォルト構成を生成しちゃうと面倒なことになる(weakなのでインスタンスが解放される可能性がある)
            let widgetWindowState = currentWidgetWindowState ?? .init(visibility: .Show, frame: .init(origin: .zero, size: .init(width: 400, height: 300)))
            viewController = WidgetAnchorEditorViewController(widgetWindowState: widgetWindowState)
            (viewController as! WidgetAnchorEditorViewController).delegate = self
             
        }
        
        return viewController
    }
    
}

extension WidgetConfigViewController: WidgetKindSelectorDelegate {
    
    func kindSelector(_ selector: WidgetKindSelectorViewController, didSelect kind: WidgetContent.Type) {
        currentWidgetKindType = kind
    }
    
}

extension WidgetConfigViewController: WidgetAnchorEditorDelegate {
    
    func anchorEditor(_ editor: WidgetAnchorEditorViewController, didChange widgetWindowState: WidgetWindowState) {
        currentWidgetWindowState = widgetWindowState
    }
    
}
