//
//  UserViewModel.swift
//  Trough_Driver
//
//  Created by Macbook on 24/02/2021.
//

import Foundation

class UserData:Codable {
    var data : UserViewModel?
    var status: Int?
    var message: String?
    
    init() {
    }
    
    enum UserDataKeys: String,CodingKey{
        case data
        case status
        case message
        }
    
    required init(from decoder: Decoder) throws {
        let dataValues = try decoder.container(keyedBy: UserDataKeys.self)
        self.data = try dataValues.decodeIfPresent(UserViewModel.self, forKey: .data)
        self.status = try dataValues.decodeIfPresent(Int.self, forKey: .status)
        self.message = try dataValues.decodeIfPresent(String.self, forKey: .message)
        
    }
}

//monday 12-04 03:05


class UserViewModel: Codable {
    var userId: Int?
    var isActive: Bool?
//    var isAccountVerified : Bool?
    var truckId : Int?
//    var roleId : Int?
//    var role : String?
//    var createdDate : String?
    var token : String?
    var email: String?
    var phone: String?
    var fullName: String?
    var profileUrl: String?
    var address: String?
    
    init() {
    }
    
    enum UserViewModelKeys: String,CodingKey{
        case userId
        case isActive
//        case isAccountVerified
        case truckId
//        case roleId
//        case role
//        case createdDate
        case token
        case email
        case phone
        case fullName
        case profileUrl
        case address
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: UserViewModelKeys.self)
        self.userId = try values.decodeIfPresent(Int.self, forKey: .userId)
        self.isActive = try values.decodeIfPresent(Bool.self, forKey: .isActive)
//        self.isAccountVerified = try values.decodeIfPresent(Bool.self, forKey: .isAccountVerified)
        self.truckId = try values.decodeIfPresent(Int.self, forKey: .truckId)
//        self.roleId = try values.decodeIfPresent(Int.self, forKey: .roleId)
//        self.role = try values.decodeIfPresent(String.self, forKey: .role)
//        self.createdDate = try values.decodeIfPresent(String.self, forKey: .createdDate)
        self.token = try values.decodeIfPresent(String.self, forKey: .token)
        self.email = try values.decodeIfPresent(String.self, forKey: .email)
        self.phone = try values.decodeIfPresent(String.self, forKey: .phone)
        //self.password = try values.decodeIfPresent(String.self, forKey: .password)
        self.fullName = try values.decodeIfPresent(String.self, forKey: .fullName)
        self.profileUrl = try values.decodeIfPresent(String.self, forKey: .profileUrl)
        // 3 - Conditional Decoding
        if let address =  try values.decodeIfPresent(String.self, forKey: .address) {
                    self.address = address
                }else {
                    self.address = ""
                }
        
    }
    
}
