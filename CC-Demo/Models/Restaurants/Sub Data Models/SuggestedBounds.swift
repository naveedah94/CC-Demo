//
//  SuggestedBounds.swift
//  CC-Demo
//
//  Created by Naveed Ahmed on 3/25/19.
//  Copyright © 2019 Naveed Ahmed. All rights reserved.
//

import Foundation

struct SuggestedBounds: Codable {
    let ne: LlModel?
    let sw: LlModel?
}

extension SuggestedBounds {
    enum CodingKeys: String, CodingKey {
        case ne = "ne"
        case sw = "sw"
    }
}


struct LlModel: Codable {
    let lat: Double?
    let lng: Double?
}

extension LlModel {
    enum CodingKeys: String, CodingKey {
        case lat = "lat"
        case lng = "lng"
    }
}
