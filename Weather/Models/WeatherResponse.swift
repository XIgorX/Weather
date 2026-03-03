//
//  WeatherResponse.swift
//  Weather
//
//  Created by Игорь Данильченко on 22.02.2026.
//

struct СurrentResponse: Codable {
    let location: Location
    let current: Current
}

struct ForecastResponse: Codable {
    let location: Location
    let current: Current
    let forecast: Forecast
}
