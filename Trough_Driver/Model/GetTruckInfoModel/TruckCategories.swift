//
//  TruckCategories.swift
//  Trough_Driver
//
//  Created by Imed on 15/11/2021.
//

import Foundation
struct TruckCategories : Codable {
    let categoryId : Int?
    let title : String?
    let name : String?
    let imageUrl : String?
    let createdDate : String?

    enum CodingKeys: String, CodingKey {

        case categoryId = "categoryId"
        case title = "title"
        case name = "name"
        case imageUrl = "imageUrl"
        case createdDate = "createdDate"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        categoryId = try values.decodeIfPresent(Int.self, forKey: .categoryId)
        title = try values.decodeIfPresent(String.self, forKey: .title)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        imageUrl = try values.decodeIfPresent(String.self, forKey: .imageUrl)
        createdDate = try values.decodeIfPresent(String.self, forKey: .createdDate)
    }

}
