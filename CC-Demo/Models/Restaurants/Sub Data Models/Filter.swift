//
//  Filter.swift
//  CC-Demo
//
//  Created by Naveed Ahmed on 3/25/19.
//  Copyright © 2019 Naveed Ahmed. All rights reserved.
//

import Foundation

struct Filter: Codable {
    let name: String?
    let key: String?
}

extension Filter {
    enum CodingKeys: String, CodingKey {
        case name = "name"
        case key = "key"
    }
}
