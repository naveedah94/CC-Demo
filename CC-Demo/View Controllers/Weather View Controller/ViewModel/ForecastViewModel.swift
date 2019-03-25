//
//  ForecastViewModel.swift
//  CC-Demo
//
//  Created by Indigo on 25/03/2019.
//  Copyright © 2019 Naveed Ahmed. All rights reserved.
//

import Foundation

struct ForecastViewModel {
    var dayString: String
    var imageUrl: URL?
    var maxTempString: String
    var minTempString: String
    
    init(item: WeatherForecastItem) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        let dayFormatter = DateFormatter()
        dayFormatter.dateFormat = "EEE"
        
        self.dayString = dayFormatter.string(from: formatter.date(from: item.dateText!)!)
        self.maxTempString = String.init(format: "%d °", Int(Helper.init().getConvertedTemperatureFrom(kelvin: (item.main?.maxTemp)!)))
        self.minTempString = String.init(format: "%d °", Int(Helper.init().getConvertedTemperatureFrom(kelvin: (item.main?.minTemp)!)))
        self.imageUrl = URL.init(string: K.ProductionServer.weatherImageUrl + item.weather![0].icon! + ".png")
    }
}
