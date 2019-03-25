//
//  Group.swift
//  CC-Demo
//
//  Created by Naveed Ahmed on 3/25/19.
//  Copyright © 2019 Naveed Ahmed. All rights reserved.
//

import Foundation

struct Group: Codable {
    let type: String?
    let name: String?
    let items: [PlaceItem]?
}

extension Group {
    enum CodingKeys: String, CodingKey {
        case type = "type"
        case name = "name"
        case items = "items"
    }
}
