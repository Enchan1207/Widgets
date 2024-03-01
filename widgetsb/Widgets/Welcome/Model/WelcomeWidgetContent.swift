//
//  WelcomeWidgetContent.swift
//  widgetsb
//
//  Created by EnchantCode on 2024/03/01.
//

import Cocoa

final class WelcomeWidgetContent: WidgetContent {
    
    // MARK: - Properties
    
    private (set) public var delegates: MulticastDelegate<WidgetContentDelegate>
    
    static var shortDescription: String { "Welcome widget" }
    
    static var longDescription: String { "Widgets displayed when no ones are registered" }
    
    static func initWithDefaultConfiguration() -> WidgetContent {
        return WelcomeWidgetContent()
    }
    
    // MARK: - Initializers
    
    init(){
        self.delegates = .init()
    }

}

extension WelcomeWidgetContent: Codable {
    
    convenience init(from decoder: Decoder) throws {
        self.init()
    }
    
    func encode(to encoder: Encoder) throws {
        // Welcome widget has no data to encode
    }
    
}
