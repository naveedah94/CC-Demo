//
//  Meta.swift
//  CC-Demo
//
//  Created by Naveed Ahmed on 3/25/19.
//  Copyright © 2019 Naveed Ahmed. All rights reserved.
//

import Foundation

struct Meta: Codable {
    let code: Int?
    let requestId: String?
}

extension Meta {
    enum CodingKeys: String, CodingKey {
        case code = "code"
        case requestId = "requestId"
    }
}
