//
//  CustomView.swift
//  Trough_Driver
//
//  Created by Macbook on 02/03/2021.
//

import UIKit

class topCornerView: UIView {


    
    
    override func layoutSubviews()
    {
        super.layoutSubviews()
        
            
        self.roundCornersView([.topLeft, .topRight], radius: 20)
     
    }
 
}
class bottomCornerView: UIView {


    
    
    override func layoutSubviews()
    {
        super.layoutSubviews()
        
            
        self.roundCornersView([.bottomLeft, .bottomRight], radius: 20)
     
    }
 
}

class customCellView : UIView {
   override func awakeFromNib() {
       super.awakeFromNib()
        
       self.layer.cornerRadius = 15
        
       self.layer.shadowRadius = 2
       self.layer.shadowOpacity = 0.5
       self.layer.shadowColor = UIColor.lightGray.cgColor
       self.layer.shadowOffset = CGSize(width: 0, height: 2)
    self.layer.borderWidth = 0.5
    self.layer.borderColor = UIColor.AppColor().cgColor
        
    }
    
}

class customCellView1 : UIView {
   override func awakeFromNib() {
       super.awakeFromNib()
        
       self.layer.cornerRadius = 15
        
       self.layer.shadowRadius = 2
       self.layer.shadowOpacity = 0.5
       self.layer.shadowColor = UIColor.lightGray.cgColor
       self.layer.shadowOffset = CGSize(width: 0, height: 2)
        
    }
    
}

class customButtonView : UIView {
   override func awakeFromNib() {
       super.awakeFromNib()
        
       self.layer.cornerRadius = 20
        
       self.layer.shadowRadius = 2
       self.layer.shadowOpacity = 0.5
       self.layer.shadowColor = UIColor.lightGray.cgColor
       self.layer.shadowOffset = CGSize(width: 0, height: 2)
    
    self.backgroundColor = UIColor.AppColor()
        
    }
    
}

class customBorderView : UIView {
   override func awakeFromNib() {
       super.awakeFromNib()
        
    self.layer.cornerRadius = 20
    self.backgroundColor = UIColor.green
       self.layer.shadowRadius = 2
       self.layer.shadowOpacity = 0.5
       self.layer.shadowColor = UIColor.lightGray.cgColor
       self.layer.shadowOffset = CGSize(width: 0, height: 2)
//    self.layer.borderWidth = 0.5
//    self.layer.borderColor = UIColor.AppColor().cgColor
        
    }
    
}
class customBorderView1 : UIView {
   override func awakeFromNib() {
       super.awakeFromNib()
        
    self.layer.cornerRadius = 20
    self.backgroundColor = UIColor.red
       self.layer.shadowRadius = 2
       self.layer.shadowOpacity = 0.5
       self.layer.shadowColor = UIColor.lightGray.cgColor
       self.layer.shadowOffset = CGSize(width: 0, height: 2)
//    self.layer.borderWidth = 0.5
//    self.layer.borderColor = UIColor.AppColor().cgColor
        
    }
    
}

extension UIView {
    
    
    
    func roundCornersView(_ corners: UIRectCorner, radius: CGFloat)
    {
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
        
    }
    
    
}
