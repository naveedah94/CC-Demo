//
//  Warning.swift
//  CC-Demo
//
//  Created by Naveed Ahmed on 3/25/19.
//  Copyright © 2019 Naveed Ahmed. All rights reserved.
//

import Foundation

struct Warning: Codable {
    let text: String?
}

extension Warning {
    enum CodingKeys: String, CodingKey {
        case text = "text"
    }
}
