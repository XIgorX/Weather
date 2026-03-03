//
//  Current.swift
//  Weather
//
//  Created by Игорь Данильченко on 21.02.2026.
//

struct Current: Codable {
    var last_updated_epoch: Int
    var last_updated: String
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
    var vis_km: Float
    var vis_miles: Float
    var uv: Float
    var gust_mph: Float
    var gust_kph: Float
}
