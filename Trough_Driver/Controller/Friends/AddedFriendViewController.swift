//
//  AddedFriendViewController.swift
//  Trough_Driver
//
//  Created by Mateen Nawaz on 30/08/2022.
//

import UIKit

class AddedFriendViewController: BaseViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var totalFriendCount: UILabel!
    @IBOutlet weak var noResultLabel: UILabel!

    var friendList = [FriendListViewModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.noResultLabel.isHidden = true

        self.getFriends()
    }

}

extension AddedFriendViewController : UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.totalFriendCount.text = String(self.friendList.count)
        if self.friendList.count > 0{
            self.noResultLabel.isHidden = true
            return self.friendList.count
        }
        else{
            self.noResultLabel.isHidden = false
        }
        return self.friendList.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AddedFriendCell", for: indexPath) as! AddedFriendCell
        let list = self.friendList[indexPath.row]
        cell.config(list: list)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
}
    


extension AddedFriendViewController {
    func getFriends(){
        var params: [String:Any] = [String:Any]()
        params = [:]
        let service = UserServices()
        GCD.async(.Main) {
            self.startActivityWithMessage(msg: "")
        }
        GCD.async(.Default) {
            service.getFriendList(params: params) { (serviceResponse) in
                GCD.async(.Main) {
                    self.stopActivity()
                }
                switch serviceResponse.serviceResponseType {
                case .Success :
                    GCD.async(.Main) {
                        if let friendList = serviceResponse.data as? [FriendListViewModel] {
                            self.friendList = friendList
                            
                            self.friendList.sort(){
                                $0.fullName ?? "" < $1.fullName ?? ""
                            }
                            self.tableView.reloadData()
                    }
                    else {
                        print("No Friend Found!")
                    }
                }
                case .Failure :
                    GCD.async(.Main) {
                        print("No Friend Found!!")
                    }
                default :
                    GCD.async(.Main) {
                        print("No Friend Found!!!")
                    }
                }
            }
        }
    }
}
