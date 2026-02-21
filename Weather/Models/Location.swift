//
//  Location.swift
//  Weather
//
//  Created by Админ on 21.02.2026.
//

struct Location: Codable {
    var name: String
    var region: String
    var country: String
    var lat: Double
    var lon: Double
    var tz_id: String
    var localtime_epoch: Int
    var localtime: String
}

