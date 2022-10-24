//
//  CategroyViewController.swift
//  Trough_Driver
//
//  Created by Imed on 21/09/2021.
//

import UIKit

protocol CategoryViewDelegate {
    func didSelectCategory(categoryID : [Int])
}

class CategoryViewController: BaseViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
        
//    var categoryNameArray = ["Desserts","Italian","Healthy","American","Indian","Thai","Pasta","Ice Cream","Sandwich","Comfort Food","SeaFood","BBQ","Salads","Japanese","Deli","Frozen Yogurt","BreakFast and Brunch","Latin American","Juice and Smoothies","Coffee & Tea","Convenience","Vegan","Caribbean","Pakistani","Chicken"]
//
//    var categoryImageArray = [#imageLiteral(resourceName: "Desserts.png"),#imageLiteral(resourceName: "Italian.png"),#imageLiteral(resourceName: "Healthy.png"),#imageLiteral(resourceName: "amrecian.png"),#imageLiteral(resourceName: "Indian.png"),#imageLiteral(resourceName: "Thai.png"),#imageLiteral(resourceName: "pasta.png"),#imageLiteral(resourceName: "pngegg (11).png"),#imageLiteral(resourceName: "pngegg.png"),#imageLiteral(resourceName: "pngegg (6).png"),#imageLiteral(resourceName: "pngegg (2).png"),#imageLiteral(resourceName: "pngegg (3).png"),#imageLiteral(resourceName: "pngegg (4).png"),#imageLiteral(resourceName: "pngegg (5).png"),#imageLiteral(resourceName: "pngegg (1).png"),#imageLiteral(resourceName: "pngegg (7).png"),#imageLiteral(resourceName: "pngegg (9).png"),#imageLiteral(resourceName: "pngegg (10).png"),#imageLiteral(resourceName: "pngegg (11).png"),#imageLiteral(resourceName: "pngegg (12).png"),#imageLiteral(resourceName: "pngegg (13).png"),#imageLiteral(resourceName: "pngegg (14).png"),#imageLiteral(resourceName: "pngegg (15).png"),#imageLiteral(resourceName: "pngegg (16).png"),#imageLiteral(resourceName: "pngegg (8).png")]
    
    var selectedCategories = [CategoriesViewModel]()
    var selectionArray = [Int]()
//    private let minItemSpacing: CGFloat = 40
//    private let itemWidth: CGFloat = 120
    private let minItemSpacing: CGFloat = 10
    private let itemWidth: CGFloat      = 170
    
    var delegate : CategoryViewDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.getCategoriesList()
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        // Create our custom flow layout that evenly space out the items, and have them in the center
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: itemWidth, height: itemWidth)
        layout.minimumInteritemSpacing = minItemSpacing
        layout.minimumLineSpacing = minItemSpacing
//        layout.headerReferenceSize = CGSize(width: 0, height: headerHeight)

        // Find n, where n is the number of item that can fit into the collection view
        var n: CGFloat = 1
        let containerWidth = collectionView.bounds.width
        while true {
            let nextN = n + 1
            let totalWidth = (nextN*itemWidth) + (nextN-1)*minItemSpacing
            if totalWidth > containerWidth {
                break
            } else {
                n = nextN
            }
        }
        // Calculate the section inset for left and right.
        // Setting this section inset will manipulate the items such that they will all be aligned horizontally center.
        let inset = max(minItemSpacing, floor( (containerWidth - (n*itemWidth) - (n-1)*minItemSpacing) / 3 ) )
        layout.sectionInset = UIEdgeInsets(top: minItemSpacing, left: inset, bottom: minItemSpacing, right: inset)

        collectionView.collectionViewLayout = layout
    }
    
    @IBAction func actionBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func actionDone(_ sender: UIButton) {
        delegate?.didSelectCategory(categoryID: self.selectionArray)
        self.navigationController?.popViewController(animated: true)

    }
}

extension CategoryViewController : UICollectionViewDelegate , UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return categoryNameArray.count
        return selectedCategories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCell", for: indexPath) as! CategoryCollectionViewCell
//        cell.nameLabel.text = categoryNameArray[indexPath.row]
//        cell.categoryImage?.image = categoryImageArray[indexPath.row]
        let item = self.selectedCategories[indexPath.row]
        if let index = selectionArray.firstIndex(where: {$0 == item.categoryId}) {
            cell.statusLabel.text = "Selected"
            cell.selectedImage.image = #imageLiteral(resourceName: "foodCheckedBox")
            cell.categoryImageView.alpha = 0.5
//            cell.categoryImageView.image = #imageLiteral(resourceName: "toppng.com-checked-checkbox-icon-checkbox-ico-1577x1577-1")
        }else {
            cell.statusLabel.text = ""
            cell.selectedImage.image = UIImage.init(named: "")
            cell.categoryImageView.alpha = 1
//            cell.categoryImageView.image = UIImage(named: "")
        }
        cell.configure(getCategories: item)
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        let alert = UIAlertController(title: "Alert", message: "Add this category", preferredStyle: UIAlertController.Style.alert)
//        alert.addAction(UIAlertAction(title: "Yes", style: UIAlertAction.Style.default, handler: nil))
//        alert.addAction(UIAlertAction(title: "No", style: UIAlertAction.Style.default, handler: nil))
//        self.present(alert, animated: true, completion: nil)
        let id = selectedCategories[indexPath.row].categoryId
        if let index = selectionArray.firstIndex(where: {$0 == id}) {
            selectionArray.remove(at: index)
        }else {
            selectionArray.append(id ?? 0)
        }
        collectionView.reloadItems(at: [indexPath])
    }
}
extension CategoryViewController{
    //GetFoodCategories
    func getCategoriesList(){
        
        var params: [String:Any] = [String:Any]()
        params = [:] as [String : Any]
        
        let service = UserServices()
        GCD.async(.Main) {
    //        self.startActivityWithMessage(msg: "")
        }
        GCD.async(.Default) {
            
            service.GetFoodCategories(params: params) { (serviceResponse) in
                GCD.async(.Main) {
    //                self.stopActivity()
                }
                switch serviceResponse.serviceResponseType {
                case .Success :
                    GCD.async(.Main) {
                        
                        if let categoriesList = serviceResponse.data as? [CategoriesViewModel] {
                            self.selectedCategories = categoriesList
                            self.selectedCategories.sort(){
                                $0.name ?? "" < $1.name ?? ""
                            }
                            self.collectionView.reloadData()
                            print("Item found....")
                        }
                        else {
                            print("No Item Found!")
                        }
                    }
                case .Failure :
                    GCD.async(.Main) {
                        print("No Item Found!!!")
                    }
                default :
                    GCD.async(.Main) {
                        print("No Item Found!!")
                    }
                }
            }
        }
    }
}
