//
//  Networks.swift
//  Trough_Driver
//
//  Created by Imed on 19/07/2021.
//

import Foundation
struct Networks : Codable {
    let available : [String]?
    let preferred : String?

    enum CodingKeys: String, CodingKey {

        case available = "available"
        case preferred = "preferred"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        available = try values.decodeIfPresent([String].self, forKey: .available)
        preferred = try values.decodeIfPresent(String.self, forKey: .preferred)
    }

}


