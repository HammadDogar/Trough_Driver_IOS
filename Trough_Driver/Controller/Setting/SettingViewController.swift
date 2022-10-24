//
//  SettingViewController.swift
//  Trough_Driver
//
//  Created by Macbook on 25/02/2021.
//

import UIKit
import SVProgressHUD

class SettingViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var settingsArray = ["My Locations","Accepted Events","Add-Edit Menu","Friends","Orders","User Settings","Logout"]
    
    var settingsImageArray : [UIImage] = [ UIImage(named: "locationiiCon")!,
                                           UIImage(named: "Event")!,
                                           UIImage(named: "menu")!,
                                           UIImage(named: "hand shake")!,
                                           UIImage(named: "orders")!,
                                           UIImage(named: "settingsIcon")!
                                           ,UIImage(named: "logoutCircle")!,]
    
    
//    var settingsImageArray = [#imageLiteral(resourceName: "locationiiCon"),#imageLiteral(resourceName: "menu"),#imageLiteral(resourceName: "hand shake"),#imageLiteral(resourceName: "settingsIcon"),#imageLiteral(resourceName: "logoutCircle")]
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func actionLogout(_ sender: UIButton) {
        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "home") as? UINavigationController
                   {
                       //Global.shared.userIsAvailable = false
                       updateUserAvailability(){ (response) in
                           print(response)
                           if response{
                               GlobalVariable.appDelegate.locationManager.stopUpdatingLocation()
                               let appsDelegate = UIApplication.shared.delegate
                               appsDelegate?.window??.rootViewController = nil
                               appsDelegate?.window??.rootViewController = vc
                           }
       
                       }
       
                   }
    }
    

    func updateUserAvailability(completion: @escaping (Bool)->Void){
        
        let params =
            [
                "isAvailable"        : false
                
            ] as [String : Any]
        
        let service = Services()
        SVProgressHUD.show()
        GCD.async(.Default) {
            service.updateTruckUserAvailability(params: params) { (serviceResponse) in
                GCD.async(.Main) {
                    SVProgressHUD.dismiss()
                  
                }
                switch serviceResponse.serviceResponseType {
                case .Success :
                    GCD.async(.Main) {
                        if let data = serviceResponse.data {
                            print(data)
                            
                            completion(true)
                                Global.shared.userIsAvailable = false
                                print(Global.shared.userIsAvailable)
                            
                            
                            SVProgressHUD.dismiss()
                        }
                        else {
                            self.simpleAlert(title: "Alert!", msg: "Error Updating User Status")
                            completion(false)
                        }
                    }
                case .Failure :
                    GCD.async(.Main) {
                        completion(false)
                        self.simpleAlert(title: "Alert!", msg: "Error Updating User Status")
                    }
                default :
                    GCD.async(.Main) {
                        completion(false)
                        self.simpleAlert(title: "Alert!", msg: "Error Updating User Status")
                    }
                }
            }
        }
    }
}
extension SettingViewController:UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settingsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "settingCell", for: indexPath) as! SettingTableViewCell
        cell.lblTitle.text = settingsArray[indexPath.row]
        cell.settingsImage.image = settingsImageArray[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == settingsArray.count-1{
            if let vc = self.storyboard?.instantiateViewController(withIdentifier: "home") as? UINavigationController
            {

                //Global.shared.userIsAvailable = false
                updateUserAvailability(){ (response) in
                    print(response)
                    if response{
                        GlobalVariable.appDelegate.locationManager.stopUpdatingLocation()
                        let appsDelegate = UIApplication.shared.delegate
                        appsDelegate?.window??.rootViewController = nil
                        appsDelegate?.window??.rootViewController = vc
                    }

                }

            }
        }
         if indexPath.row == 0{
            if let vc = UIStoryboard.init(name: "Others", bundle: nil).instantiateViewController(withIdentifier: "DriverLocationViewController") as? DriverLocationViewController
            {
                self.navigationController?.pushViewController(vc, animated: true)
            }
             
        }
        else if indexPath.row == 1{
            if let vc = UIStoryboard.init(name: "Friends", bundle: nil).instantiateViewController(withIdentifier: "AcceptedViewController") as? AcceptedViewController
            {
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
        
        else if indexPath.row == 2{
            if let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TruckMenuViewController") as? TruckMenuViewController
            {
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
        
        else if indexPath.row == 3{
            if let vc = UIStoryboard.init(name: "Friends", bundle: nil).instantiateViewController(withIdentifier: "FriendsViewController") as? FriendsViewController
            {
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
        
        else if indexPath.row == 4{
            if let vc = UIStoryboard.init(name: "Orders", bundle: nil).instantiateViewController(withIdentifier: "MyOrdersViewController") as? MyOrdersViewController
            {
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
        
        
        else if indexPath.row == 5{
            if let vc = UIStoryboard.init(name: "Others", bundle: nil).instantiateViewController(withIdentifier: "UserProfileViewController") as? UserProfileViewController
            {
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
        
    }
    
    
}
