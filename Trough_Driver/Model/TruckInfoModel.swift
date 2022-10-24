//
//  TruckInfoModel.swift
//  Trough_Driver
//
//  Created by Imed on 25/04/2021.
//

import Foundation

class TruckInfoModel : Codable {
    
    var Name: String?
    var Address: String?
    var PermanentLatitude : Double?
    var PermanentLongitude : Double?
    var Description : String?
    var File : String?

    enum TruckInfoModel: String, CodingKey {
       
        case Name = "Name"
        case Address = "Address"
        case PermanentLatitude = "PermanentLatitude"
        case PermanentLongitude = "PermanentLongitude"
        case Description = "Description"
        case File = "File"
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: TruckInfoModel.self)
        self.Name = try values.decodeIfPresent(String.self, forKey: .Name)
        self.Description = try values.decodeIfPresent(String.self, forKey: .Description)
        self.PermanentLatitude = try values.decodeIfPresent(Double.self, forKey: .PermanentLatitude)
        self.PermanentLongitude = try values.decodeIfPresent(Double.self, forKey: .PermanentLongitude)
        self.Address = try values.decodeIfPresent(String.self, forKey: .Address)
        self.File = try values.decodeIfPresent(String.self, forKey: .File)
    }
    
}
