//
//  BaseServices.swift
//  Trough_Driver
//
//  Created by Macbook on 23/02/2021.
//

import UIKit

class BaseServices: NSObject {
    
    func getSuccessResponseMessage (_ message:String? = "Success")->(ServiceResponseMessage) {
        
        let svcResponse = ServiceResponseMessage()
        svcResponse.serviceResponseType = ServiceResponseType.Success
        svcResponse.message = message!
        
        return svcResponse
    }
    
    func getErrorResponseMessage (_ message: AnyObject?)->(ServiceResponseMessage) {
        
        let svcResponse = ServiceResponseMessage()
        svcResponse.serviceResponseType = ServiceResponseType.Failure
         svcResponse.message = "Failed Please Try Again!"//messageText
//        if let messageText = message as? String {
//            svcResponse.message = FAILED_MESSAGE//messageText
//        } else {
//            svcResponse.message = STRING_UNEXPECTED_ERROR
//        }
        
        return svcResponse
    }
    
    func getTimeoutErrorResponseMessage (_ message: AnyObject?)->(ServiceResponseMessage) {
        
        let svcResponse = ServiceResponseMessage()
        svcResponse.serviceResponseType = ServiceResponseType.Timeout
        svcResponse.message = "Request Time out"
//        if let messageText = message as? String {
//            svcResponse.message = TIMEOUT_MESSAGE//messageText
//        } else {
//            svcResponse.message = STRING_UNEXPECTED_ERROR
//        }
        
        return svcResponse;
    }
}
