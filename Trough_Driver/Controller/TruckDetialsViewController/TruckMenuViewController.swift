//
//  TruckMenuViewController.swift
//  Trough_Driver
//
//  Created by Imed on 24/03/2021.
//

import UIKit
import SVProgressHUD

class TruckMenuViewController: UIViewController , UITableViewDelegate, UITableViewDataSource {
    
    var truckMenu = [TruckMenuViewModel]()
     
    var dealMenu = [MenuCategoryViewModel]()
    
    var regularMenu = [MenuCategoryViewModel]()
    
    var TypeId = 10

//    var fastMenu = [MenuCategoryViewModel]()
    
    var selectedMenu = [MenuCategoryViewModel]()
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var menuChange: UISegmentedControl!
    @IBOutlet weak var addBtn: UIButton!
    
    var id = 0

    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        
        tableView.reloadData()
        addBtn.isHidden = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        getTruckMenuList()
        
        // Hide the navigation bar on the this view controller
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
       override func viewWillDisappear(_ animated: Bool) {
           super.viewWillDisappear(animated)
           // Show the navigation bar on other view controllers
           self.navigationController?.setNavigationBarHidden(false, animated: animated)
       }
    
    
    @IBAction func menuChange(_ sender: UISegmentedControl) {
        
        switch sender.selectedSegmentIndex {
        case 0:
//            selectedArray = DealsArray
            selectedMenu = dealMenu
            TypeId = 10
            addBtn.isHidden = false
            
        case 1:
//            selectedArray = FastFoodArray
            selectedMenu = regularMenu
            TypeId = 9
            addBtn.isHidden = false

//        case 1:
////            selectedArray = PopularArray
//            selectedMenu = regularMenu
//            addBtn.isHidden = false
//
//        case 2:
////            selectedArray = FastFoodArray
//            selectedMenu = regularMenu
//            TypeId = 9
//            addBtn.isHidden = false
            
        default:
            print("----------------")
        }
        tableView.reloadData()
    }
    
    
    @IBAction func actionNotification(_ sender: UIButton) {
        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "NotificationViewController") as? NotificationViewController{
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @IBAction func actionAddMenu(_ sender: UIButton) {
        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "MenuDetailViewController") as? MenuDetailViewController{
            
            vc.menuType = "Add"
            vc.TypeId = TypeId
            
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func getTruckMenuList(){

        var params: [String:Any] = [String:Any]()
        params = [
            :
        ] as [String : Any]

        let service = Services()
        GCD.async(.Main) {
            SVProgressHUD.show()
          
        }
        GCD.async(.Default) {

            service.GetTruckMenu(params: params, truckId: Global.shared.currentUser.truckId!) { (serviceResponse) in
                GCD.async(.Main) {
                    SVProgressHUD.dismiss()
                }
                switch serviceResponse.serviceResponseType {
                case .Success :
                    GCD.async(.Main) {
                        if let Menu = serviceResponse.data as? [TruckMenuViewModel] {
                            self.truckMenu = Menu
                            
                            
                            self.regularMenu.removeAll()
                            self.dealMenu.removeAll()
//                            self.fastMenu.removeAll()
                            for category in Menu[0].categories!{
                                
                                if category.typeId == 9{
                                    self.regularMenu.append(category)
                                    print("Regular")
                                    
                                }
                                else {
                                    print("Deal")
                                    self.dealMenu.append(category)
                                    self.selectedMenu = self.dealMenu
                                }
                            }
                            self.tableView.reloadData()
                    }
                    else {
                        print("No Deal Found!")
                    }
                }
                case .Failure :
                    GCD.async(.Main) {
                        print("No Deal Found!")
                    }
                default :
                    GCD.async(.Main) {
                        print("No Deal Found!")
                    }
                }
            }
        }
    }
    
}

extension TruckMenuViewController{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return selectedMenu.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "menuCell", for: indexPath) as! MenuCell
        let dish = selectedMenu[indexPath.row]
        cell.setUpData(dish: dish)
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let path = NSIndexPath.init(row: indexPath.row, section: 0)
        let cell = tableView.cellForRow(at: path as IndexPath) as! MenuCell
        
        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "MenuDetailViewController") as? MenuDetailViewController{
            
            vc.menuType = "Edit"
            vc.dish = selectedMenu[indexPath.row]
            vc.MenuId = selectedMenu[indexPath.row].menuId!
            vc.CategoryId = selectedMenu[indexPath.row].categoryId!
            
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    
    
    
}
