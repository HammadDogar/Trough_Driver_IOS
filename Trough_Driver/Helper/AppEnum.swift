//
//  AppEnum.swift
//  Trough_Driver
//
//  Created by Macbook on 15/04/2021.
//

import Foundation
enum ScrollDirection {
    case up, down
}
enum StoryBoard {
    case Main
    case Home
    case AddEvent
    
    var rawValue : String {
        switch self {
        case .Main:
            return "Main"
        case .Home:
            return "Home"
        case .AddEvent:
            return "AddEvent"
        }
    }
}
