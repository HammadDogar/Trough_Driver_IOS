//
//  NetworkRequestMessage.swift
//  Trough_Driver
//
//  Created by Macbook on 23/02/2021.
//

import Foundation
enum RequestType{
    case GET
    case POST
    case PUT
    case DELETE
    case HEAD
    case OPTIONS
}

enum ContentType{
    case HTML
    case JSON
}
class NetworkRequestMessage {
    
    var requestType: RequestType
    var contentType: ContentType
    var url: String
    var restMethod: String?
    var params: Dictionary<String, AnyObject>
    var paramsArray: [Dictionary<String, AnyObject>]
    var completeUrl:URL
    
    required init () {
        requestType = RequestType.GET
        contentType = ContentType.JSON
        url = ""
        restMethod = ""
        params = Dictionary<String, AnyObject>()
        paramsArray = [Dictionary<String, AnyObject>]()
        self.completeUrl = URL(fileURLWithPath: "")
    }

    init (requestType: RequestType,
          contentType: ContentType,
          url: String,
          params: Dictionary<String, AnyObject>,
          paramsArray: [Dictionary<String, AnyObject>] = [],
          restMethod: String? = nil) {
        
        self.requestType = requestType
        self.contentType = contentType
        self.url = url
        self.restMethod = restMethod
        self.params = params
        self.paramsArray = paramsArray
        self.completeUrl = URL(fileURLWithPath: "")
    }
    init (requestType: RequestType,
          contentType: ContentType,
          url: String,
          params: Dictionary<String, AnyObject>,
          paramsArray: [Dictionary<String, AnyObject>] = [],
          restMethod: String? = nil,
          Url:URL) {
        
        self.requestType = requestType
        self.contentType = contentType
        self.url = url
        self.restMethod = restMethod
        self.params = params
        self.paramsArray = paramsArray
        self.completeUrl = Url
    }
    
}

