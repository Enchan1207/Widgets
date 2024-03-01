//
//  WelcomeWidgetContentEditorViewController.swift
//  widgetsb
//
//  Created by EnchantCode on 2024/03/01.
//

import Cocoa

class WelcomeWidgetContentEditorViewController: NSViewController {
    
    // MARK: - Properties
    
    private weak var welcomeWidgetContent: WelcomeWidgetContent?

    override var nibName: NSNib.Name? { "WelcomeWidgetContentEditorView" }
    
    // MARK: - Initializers
    
    init(welcomeWidgetContent: WelcomeWidgetContent?){
        self.welcomeWidgetContent = welcomeWidgetContent
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
