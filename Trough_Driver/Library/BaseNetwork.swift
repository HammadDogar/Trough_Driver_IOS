//
//  BaseNetwork.swift
//  Trough_Driver
//
//  Created by Macbook on 23/02/2021.
//

import UIKit

class BaseNetwork {
    
    func performUploadImageNetworkTaskPostEvent(isToken:Bool, requestMessage : NetworkRequestMessage, complete: @escaping ((_ responseMessage: NetworkResponseMessage)->Void))  {
        let responseMessage = NetworkResponseMessage()
        if let reallyURL = NSURL(string: requestMessage.url){
            var request = NSMutableURLRequest(url: reallyURL as URL)
            if isToken{
                self.addTokenHeader(request: &request)
            }
//            self.addCustomHeaders(request: &request)
            //self.configureRequest(request: &request, requestMessage: requestMessage)
            //self.addTokenHeader(request: &request)
            self.configureMultiPartUploadRequestPostEvent(request: &request, requestMessage: requestMessage)
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: request as URLRequest, completionHandler: { (incomingData, response, error) in
                if let err = error{
                    if err.localizedDescription.contains("timed out"){
                        responseMessage.statusCode = StatusCode.Timeout
                    }else{
                        responseMessage.statusCode = StatusCode.Failure
                    }
                    responseMessage.message = err.localizedDescription
                }else if let incomingData = incomingData {
                    let res = response as! HTTPURLResponse
                    print("STATUSCODE: \(res.statusCode)")
                    print("RESPONSE :  \(String(data: incomingData, encoding: String.Encoding.utf8)!)" )
                    let responseInStringFormat : String = String(data: incomingData, encoding: String.Encoding.utf8)!
                    print("----- Response -----")
                    print("\(responseInStringFormat)")
                    print("----- Response -----")
                    
                    responseMessage.statusCode = StatusCode.Success
                    responseMessage.message = "Success"
                    responseMessage.data = incomingData as AnyObject?
                }
                complete(responseMessage)
                
            })
            
            task.resume()
        }
    }
    
    private func configureMultiPartUploadRequestPostEvent( request :inout NSMutableURLRequest , requestMessage : NetworkRequestMessage) {

        request.httpMethod = "POST"
        let parameeters = requestMessage.params
        let IMAGE_KEY = "ImageFile"
        let resizedImage = parameeters["ImageFile"] as! UIImage

        let boundary = generateBoundaryString()
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        let imageData = resizedImage.jpegData(compressionQuality: 0.1)
//        if(imageData == nil){
//            return
//        }
        if requestMessage.contentType == ContentType.JSON {
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            //var error: AutoreleasingUnsafeMutablePointer<NSError?> = nil
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: requestMessage.params, options:JSONSerialization.WritingOptions.prettyPrinted)

                request.httpBody = jsonData;
            } catch _ {
                /* TODO: Finish migration: handle the expression passed to error arg: error */
            }
        }
         else if requestMessage.contentType == ContentType.HTML {
//            var queryString = ""
//
//            for (key,value) in requestMessage.params {
//                let valueString = "\(value)".htmlEncodedString() //.URLEncodedValue
//                queryString = "\(queryString)\(key)=\(valueString)&"
//            }
//
//            if queryString.count > 0{
//                queryString = queryString.substring(to: queryString.endIndex)
//            }

            request.httpBody = self.createBodyWithParameters(parameters: parameeters, filePathKey: IMAGE_KEY, imageDataKey: imageData! as NSData, boundary: boundary) as Data
//            request.httpBody =  queryString.data(using: String.Encoding.utf8, allowLossyConversion: false)

        }
    }


    
    func performUploadImageNetworkTask1(requestMessage : NetworkRequestMessage,imageKey:String = "File", complete: @escaping ((_ responseMessage: NetworkResponseMessage)->Void))  {
        let responseMessage = NetworkResponseMessage()
        if let reallyURL = NSURL(string: requestMessage.url){
            var request = NSMutableURLRequest(url: reallyURL as URL)
            self.addCustomHeaders(request: &request)
            //self.configureRequest(request: &request, requestMessage: requestMessage)
            self.addTokenHeader(request: &request)
            self.configureMultiPartUploadRequest1(request: &request, requestMessage: requestMessage,imageKey: imageKey)
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: request as URLRequest, completionHandler: { (incomingData, response, error) in
                if let err = error{
                    if err.localizedDescription.contains("timed out"){
                        responseMessage.statusCode = StatusCode.Timeout
                    }else{
                        responseMessage.statusCode = StatusCode.Failure
                    }
                    responseMessage.message = err.localizedDescription
                }else if let incomingData = incomingData {
                    let res = response as! HTTPURLResponse
                    print("STATUSCODE: \(res.statusCode)")
                    print("RESPONSE :  \(String(data: incomingData, encoding: String.Encoding.utf8)!)" )
                    let responseInStringFormat : String = String(data: incomingData, encoding: String.Encoding.utf8)!
                    print("----- Response -----")
                    print("\(responseInStringFormat)")
                    print("----- Response -----")
                    
                    responseMessage.statusCode = StatusCode.Success
                    responseMessage.message = "Success"
                    responseMessage.data = incomingData as AnyObject?
                }
                complete(responseMessage)
                
            })
            
            task.resume()
        }
    }
    
    private func configureMultiPartUploadRequest1( request :inout NSMutableURLRequest , requestMessage : NetworkRequestMessage, imageKey:String = "File") {

        request.httpMethod = POST_METHOD
        let parameeters = requestMessage.params
        let IMAGE_KEY = imageKey
        let resizedImage = parameeters[imageKey] as! UIImage

        let boundary = generateBoundaryString()
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        let imageData = resizedImage.jpegData(compressionQuality: 0.1)
        if(imageData == nil){
            return
        }
        if requestMessage.contentType == ContentType.JSON {
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            //var error: AutoreleasingUnsafeMutablePointer<NSError?> = nil
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: requestMessage.params, options:JSONSerialization.WritingOptions.prettyPrinted)

                request.httpBody = jsonData;
            } catch _ {
                /* TODO: Finish migration: handle the expression passed to error arg: error */
            }
        }
        else if requestMessage.contentType == ContentType.HTML {
            request.httpBody = self.createBodyWithParameters(parameters: parameeters, filePathKey: IMAGE_KEY, imageDataKey: imageData! as NSData, boundary: boundary) as Data
        }
        

        
    }
    
    func createBodyWithParameters(parameters: [String: AnyObject]?, filePathKey: String?, imageDataKey: NSData, boundary: String) -> NSData  {
        
        let body = NSMutableData()
        
        if parameters != nil {
            for (key, value) in parameters! {
                if(key != "image" && key != "imageKey"){
                    body.appendString(string: "--\(boundary)\r\n")
                    body.appendString(string: "Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
                    body.appendString(string: "\(value)\r\n")
                }
            }
        }
        let filename = "propertyFile.jpg"
        let mimetype = "image/jpg"
        body.appendString(string: "--\(boundary)\r\n")
        body.appendString(string: "Content-Disposition: form-data; name=\"\(filePathKey!)\"; filename=\"\(filename)\"\r\n")
        
        body.appendString(string: "Content-Type: \(mimetype)\r\n\r\n")
        body.append(imageDataKey as Data)
        body.appendString(string: "\r\n")
        body.appendString(string: "--\(boundary)--\r\n")
        
        return body as NSData
        
        
    }
    private  func addTokenHeader (request:inout NSMutableURLRequest){
          request.addValue("Bearer \(Global.shared.headerToken)", forHTTPHeaderField: "Authorization")
      }
    
    func performNetworkTask(isToken:Bool,requestMessage : NetworkRequestMessage, complete: @escaping ((_ responseMessage: NetworkResponseMessage)->Void)) {
      
      let responseMessage = NetworkResponseMessage()
      
      if let reallyURL = NSURL(string: requestMessage.url){
          
          var request = NSMutableURLRequest(url: reallyURL as URL)
        
         if isToken{
             self.addTokenHeader(request: &request)
         }
          self.configureRequest(request: &request, requestMessage: requestMessage)
          
          let session = URLSession(configuration: .default)
          
          let task = session.dataTask(with: request as URLRequest, completionHandler: { (incomingData, response, error) in
              
              if let err = error{
                  if err.localizedDescription.contains("timed out"){
                      responseMessage.statusCode = StatusCode.Timeout
                  }else{
                      responseMessage.statusCode = StatusCode.Failure
                  }
                  responseMessage.message = err.localizedDescription
              }else if let incomingData = incomingData {
                  let responseInStringFormat : String = String(data: incomingData, encoding: String.Encoding.utf8)!
                  print("----- Response -----")
                  print("\(responseInStringFormat)")
                  print("----- Response -----")
                  
                  responseMessage.statusCode = StatusCode.Success
                  responseMessage.message = "Success"
                  responseMessage.data = incomingData as AnyObject?
              }
              complete(responseMessage)
          })
          task.resume()
      }
  }
    
    private func configureGetRequest(request:inout NSMutableURLRequest , requestMessage : NetworkRequestMessage) {
        
        request.httpMethod = "GET"
        
        let queryString = ""
        
//        for (key,value) in requestMessage.params {
//            queryString = "\(queryString)\(key)=\(value)&"
//        }
//
//        if queryString.characters.count > 2{
//            queryString = queryString.substring(from: queryString.endIndex)
//            //queryString = queryString.substringToIndex(queryString.endIndex.predecessor())
//        }
        
        print(queryString)
        
        if let reallyURL = NSURL(string: requestMessage.url ){//+ "?" + queryString){
            request.url = reallyURL as URL
        }
        else{
            
        }
        
        print("----- GET Request -----")
        print("URL : \(String(describing: request.url))")
        print("Query String : \(queryString)")
        print("----- GET Request -----")
    }

    private func configurePostRequest( request:inout NSMutableURLRequest,requestMessage:NetworkRequestMessage){
        
        request.httpMethod = "POST"
        
        if(requestMessage.contentType == ContentType.JSON){
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            
            do {
                
                if !requestMessage.paramsArray.isEmpty {
                    let jsonData = try JSONSerialization.data(withJSONObject: requestMessage.paramsArray, options: .prettyPrinted)
                    request.httpBody = jsonData
                }else {
                    let jsonData = try JSONSerialization.data(withJSONObject: requestMessage.params, options: .prettyPrinted)
                    request.httpBody = jsonData
                }
            } catch _ {
                /* TODO: Finish migration: handle the expression passed to error arg: error */
            }
        }else if requestMessage.contentType == ContentType.HTML {
            
            var queryString = ""
            
            for (key,value) in requestMessage.params {
                let valueString = "\(value)".htmlEncodedString()
                queryString = "\(queryString)\(key)=\(valueString)&"
            }
            
//            if queryString.count > 0{
//                queryString  = String(queryString[..<queryString.endIndex])
//              //  queryString = queryString.substring(from: queryString.endIndex)// substringToIndex(queryString.endIndex.predecessor())
//            }
            
            print("----- POST Request -----")
            print("URL : \(String(describing: request.url))")
            print("Query String : \(queryString)")
            print("----- POST Request -----")
            request.httpBody = queryString.data(using: String.Encoding.utf8)
        }

    }
    
    private func configureRequest (request:inout NSMutableURLRequest , requestMessage : NetworkRequestMessage) {
        
        switch requestMessage.requestType {
            
        case RequestType.GET:
            
            self.configureGetRequest(request: &request, requestMessage: requestMessage)
            
        case RequestType.POST:
            
            self.configurePostRequest(request: &request, requestMessage: requestMessage)
            
        case RequestType.PUT:
            
            request.httpMethod = "PUT"
            
        case RequestType.DELETE:
            
            request.httpMethod = "DELETE"
            
        case RequestType.HEAD:
            
            request.httpMethod = "HEAD"
            
        case RequestType.OPTIONS:
            
            request.httpMethod = "OPTIONS"
            
        }
    }
    
    func generateBoundaryString() -> String {
        return "Boundary-\(NSUUID().uuidString)"
    }
    
    private func addCustomHeaders(request:inout NSMutableURLRequest){
        
        request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
       // request.addValue(Global.shared.API_TOKEN, forHTTPHeaderField: "Authorization")
        
    }
    
}
extension NSMutableData {
    
    func appendString(string: String) {
        let data = string.data(using: String.Encoding.utf8,allowLossyConversion: true)
        append(data!)
    }
    
}
