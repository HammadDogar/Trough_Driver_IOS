//
//  FoodCategoriesCollectionViewCell.swift
//  Trough
//
//  Created by Irfan Malik on 05/01/2021.
//

import UIKit
protocol FoodCategoriesCollectionViewCellDelegate:AnyObject {
    func selectFood(index: Int)
}


class FoodCategoriesCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var btnCategory:UIButton!
    var index = -1
    weak var delegate: FoodCategoriesCollectionViewCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    @IBAction func actionSelectFoodCategory(_ sender: Any){
        self.delegate?.selectFood(index: Global.shared.foodCategoriesList[self.index].categoryID!)
    }
    
    func config(category: String){
        self.btnCategory.setTitle(" \(category)", for: .normal)
    }

}
