//
//  NearByRestaurantsModel.swift
//  CC-Demo
//
//  Created by Naveed Ahmed on 3/25/19.
//  Copyright © 2019 Naveed Ahmed. All rights reserved.
//

import Foundation

struct NearByRestaurantsModel: Codable {
    let meta: Meta?
    let response: Response?
}

extension NearByRestaurantsModel {
    enum CodingKeys: String, CodingKey {
        case meta = "meta"
        case response = "response"
    }
}
