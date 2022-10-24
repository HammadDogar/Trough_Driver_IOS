//
//  InvitedTruckListModel.swift
//  Trough_Driver
//
//  Created by Mateen Nawaz on 29/08/2022.
//

import Foundation
struct InvitedTruckListModel : Codable {
    let status : Int?
    let message : String?
    let data : [EventViewModel]?

    enum CodingKeys: String, CodingKey {
        case status = "status"
        case message = "message"
        case data = "data"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.status = try values.decodeIfPresent(Int.self, forKey: .status)
        self.message = try values.decodeIfPresent(String.self, forKey: .message)
        self.data = try values.decodeIfPresent([EventViewModel].self, forKey: .data)
    }
}
