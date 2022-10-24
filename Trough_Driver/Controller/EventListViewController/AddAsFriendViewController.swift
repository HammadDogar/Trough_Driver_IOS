//
//  AddFriendViewController.swift
//  Trough_Driver
//
//  Created by Imed on 27/09/2021.
//

import UIKit

protocol AddRemoveFriendDelgeate {
    func AddOrRemoveFriend()
}

class AddAsFriendViewController: BaseViewController {

    var list:EventViewModel?
    var isFriend: Bool = false
    
    var delegate:AddRemoveFriendDelgeate?

    @IBOutlet weak var friendButtonView: UIView!
    @IBOutlet weak var addFriendButton: UIButton!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var ImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadData()
        print(isFriend)
    }
    func loadData(){
        self.nameLabel.text = list?.fullName!
        
//                if list!.profileUrl != "" && list!.profileUrl != nil{
//                    let url = URL(string: BASE_URL+list!.profileUrl!) ?? URL.init(string: "https://www.google.com")!
//                    print(url)
//                    self.ImageView.setImage(url: url)
//                }else{   }
        
        if list!.profileUrl != "" && list!.profileUrl != nil{
            if let url = URL(string: list!.profileUrl   ?? "") {
                DispatchQueue.main.async {
                    self.ImageView.setImage(url: url)
                }
            }
        }else{}

        
        if isFriend{
            self.addFriendButton.setTitle("Remove Friend", for: .normal)
        }
        else{
            self.addFriendButton.setTitle("Add as friend", for: .normal)
        }
    }

    
    @IBAction func actionAddRemoveFriend(_ sender: UIButton) {
        if isFriend{
            self.removeAsFriend()
        }
        else{
            self.addAsFriend()
        }
    }
    
    @IBAction func actionCancelBtn(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func addAsFriend(){
        let params:[String:Any] = [
            "friendId": list!.createdById! ]
        print(params)
        let service = UserServices()
        GCD.async(.Default) {
            service.addFriendRequest(params: params,FriendId: self.list!.createdById!) { (serviceResponse) in
                GCD.async(.Main) {
                }
                switch serviceResponse.serviceResponseType {
                case .Success :
                    GCD.async(.Main) {
                        print("Success")
                        self.delegate?.AddOrRemoveFriend()
                        self.dismiss(animated: true, completion: nil)
                    }
                case .Failure :
                    GCD.async(.Main) {
                        self.simpleAlert(title: "Alert!", msg: serviceResponse.message)
                    }
                default :
                    GCD.async(.Main) {
                        self.simpleAlert(title: "Alert!", msg: serviceResponse.message)
                    }
                }
            }
        }
    }
    
    func removeAsFriend(){
        let params:[String:Any] = [
            "friendId": list!.createdById! ]
        print(params)
        let service = UserServices()
        GCD.async(.Default) {
            service.removeFriendRequest(params: params, FriendId: self.list!.createdById!) { (serviceResponse) in
                GCD.async(.Main) {
                  
                }
                switch serviceResponse.serviceResponseType {
                case .Success :
                    GCD.async(.Main) {
                        print("Success")
                        self.delegate?.AddOrRemoveFriend()
                        self.dismiss(animated: true, completion: nil)
                    }
                case .Failure :
                    GCD.async(.Main) {
                        self.simpleAlert(title: "Alert!", msg: serviceResponse.message)
                    }
                default :
                    GCD.async(.Main) {
                        self.simpleAlert(title: "Alert!", msg: serviceResponse.message)
                    }
                }
            }
        }
    }
}
