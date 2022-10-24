//
//  BaseTableViewCell.swift
//  Trough_Driver
//
//  Created by Imed on 15/04/2021.
//

import UIKit
import SDWebImage

class BaseTableViewCell: UITableViewCell {
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func setImage(imageView:UIImageView,url:URL)  {
        imageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
        imageView.sd_imageIndicator?.startAnimatingIndicator()
        
        imageView.sd_setImage(with: url) { (img, err, cahce, URI) in
            imageView.sd_imageIndicator?.stopAnimatingIndicator()
            if err == nil{
                imageView.image = img
            }else{
                imageView.image = UIImage(named: "Dummy")
            }
            
            
        }
    }
}
