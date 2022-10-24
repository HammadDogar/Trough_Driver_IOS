//
//  FavouriteLocationResponseViewModel.swift
//  Trough_Driver
//
//  Created by Imed on 16/04/2021.
//

import Foundation
import UIKit


struct FavouriteLocationResponseViewModel : Codable {
    var status : Int?
    var message : String?
    var data : [favouriteLocationViewModel]?

    enum CodingKeys: String, CodingKey {

        case status = "status"
        case message = "message"
        case data = "data"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        status = try values.decodeIfPresent(Int.self, forKey: .status)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        data = try values.decodeIfPresent([favouriteLocationViewModel].self, forKey: .data)
    }

}


