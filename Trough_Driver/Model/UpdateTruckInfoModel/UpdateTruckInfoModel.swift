//
//  UpdateTruckInfoModel.swift
//  Trough_Driver
//
//  Created by Imed on 06/10/2021.
//

import Foundation

struct UpdateTruckInfoModel : Codable {
    let truckId : Int?
    let name : String?
    let description : String?
    let bannerUrl : String?
    let address : String?
//    let categoryIds  : [Int]?

    enum CodingKeys: String, CodingKey {

        case truckId = "truckId"
        case name = "name"
        case description = "description"
        case bannerUrl = "bannerUrl"
        case address = "address"
//        case categoryIds = "categoryIds"

    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        truckId = try values.decodeIfPresent(Int.self, forKey: .truckId)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        description = try values.decodeIfPresent(String.self, forKey: .description)
        bannerUrl = try values.decodeIfPresent(String.self, forKey: .bannerUrl)
        address = try values.decodeIfPresent(String.self, forKey: .address)
//        categoryIds = try values.decode([Int].self, forKey: .categoryIds)
    }

}
