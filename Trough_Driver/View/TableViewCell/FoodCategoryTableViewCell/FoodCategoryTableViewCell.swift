//
//  FoodCategoryTableViewCell.swift
//  Trough
//
//  Created by Irfan Malik on 05/01/2021.
//

import UIKit

protocol FoodCategoryTableViewCellDelegate:AnyObject {
    func categorySelected(indexes:[Int])
}

class FoodCategoryTableViewCell: UITableViewCell {

    @IBOutlet weak var collectionView: UICollectionView!
    
    var selectedFoodArray = [Int]()
    weak var delegate: FoodCategoryTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.register(UINib.init(nibName: "FoodCategoriesCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "FoodCategoriesCollectionViewCell")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    func config(){
        self.selectedFoodArray.removeAll()
        self.collectionView.reloadData()
    }
}

extension FoodCategoryTableViewCell:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Global.shared.foodCategoriesList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = self.collectionView.dequeueReusableCell(withReuseIdentifier: "FoodCategoriesCollectionViewCell", for: indexPath) as! FoodCategoriesCollectionViewCell
        cell.config(category: Global.shared.foodCategoriesList[indexPath.row].title ?? "")
        cell.delegate = self
        cell.index = indexPath.row
        if self.selectedFoodArray.contains(Global.shared.foodCategoriesList[indexPath.row].categoryID!){
            cell.btnCategory.isSelected = true
        }else{
            cell.btnCategory.isSelected = false
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.collectionView.frame.size.width/1.7, height: 40)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 2)
    }
}

extension FoodCategoryTableViewCell: FoodCategoriesCollectionViewCellDelegate{
    func selectFood(index: Int) {
        if self.selectedFoodArray.contains(index){
            let ind = self.selectedFoodArray.firstIndex(of:index)
            self.selectedFoodArray.remove(at: ind!)
        }else{
            self.selectedFoodArray.append(index)
        }
        self.delegate?.categorySelected(indexes: selectedFoodArray)
        self.collectionView.reloadData()
    }
}
