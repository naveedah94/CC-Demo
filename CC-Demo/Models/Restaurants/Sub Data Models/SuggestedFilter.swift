//
//  SuggestedFilter.swift
//  CC-Demo
//
//  Created by Naveed Ahmed on 3/25/19.
//  Copyright © 2019 Naveed Ahmed. All rights reserved.
//

import Foundation

struct SuggestedFilter: Codable {
    let header: String?
    let filters: [Filter]?
}

extension SuggestedFilter {
    enum CodingKeys: String, CodingKey {
        case header = "header"
        case filters = "filters"
    }
}
