//
//  ThreeDSecureUsage.swift
//  Trough_Driver
//
//  Created by Imed on 19/07/2021.
//

import Foundation
struct ThreeDSecureUsage : Codable {
    let supported : Bool?

    enum CodingKeys: String, CodingKey {

        case supported = "supported"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        supported = try values.decodeIfPresent(Bool.self, forKey: .supported)
    }

}
