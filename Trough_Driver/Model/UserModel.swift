//
//  UserModel.swift
//  Trough_Driver
//
//  Created by Macbook on 24/02/2021.
//

import Foundation

class UserModel: Codable {
    var status : Int?
    var message : String?
    var data : UserViewModel?
    
    init() {
        
    }
    
    enum UserModelKeys: String,CodingKey{
        case message
        case status
        case data
    }

    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: UserModelKeys.self)
        self.message = try values.decodeIfPresent(String.self, forKey: .message)
        self.status = try values.decodeIfPresent(Int.self, forKey: .status)
        self.data = try values.decodeIfPresent(UserViewModel.self, forKey: .data)
    }
}
