//
//  Global.swift
//  Trough_Driver
//
//  Created by Macbook on 24/02/2021.
//

import UIKit


struct GlobalVariable {
    static var totalRange:Double = 2.0
    static var isTruckShow:Bool = true
    static var isEventShow:Bool = true
    static var truckCurrentLatitude:Double = 0.0
    static var truckCurrentLongitude:Double = 0.0
    static var isFirstTime:Bool = true
    static let appDelegate = UIApplication.shared.delegate as! AppDelegate
}


class Global {
    class var shared : Global {
        struct Static {
            static let instance : Global  = Global()
        }
        return Static.instance
    }
    
    var headerToken       = ""
    var userIsAvailable   = false
    
    var fcmToken: String = ""{
        didSet{
            if self.headerToken != "" && (oldValue != fcmToken){
                self.updateTokenApiCall()
            }
        }
    }
    
    
    
    var currentNavigationController = BaseNavigationViewController()
    var currentController = ""
    var currentUser = UserViewModel.init()

    var truckTimeSlot = [WorkHours]()
    var foodCategoriesList = [FoodCategoriesViewModel]()
    
    // SAVE LOGGED IN USER DATA
    func saveLoginUserData(){
        let encoder = JSONEncoder()
        do {
            let data = try encoder.encode(self.currentUser)
            UserDefaults.standard.set(data, forKey: CurrentUser)
            UserDefaults.standard.synchronize()
        }
        catch {
            print("Unexpected error: \(error).")
        }
    }
    
    // RETRIEVE SAVED USER DATA
    func loadLoginUserData(){
        let decoder = JSONDecoder()
        do {
            if let data = UserDefaults.standard.value(forKeyPath: CurrentUser) {
                self.currentUser = try decoder.decode(UserViewModel.self, from: data as! Data)
            }
        }
        catch {
            print("Unexpected error: \(error).")
        }
    }

    func updateTokenApiCall(){
        
        let params = [
            "deviceTypeId" : 12,
            "deviceToken"  : self.fcmToken
            ] as [String : Any]
        let service = UserServices()
//        GCD.async(.Main) {
//            self.startActivityWithMessage(msg: "")
//        }
        GCD.async(.Default) {
            service.userDeviceTokenUpdateRequest(params: params) { (serviceResponse) in
//                GCD.async(.Main) {
//                   self.stopActivity()
//                }
                switch serviceResponse.serviceResponseType {
                case .Success :
                    GCD.async(.Main) {
                        if USER_SUCCESS == serviceResponse.message {
                            print("Device Token is updated!")
                        }
                    }
                case .Failure :
                    GCD.async(.Main) {
                        print("Device Token is not updated!")
                    }
                default :
                    GCD.async(.Main) {
                        print("Device Token is not updated!")
                    }
                }
            }
        }
    }

}
