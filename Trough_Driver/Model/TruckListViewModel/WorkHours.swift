//
//  WorkHours.swift
//  Trough_Driver
//
//  Created by Macbook on 08/03/2021.
//

import Foundation

class WorkHours : Codable {
//    var dayOfWeek : Int = -1
//    var startTime : String = ""
//    var endTime : String = ""
//
//    var slotId : Int? = -1
//    var truckId : Int? = -1
//    var isActive : Bool? = true
    
    var dayOfWeek : Int?
    var startTime : String?
    var endTime : String?
    
    var slotId : Int?
    var truckId : Int?
    var isActive : Bool?
    
//    init(){
//
//    }
    
    enum CodingKeys: String, CodingKey {

        case dayOfWeek = "dayOfWeek"
        case startTime = "startTime"
        case endTime = "endTime"
        
        case slotId = "slotId"
        case truckId = "truckId"
        case isActive = "isActive"
    }

    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        dayOfWeek = try values.decodeIfPresent(Int.self, forKey: .dayOfWeek)!
        startTime = try values.decodeIfPresent(String.self, forKey: .startTime)!
        endTime = try values.decodeIfPresent(String.self, forKey: .endTime)!
        
        slotId = try values.decodeIfPresent(Int.self, forKey: .slotId)
        truckId = try values.decodeIfPresent(Int.self, forKey: .truckId)
        isActive = try values.decodeIfPresent(Bool.self, forKey: .isActive)
    }

}
