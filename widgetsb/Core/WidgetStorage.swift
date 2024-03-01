//
//  WidgetStorage.swift
//  widgetsb
//
//  Created by EnchantCode on 2024/02/24.
//

import Foundation

/// ウィジェットオブジェクトのロード・セーブ
final class WidgetStorage {
    
    /// アプリケーションライブラリの場所
    /// - Note: ~/Library/Application Support/{bundle-identifier} が返ります。
    private static var appLibraryDir: URL {
        // ベースディレクトリはApplication Support
        let appSupportDir = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first!
        
        // バンドル識別子を足して返す
        let bundleID = Bundle.main.bundleIdentifier!
        if #available(macOS 13.0, *) {
            return appSupportDir.appending(path: bundleID, directoryHint: .isDirectory)
        } else {
            return appSupportDir.appendingPathComponent(bundleID)
        }
    }
    
    /// ウィジェット構成情報の格納先
    private static var widgetConfigDir: URL {
        let configFileName = "widgets.json"
        if #available(macOS 13.0, *) {
            return WidgetStorage.appLibraryDir.appending(path: configFileName)
        } else {
            return WidgetStorage.appLibraryDir.appendingPathComponent(configFileName, conformingTo: .json)
        }
    }
    
    /// ウィジェット構成情報を復元
    /// - Parameter url: 読込み元
    /// - Returns: 復元されたウィジェット配列
    static func load(from url: URL = WidgetStorage.widgetConfigDir) throws -> [Widget] {
        print("Load widgets from \(url.filePath)")
        
        do {
            let storedWidgetData = try Data(contentsOf: url)
            let decodedWidgetData = try JSONDecoder().decode([Widget].self, from: storedWidgetData)
            print("Total \(decodedWidgetData.count) widgets loaded.")
            return decodedWidgetData
        } catch let decodingError as DecodingError {
            print("Failed to decode: \(decodingError.localizedDescription)")
            throw decodingError
        } catch let cocoaError as CocoaError {
            print("Failed to load: \(cocoaError.localizedDescription)")
            throw cocoaError
        } catch {
            print("Unexpected error occurred while loading: \(error)")
            throw error
        }
    }
    
    /// ウィジェット構成情報を保存
    /// - Parameter url: 保存先
    /// - Parameter widgets: 保存するウィジェット配列
    static func save(to url: URL = WidgetStorage.widgetConfigDir, widgets: [Widget]) throws {
        do {
            try FileManager.default.createDirectory(at: url.deletingLastPathComponent(), withIntermediateDirectories: true)
            let encodedWidgets = try JSONEncoder().encode(widgets)
            try encodedWidgets.write(to: url)
            print("Total \(widgets.count) widgets saved.")
        } catch let encodingError as EncodingError {
            print("Failed to encode: \(encodingError.localizedDescription)")
            throw encodingError
        } catch let cocoaError as CocoaError {
            print("Failed to save: \(cocoaError.localizedDescription)")
            throw cocoaError
        } catch {
            print("Unexpected error occurred during load: \(error)")
            throw error
        }
    }
    
}
