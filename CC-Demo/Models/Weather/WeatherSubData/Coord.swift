//
//  Coord.swift
//  CC-Demo
//
//  Created by Naveed Ahmed on 3/24/19.
//  Copyright © 2019 Naveed Ahmed. All rights reserved.
//

import Foundation

struct Coord: Codable {
    let lat: Double?
    let lng: Double?
}

extension Coord {
    enum CodingKeys: String, CodingKey {
        case lat = "lat"
        case lng = "lng"
    }
}
