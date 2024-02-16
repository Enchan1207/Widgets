//
//  ProcessInfoView.swift
//  widgetsb
//
//  Created by EnchantCode on 2024/02/16.
//

import Cocoa

class ProcessInfoView: NSView {
    
    /// 文字色
    var textColor = NSColor() {
        didSet {
            layerTransaction {[weak self] in
                guard let `self` = self else {return}
                textLayer.foregroundColor = textColor.cgColor
            }
        }
    }
    
    /// フォント
    var font = NSFont() {
        didSet {
            layerTransaction {[weak self] in
                guard let `self` = self else {return}
                textLayer.font = font.fontName as CFTypeRef
                textLayer.fontSize = font.pointSize
            }
        }
    }
    
    /// 表示内容
    var string = "" {
        didSet {
            layerTransaction {[weak self] in
                guard let `self` = self else {return}
                textLayer.string = string
            }
        }
    }
    
    private let textLayer = CATextLayer()
    
    private let gradientMask = CAGradientLayer()
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure(){
        // テキストレイヤを初期化
        textLayer.frame = self.frame
        textLayer.autoresizingMask = [.layerWidthSizable, .layerHeightSizable]
        if let scale = NSScreen.main?.backingScaleFactor {
            textLayer.contentsScale = scale
        }
        textLayer.backgroundColor = .clear
        textLayer.alignmentMode = .left
        textLayer.isOpaque = false
        self.string = ""
        self.textColor = .white
        self.font = .systemFont(ofSize: 14.0)
        
        // グラデーションマスクを初期化
        let colors: [NSColor] = [.white, .clear]
        gradientMask.frame = self.frame
        gradientMask.autoresizingMask = [.layerWidthSizable, .layerHeightSizable]
        gradientMask.colors = colors.map{$0.cgColor}
        gradientMask.startPoint = .init(x: 0.5, y: 1.0)
        gradientMask.endPoint = .init(x: 0.5, y: 0.0)
        gradientMask.isOpaque = false
        
        // マスクに割り当ててサブレイヤに追加
        textLayer.mask = gradientMask
        self.wantsLayer = true
        self.layer?.addSublayer(textLayer)
    }
    
    /// CALayerに対する操作を行う
    /// - Parameter transaction: 操作
    private func layerTransaction(_ transaction: @escaping ()->Void){
        DispatchQueue.main.async{
            CATransaction.begin()
            CATransaction.disableActions()
            transaction()
            CATransaction.commit()
        }
    }
    
}
