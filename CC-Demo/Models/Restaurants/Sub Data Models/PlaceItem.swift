//
//  PlaceItem.swift
//  CC-Demo
//
//  Created by Naveed Ahmed on 3/25/19.
//  Copyright © 2019 Naveed Ahmed. All rights reserved.
//

import Foundation

struct PlaceItem: Codable {
    let venue: Venue?
}

extension PlaceItem {
    enum CodingKeys: String, CodingKey {
        case venue = "venue"
    }
}

struct Venue: Codable {
    let id: String?
    let name: String?
    let location: Location?
    let categories: [Category]?
}

extension Venue {
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
        case location = "location"
        case categories = "categories"
    }
}
