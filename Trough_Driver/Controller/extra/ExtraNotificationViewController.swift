//
//  ExtraNotificationViewController.swift
//  Trough_Driver
//
//  Created by Imed on 13/10/2021.
//

import UIKit

class ExtraNotificationViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
   
    var friendName = ["test user","shan ahmed","test55","umair","ali"]
    var message = ["You have been invited to an event","You have been invited to an event","You have been invited to an event","You have been invited to an event","You have been invited to an event"]
var time = ["11:50pm","10:00am","12:00pm","10:30pm","12:25pm"]
    
    override func viewDidLoad() {
        super.viewDidLoad()


    }
    

}
extension ExtraNotificationViewController : UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ExtraNotificationTableViewCell", for: indexPath) as! ExtraNotificationTableViewCell
        cell.time.text = time[indexPath.row]
        cell.friendName.text = friendName[indexPath.row]
        cell.message.text = message[indexPath.row]
        return cell
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
        
    }
    
}
