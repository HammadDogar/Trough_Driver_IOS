//
//  File.swift
//  Trough_Driver
//
//  Created by Macbook on 20/04/2021.
//

import UIKit


struct GetAllUserViewModel : Codable {
    var status : Int?
    var message : String?
    var userData : [GetUserViewModel]?

    enum CodingKeys: String, CodingKey {

        case status = "status"
        case message = "message"
        case userData = "data"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        status = try values.decodeIfPresent(Int.self, forKey: .status)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        userData = try values.decodeIfPresent([GetUserViewModel].self, forKey: .userData)
    }

}

