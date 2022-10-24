//
//  BaseResponseViewModel.swift
//  Trough_Driver
//
//  Created by Macbook on 23/02/2021.
//

import Foundation

class BaseResponseViewModel : Codable {

    var status : Int?
    var message : String?
    var data : Bool?

    init() {
        self.status = 0
        self.message = ""
        self.data = false
    }

    enum BaseResponseKey : String,CodingKey {
        case message
        case status
        case data
    }

    required init(from decoder : Decoder)  throws {
        let values = try decoder.container(keyedBy: BaseResponseKey.self)
        self.message = try values.decodeIfPresent(String.self, forKey: .message)
        self.status = try values.decodeIfPresent(Int.self, forKey: .status)
        self.data = try values.decodeIfPresent(Bool.self, forKey: .data)
    }
}

class ResponseViewModel : Codable {

    var status : Int?
    var message : String?
    //var data : Bool?

    init() {
        self.status = 0
        self.message = ""
       // self.data = false
    }

    enum BaseResponseKey : String,CodingKey {
        case message
        case status
       // case data
    }

    required init(from decoder : Decoder)  throws {
        let values = try decoder.container(keyedBy: BaseResponseKey.self)
        self.message = try values.decodeIfPresent(String.self, forKey: .message)
        self.status = try values.decodeIfPresent(Int.self, forKey: .status)
        //self.data = try values.decodeIfPresent(Bool.self, forKey: .data)
    }
}
