//
//  GetTruckInfoResponseModel.swift
//  Trough_Driver
//
//  Created by Imed on 31/08/2021.
//

import Foundation
struct GetTruckInfoResponseModel : Codable {
    var status : Int?
    var message : String?
    var data : [GetTruckInfoModel]?

    enum CodingKeys: String,CodingKey{
        case message = "message"
        case status = "status"
        case data = "data"
    }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        status = try values.decodeIfPresent(Int.self, forKey: .status)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        data = try values.decodeIfPresent([GetTruckInfoModel].self, forKey:  .data)
    }

}
