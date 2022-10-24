//
//  CategoryCollectionViewCell.swift
//  Trough_Driver
//
//  Created by Imed on 21/09/2021.
//

import UIKit

class CategoryCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var categoryImageView: UIImageView!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var selectedImage: UIImageView!
    
    var categories : CategoriesViewModel?

    func configure(getCategories : CategoriesViewModel){
        self.categories = getCategories
        self.nameLabel.text = "\(getCategories.name ?? "")"
//
//        if getCategories.imageUrl != "" && getCategories.imageUrl != nil{
//            let url = URL(string: BASE_URL+getCategories.imageUrl!) ?? URL.init(string: "https://www.google.com")!
//            self.categoryImageView?.setImage(url: url)
//        }else{
//
//        }
        
        if getCategories.imageUrl != "" && getCategories.imageUrl != nil{
            if let url = URL(string: getCategories.imageUrl! ) {
                DispatchQueue.main.async {
                    self.categoryImageView.setImage(url: url)
                }
            }
        }else{
            
        }
        
    }
    
}
