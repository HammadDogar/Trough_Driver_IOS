//
//  EventSlots.swift
//  Trough_Driver
//
//  Created by Macbook on 03/03/2021.
//

import Foundation
struct EventSlots : Codable {
    var slotId : Int?
    var eventId : Int?
    var startDate : String?
//    var startTime : StartTime?
//    var endTime : EndTime?
    var startTime : String?
    var endTime : String?

    enum CodingKeys: String, CodingKey {

        case slotId = "slotId"
        case eventId = "eventId"
        case startDate = "startDate"
        case startTime = "startTime"
        case endTime = "endTime"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.slotId = try values.decodeIfPresent(Int.self, forKey: .slotId)
        self.eventId = try values.decodeIfPresent(Int.self, forKey: .eventId)
        self.startDate = try values.decodeIfPresent(String.self, forKey: .startDate)
//        self.startTime = try values.decodeIfPresent(StartTime.self, forKey: .startTime)
//        self.endTime = try values.decodeIfPresent(EndTime.self, forKey: .endTime)
        let sTime = try values.decodeIfPresent(StartTime.self, forKey: .startTime)
        let eTime = try values.decodeIfPresent(EndTime.self, forKey: .endTime)
        self.startTime =  "\(sTime?.hours ?? 0):\(sTime?.minutes ?? 0)"
        
        self.endTime = "\(eTime?.hours ?? 0):\(eTime?.minutes ?? 0)"
    }

}
