//
//  UserServices.swift
//  Trough_Driver
//
//  Created by Macbook on 23/02/2021.
//

import Foundation

class UserServices:BaseServices{
    //REGISTER USER
    func userRegistrationRequest(params : [String : Any], complete : @escaping(( _ serviceResponse : ServiceResponseMessage)->Void)){
        let url = SIGNUP_API
        let networkRequestMessage = NetworkRequestMessage.init(requestType: .POST, contentType: .JSON, url: url, params: params as Dictionary<String,AnyObject>)
        BaseNetwork().performNetworkTask(isToken: false, requestMessage: networkRequestMessage) { (networkResponseMessage) in
//        BaseNetwork().performUploadImageNetworkTask1(requestMessage: networkRequestMessage,imageKey: "ProfileFile") { (networkResponseMessage) in
            switch networkResponseMessage.statusCode {
            case .Success :
                do {
                    let user = try JSONDecoder().decode(UserModel.self , from: networkResponseMessage.data as! Data)
                    if user.status == 1 {
                        let response = self.getSuccessResponseMessage()
                        response.message = user.message ?? ""
                        response.data = user.data
                        complete(response)
                    }
                    else {
                        let response = self.getErrorResponseMessage(FAILED_MESSAGE as AnyObject)
                        response.message = user.message ?? ""
                        complete(response)
                    }
                }catch _ {
                    let response = self.getErrorResponseMessage(FAILED_MESSAGE as AnyObject)
                    complete(response)
                }
            case .Failure :
                let response = self.getErrorResponseMessage("Failed Please Try Again!" as AnyObject)
                complete(response)
            case .Timeout :
                let response = self.getTimeoutErrorResponseMessage("Request Timeout" as AnyObject)
                complete(response)
            }
        }
    }
    
    //LOGIN USER
    func userLoginRequest(params : [String : Any], complete : @escaping(( _ serviceResponse : ServiceResponseMessage)->Void)){
        let url = LOGIN_API
        let networkRequestMessage = NetworkRequestMessage.init(requestType: .POST, contentType: .JSON, url: url, params: params as Dictionary<String,AnyObject>)
        BaseNetwork().performNetworkTask(isToken: false, requestMessage: networkRequestMessage) { (networkResponseMessage) in
            switch networkResponseMessage.statusCode {
            case .Success :
                do {
                    let user = try JSONDecoder().decode(UserModel.self , from: networkResponseMessage.data as! Data)
                    if user.status == 1 {
                        let response = self.getSuccessResponseMessage()
                        response.message = user.message ?? ""
                        response.data = user.data
                        complete(response)
                    }
                    else {
                        let response = self.getErrorResponseMessage("Failed Please Try Again!" as AnyObject)
                        response.message = user.message ?? ""
                        complete(response)
                    }
                }catch _ {
                    let response = self.getErrorResponseMessage("Failed Please Try Again!" as AnyObject)
                    complete(response)
                }
            case .Failure :
                let response = self.getErrorResponseMessage("Failed Please Try Again!" as AnyObject)
                complete(response)
            case .Timeout :
                let response = self.getTimeoutErrorResponseMessage("Request Timeout" as AnyObject)
                complete(response)
            }
        }
    }
    
