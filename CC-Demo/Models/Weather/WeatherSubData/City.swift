//
//  CityModel.swift
//  CC-Demo
//
//  Created by Naveed Ahmed on 3/24/19.
//  Copyright © 2019 Naveed Ahmed. All rights reserved.
//

import Foundation


struct City: Codable {
    let id: Int?
    let name: String?
    let coord: Coord?
    let country: String?
}

extension City {
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
        case coord = "coord"
        case country = "country"
    }
}

