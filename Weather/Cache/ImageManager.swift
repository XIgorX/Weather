//
//  ImageManager.swift
//  Weather
//
//  Created by Админ on 02.03.2026.
//

import UIKit

class ImageManager {
    static let shared = ImageManager()
    
    private let memoryCache = MemoryCache.shared
    private let diskCache = DiskCache.shared
    
    private init() {}
    
    func loadImage(
        from url: URL,
        placeholder: UIImage? = nil,
        completion: @escaping (UIImage?) -> Void
    ) {
        // 1. Проверяем кэш в памяти
        if let image = memoryCache.image(for: url.absoluteString) {
            completion(image)
            return
        }
        
        // 2. Проверяем дисковый кэш
        if let image = diskCache.image(forKey: url.absoluteString) {
            memoryCache.setImage(image, for: url.absoluteString)
            completion(image)
            return
        }
        
        // 3. Проверяем HTTP‑кэш (если сервер поддерживает)
        let request = URLRequest(
            url: url,
            cachePolicy: .useProtocolCachePolicy,
            timeoutInterval: 10
        )
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                DispatchQueue.main.async { completion(nil) }
                return
            }
            
            // 4. Создаём изображение из данных
            guard let image = UIImage(data: data) else {
                DispatchQueue.main.async { completion(nil) }
                return
            }
            
            // 5. Сохраняем во все уровни кэша
            self.memoryCache.setImage(image, for: url.absoluteString)
            self.diskCache.saveImage(image, forKey: url.absoluteString)
            
            
            // 6. Возвращаем результат
            DispatchQueue.main.async {
                completion(image)
            }
        }.resume()
    }
    
    // Очистка кэша
    func clearCaches() {
        memoryCache.clear()
        diskCache.removeAllImages()
    }
}

// Расширение для удобства использования с UIImageView
extension UIImageView {
    func loadImage(from url: URL, placeholder: UIImage? = nil) {
        self.image = placeholder
        ImageManager.shared.loadImage(from: url) { [weak self] image in
            guard let self = self else { return }
            self.image = image
        }
    }
}
