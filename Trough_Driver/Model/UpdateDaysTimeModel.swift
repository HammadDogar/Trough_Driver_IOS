//
//  UpdateDaysTimeModel.swift
//  Trough_Driver
//
//  Created by Imed on 26/04/2021.
//

import Foundation

class UpdateDaysTimeModel: Codable {
    
    var dayOfWeek : String?
    var startTime : String?
    var endTime : String?
    
    
    
    enum UpdateDaysTimeModel : String, CodingKey {
        case dayOfWeek
        case startTime
        case endTime
    }
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: UpdateDaysTimeModel.self)
        self.dayOfWeek = try values.decodeIfPresent(String.self, forKey: .dayOfWeek)
        self.startTime = try values.decodeIfPresent(String.self, forKey: .startTime)
        
        
    }
    
}
