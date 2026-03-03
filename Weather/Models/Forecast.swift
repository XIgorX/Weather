//
//  Forecast.swift
//  Weather
//
//  Created by Игорь Данильченко on 25.02.2026.
//

struct Day: Codable {
    var maxtemp_c: Float
    var maxtemp_f: Float
    var mintemp_c: Float
    var mintemp_f: Float
    var avgtemp_c: Float
    var avgtemp_f: Float
    var maxwind_mph: Float
    var maxwind_kph: Float
    var totalprecip_mm: Float
    var totalprecip_in: Float
    var totalsnow_cm: Float
    var avgvis_km: Float
    var avgvis_miles: UInt8
    var avghumidity: UInt8
    var daily_will_it_rain: UInt8
    var daily_chance_of_rain: UInt8
    var daily_will_it_snow: UInt8
    var daily_chance_of_snow: UInt8
    var condition: Condition
    var uv: Float
}

struct Astro: Codable {
    var sunrise: String
    var sunset: String
    var moonrise: String
    var moonset: String
    var moon_phase: String
    var moon_illumination: UInt8
    var is_moon_up: UInt8
    var is_sun_up: UInt8
}

struct HourElement: Codable {
    var time_epoch: UInt32
    var time: String
    var temp_c: Float
    var temp_f: Float
    var is_day: UInt8
    var condition: Condition
    var wind_mph: Float
    var wind_kph: Float
    var wind_degree: UInt16
    var wind_dir: String
    var pressure_mb: Float
    var pressure_in: Float
    var precip_mm: Float
    var precip_in: Float
    var snow_cm: Float
    var humidity: UInt8
    var cloud: UInt8
    var feelslike_c: Float
    var feelslike_f: Float
    var windchill_c: Float
    var windchill_f: Float
    var heatindex_c: Float
    var heatindex_f: Float
    var dewpoint_c: Float
    var dewpoint_f: Float
    var will_it_rain: UInt8
    var chance_of_rain: UInt8
    var will_it_snow: UInt8
    var chance_of_snow: UInt8
    var vis_km: Float
    var vis_miles: Float
    var gust_mph: Float
    var gust_kph: Float
    var uv: Float
}

struct ForecastDayElement: Codable {
    var date: String
    var date_epoch: UInt32
    var day: Day
    var astro: Astro
    var hour: [HourElement]
}

struct Forecast: Codable {
    var forecastday: [ForecastDayElement]
}