    //Update USER Profile
    func updateUserProfile(params : [String : Any], complete : @escaping(( _ serviceResponse : ServiceResponseMessage)->Void)){
        let url = UPDATE_USER_PROFILE
        let networkRequestMessage = NetworkRequestMessage.init(requestType: .POST, contentType: .HTML, url: url, params: params as Dictionary<String,AnyObject>)
//
//        BaseNetwork().performUploadImageNetworkTask1(requestMessage: networkRequestMessage) { (networkResponseMessage) in
        BaseNetwork().performNetworkTask(isToken: true, requestMessage: networkRequestMessage) { (networkResponseMessage) in

            
            switch networkResponseMessage.statusCode {
            case .Success :
                do {
                    let user = try JSONDecoder().decode(UserModel.self , from: networkResponseMessage.data as! Data)
                    if user.status == 1 {
                        let response = self.getSuccessResponseMessage()
                        response.message = user.message ?? ""
                        response.data = user.data
                        complete(response)
                    }
                    else {
                        let response = self.getErrorResponseMessage(FAILED_MESSAGE as AnyObject)
                        response.message = user.message ?? ""
                        complete(response)
                    }
                }catch _ {
                    let response = self.getErrorResponseMessage(FAILED_MESSAGE as AnyObject)
                    complete(response)
                }

            case .Failure :
                let response = self.getErrorResponseMessage(FAILED_MESSAGE as AnyObject)
                complete(response)
            case .Timeout :
                let response = self.getTimeoutErrorResponseMessage("Request Timeout" as AnyObject)
                complete(response)
            }
        }
    }

    //UPDATE USER TOKEN
    func userDeviceTokenUpdateRequest(params : [String : Any], complete : @escaping(( _ serviceResponse : ServiceResponseMessage)->Void)){
        let url = USER_DEVICE_TOKEN_URL
        let networkRequestMessage = NetworkRequestMessage.init(requestType: .POST, contentType: .JSON, url: url, params: params as Dictionary<String,AnyObject>)
        BaseNetwork().performNetworkTask(isToken: true, requestMessage: networkRequestMessage) { (networkResponseMessage) in
            switch networkResponseMessage.statusCode {
            case .Success :
                do {
                    let user = try JSONDecoder().decode(BaseResponseViewModel.self , from: networkResponseMessage.data as! Data)
                    if user.status == 1 {
                        let response = self.getSuccessResponseMessage()
                        response.message = user.message ?? ""
                        complete(response)
                    }
                    else {
                        let response = self.getErrorResponseMessage(FAILED_MESSAGE as AnyObject)
                        response.message = user.message ?? ""
                        complete(response)
                    }
                }catch _ {
                    let response = self.getErrorResponseMessage(FAILED_MESSAGE as AnyObject)
                    complete(response)
                }
            case .Failure :
                let response = self.getErrorResponseMessage(FAILED_MESSAGE as AnyObject)
                complete(response)
            case .Timeout :
                let response = self.getTimeoutErrorResponseMessage("Request Timeout" as AnyObject)
                complete(response)
            }
        }
    }
    
    
    // User ResetPassword API REQUEST
    func ResetPasswordRequest(params : [String : Any], complete : @escaping(( _ serviceResponse : ServiceResponseMessage)->Void)){
        let url = RESET_PASSWORD_REQUEST
        let networkRequestMessage = NetworkRequestMessage.init(requestType: .POST, contentType: .JSON, url: url, params: params as Dictionary<String,AnyObject>)
        BaseNetwork().performNetworkTask(isToken: true, requestMessage: networkRequestMessage) { (networkResponseMessage) in
            switch networkResponseMessage.statusCode {
            case .Success :
                do {
                    let result = try JSONDecoder().decode(BaseResponseViewModel.self , from: networkResponseMessage.data as! Data)
                    if result.status == 1 {
                        let response = self.getSuccessResponseMessage()
                        response.message = result.message ?? ""
                        response.data = result.data as AnyObject?

                        complete(response)
                    }
                    else {
                        let response = self.getErrorResponseMessage("Failed Please Try Again!" as AnyObject)
                        response.message = result.message ?? ""
                        complete(response)
                    }
                }catch _ {
                    let response = self.getErrorResponseMessage("Failed Please Try Again!" as AnyObject)
                    complete(response)
                }
            case .Failure :
                let response = self.getErrorResponseMessage("Failed Please Try Again!" as AnyObject)
                complete(response)
            case .Timeout :
                let response = self.getTimeoutErrorResponseMessage("Request Timeout" as AnyObject)
                complete(response)
            }
        }
    }
    
