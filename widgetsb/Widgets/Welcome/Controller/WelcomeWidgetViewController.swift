//
//  WelcomeWidgetViewController.swift
//  widgetsb
//
//  Created by EnchantCode on 2024/03/01.
//

import Cocoa

class WelcomeWidgetViewController: WidgetViewController {
    
    // MARK: - GUI components
    
    @IBOutlet weak var versionInfoField: NSTextField! {
        didSet {
            guard let version = lookupInfoPlist("CFBundleShortVersionString"),
                  let build = lookupInfoPlist("CFBundleVersion"),
                  let displayName = lookupInfoPlist("CFBundleDisplayName"),
                  let copyright = lookupInfoPlist("NSHumanReadableCopyright")
            else {return}
            versionInfoField.stringValue = "\(displayName) version \(version) (build \(build)) \(copyright)"
        }
    }
    
    // MARK: - Properties
    
    override var nibName: NSNib.Name? { "WelcomeWidgetView" }
    
    // MARK: - View lifecycle
    
    override func viewWillAppear() {
        self.view.window?.center()
        
    }
    
    // MARK: - GUI action
    
    @IBAction func onClickPreferenceButton(_ sender: Any) {
        // TODO: 設定画面の表示
    }
    
    // MARK: - Private methods
    
    private func lookupInfoPlist(_ key: String) -> String? {
        Bundle.main.object(forInfoDictionaryKey: key) as? String
    }
    
}
