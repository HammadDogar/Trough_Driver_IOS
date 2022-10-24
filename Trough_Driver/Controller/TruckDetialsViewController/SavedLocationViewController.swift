//
//  SavedLocationViewController.swift
//  Trough_Driver
//
//  Created by Imed on 12/04/2021.
//

import UIKit
import SVProgressHUD

class SavedLocationViewController: UIViewController,UITableViewDelegate, UITableViewDataSource  {
    
    @IBOutlet weak var tableView: UITableView!
    
    var userFavouriteLocation = [favouriteLocationViewModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.getUserFavouriteLocation()
        
    }
    
    
    @IBAction func backButton(_ sender: UIButton) {
        
        self.navigationController?.popViewController(animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.userFavouriteLocation.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let  cell = tableView.dequeueReusableCell(withIdentifier: "CellLocation", for: indexPath) as! FavouriteLocationTableViewCell
        
        cell.locationTitle.text = userFavouriteLocation[indexPath.row].title
        cell.locationDescription.text = userFavouriteLocation[indexPath.row].addres
        
        return cell
    
    }
        func getUserFavouriteLocation(){

        var params: [String:Any] = [String:Any]()
        params = [:] as [String : Any]

        let service = UserServices()
        GCD.async(.Main) {
            SVProgressHUD.dismiss()
          
        }
        GCD.async(.Default) {
            service.UsersFavouriteLocations(params: params) { (serviceResponse) in
                GCD.async(.Main) {
                    SVProgressHUD.dismiss()
                }
                switch serviceResponse.serviceResponseType {
                case .Success :
                    GCD.async(.Main) {
                        if let location = serviceResponse.data as? [favouriteLocationViewModel] {
                            self.userFavouriteLocation = location
                            
                            
                            self.tableView.reloadData()
                    }
                    else {
                        print("No Location1 Found!")
                    }
                }
                case .Failure :
                    GCD.async(.Main) {
                        print("No Location2 Found!")
                    }
                default :
                    GCD.async(.Main) {
                        print("No Location3 Found!")
                    }
                }
            }
        }
    }
}

