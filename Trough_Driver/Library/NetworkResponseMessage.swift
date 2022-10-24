//
//  NetworkResponseMessage.swift
//  Trough_Driver
//
//  Created by Macbook on 23/02/2021.
//

import Foundation

enum StatusCode{
    case Success
    case Failure
    case Timeout
    
}

class NetworkResponseMessage{
    
    var statusCode: StatusCode
    var message: String
    var data: AnyObject?
    
    required init () {
        
        statusCode = StatusCode.Failure
        message = "Unknown error"
        
    }
    
    init ( statusCode: StatusCode,
           message : String,
           data: AnyObject? = nil) {
        
        self.statusCode = statusCode
        self.message = message
        self.data = data
    }

}

