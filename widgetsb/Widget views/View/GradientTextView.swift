//
//  GradientTextView.swift
//  widgetsb
//
//  Created by EnchantCode on 2024/02/16.
//

import Cocoa

/// テキストをアルファチャネルでグラデーションするView
class GradientTextView: NSView {
    
    // MARK: - Public properties
    
    /// 背景色の配列
    var backgroundColors: [NSColor] = [] {
        didSet{
            layerTransaction {[weak self] in
                guard let `self` = self else {return}
                self.gradientMask.colors = backgroundColors.map{$0.cgColor}
            }
        }
    }
    
    /// グラデーション開始位置
    var startPoint: CGPoint = .zero {
        didSet{
            layerTransaction {[weak self] in
                guard let `self` = self else {return}
                self.gradientMask.startPoint = startPoint
            }
        }
    }

    /// グラデーション終了位置
    var endPoint: CGPoint = .zero {
        didSet{
            layerTransaction {[weak self] in
                guard let `self` = self else {return}
                self.gradientMask.endPoint = endPoint
            }
        }
    }
    
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
    
    // MARK: - Private properties
    
    private let textLayer = CATextLayer()
    
    private let gradientMask = CAGradientLayer()
    
    // MARK: - Initializers
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        configure()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configure()
    }
    
    // MARK: - Private methods
    
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
        gradientMask.frame = self.frame
        gradientMask.autoresizingMask = [.layerWidthSizable, .layerHeightSizable]
        gradientMask.isOpaque = false
        self.backgroundColors = [.white, .clear]
        self.startPoint = .init(x: 0.5, y: 1.0)
        self.endPoint = .init(x: 0.5, y: 0.0)
        
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
