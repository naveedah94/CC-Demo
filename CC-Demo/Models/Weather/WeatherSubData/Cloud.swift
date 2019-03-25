//
//  Cloud.swift
//  CC-Demo
//
//  Created by Naveed Ahmed on 3/24/19.
//  Copyright © 2019 Naveed Ahmed. All rights reserved.
//

import Foundation

struct Cloud: Codable {
    let all: Double?
}

extension Cloud {
    enum CodingKeys: String, CodingKey {
        case all = "all"
    }
}
