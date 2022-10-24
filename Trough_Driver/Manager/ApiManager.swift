//
//  ApiManager.swift
//  Trough_Driver
//
//  Created by Imed on 17/02/2021.
//

import UIKit
import Alamofire
import SVProgressHUD




class ApiManager: NSObject {
    
    static let sharedInstance = ApiManager()
    
    func getOrPostMethod(url:String,parameters:Parameters?,method:HTTPMethod,profileImage:UIImage?,profileImageKey:String, completion: @escaping (Result<Any,Error>) -> Void){
        
        let urlString = url.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!
                
         let imageData = profileImage!.jpegData(compressionQuality: 0.4)         
        let imgStr = imageData!.base64EncodedString()
                print(imgStr)
        let header:HTTPHeaders = ["Content-type": "multipart/form-data"]
                
                let params = parameters
                
                let URL = try! URLRequest(url: urlString, method: method,headers: header)
                
                
                AF.upload(multipartFormData: { multiPart in
                    
                    
                    
                    if let paramatersDictionary = params
                    {
                        for (key, value) in paramatersDictionary
                        {
                            multiPart.append((value as AnyObject).data(using: String.Encoding.utf8.rawValue)!, withName: key)
                        }
                        
                        
                    }
                    
                    
                    
                    
                    
                    if profileImageKey != "" {
                        
                        
                        
                        if let singleImageData = imageData
                        {
                            
                            multiPart.append(singleImageData, withName: profileImageKey, fileName: "\(profileImageKey).jpg", mimeType: "image/jpg")
                        }
                        
                        
                        
                        
                    }
                    
                    
                }, with: URL)
                    .uploadProgress(queue: .main, closure: { progress in
                        //Current upload progress of file
                        print("Upload Progress: \(progress.fractionCompleted)")
                    })
                    .responseJSON(completionHandler: { response in
                        //Do what ever you want to do with response
                        
                        print(response)
                        
                        switch response.result {
                            
                            
                        case .success(let value):
                            
                            
                            if let JSON = value as? [String: Any] {
                                
                                let statusCode = JSON["status"] as! Int
                                
                                
                                if statusCode == 200 {
                                    
                                    completion(.success(value))
                                    
                                }
                                
                                
                        }
                            
                            
                        case .failure:
                            print("Error")
                        }
                        
                        
                        
                    })
        

    }



    func loginApiCall(params:[String:Any], url:String, method: String,completion: @escaping (Result<UserModel,Error>) -> Void,completionString: @escaping (String) -> Void){
        
        var task:URLSessionDataTask?
        
        SVProgressHUD.show()
        
        let urlString = URL(string: url)
        var request = URLRequest(url: urlString!)
        
        request.httpMethod = method
        
        
        print(params)
        
        do{
            request.httpBody = try JSONSerialization.data(withJSONObject: params, options: .fragmentsAllowed)
        }
        catch{
            print("error")
        }
        
        request.addValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        
        //request.addValue("Bearer \(LoginData.shared.token)", forHTTPHeaderField: "Authorization")
        
            task = URLSession.shared.dataTask(with: request){(data,response,error) in
                if let error = error{
                    print(error)
                    SVProgressHUD.dismiss()
                }
                 guard let data = data else{
                    SVProgressHUD.dismiss()
                    return
                }
                
                
                do{
//                    if let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String:Any]{
//                        print(json)
//
//
//                        if let jsonData = json["status"]{
//                            if jsonData as! Int == 1{
//                                print("Successfull")
//                                completion(.success(json))
//
//                            }
//                            print("Status code \(jsonData)")
//                            SVProgressHUD.dismiss()
//                        }
//
//                    }
                    let decoder = JSONDecoder()
                    let jsonData = try decoder.decode(UserModel.self, from: data)
                    
                    if jsonData.status! == 1{
                        DispatchQueue.main.async {
                            //print(jsonData.data)
                            print(jsonData)
                            SVProgressHUD.dismiss()
                            completion(.success(jsonData))
                        }
                    }
                    else{
                       // completion(.failure(error!))
                        var message = "Error"
                        if let responseMessage = jsonData.message {
                            message = responseMessage
                        }
                        DispatchQueue.main.async {
                            SVProgressHUD.dismiss()
                            completionString(message)
                        }
                    }

                }
                catch{
                    print("Error")
                    SVProgressHUD.dismiss()
                    completion(.failure(error))
                }
                
            }
            task?.resume()

        
            
}
    
