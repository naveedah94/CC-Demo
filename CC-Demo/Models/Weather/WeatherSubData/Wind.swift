//
//  Wind.swift
//  CC-Demo
//
//  Created by Naveed Ahmed on 3/24/19.
//  Copyright © 2019 Naveed Ahmed. All rights reserved.
//

import Foundation

struct Wind: Codable {
    let degrees: Double?
    let speed: Double?
}

extension Wind {
    enum CodingKeys: String, CodingKey {
        case degrees = "deg"
        case speed = "speed"
    }
}
