//
//  UpdateAvailabilityViewModel.swift
//  Trough_Driver
//
//  Created by Macbook on 08/03/2021.
//

import Foundation
struct UpdateAvailabilityViewModel : Codable {
    var status : Int?
    var message : String?
    var UpdateAvailability : Bool?

    enum CodingKeys: String, CodingKey {

        case status = "status"
        case message = "message"
        case UpdateAvailability = "data"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        status = try values.decodeIfPresent(Int.self, forKey: .status)
        message = try values.decodeIfPresent(String.self, forKey: .message)
        UpdateAvailability = try values.decodeIfPresent(Bool.self, forKey: .UpdateAvailability)
    }

}
