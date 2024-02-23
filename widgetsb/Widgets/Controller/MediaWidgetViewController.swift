//
//  MediaWidgetViewController.swift
//  widgetsb
//
//  Created by EnchantCode on 2024/02/17.
//

import Cocoa
import AVKit

final class MediaWidgetViewController: WidgetViewController {
    
    // MARK: - GUI Components
    
    /// メディアコンテンツを描画するビュー
    private var mediaView: NSView?
    
    // MARK: - Properties
    
    override var nibName: NSNib.Name? { "MediaWidgetView" }
    
    /// メディアモデル
    private var mediaModel: MediaModel
    
    /// ビューが動画を保持する場合のプレイヤー
    private var player: AVQueuePlayer?
    
    /// ルーパ
    private var playerLooper: AVPlayerLooper?
    
    /// プレイヤーが保持するアイテム
    private var playerItem: AVPlayerItem?
    
    // MARK: - Initializers
    
    init(widgetContent: MediaWidgetContent) {
        self.mediaModel = .init(mediaURL: widgetContent.mediaURL)
        super.init(widgetContent: widgetContent)
        self.widgetContent?.delegates.addDelegate(self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        self.widgetContent?.delegates.removeDelegate(self)
    }
    
    // MARK: - View lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.wantsLayer = true
        self.view.layer?.autoresizingMask = [.layerWidthSizable, .layerHeightSizable]
        self.mediaModel.delegate = self
    }
    
    override func viewWillAppear() {
        // モデルのコンテンツを反映
        if let mediaURL = mediaModel.mediaURL {
            updateMediaContent(with: mediaURL)
        }
    }
    
    override func viewDidAppear() {
        super.viewDidAppear()
    }
    
    // MARK: - Private methods
    
    /// メディアコンテンツを更新する
    private func updateMediaContent(with mediaURL: URL){
        // パスの取得と存在チェック
        let mediaPath: String
        if #available(macOS 13.0, *) {
            mediaPath = mediaURL.path()
        } else {
            mediaPath = mediaURL.path
        }
        guard FileManager.default.fileExists(atPath: mediaPath),
              FileManager.default.isReadableFile(atPath: mediaPath) else {return}
        
        // メディアタイプで分岐
        guard let mediaType = UTType(filenameExtension: mediaURL.pathExtension) else {return}
        if mediaType.conforms(to: .image){
            configureImageView(with: mediaURL)
        }
        if mediaType.conformsAny(to: [.video, .movie]){
            configureVideoView(with: mediaURL)
        }
        
        // 正しく構成できたらviewに追加する
        if let mediaView = mediaView, mediaView.superview == nil {
            self.view.addSubview(mediaView)
        }
    }
    
    /// レイヤに画像コンテンツを構成する
    private func configureImageView(with url: URL){
        guard let image = NSImage(contentsOf: url) else {
            print("Failed to load resource \(url)")
            return
        }
        
        mediaView = DraggableImageView(image: image)
        mediaView?.autoresizingMask = [.width, .height]
        mediaView?.frame = self.view.bounds
    }
    
    /// レイヤに動画コンテンツを構成する
    private func configureVideoView(with url: URL){
        playerItem = .init(url: url)
        player = .init(playerItem: playerItem)
        playerLooper = .init(player: player!, templateItem: playerItem!)
        
        mediaView = .init(frame: self.view.bounds)
        mediaView?.autoresizingMask = [.width, .height]
        mediaView?.wantsLayer = true
        mediaView?.layer = AVPlayerLayer(player: player)
        mediaView?.layer?.frame = self.view.bounds
        
        player?.play()
    }
    
    /// メディアコンテンツを削除する
    private func removeMediaContent(){
        // 動画を停止
        player?.pause()
        
        // レイヤがビューに追加されていれば外し、削除
        mediaView?.removeFromSuperview()
        mediaView = nil
        
        // 後片付け
        playerLooper = nil
        player = nil
        playerItem = nil
    }
}

extension MediaWidgetViewController: MediaModelDelegate {
    
    func media(_ model: MediaModel, didChangeURL to: URL?) {
        // 一旦コンテンツを削除し、再構成
        removeMediaContent()
        guard let mediaURL = to else {return}
        updateMediaContent(with: mediaURL)
    }
    
}

extension MediaWidgetViewController: WidgetContentDelegate {
    
    func widget(_ widgetContent: WidgetContent, didChange keyPath: AnyKeyPath) {
        
    }
    
}