    //GET NOTIFICATION API REQUEST
    func UsersFavouriteLocations(params : [String : Any], complete : @escaping(( _ serviceResponse : ServiceResponseMessage)->Void)){
        let url = GET_USER_FAVOURITE_LOCATIONS
        let networkRequestMessage = NetworkRequestMessage.init(requestType: .GET, contentType: .JSON, url: url, params: params as Dictionary<String,AnyObject>)
        BaseNetwork().performNetworkTask(isToken: true, requestMessage: networkRequestMessage) { (networkResponseMessage) in
            switch networkResponseMessage.statusCode {
            case .Success :
                do {
                    let result = try JSONDecoder().decode(FavouriteLocationResponseViewModel.self , from: networkResponseMessage.data as! Data)
                    if result.status == 1 {
                        let response = self.getSuccessResponseMessage()
                        response.message = result.message ?? ""
                        response.data = result.data as AnyObject?

                        complete(response)
                    }
                    else {
                        let response = self.getErrorResponseMessage(FAILED_MESSAGE as AnyObject)
                        response.message = result.message ?? ""
                        complete(response)
                    }
                }catch _ {
                    let response = self.getErrorResponseMessage(FAILED_MESSAGE as AnyObject)
                    complete(response)
                }
            case .Failure :
                let response = self.getErrorResponseMessage(FAILED_MESSAGE as AnyObject)
                complete(response)
            case .Timeout :
                let response = self.getTimeoutErrorResponseMessage("Request Timeout" as AnyObject)
                complete(response)
            }
        }
    }
    
    //Save User Location API REQUEST
    func SaveUserLocation(params : [String : Any], complete : @escaping(( _ serviceResponse : ServiceResponseMessage)->Void)){
//        let url = ADD_EDIT_USER_FAVOURITE_LOCATION
        let url = "https://troughapi.azurewebsites.net/api/UsersFavoriteLocation/AddEditV2"
        let networkRequestMessage = NetworkRequestMessage.init(requestType: .POST, contentType: .JSON, url: url, params: params as Dictionary<String,AnyObject>)
        BaseNetwork().performNetworkTask(isToken: true, requestMessage: networkRequestMessage) { (networkResponseMessage) in
            switch networkResponseMessage.statusCode {
            case .Success :
                do {
                    let result = try JSONDecoder().decode(BaseResponseViewModel.self , from: networkResponseMessage.data as! Data)
                    if result.status == 1 {
                        let response = self.getSuccessResponseMessage()
                        response.message = result.message ?? ""
                        response.data = result.data as AnyObject?

                        complete(response)
                    }
                    else {
                        let response = self.getErrorResponseMessage("Failed Please Try Again!" as AnyObject)
                        response.message = result.message ?? ""
                        complete(response)
                    }
                }catch _ {
                    let response = self.getErrorResponseMessage("Failed Please Try Again!" as AnyObject)
                    complete(response)
                }
            case .Failure :
                let response = self.getErrorResponseMessage("Failed Please Try Again!" as AnyObject)
                complete(response)
            case .Timeout :
                let response = self.getTimeoutErrorResponseMessage("Request Timeout" as AnyObject)
                complete(response)
            }
        }
    }
    
    //Get All User
    func getAllUser(params : [String : Any], complete : @escaping(( _ serviceResponse : ServiceResponseMessage)->Void)){
        let url = GET_ALL_USER
        let networkRequestMessage = NetworkRequestMessage.init(requestType: .GET, contentType: .JSON, url: url, params: params as Dictionary<String,AnyObject>)
        BaseNetwork().performNetworkTask(isToken: true, requestMessage: networkRequestMessage) { (networkResponseMessage) in
            switch networkResponseMessage.statusCode {
            case .Success :
                do {
                    let result = try JSONDecoder().decode(GetAllUserViewModel.self , from: networkResponseMessage.data as! Data)
                    if result.status == 1 {
                        let response = self.getSuccessResponseMessage()
                        response.message = result.message ?? ""
                        response.data = result.userData as AnyObject?

                        complete(response)
                    }
                    else {
                        let response = self.getErrorResponseMessage(FAILED_MESSAGE as AnyObject)
                        response.message = result.message ?? ""
                        complete(response)
                    }
                }catch _ {
                    let response = self.getErrorResponseMessage(FAILED_MESSAGE as AnyObject)
                    complete(response)
                }
            case .Failure :
                let response = self.getErrorResponseMessage(FAILED_MESSAGE as AnyObject)
                complete(response)
            case .Timeout :
                let response = self.getTimeoutErrorResponseMessage("Request Timeout" as AnyObject)
                complete(response)
            }
        }
    }

