//
//  Location.swift
//  CC-Demo
//
//  Created by Naveed Ahmed on 3/25/19.
//  Copyright © 2019 Naveed Ahmed. All rights reserved.
//

import Foundation

struct Location: Codable {
    let lat: Double?
    let lng: Double?
    let distance: Int?
    let cc: String?
    let city: String?
    let state: String?
    let country: String?
    let formattedAddress: [String]?
}

extension Location {
    enum CodingKeys: String, CodingKey {
        case lat = "lat"
        case lng = "lng"
        case distance = "distance"
        case cc = "cc"
        case city = "city"
        case state = "state"
        case country = "country"
        case formattedAddress = "formattedAddress"
    }
}
