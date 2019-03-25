//
//  Constants.swift
//  CC-Demo
//
//  Created by Naveed Ahmed on 3/24/19.
//  Copyright © 2019 Naveed Ahmed. All rights reserved.
//

import Foundation

struct K {
    struct ProductionServer {
        static let weatherBaseURL = "http://api.openweathermap.org/data/2.5/"
        static let weatherImageUrl = "http://openweathermap.org/img/w/"
        
        static let restaurantsBaseURL = "https://api.foursquare.com/v2/venues/explore"
    }
    
    struct APIParameterKey {
        static let lat = "lat"
        static let lng = "lon"
        static let appid = "appid"
        
        static let client_id = "client_id"
        static let client_secret = "client_secret"
        static let lat_lng = "ll"
        static let category_id = "categoryId"
        static let api_version = "v"
        static let sort_by_distance = "sortByDistance"
    }
    
    struct EndPoints {
        static let WEATHER = "weather"
        static let FORECAST = "forecast"
    }
    
    struct Constants {
        static let open_weather_map_api_key = "6d31ce0efdd4cf37ad972f6ffab1be4e"
        
        static let temperature_preference = "temperature_preference"
        static let celcius = "celcius"
        static let fahrenheit = "fahrenheit"
        
        static let four_square_client_id = "IGIIG4YUYGELCY3FGPU2DZY32URW5PNEZLBFVP15COWCPAPI"
        static let four_square_client_secret = "P2YLU5ZQTZOXHBCGSFDSW40HE2HIY4HQBBIEGIDA51NTXKUY"
        
        static let four_square_category_id = "4d4b7105d754a06374d81259"
    }
}
