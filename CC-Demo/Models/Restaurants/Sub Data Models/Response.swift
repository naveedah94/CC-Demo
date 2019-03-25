//
//  Response.swift
//  CC-Demo
//
//  Created by Naveed Ahmed on 3/25/19.
//  Copyright © 2019 Naveed Ahmed. All rights reserved.
//

import Foundation

struct Response: Codable {
    let suggestedFilters: SuggestedFilter?
    let warning: Warning?
    let suggestedRadius: Int?
    let headerLocation: String?
    let headerFullLocation: String?
    let headerLocationGranularity: String?
    let query: String?
    let totalResults: Int?
    let suggestedBounds: SuggestedBounds?
    let groups: [Group]?
}

extension Response {
    enum CodingKeys: String, CodingKey {
        case suggestedFilters = "suggestedFilters"
        case warning = "warning"
        case suggestedRadius = "suggestedRadius"
        case headerLocation = "headerLocation"
        case headerFullLocation = "headerFullLocation"
        case headerLocationGranularity = "headerLocationGranularity"
        case query = "query"
        case totalResults = "totalResults"
        case suggestedBounds = "suggestedBounds"
        case groups = "groups"
    }
}
