//
//  Weather.swift
//  CC-Demo
//
//  Created by Naveed Ahmed on 3/24/19.
//  Copyright © 2019 Naveed Ahmed. All rights reserved.
//

import Foundation

struct Weather: Codable {
    let id: Int?
    let main: String?
    let description: String?
    let icon: String?
}

extension Weather {
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case main = "main"
        case description = "description"
        case icon = "icon"
    }
}
