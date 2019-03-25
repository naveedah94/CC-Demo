//
//  CurrentWeatherModel.swift
//  CC-Demo
//
//  Created by Naveed Ahmed on 3/24/19.
//  Copyright © 2019 Naveed Ahmed. All rights reserved.
//

import Foundation

struct CurrentWeatherModel: Codable {
    let id: Int?
    let cod: Int?
    let base: String?
    let name: String?
    let visibility: Int?
    let date: Int?
    let coord: Coord?
    let weather: [Weather]?
    let main: MainWeatherData?
    let wind: Wind?
    let clouds: Cloud?
    let sys: Sys?
    
}


//{
//    "coord": {
//        "lon": 67.14,
//        "lat": 24.94
//    },
//    "weather": [
//    {
//    "id": 802,
//    "main": "Clouds",
//    "description": "scattered clouds",
//    "icon": "03n"
//    }
//    ],
//    "base": "stations",
//    "main": {
//        "temp": 298.15,
//        "pressure": 1014,
//        "humidity": 61,
//        "temp_min": 298.15,
//        "temp_max": 298.15
//    },
//    "visibility": 6000,
//    "wind": {
//        "speed": 3.1,
//        "deg": 280
//    },
//    "clouds": {
//        "all": 36
//    },
//    "dt": 1553367300,
//    "sys": {
//        "type": 1,
//        "id": 7576,
//        "message": 0.0041,
//        "country": "PK",
//        "sunrise": 1553391112,
//        "sunset": 1553435027
//    },
//    "id": 1174867,
//    "name": "Karāchi Lines",
//    "cod": 200
//}
