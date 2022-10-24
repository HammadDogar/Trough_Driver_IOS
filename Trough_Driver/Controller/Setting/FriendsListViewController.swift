//
//  FriendsListViewController.swift
//  Trough_Driver
//
//  Created by Imed on 28/09/2021.
//

import UIKit

class FriendsListViewController: BaseViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var totalFriendCount: UILabel!
    
    var friendList = [FriendListViewModel]()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.getFriendList()
    }

    @IBAction func actionBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}

extension FriendsListViewController  : UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.totalFriendCount.text = String(self.friendList.count)
        return self.friendList.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! FriendListTableViewCell
        let list = self.friendList[indexPath.row]
        cell.config(list: list)
    return cell
    }
}

extension FriendsListViewController {
    func getFriendList(){
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
                        self.tableView.reloadData()
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

