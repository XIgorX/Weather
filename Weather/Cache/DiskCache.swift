//
//  DiskCache.swift
//  Weather
//
//  Created by Админ on 02.03.2026.
//

import UIKit

class DiskCache {
    static let shared = DiskCache()
    private let fileManager = FileManager.default
    private lazy var cacheDirectory: URL = {
        let urls = fileManager.urls(for: .cachesDirectory, in: .userDomainMask)
        return urls.first!.appendingPathComponent("ImageCache")
    }()
    
    private init() {
        createCacheDirectory()
    }
    
    private func createCacheDirectory() {
        if !fileManager.fileExists(atPath: cacheDirectory.path) {
            try? fileManager.createDirectory(at: cacheDirectory, withIntermediateDirectories: true, attributes: nil)
        }
    }
    
    func saveImage(_ image: UIImage, forKey key: String, fileExtension: String = "jpg") {
        guard let data = imageData(for: image, fileExtension: fileExtension) else { return }
        let fileURL = cacheDirectory.appendingPathComponent("\(key).\(fileExtension)")
        try? data.write(to: fileURL, options: .atomic)
    }
    
    func image(forKey key: String) -> UIImage? {
        let jpgURL = cacheDirectory.appendingPathComponent("\(key).jpg")
        let pngURL = cacheDirectory.appendingPathComponent("\(key).png")
        
        for url in [jpgURL, pngURL] {
            guard fileManager.fileExists(atPath: url.path),
                  let data = try? Data(contentsOf: url) else { continue }
            return UIImage(data: data)
        }
        return nil
    }
    
    func removeImage(forKey key: String) {
        let extensions = ["jpg", "png"]
        for ext in extensions {
            let fileURL = cacheDirectory.appendingPathComponent("\(key).\(ext)")
            try? fileManager.removeItem(at: fileURL)
        }
    }
    
    func removeAllImages() {
        do {
            let files = try fileManager.contentsOfDirectory(at: cacheDirectory, includingPropertiesForKeys: nil)
            for file in files {
                try fileManager.removeItem(at: file)
            }
        } catch {
            print("Failed to remove all images from disk cache: \(error)")
        }
    }
    
    // Вспомогательная функция для выбора формата данных
    private func imageData(for image: UIImage, fileExtension: String) -> Data? {
        switch fileExtension.lowercased() {
        case "jpg", "jpeg":
            return image.jpegData(compressionQuality: 0.8)
        case "png":
            return image.pngData()
        default:
            return image.jpegData(compressionQuality: 0.8)
        }
    }
}

