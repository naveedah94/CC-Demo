//
//  CurrentWeatherViewModel.swift
//  CC-Demo
//
//  Created by Indigo on 25/03/2019.
//  Copyright © 2019 Naveed Ahmed. All rights reserved.
//

import Foundation

struct CurrentWeatherViewModel {
    
    var temperatureString: String
    var visibilityString: String
    var humidityString: String
    var windString: String
    var weatherDescriptionString: String
    var dayString: String
    var imageUrl: URL?
    
    init(currentWeatherData: CurrentWeatherModel) {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE"
        self.dayString = formatter.string(from: Date())
        
        self.temperatureString = String.init(format: "%d", Int(Helper.init().getConvertedTemperatureFrom(kelvin: (currentWeatherData.main?.temp)!)))
        self.visibilityString = String(currentWeatherData.visibility! / 1000)
        self.humidityString = String((currentWeatherData.main?.humidity)!)
        self.windString = String.init(format: "%.2f", (currentWeatherData.wind?.speed!)! * 3.6)
        
        if let weather = currentWeatherData.weather {
            if weather.count > 0 {
                self.weatherDescriptionString = weather[0].description!
                self.imageUrl = URL.init(string: K.ProductionServer.weatherImageUrl + weather[0].icon! + ".png")
            } else {
                self.weatherDescriptionString = "-"
            }
        } else {
            self.weatherDescriptionString = "-"
        }
    }
    
    
    
}
