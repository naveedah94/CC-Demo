//
//  RestaurantItemViewModel.swift
//  CC-Demo
//
//  Created by Indigo on 25/03/2019.
//  Copyright © 2019 Naveed Ahmed. All rights reserved.
//

import Foundation

struct RestaurantItemViewModel {
    
    var nameString: String
    var locationString: String
    var categoryString: String
    var imageUrl: URL?
    var lat: Double
    var lng: Double
    
    init(data: PlaceItem, cityName: String) {
        self.nameString = (data.venue?.name)!
        self.locationString = cityName
        if (data.venue?.categories?.count)! > 0 {
            self.categoryString = (data.venue?.categories![0].name)!
        } else {
            self.categoryString = "-"
        }
        let prefix = (data.venue?.categories![0].icon?.prefix)!
        let suffix = (data.venue?.categories![0].icon?.suffix)!
        
        self.imageUrl = URL.init(string: prefix + "100" + suffix)
        
        self.lat = (data.venue?.location?.lat)!
        self.lng = (data.venue?.location?.lng)!
    }
    
}
