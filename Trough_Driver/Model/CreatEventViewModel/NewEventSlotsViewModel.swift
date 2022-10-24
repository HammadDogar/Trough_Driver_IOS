//
//  NewEventSlotsViewModel.swift
//  Trough_Driver
//
//  Created by Macbook on 20/04/2021.
//

import Foundation

class NewEventSlotsViewModel:Encodable{
    var startDate = ""
    var startTime = ""
    var endTime   = ""
    
    init() {}
    
    init(sDate:String,sTime:String,eTime:String) {
        self.startDate = sDate
        self.startTime = sTime
        self.endTime   = eTime
    }
    
    func toDictionary() -> [String: Any]{
        return ["startDate": startDate,
                "startTime": startTime,
                "endTime": endTime]
    }
  
}
