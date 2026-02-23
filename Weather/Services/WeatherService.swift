//
//  WeatherService.swift
//  Weather
//
//  Created by Админ on 22.02.2026.
//

import CoreLocation
import Foundation

class WeatherService {
    private let apiKey = "fa8b3df74d4042b9aa7135114252304"
    private let baseURL = "http://api.weatherapi.com/v1/current.json"
    
    private let session: URLSession
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    func fetchCurrentWeather(
        latitude: Double,
        longitude: Double,
        completion: @escaping (Result<WeatherResponse, WeatherError>) -> Void
    ) {
        let urlString = "\(baseURL)?key=\(apiKey)&q=\(latitude),\(longitude)"
        
        guard let url = URL(string: urlString) else {
            completion(.failure(.invalidURL))
            return
        }
        
        let task = session.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(.networkError(error)))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse,
                httpResponse.statusCode == 200 else {
                completion(.failure(.invalidResponse))
                return
            }
            
            guard let data = data else {
                completion(.failure(.noData))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                if let text = String(data: data, encoding: .utf8) {
                    print(text)
                }
                let weatherResponse = try decoder.decode(WeatherResponse.self, from: data)
                completion(.success(weatherResponse))
            } catch let error as DecodingError {
                switch error {
                case .keyNotFound(let key, let context):
                    print("Ключ '\(key)' не найден: \(context.debugDescription)")
                    print("Путь:", context.codingPath)
                case .typeMismatch(let type, let context):
                    print("Несоответствие типа '\(type)': \(context.debugDescription)")
                    print("Путь:", context.codingPath)
                case .valueNotFound(let type, let context):
                    print("Значение '\(type)' не найдено: \(context.debugDescription)")
                    print("Путь:", context.codingPath)
                case .dataCorrupted(let context):
                    print("Данные повреждены: \(context.debugDescription)")
                    print("Путь:", context.codingPath)
                @unknown default:
                    print("Неизвестная ошибка")
                }
            } catch {
                completion(.failure(.parsingError(error)))
            }
        }
        task.resume()
    }
}

