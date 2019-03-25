//
//  WeatherItem.swift
//  CC-Demo
//
//  Created by Naveed Ahmed on 3/24/19.
//  Copyright © 2019 Naveed Ahmed. All rights reserved.
//

import Foundation

struct WeatherForecastItem: Codable {
    let date: Int?
    let main: MainWeatherData?
    let weather: [Weather]?
    let clouds: Cloud?
    let wind: Wind?
    let rain: Rain?
    let sys: Sys?
    let dateText: String?
}

extension WeatherForecastItem {
    enum CodingKeys: String, CodingKey {
        case date = "dt"
        case main = "main"
        case weather = "weather"
        case clouds = "clouds"
        case wind = "wind"
        case rain = "rain"
        case sys = "sys"
        case dateText = "dt_txt"
    }
}
