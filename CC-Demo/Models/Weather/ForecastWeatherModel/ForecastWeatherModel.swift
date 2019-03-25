//
//  ForecastWeatherModel.swift
//  CC-Demo
//
//  Created by Naveed Ahmed on 3/24/19.
//  Copyright © 2019 Naveed Ahmed. All rights reserved.
//

import Foundation

struct ForecastWeatherModel: Codable {
    let cod: String?
    let message: Double?
    let cnt: Int?
    let forecastArray: [WeatherForecastItem]?
    let city: City?
}

extension ForecastWeatherModel {
    enum CodingKeys: String, CodingKey {
        case cod = "cod"
        case message = "message"
        case cnt = "cnt"
        case forecastArray = "list"
        case city = "city"
    }
}
