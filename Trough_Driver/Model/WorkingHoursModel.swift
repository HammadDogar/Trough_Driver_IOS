//
//  WorkingHoursModel.swift
//  Trough_Driver
//
//  Created by Macbook on 18/03/2021.
//

import Foundation

struct WorkingHours {
//
//
//    var dayOfWeek : Int = 0
//    var startTime : String = ""
//    var endTime : String = ""
//    var isActive : Bool = true
//
//    init() {
//        self.dayOfWeek = -1
//        self.startTime = ""
//        self.endTime = ""
//        self.isActive = true
//    }
//
//    init(dayOfweek:Int,startTime:String,endTime:String,isActive:Bool) {
//        self.dayOfWeek = dayOfweek
//        self.startTime = startTime
//        self.endTime = endTime
//        self.isActive = isActive
//    }
    
    var day_id : Int = 0
    var title : String = ""
    var fromHours : String = ""
    var toHours : String = ""
    var isAvailable : Int = 0
    


    init () {
        self.day_id = -1
        self.title = ""
        self.fromHours = ""
        self.toHours = ""
        self.isAvailable = 0
    }

    init(day_id:Int,title:String,fromHours:String,toHours:String,isAvailable:Int) {

        self.day_id = day_id
        self.title = title
        self.fromHours = fromHours
        self.toHours = toHours
        self.isAvailable = isAvailable
    }
    
    private func returnDayID(for day: String) -> Int {
        switch day {
        case "Monday":
            return 0
        case "Tuesday":
            return 1
        case "Wednesday":
            return 2
        case "Thursday":
            return 3
        case "Friday":
            return 4
        case "Saturday":
            return 5
        case "Sunday":
            return 6
        default:
            return -1
        }
    }

    func toJson() -> [String: Any] {
        var dict: [String: Any] = [:]
        if title != "" {
            dict["dayOfWeek"] = self.returnDayID(for: title)
        }
        if fromHours != "" {
            dict["startTime"] = fromHours
        }
        if toHours != "" {
            dict["endTime"] = toHours
        }
        if isAvailable != 0 {
            dict["isActive"] = true
        }else {
            dict["isActive"] = false
        }
        return dict
    }
    
}
