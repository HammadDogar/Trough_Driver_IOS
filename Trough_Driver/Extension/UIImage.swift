//
//  UIImage.swift
//  Trough_Driver
//
//  Created by Macbook on 04/03/2021.
//

import UIKit
import SDWebImage

extension UIImageView{
    func setImage(url:URL)  {
        
        self.sd_imageIndicator = SDWebImageActivityIndicator.gray
        self.sd_imageIndicator?.startAnimatingIndicator()
        self.sd_setImage(with: url) { (img, err, cahce, URI) in
            self.sd_imageIndicator?.stopAnimatingIndicator()
            if err == nil{
                self.image = img
            }else{
                self.image = UIImage(named: "PlaceHolder")
            }
        }
    }
    
    func getImage(url:String?){
        print("hello")
        let urlString = URL(string: url!)
        URLSession.shared.dataTask(with: urlString!){(data,response,error) in
            if let error = error{
                print(error.localizedDescription)
                return
            }
            
            guard let data = data else{
                print("Data is empty")
                return
            }
            
            DispatchQueue.main.async {
                if let image = UIImage(data: data){
                    self.image = image
                }
            }
        }.resume()
    }

}
