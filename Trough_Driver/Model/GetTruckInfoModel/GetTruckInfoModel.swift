//
//  GetTruckInfoModel.swift
//  Trough_Driver
//
//  Created by Imed on 31/08/2021.
//

import Foundation

struct GetTruckInfoModel : Codable {
    let truckId : Int?
    let name : String?
    let description : String?
    let bannerUrl : String?
    let address : String?
    let truckCategories : [TruckCategories]?
    let workHours : [WorkHours]?
//    let truckCategories  : [CategoriesViewModel]?
    
    enum CodingKeys: String, CodingKey {
        case truckId = "truckId"
        case name = "name"
        case description = "description"
        case bannerUrl = "bannerUrl"
        case address = "address"
        case truckCategories = "truckCategories"
        case workHours = "workHours"
        //        case truckCategories = "truckCategories"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        truckId = try values.decodeIfPresent(Int.self, forKey: .truckId)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        description = try values.decodeIfPresent(String.self, forKey: .description)
        bannerUrl = try values.decodeIfPresent(String.self, forKey: .bannerUrl)
        address = try values.decodeIfPresent(String.self, forKey: .address)
        truckCategories = try values.decodeIfPresent([TruckCategories].self, forKey: .truckCategories)
        workHours = try values.decodeIfPresent([WorkHours].self, forKey: .workHours)
//        truckCategories = try values.decode([CategoriesViewModel].self, forKey: .truckCategories)
    }
}
