//
//  String.swift
//  Trough_Driver
//
//  Created by Macbook on 24/02/2021.
//

import UIKit

extension String{
    public func htmlEncodedString() -> String{
        if let str = self.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed){
            return str
        }
        else{
            return self
        }
    }
    func heightWithConstrainedWidth(width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: CGFloat(99999))
        let boundingBox = self.boundingRect(with: constraintRect, options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        
        return boundingBox.height
    }

}
