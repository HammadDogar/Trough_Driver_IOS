//
//  AcceptedViewController.swift
//  Trough_Driver
//
//  Created by Mateen Nawaz on 03/09/2022.
//

import UIKit

class AcceptedViewController: BaseViewController {

    @IBOutlet weak var noResultLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var eventList = [EventViewModel]()
    var isGoingEvent = [EventViewModel]()
    var isGoingIndex:Int = 0
    var currenController : BaseNavigationViewController?
    var previousController : BaseNavigationViewController?
    
    var isInvite = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.noResultLabel.isHidden = true
        getAcceptedInvitationList()
        self.tableView.reloadData()
       
    }
    


}


extension AcceptedViewController : UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.isGoingIndex = 0
        print(self.eventList.count)
        print(self.isGoingEvent.count)

//        return self.eventList.count //+ self.isGoingEvent.count
//

        if self.isInvite{
            (self.isGoingEvent.count > 0) ? (self.noResultLabel.isHidden = true) : (self.noResultLabel.isHidden = false)
            return self.isGoingEvent.count
        }else{
            (self.eventList.count > 0) ? (self.noResultLabel.isHidden = true) : (self.noResultLabel.isHidden = false)
            return self.eventList.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AcceptedEventCell") as! AcceptedEventCell

            cell.index = indexPath.row
            var item: EventViewModel?
            item = self.eventList[indexPath.row]
            cell.configure(event: item!)
            
            return cell
        //}
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        var item: EventViewModel?
        item = self.eventList[indexPath.row]

        if let vc = storyboard?.instantiateViewController(withIdentifier: "AcceptedDetialViewController") as? AcceptedDetialViewController{

            vc.event = item
            
            self.navigationController?.pushViewController(vc, animated: true)

        }

    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

extension AcceptedViewController{
    
    func getAcceptedInvitationList(){
        
        self.eventList.removeAll()
        var params: [String:Any] = [String:Any]()
        params = [
//                        "truckId" : Global.shared.currentUser.truckId!
            :
        ] as [String : Any]
        
        print(params)
        let service = Services()
//        SVProgressHUD.show()
        GCD.async(.Main) {
            self.startActivityWithMessage(msg: "")
        }
        GCD.async(.Default) {
            
            service.getTruckAcceptedInvitationList(params: params, truckId: Global.shared.currentUser.truckId!) { (serviceResponse) in

                GCD.async(.Main) {
                    self.stopActivity()

                }
                switch serviceResponse.serviceResponseType {
                case .Success :
                    GCD.async(.Main) {
                        
                        if let invitationList = serviceResponse.data as? [EventViewModel] {
                            print(invitationList)
                            self.eventList = invitationList
                            print(self.eventList)
                            self.tableView.reloadData()
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
