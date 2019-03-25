//
//  Category.swift
//  CC-Demo
//
//  Created by Naveed Ahmed on 3/25/19.
//  Copyright © 2019 Naveed Ahmed. All rights reserved.
//

import Foundation

struct Category: Codable {
    let id: String?
    let name: String?
    let pluralName: String?
    let shortName: String?
    let icon: Icon?
}

extension Category {
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
        case pluralName = "pluralName"
        case shortName = "shortName"
        case icon = "icon"
    }
}

struct Icon: Codable {
    let prefix: String?
    let suffix: String?
}

extension Icon {
    enum CodingKeys: String, CodingKey {
        case prefix = "prefix"
        case suffix = "suffix"
    }
}
