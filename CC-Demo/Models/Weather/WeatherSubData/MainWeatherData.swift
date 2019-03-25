//
//  MainWeatherData.swift
//  CC-Demo
//
//  Created by Naveed Ahmed on 3/24/19.
//  Copyright © 2019 Naveed Ahmed. All rights reserved.
//

import Foundation

struct MainWeatherData: Codable {
    let temp: Double?
    let minTemp: Double?
    let maxTemp: Double?
    let pressure: Double?
    let seaLevel: Double?
    let groundLevel: Double?
    let humidity: Int?
    let tempKf: Double?
}

extension MainWeatherData {
    enum CodingKeys: String, CodingKey {
        case temp = "temp"
        case minTemp = "temp_min"
        case maxTemp = "temp_max"
        case pressure = "pressure"
        case seaLevel = "sea_level"
        case groundLevel = "grnd_level"
        case humidity = "humidity"
        case tempKf = "temp_kf"
    }
}