    func SignupApiCall(params:[String:Any], url:String, method: String){
        
        var task:URLSessionDataTask?
        
        SVProgressHUD.show()
        
        let urlString = URL(string: url)
        var request = URLRequest(url: urlString!)
        
        request.httpMethod = method
        
        
        print(params)
        
        do{
            request.httpBody = try JSONSerialization.data(withJSONObject: params, options: .fragmentsAllowed)
        }
        catch{
            print("error")
        }
        let boundry = "----\(UUID().uuidString)"
        request.addValue("multipart/form-data; boundry=\(boundry)", forHTTPHeaderField: "Content-Type")
//        var requestData = Data()
//
//        requestData.append("--\(boundry)\r\n" .data(using: .utf8)!)
        
        
        
        
        //request.addValue("Bearer \(LoginData.shared.token)", forHTTPHeaderField: "Authorization")
        
            task = URLSession.shared.dataTask(with: request){(data,response,error) in
                if let error = error{
                    print(error)
                    SVProgressHUD.dismiss()
                }
                 guard let data = data else{
                    SVProgressHUD.dismiss()
                    return
                }
                
                
                do{
                    if let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String:Any]{
                        print(json)
                        
                                            
                        if let jsonData = json["status"]{
                            if jsonData as! Int == 1{
                                print("Successfull")
                                
                            }
                            print("Status code \(jsonData)")
                            SVProgressHUD.dismiss()
                        }
                        
                    }
                }
                catch{
                    print("Error")
                    SVProgressHUD.dismiss()
                }
                
            }
            task?.resume()

        
            
}
    
    
     func getPostMethodForMultiparts(URLString: String,  method:HTTPMethod ,  parameters: Parameters?, profileImageKey:String , profileImage:UIImage?,  successCallback: @escaping (NSDictionary) -> Void, errorCallBack: @escaping (String) -> Void) {
        
        let url = URLString.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!
        
        
        
        
        
        let params = parameters
        
        //   params?[IOS_APP_VERSION] = getAppVersion()
        
        let header:HTTPHeaders = ["Content-type": "multipart/form-data"]
        
        let URL = try! URLRequest(url: url, method: method,headers: header)
        
        
        AF.upload(multipartFormData: { multiPart in
            
            
            
            if let paramatersDictionary = params
            {
                for (key, value) in paramatersDictionary
                {
                    multiPart.append((value as AnyObject).data(using: String.Encoding.utf8.rawValue)!, withName: key)
                }
                
                
            }
            
            
            if profileImageKey != "" {
                
                
                
                if let singleImageData = profileImage?.jpegData(compressionQuality: 0.6)
                {
                    
                    multiPart.append(singleImageData, withName: profileImageKey, fileName: "\(profileImageKey).jpg", mimeType: "image/jpg")
                }
                
                
                
                
            }
            
            
            
            
            
        }, with: URL)
            .uploadProgress(queue: .main, closure: { progress in
                //Current upload progress of file
                print("Upload Progress: \(progress.fractionCompleted)")
            })
            .responseJSON(completionHandler: { response in
                //Do what ever you want to do with response
                
//                SharedManager.hideHud()
                
                print(response)
                
                switch response.result {
                    
                    
                case .success(let value):
                    
                    
                    if let JSON = value as? [String: Any] {
                        
                        
                        let keyExists = JSON["status"]
                        
                        if keyExists != nil
                        {
                            
                            
                            let statusCode = JSON["status"] as! Bool
                            
                            
                            if statusCode == true {
                                
                                successCallback(JSON as NSDictionary)
                                
                            }
                            else
                            {
                                var msg  = "Oops!!Something went wrong."
                                let keyExists = JSON["message"]
                                if keyExists != nil
                                {
                                    msg = JSON["message"] as! String
                                }
                                
                                let keyExistsVersion = JSON["version_ok"]
                                if keyExistsVersion != nil
                                {
                                    let bool = JSON["version_ok"] as! Bool
                                    if bool == false
                                    {
                                        
                                    }
                                }
                                
                                errorCallBack(msg)
                            }
                        }
                        else
                        {
                            print("aa")
                            errorCallBack("Oops!!Something went wrong.")
                        }
  
                    }
                    
                    
                case .failure(let error):
                    
                    
                    errorCallBack(error.localizedDescription)

                }

            })
   
    }
    
    
    
}

