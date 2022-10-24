//
//  EventServices.swift
//  Trough_Driver
//
//  Created by Macbook on 03/03/2021.
//

import UIKit

class Services: BaseServices{
    
    //GET EVENTS LISITNG API REQUEST
    func getEventsListRequest(params : [String : Any], complete : @escaping(( _ serviceResponse : ServiceResponseMessage)->Void)){
        let url = GET_EVENTS_LISTING_URL
        let networkRequestMessage = NetworkRequestMessage.init(requestType: .POST, contentType: .JSON, url: url, params: params as Dictionary<String,AnyObject>)
        BaseNetwork().performNetworkTask(isToken: true, requestMessage: networkRequestMessage) { (networkResponseMessage) in
            switch networkResponseMessage.statusCode {
            case .Success :
                do {
                    let event = try JSONDecoder().decode(EventResponseViewModel.self , from: networkResponseMessage.data as! Data)
                    if event.status == 1 {
                        let response = self.getSuccessResponseMessage()
                        response.message = event.message ?? ""
                        response.data = event.eventList as AnyObject?

                        complete(response)
                    }
                    else {
                        let response = self.getErrorResponseMessage("Failed Please Try Again!" as AnyObject)
                        response.message = event.message ?? ""
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
    
    //GET NearBy Trucks LISITNG API REQUEST
    func getNearByTrucksListRequest(params : [String : Any], complete : @escaping(( _ serviceResponse : ServiceResponseMessage)->Void)){
        let url = GET_TRUCK_LISTING
        let networkRequestMessage = NetworkRequestMessage.init(requestType: .POST, contentType: .JSON, url: url, params: params as Dictionary<String,AnyObject>)
        BaseNetwork().performNetworkTask(isToken: true, requestMessage: networkRequestMessage) { (networkResponseMessage) in
            switch networkResponseMessage.statusCode {
            case .Success :
                do {
                    let result = try JSONDecoder().decode(NearByTruckResponseViewModel.self , from: networkResponseMessage.data as! Data)
                    if result.status == 1 {
                        let response = self.getSuccessResponseMessage()
                        response.message = result.message ?? ""
                        response.data = result.nearByTrucksList as AnyObject?

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
    
    //Truck User Availability API REQUEST
    func updateTruckUserAvailability(params : [String : Any], complete : @escaping(( _ serviceResponse : ServiceResponseMessage)->Void)){
        let url = UPDATE_TRUCK_AVAILABILITY
        let networkRequestMessage = NetworkRequestMessage.init(requestType: .POST, contentType: .JSON, url: url, params: params as Dictionary<String,AnyObject>)
        BaseNetwork().performNetworkTask(isToken: true, requestMessage: networkRequestMessage) { (networkResponseMessage) in
            switch networkResponseMessage.statusCode {
            case .Success :
                do {
                    let result = try JSONDecoder().decode(UpdateAvailabilityViewModel.self , from: networkResponseMessage.data as! Data)
                    if result.status == 1 {
                        let response = self.getSuccessResponseMessage()
                        response.message = result.message ?? ""
                        response.data = result.UpdateAvailability as AnyObject?

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
    
    //Update truck User Live Location
    func UpdateTruckLiveLocation(params : [String : Any], complete : @escaping(( _ serviceResponse : ServiceResponseMessage)->Void)){
        let url = UPDATE_TRUCK_Live_Location
        let networkRequestMessage = NetworkRequestMessage.init(requestType: .POST, contentType: .JSON, url: url, params: params as Dictionary<String,AnyObject>)
        BaseNetwork().performNetworkTask(isToken: true, requestMessage: networkRequestMessage) { (networkResponseMessage) in
            switch networkResponseMessage.statusCode {
            case .Success :
                do {
                    let result = try JSONDecoder().decode(UpdateLiveLocationViewModel.self , from: networkResponseMessage.data as! Data)
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
    
    //EVENTS GOING OR MAYBE API REQUEST
    func eventGoingOrMaybeRequest(params : [String : Any], complete : @escaping(( _ serviceResponse : ServiceResponseMessage)->Void)){
        let url = EVENT_GOING_MAYBE_URL
        let networkRequestMessage = NetworkRequestMessage.init(requestType: .POST, contentType: .JSON, url: url, params: params as Dictionary<String,AnyObject>)
        BaseNetwork().performNetworkTask(isToken: true, requestMessage: networkRequestMessage) { (networkResponseMessage) in
            switch networkResponseMessage.statusCode {
            case .Success :
                do {
                    let event = try JSONDecoder().decode(BaseResponseViewModel.self , from: networkResponseMessage.data as! Data)
                    if event.status == 1 {
                        let response = self.getSuccessResponseMessage()
                        response.message = event.message ?? ""
                        complete(response)
                    }
                    else {
                        let response = self.getErrorResponseMessage("Failed Please Try Again!" as AnyObject)
                        response.message = event.message ?? ""
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
    func notificatons(params : [String : Any], complete : @escaping(( _ serviceResponse : ServiceResponseMessage)->Void)){
        let url = "https://troughapi.azurewebsites.net/api/Notification/GetALL?take=50"
        let networkRequestMessage = NetworkRequestMessage.init(requestType: .GET, contentType: .JSON, url: url, params: params as Dictionary<String,AnyObject>)
        BaseNetwork().performNetworkTask(isToken: true, requestMessage: networkRequestMessage) { (networkResponseMessage) in
            switch networkResponseMessage.statusCode {
            case .Success :
                do {
                    let result = try JSONDecoder().decode(NotificationResponseViewModel.self , from: networkResponseMessage.data as! Data)
                    if result.status == 1 {
                        let response = self.getSuccessResponseMessage()
                        response.message = result.message ?? ""
                        response.data = result.notificationsList as AnyObject?

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
    
    //Forgot Password Api
    func ForgotpasswordApi(params : [String : Any],email:String,userRoleId:Int, complete : @escaping(( _ serviceResponse : ServiceResponseMessage)->Void)){
        let url =
            "https://troughapi.azurewebsites.net/api/Users/ForgotPassword?email=\(email)&userRoleId=\(userRoleId)"
        let networkRequestMessage = NetworkRequestMessage.init(requestType: .POST, contentType: .JSON, url: url, params: params as Dictionary<String,AnyObject>)
        BaseNetwork().performNetworkTask(isToken: false, requestMessage: networkRequestMessage) { (networkResponseMessage) in
            switch networkResponseMessage.statusCode {
            case .Success :
                do {
                    let result = try JSONDecoder().decode(UpdateLiveLocationViewModel.self , from: networkResponseMessage.data as! Data)
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
    
    //GET TruckMenu API REQUEST
    func GetTruckMenu(params : [String : Any], truckId:Int, complete : @escaping(( _ serviceResponse : ServiceResponseMessage)->Void)){
        let url = "https://troughapi.azurewebsites.net/api/Menu/GetMenuByTruckId?truckId=\(truckId)"
        let networkRequestMessage = NetworkRequestMessage.init(requestType: .GET, contentType: .JSON, url: url, params: params as Dictionary<String,AnyObject>)
        BaseNetwork().performNetworkTask(isToken: true, requestMessage: networkRequestMessage) { (networkResponseMessage) in
            switch networkResponseMessage.statusCode {
            case .Success :
                do {
                    let result = try JSONDecoder().decode(TruckMenuResponseViewModel.self , from: networkResponseMessage.data as! Data)
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
    
    //Add Menu
    func addMenuRequest(params : [String : Any], complete : @escaping(( _ serviceResponse : ServiceResponseMessage)->Void)){
        let url = ADD_MENU_API
        let networkRequestMessage = NetworkRequestMessage.init(requestType: .POST, contentType: .JSON, url: url, params: params as Dictionary<String,AnyObject>)
        
        BaseNetwork().performNetworkTask(isToken: true, requestMessage: networkRequestMessage) { (networkResponseMessage) in

//        BaseNetwork().performUploadImageNetworkTask1(requestMessage: networkRequestMessage,imageKey: "ImageFile") { (networkResponseMessage) in
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
    
    //Edit Add Menu
    func editMenuRequest(params : [String : Any], complete : @escaping(( _ serviceResponse : ServiceResponseMessage)->Void)){
        let url = Edit_MENU_API
        let networkRequestMessage = NetworkRequestMessage.init(requestType: .POST, contentType: .JSON, url: url, params: params as Dictionary<String,AnyObject>)
        
        BaseNetwork().performNetworkTask(isToken: true, requestMessage: networkRequestMessage) { (networkResponseMessage) in

//        BaseNetwork().performUploadImageNetworkTask1(requestMessage: networkRequestMessage,imageKey: "ImageFile") { (networkResponseMessage) in
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
    
    //GET TRUCK INFO
    func GetTruckInfomation(params : [String : Any], complete : @escaping(( _ serviceResponse : ServiceResponseMessage)->Void)){
       
        let url = "https://troughapi.azurewebsites.net/api/FoodTruck/GetTruckInfo"
        let networkRequestMessage = NetworkRequestMessage.init(requestType: .POST, contentType: .JSON, url: url, params: params as Dictionary<String,AnyObject>)
        BaseNetwork().performNetworkTask(isToken: true, requestMessage: networkRequestMessage) { (networkResponseMessage) in
            switch networkResponseMessage.statusCode {
            case .Success :
                do {
                    let result = try JSONDecoder().decode(GetTruckInfoResponseModel.self , from: networkResponseMessage.data as! Data)
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
    
    //UPDATE TRUCK INFO
    func updateTruckInfo(params : [String : Any], complete : @escaping(( _ serviceResponse : ServiceResponseMessage)->Void)){
        let url = UPDATE_TRUCK_INFO
        let networkRequestMessage = NetworkRequestMessage.init(requestType: .POST, contentType: .HTML, url: url, params: params as Dictionary<String,AnyObject>)
        
        BaseNetwork().performNetworkTask(isToken: true, requestMessage: networkRequestMessage) { (networkResponseMessage) in
            
//        BaseNetwork().performUploadImageNetworkTask1(requestMessage: networkRequestMessage,imageKey: "File") { (networkResponseMessage) in
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

    //UPDATE WORKING HOUR
    func updateWorkingHour(params : [[String : Any]], complete : @escaping(( _ serviceResponse : ServiceResponseMessage)->Void)){
        let url = UPDATE_WORK_HOURS
        let networkRequestMessage = NetworkRequestMessage.init(requestType: .POST, contentType: .JSON, url: url, params: [:], paramsArray: params as [Dictionary<String,AnyObject>]) //NetworkRequestMessage.init(requestType: .POST, contentType: .JSON, url: url, params: params as [Dictionary<String,AnyObject>])
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
    
    
    //GET invited Trucks LISITNG API REQUEST
    func getInvitationList(params : [String : Any], truckId:Int, complete : @escaping(( _ serviceResponse : ServiceResponseMessage)->Void)){
//        let url = GET_INVITATION_LIST
        let url = "https://troughapi.azurewebsites.net/api/Event/InviteTrucks?truckId=\(truckId)"
        let networkRequestMessage = NetworkRequestMessage.init(requestType: .GET, contentType: .JSON, url: url, params: params as Dictionary<String,AnyObject>)
        BaseNetwork().performNetworkTask(isToken: true, requestMessage: networkRequestMessage) { (networkResponseMessage) in
            switch networkResponseMessage.statusCode {
            case .Success :
                do {
                    let result = try JSONDecoder().decode(EventResponseViewModel.self , from: networkResponseMessage.data as! Data)
                    if result.status == 1 {
                        let response = self.getSuccessResponseMessage()
                        response.message = result.message ?? ""
                        response.data = result.eventList as AnyObject?

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
    
        //GET invited-Trucks detials LISITNG API REQUEST
    func getTruckInvitationList(params : [String : Any], truckId:Int, complete : @escaping(( _ serviceResponse : ServiceResponseMessage)->Void)){
//        let url = GET_INVITATION_LIST
        let url = "https://troughapi.azurewebsites.net/api/Event/InviteTrucksDetails?truckId=\(truckId)"
        let networkRequestMessage = NetworkRequestMessage.init(requestType: .GET, contentType: .JSON, url: url, params: params as Dictionary<String,AnyObject>)
        BaseNetwork().performNetworkTask(isToken: true, requestMessage: networkRequestMessage) { (networkResponseMessage) in
            switch networkResponseMessage.statusCode {
            case .Success :
                do {
                    let result = try JSONDecoder().decode(EventResponseViewModel.self , from: networkResponseMessage.data as! Data)
                    if result.status == 1 {
                        let response = self.getSuccessResponseMessage()
                        response.message = result.message ?? ""
                        response.data = result.eventList as AnyObject?

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
    
    
    
        //GET accepted LISITNG API REQUEST
    func getTruckAcceptedInvitationList(params : [String : Any], truckId:Int, complete : @escaping(( _ serviceResponse : ServiceResponseMessage)->Void)){
//        let url = GET_INVITATION_LIST
        let url = "https://troughapi.azurewebsites.net/api/Event/GetAllAcceptedInvitionbyTrucks?truckId=\(truckId)"
        let networkRequestMessage = NetworkRequestMessage.init(requestType: .GET, contentType: .HTML, url: url, params: params as Dictionary<String,AnyObject>)
        BaseNetwork().performNetworkTask(isToken: true, requestMessage: networkRequestMessage) { (networkResponseMessage) in
            switch networkResponseMessage.statusCode {
            case .Success :
                do {
                    let result = try JSONDecoder().decode(EventResponseViewModel.self , from: networkResponseMessage.data as! Data)
                    if result.status == 1 {
                        let response = self.getSuccessResponseMessage()
                        response.message = result.message ?? ""
                        response.data = result.eventList as AnyObject?

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
    
    
    //INVITATION OF EVENTS FOR TRUCK API REQUEST
    func acceptInvitationRequestOfEvent(params : [String : Any],eventId:Int,truckId:Int, complete : @escaping(( _ serviceResponse : ServiceResponseMessage)->Void)){
        let url = "https://troughapi.azurewebsites.net/api/Event/AcceptInvitedTrucks?eventId=\(eventId)&truckId=\(truckId)"
        
//        let url = ACCEPT_EVENT_INVITATION_FOR_TRUCK
        let networkRequestMessage = NetworkRequestMessage.init(requestType: .GET, contentType: .JSON, url: url, params: params as Dictionary<String,AnyObject>)
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
    
    
    
    //INVITATION OF EVENTS FOR TRUCK TO Reject API REQUEST
    func rejectInvitationRequestOfEvent(params : [String : Any],eventId:Int,truckId:Int, complete : @escaping(( _ serviceResponse : ServiceResponseMessage)->Void)){
        let url = "https://troughapi.azurewebsites.net/api/Event/RejectInvitedTrucks?eventId=\(eventId)&truckId=\(truckId)"
        
//        let url = ACCEPT_EVENT_INVITATION_FOR_TRUCK
        let networkRequestMessage = NetworkRequestMessage.init(requestType: .GET, contentType: .JSON, url: url, params: params as Dictionary<String,AnyObject>)
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
}


