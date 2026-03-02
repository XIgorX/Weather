//
//  MemoryCache.swift
//  Weather
//
//  Created by Админ on 02.03.2026.
//

import UIKit

class MemoryCache {
    static let shared = MemoryCache()
    private let cache = NSCache<NSString, UIImage>()
    
    private init() {
        // Ограничение по памяти: 1/6 от физической памяти устройства
        let totalMemory = ProcessInfo.processInfo.physicalMemory
        cache.totalCostLimit = Int(totalMemory / 6)
        
        // Очистка при нехватке памяти
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(clear),
            name: UIApplication.didReceiveMemoryWarningNotification,
            object: nil
        )
    }
    
    @objc func clear() {
        cache.removeAllObjects()
    }
    
    func image(for key: String) -> UIImage? {
        return cache.object(forKey: key as NSString)
    }
    
    func setImage(_ image: UIImage, for key: String) {
        let cost = Int(image.size.width * image.size.height * 4) // оценка в байтах
        cache.setObject(image, forKey: key as NSString, cost: cost)
    }
    
    func removeImage(for key: String) {
        cache.removeObject(forKey: key as NSString)
    }
}

