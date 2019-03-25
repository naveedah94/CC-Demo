//
//  Rain.swift
//  CC-Demo
//
//  Created by Naveed Ahmed on 3/24/19.
//  Copyright © 2019 Naveed Ahmed. All rights reserved.
//

import Foundation

struct Rain: Codable {
    let threeHourValue: Double?
}

extension Rain {
    enum CodingKeys: String, CodingKey {
        case threeHourValue = "3h"
    }
}
