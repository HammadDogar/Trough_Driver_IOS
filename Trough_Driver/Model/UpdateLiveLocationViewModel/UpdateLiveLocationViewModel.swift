//
//  UpdateLiveLocationViewModel.swift
//  Trough_Driver
//
//  Created by Macbook on 09/03/2021.
//

import Foundation
struct UpdateLiveLocationViewModel : Codable {
    var status : Int?
    var message : String?
    var data : Bool?

    enum CodingKeys: String, CodingKey {

        case status = "status"
        case message = "message"
        case data
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        status = try values.decodeIfPresent(Int.self, forKey: .status)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        data = try values.decodeIfPresent(Bool.self, forKey: .data)
    }

}
