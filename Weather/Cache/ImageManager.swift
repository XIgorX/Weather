//
//  ImageManager.swift
//  Weather
//
//  Created by Игорь Данильченко on 02.03.2026.
//

import UIKit

class ImageManager {
    static let shared = ImageManager()
    
    private let memoryCache = MemoryCache.shared
    private let diskCache = DiskCache.shared
    
    private init() {}
    
    func loadImage(from url: URL, placeholder: UIImage? = nil) async -> UIImage? {
            // 1. Проверяем кэш в памяти
            if let image = memoryCache.image(for: url.absoluteString) {
                return image
            }
        
            // 2. Проверяем дисковый кэш
            if let image = diskCache.image(forKey: url.absoluteString) {
                memoryCache.setImage(image, for: url.absoluteString)
                return image
            }
        
            // 3. Загружаем изображение с сети
            do {
                let request = URLRequest(
                url: url,
                cachePolicy: .useProtocolCachePolicy,
                timeoutInterval: 10
                )
            
            let (data, _) = try await URLSession.shared.data(for: request)
            
            // 4. Создаём изображение из данных
            guard let image = UIImage(data: data) else {
                return nil
            }
            
            // 5. Сохраняем во все уровни кэша
            memoryCache.setImage(image, for: url.absoluteString)
            diskCache.saveImage(image, forKey: url.absoluteString)
            
            // 6. Возвращаем результат
            return image
            
        } catch {
            print("Ошибка загрузки изображения: \(error)")
            return nil
        }
    }
    
    // Очистка кэша (асинхронная версия)
    func clearCaches() async {
        await withTaskGroup(of: Void.self) { group in
            group.addTask {
                self.memoryCache.clear()
            }
            group.addTask {
                self.diskCache.removeAllImages()
            }
        }
    }
}

// Расширение для удобства использования с UIImageView
extension UIImageView {
    func loadImage(from url: URL, placeholder: UIImage? = nil) {
        self.image = placeholder
        
        Task { [weak self] in
            let image = await ImageManager.shared.loadImage(from: url)
            await MainActor.run {
                guard let self = self else { return }
                self.image = image
            }
        }
    }
}

