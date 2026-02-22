//
//  Error.swift
//  Weather
//
//  Created by Админ on 22.02.2026.
//

import Foundation

enum WeatherError: Error, LocalizedError {
    case invalidURL
    case networkError(Error)
    case invalidResponse
    case noData
    case parsingError(Error)
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Неверный URL для запроса погоды"
        case .networkError(let error):
            return "Ошибка сети: \(error.localizedDescription)"
        case .invalidResponse:
            return "Некорректный ответ от сервера"
        case .noData:
            return "Нет данных для обработки"
        case .parsingError(let error):
            return "Ошибка парсинга данных: \(error.localizedDescription)"
        }
    }
}

