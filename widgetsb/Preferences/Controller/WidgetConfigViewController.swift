//
//  WidgetConfigViewController.swift
//  widgetsb
//
//  Created by EnchantCode on 2024/02/27.
//

import Cocoa

class WidgetConfigViewController: NSViewController {
    
    @IBOutlet weak var pageController: WidgetConfigPageController!
    
    @IBOutlet weak var configView: NSView!
    
    override var nibName: NSNib.Name? { "WidgetConfigView" }
    
    private let vcs: [ShellWidgetViewController] = [.init(widgetContent: .init(maxLines: 2, updateInterval: 100)), .init(widgetContent: .init(maxLines: 2, updateInterval: 100)), .init(widgetContent: .init(maxLines: 2, updateInterval: 100)), .init(widgetContent: .init(maxLines: 2, updateInterval: 100))]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        vcs.forEach({$0.view.frame = self.view.bounds})
        pageController.selectedIndex = 0
        pageController.arrangedObjects = Array(0..<vcs.count)
    }
    
    @IBAction func onClickNext(_ sender: Any) {
        NSAnimationContext.runAnimationGroup { [weak self] context in
            guard let `self` = self else {return}
            context.duration = 1.0
            let currentIndex = self.pageController.selectedIndex
            self.pageController.animator().selectedIndex = currentIndex + 1
        }
    }
    
    @IBAction func onClickCancel(_ sender: Any) {
        dismiss(nil)
    }
    
}

extension WidgetConfigViewController: NSPageControllerDelegate {
    
    func pageController(_ pageController: NSPageController, identifierFor object: Any) -> NSPageController.ObjectIdentifier {
        guard let vcIndex = object as? Int else {fatalError("arrangedObjects must contain integer")}
        print("identifier: \(vcIndex)")
        return .init(vcIndex)
    }
    
    func pageController(_ pageController: NSPageController, viewControllerForIdentifier identifier: NSPageController.ObjectIdentifier) -> NSViewController {
        guard let vcIndex = Int(identifier) else {fatalError("identifier must integer")}
        return vcs[vcIndex]
    }
    
    func pageController(_ pageController: NSPageController, prepare viewController: NSViewController, with object: Any?) {
    }
    
    func pageControllerWillStartLiveTransition(_ pageController: NSPageController) {
        print(pageController.selectedIndex)
    }
    
}