    func GetOrderByTruck(params : [String : Any], complete : @escaping(( _ serviceResponse : ServiceResponseMessage)->Void)){
        
        let url = GET_ORDER_BY_TRUCK
        let networkRequestMessage = NetworkRequestMessage.init(requestType: .GET, contentType: .JSON, url: url, params: params as Dictionary<String,AnyObject>)
        BaseNetwork().performNetworkTask(isToken: true, requestMessage: networkRequestMessage) { (networkResponseMessage) in
            switch networkResponseMessage.statusCode {
            case .Success :
                do {
                    let result = try JSONDecoder().decode(GetOrderByTruckResponseModel.self , from: networkResponseMessage.data as! Data)
                    if result.status == 1 {
                        let response = self.getSuccessResponseMessage()
                        response.message = result.message ?? ""
                        response.data = result.data as AnyObject?

                        complete(response)
                    }
                    else {
                        let response = self.getErrorResponseMessage(FAILED_MESSAGE as AnyObject)
                        response.message = result.message ?? ""
                        complete(response)
                    }
                }catch _ {
                    let response = self.getErrorResponseMessage(FAILED_MESSAGE as AnyObject)
                    complete(response)
                }
            case .Failure :
                let response = self.getErrorResponseMessage(FAILED_MESSAGE as AnyObject)
                complete(response)
            case .Timeout :
                let response = self.getTimeoutErrorResponseMessage("Request Timeout" as AnyObject)
                complete(response)
            }
        }
    }
    
    
    func GetPreOrderByTruck(params : [String : Any], complete : @escaping(( _ serviceResponse : ServiceResponseMessage)->Void)){
        
        let url = GET_PRE_ORDER_BY_TRUCK
        let networkRequestMessage = NetworkRequestMessage.init(requestType: .GET, contentType: .JSON, url: url, params: [:])
        BaseNetwork().performNetworkTask(isToken: true, requestMessage: networkRequestMessage) { (networkResponseMessage) in
            switch networkResponseMessage.statusCode {
            case .Success :
                do {
                    let result = try JSONDecoder().decode(GetOrderByTruckResponseModel.self , from: networkResponseMessage.data as! Data)
                    if result.status == 1 {
                        let response = self.getSuccessResponseMessage()
                        response.message = result.message ?? ""
                        response.data = result.data as AnyObject?

                        complete(response)
                    }
                    else {
                        let response = self.getErrorResponseMessage(FAILED_MESSAGE as AnyObject)
                        response.message = result.message ?? ""
                        complete(response)
                    }
                }catch _ {
                    let response = self.getErrorResponseMessage(FAILED_MESSAGE as AnyObject)
                    complete(response)
                }
            case .Failure :
                let response = self.getErrorResponseMessage(FAILED_MESSAGE as AnyObject)
                complete(response)
            case .Timeout :
                let response = self.getTimeoutErrorResponseMessage("Request Timeout" as AnyObject)
                complete(response)
            }
        }
    }
    
    
    //Complete Order Api
    func completeOrder(params : [String : Any],invoiceNumber:String, complete : @escaping(( _ serviceResponse : ServiceResponseMessage)->Void)){
        let url = "https://troughapi.azurewebsites.net/api/Orders/OrderComplete?invoiceNumber=\(invoiceNumber)".replacingOccurrences(of: "#", with: "%23")

        let networkRequestMessage = NetworkRequestMessage.init(requestType: .POST, contentType: .HTML, url: url, params: [:])
        BaseNetwork().performNetworkTask(isToken: true, requestMessage: networkRequestMessage) { (networkResponseMessage) in
            switch networkResponseMessage.statusCode {
            case .Success :
                do {
                    let result = try JSONDecoder().decode(BaseResponseViewModel.self , from: networkResponseMessage.data as! Data)
                    if result.status == 1 {
                        let response = self.getSuccessResponseMessage()
                        response.message = result.message ?? ""
                        response.data = result.data as AnyObject?

                        complete(response)
                    }
                    else {
                        let response = self.getErrorResponseMessage("Failed Please Try Again!" as AnyObject)
                        response.message = result.message ?? ""
                        complete(response)
                    }
                }catch _ {
                    let response = self.getErrorResponseMessage("Failed Please Try Again!" as AnyObject)
                    complete(response)
                }
            case .Failure :
                let response = self.getErrorResponseMessage("Failed Please Try Again!" as AnyObject)
                complete(response)
            case .Timeout :
                let response = self.getTimeoutErrorResponseMessage("Request Timeout" as AnyObject)
                complete(response)
            }
        }
    }
    
    
    func GetTerms(params : [String : Any], complete : @escaping(( _ serviceResponse : ServiceResponseMessage)->Void)){
        
        let url = GET_PRIVACY_AND_TERMS
        let networkRequestMessage = NetworkRequestMessage.init(requestType: .GET, contentType: .JSON, url: url, params: params as Dictionary<String,AnyObject>)
        BaseNetwork().performNetworkTask(isToken: true, requestMessage: networkRequestMessage) { (networkResponseMessage) in
            switch networkResponseMessage.statusCode {
            case .Success :
                do {
                    let result = try JSONDecoder().decode(TermsResponseModel.self , from: networkResponseMessage.data as! Data)
                    if result.status == 1 {
                        let response = self.getSuccessResponseMessage()
                        response.message = result.message ?? ""
                        response.data = result.data as AnyObject?

                        complete(response)
                    }
                    else {
                        let response = self.getErrorResponseMessage(FAILED_MESSAGE as AnyObject)
                        response.message = result.message ?? ""
                        complete(response)
                    }
                }catch _ {
                    let response = self.getErrorResponseMessage(FAILED_MESSAGE as AnyObject)
                    complete(response)
                }
            case .Failure :
                let response = self.getErrorResponseMessage(FAILED_MESSAGE as AnyObject)
                complete(response)
            case .Timeout :
                let response = self.getTimeoutErrorResponseMessage("Request Timeout" as AnyObject)
                complete(response)
            }
        }
    }
    //Add Friend API REQUEST
    func addFriendRequest(params : [String : Any],FriendId:Int, complete : @escaping(( _ serviceResponse : ServiceResponseMessage)->Void)){
        let url = "https://troughapi.azurewebsites.net/api/Users/AddFriend?friendId=\(FriendId)"
        let networkRequestMessage = NetworkRequestMessage.init(requestType: .POST, contentType: .JSON, url: url, params: params as Dictionary<String,AnyObject>)
        BaseNetwork().performNetworkTask(isToken: true, requestMessage: networkRequestMessage) { (networkResponseMessage) in
            switch networkResponseMessage.statusCode {
            case .Success :
                do {
                    let result = try JSONDecoder().decode(ResponseViewModel.self , from: networkResponseMessage.data as! Data)
                    if result.status == 1 {
                        let response = self.getSuccessResponseMessage()
                        response.message = result.message ?? ""
//                        response.data = result.data as AnyObject?

                        complete(response)
                    }
                    else {
                        let response = self.getErrorResponseMessage("Failed Please Try Again!" as AnyObject)
                        response.message = result.message ?? ""
                        complete(response)
                    }
                }catch _ {
                    let response = self.getErrorResponseMessage("Failed Please Try Again!" as AnyObject)
                    complete(response)
                }
            case .Failure :
                let response = self.getErrorResponseMessage("Failed Please Try Again!" as AnyObject)
                complete(response)
            case .Timeout :
                let response = self.getTimeoutErrorResponseMessage("Request Timeout" as AnyObject)
                complete(response)
            }
        }
    }
    //Add Friend API REQUEST
    func removeFriendRequest(params : [String : Any],FriendId:Int, complete : @escaping(( _ serviceResponse : ServiceResponseMessage)->Void)){
        let url = "https://troughapi.azurewebsites.net/api/Users/RemoveFriend?friendId=\(FriendId)"
        let networkRequestMessage = NetworkRequestMessage.init(requestType: .POST, contentType: .JSON, url: url, params: params as Dictionary<String,AnyObject>)
        BaseNetwork().performNetworkTask(isToken: true, requestMessage: networkRequestMessage) { (networkResponseMessage) in
            switch networkResponseMessage.statusCode {
            case .Success :
                do {
                    let result = try JSONDecoder().decode(ResponseViewModel.self , from: networkResponseMessage.data as! Data)
                    if result.status == 1 {
                        let response = self.getSuccessResponseMessage()
                        response.message = result.message ?? ""
                        //response.data = result.data as AnyObject?

                        complete(response)
                    }
                    else {
                        let response = self.getErrorResponseMessage("Failed Please Try Again!" as AnyObject)
                        response.message = result.message ?? ""
                        complete(response)
                    }
                }catch _ {
                    let response = self.getErrorResponseMessage("Failed Please Try Again!" as AnyObject)
                    complete(response)
                }
            case .Failure :
                let response = self.getErrorResponseMessage("Failed Please Try Again!" as AnyObject)
                complete(response)
            case .Timeout :
                let response = self.getTimeoutErrorResponseMessage("Request Timeout" as AnyObject)
                complete(response)
            }
        }
    }
    //GET FriendList API REQUEST
    func getFriendList(params : [String : Any], complete : @escaping(( _ serviceResponse : ServiceResponseMessage)->Void)){
        let url = GET_ALL_FRIEND
        let networkRequestMessage = NetworkRequestMessage.init(requestType: .GET, contentType: .JSON, url: url, params: params as Dictionary<String,AnyObject>)
        BaseNetwork().performNetworkTask(isToken: true, requestMessage: networkRequestMessage) { (networkResponseMessage) in
            switch networkResponseMessage.statusCode {
            case .Success :
                do {
                    let result = try JSONDecoder().decode(FriendListResponseViewModel.self , from: networkResponseMessage.data as! Data)
                    if result.status == 1 {
                        let response = self.getSuccessResponseMessage()
                        response.message = result.message ?? ""
                        response.data = result.friendList as AnyObject?

                        complete(response)
                    }
                    else {
                        let response = self.getErrorResponseMessage(FAILED_MESSAGE as AnyObject)
                        response.message = result.message ?? ""
                        complete(response)
                    }
                }catch _ {
                    let response = self.getErrorResponseMessage(FAILED_MESSAGE as AnyObject)
                    complete(response)
                }
            case .Failure :
                let response = self.getErrorResponseMessage(FAILED_MESSAGE as AnyObject)
                complete(response)
            case .Timeout :
                let response = self.getTimeoutErrorResponseMessage("Request Timeout" as AnyObject)
                complete(response)
            }
        }
    }
    
    
    //GET FriendRequest List API REQUEST
    func getFriendRequestList(params : [String : Any], complete : @escaping(( _ serviceResponse : ServiceResponseMessage)->Void)){
        let url = GET_ALL_FRIEND_REQUEST
        let networkRequestMessage = NetworkRequestMessage.init(requestType: .GET, contentType: .JSON, url: url, params: params as Dictionary<String,AnyObject>)
        BaseNetwork().performNetworkTask(isToken: true, requestMessage: networkRequestMessage) { (networkResponseMessage) in
            switch networkResponseMessage.statusCode {
            case .Success :
                do {
                    let result = try JSONDecoder().decode(FriendListResponseViewModel.self , from: networkResponseMessage.data as! Data)
                    if result.status == 1 {
                        let response = self.getSuccessResponseMessage()
                        response.message = result.message ?? ""
                        response.data = result.friendList as AnyObject?

                        complete(response)
                    }
                    else {
                        let response = self.getErrorResponseMessage(FAILED_MESSAGE as AnyObject)
                        response.message = result.message ?? ""
                        complete(response)
                    }
                }catch _ {
                    let response = self.getErrorResponseMessage(FAILED_MESSAGE as AnyObject)
                    complete(response)
                }
            case .Failure :
                let response = self.getErrorResponseMessage(FAILED_MESSAGE as AnyObject)
                complete(response)
            case .Timeout :
                let response = self.getTimeoutErrorResponseMessage("Request Timeout" as AnyObject)
                complete(response)
            }
        }
    }
    
    
    //Add Friend API REQUEST
    func acceptOrRejectFriendRequest(params : [String : Any], complete : @escaping(( _ serviceResponse : ServiceResponseMessage)->Void)){
        let url = ACCEPT_REJECT_FRIEND_REQUEST
        let networkRequestMessage = NetworkRequestMessage.init(requestType: .POST, contentType: .JSON, url: url, params: params as Dictionary<String,AnyObject>)
        BaseNetwork().performNetworkTask(isToken: true, requestMessage: networkRequestMessage) { (networkResponseMessage) in
            switch networkResponseMessage.statusCode {
            case .Success :
                do {
                    let result = try JSONDecoder().decode(ResponseViewModel.self , from: networkResponseMessage.data as! Data)
                    if result.status == 1 {
                        let response = self.getSuccessResponseMessage()
                        response.message = result.message ?? ""
//                        response.data = result.data as AnyObject?

                        complete(response)
                    }
                    else {
                        let response = self.getErrorResponseMessage("Failed Please Try Again!" as AnyObject)
                        response.message = result.message ?? ""
                        complete(response)
                    }
                }catch _ {
                    let response = self.getErrorResponseMessage("Failed Please Try Again!" as AnyObject)
                    complete(response)
                }
            case .Failure :
                let response = self.getErrorResponseMessage("Failed Please Try Again!" as AnyObject)
                complete(response)
            case .Timeout :
                let response = self.getTimeoutErrorResponseMessage("Request Timeout" as AnyObject)
                complete(response)
            }
        }
    }
    
    
    func GetFoodCategories(params : [String : Any], complete : @escaping(( _ serviceResponse : ServiceResponseMessage)->Void)){
        
        let url = FOOD_CATEGORIES
        let networkRequestMessage = NetworkRequestMessage.init(requestType: .POST, contentType: .JSON, url: url, params: params as Dictionary<String,AnyObject>)
        BaseNetwork().performNetworkTask(isToken: true, requestMessage: networkRequestMessage) { (networkResponseMessage) in
            switch networkResponseMessage.statusCode {
            case .Success :
                do {
                  let result = try JSONDecoder().decode(CategoriesResponseViewModel.self , from: networkResponseMessage.data as! Data)
                    if result.status == 1 {
                        let response = self.getSuccessResponseMessage()
                        response.message = result.message ?? ""
                        response.data = result.data as AnyObject?

                        complete(response)
                    }
                    else {
                        let response = self.getErrorResponseMessage(FAILED_MESSAGE as AnyObject)
                        response.message = result.message ?? ""
                        complete(response)
                    }
                }catch _ {
                    let response = self.getErrorResponseMessage(FAILED_MESSAGE as AnyObject)
                    complete(response)
                }
            case .Failure :
                let response = self.getErrorResponseMessage(FAILED_MESSAGE as AnyObject)
                complete(response)
            case .Timeout :
                let response = self.getTimeoutErrorResponseMessage("Request Timeout" as AnyObject)
                complete(response)
            }
        }
    }

}
