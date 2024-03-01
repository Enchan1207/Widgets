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
    
    /// ビューが動画を保持する場合のプレイヤー
    private var player: AVQueuePlayer?
    
    /// ルーパ
    private var playerLooper: AVPlayerLooper?
    
    /// プレイヤーが保持するアイテム
    private var playerItem: AVPlayerItem?
    
    // MARK: - Initializers
    
    init(widgetContent: MediaWidgetContent) {
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
        
        // モデルのコンテンツを反映
        if let mediaURL = (widgetContent as? MediaWidgetContent)?.mediaURL {
            updateMediaContent(with: mediaURL)
        }else{
            configureFallbackView()
            addMediaViewIfNeeded()
        }
    }
    
    // MARK: - Private methods
    
    /// メディアコンテンツを更新する
    private func updateMediaContent(with mediaURL: URL){
        // パスの取得と存在チェック
        let mediaPath = mediaURL.filePath
        guard FileManager.default.fileExists(atPath: mediaPath),
              FileManager.default.isReadableFile(atPath: mediaPath) else {return}
        
        // メディアタイプで分岐
        guard let mediaType = UTType(filenameExtension: mediaURL.pathExtension) else { return }
        switch mediaType {
        case let t where t.conforms(to: .image):
            configureImageView(with: mediaURL)
            
        case let t where t.conformsAny(to: [.video, .movie]):
            configureVideoView(with: mediaURL)
            
        default:
            // サポート外ならフォールバックビューに切り替える
            print("Unsupported media type: \(mediaType)")
            configureFallbackView()
            break
        }
        
        // 正しく構成できたらviewに追加する
        addMediaViewIfNeeded()
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
    
    /// レイヤにフォールバックビューを構成する
    private func configureFallbackView(){
        let fallbackImage = NSImage(systemSymbolName: "photo", accessibilityDescription: "no image")!
        mediaView = DraggableImageView(image: fallbackImage)
        mediaView?.autoresizingMask = [.width, .height]
        mediaView?.frame = self.view.bounds
    }
    
    /// メディアビューが構成されていて、かつ宙ぶらりんの状態ならメインビューに追加する
    private func addMediaViewIfNeeded(){
        guard let mediaView = mediaView, mediaView.superview == nil else {return}
        self.view.addSubview(mediaView)
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

extension MediaWidgetViewController: WidgetContentDelegate {
    
    func widget(_ widgetContent: WidgetContent, didChange keyPath: AnyKeyPath) {
        // 変更内容がメディアURLのそれであることを確認
        guard let widgetContent = widgetContent as? MediaWidgetContent,
              keyPath == \MediaWidgetContent.mediaURL else {return}
        
        // 一旦削除
        removeMediaContent()
        
        // 再構成
        if let mediaURL = widgetContent.mediaURL {
            updateMediaContent(with: mediaURL)
        }else {
            configureFallbackView()
            addMediaViewIfNeeded()
        }
    }
    
}
