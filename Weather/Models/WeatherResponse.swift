//
//  CurrentResponse.swift
//  Weather
//
//  Created by Админ on 22.02.2026.
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
