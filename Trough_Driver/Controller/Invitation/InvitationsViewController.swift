//
//  InvitationsViewController.swift
//  Trough_Driver
//
//  Created by Macbook on 01/03/2021.
//

import UIKit
import SVProgressHUD

class InvitationsViewController: BaseViewController,UITableViewDataSource,UITableViewDelegate {
        
    var eventList = [EventViewModel]()
    var isGoingEvent = [EventViewModel]()
    
    var isGoingIndex:Int = 0
    
    var currenController : BaseNavigationViewController?
    var previousController : BaseNavigationViewController?
    
    var isInvite = false

    @IBOutlet weak var noResultLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.noResultLabel.isHidden = true
//        getActivityListing()
        getInvitationList()
        self.tableView.reloadData()
    }
    

    @IBAction func actionNotificationBtn(_ sender: UIButton) {
        //self.simpleAlert(title: "Alert", msg: "Notification Screen")
        
        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "NotificationViewController") as? NotificationViewController{
            self.navigationController?.pushViewController(vc, animated: true)
        }

    }
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "InvitationsViewController") as! InvitationsTableViewCell
//        if indexPath.row >= self.eventList.count{
//            cell.index = indexPath.row
//            cell.delegate = self
//            var item: EventViewModel?
//            print("is Going Index: \(isGoingIndex)")
//            item = self.isGoingEvent[isGoingIndex]
//
//            cell.configure(event: item!,isGoing: true)
//
//            if self.isGoingIndex < self.isGoingEvent.count-1{
//                isGoingIndex = isGoingIndex + 1
//            }
//
//            return cell
//        }
//        else{
            cell.index = indexPath.row
            cell.delegate = self
            var item: EventViewModel?
            item = self.eventList[indexPath.row]
            cell.configure(event: item!)
            
            return cell
        //}
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        var item: EventViewModel?
        item = self.eventList[indexPath.row]

        if let vc = storyboard?.instantiateViewController(withIdentifier: "InvitationDetailViewController") as? InvitationDetailViewController{

            vc.event = item
            
            self.navigationController?.pushViewController(vc, animated: true)

        }

    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

}

extension InvitationsViewController:InvitationBtnDelegate{
    
    func actionCancelBtn(eventId:Int) {
        let alert = UIAlertController(title: "Alert", message: "Are you sure you want to decline the invitation", preferredStyle: UIAlertController.Style.alert)

        alert.addAction(UIAlertAction(title: "No", style: .default, handler: { (action: UIAlertAction!) in
              print("Handle No logic here")
        }))

        alert.addAction(UIAlertAction(title: "Yes", style: .cancel, handler: { (action: UIAlertAction!) in
        print(eventId)
//            self.AcceptOrCancelBtnApi(eventId: eventId, isGoing: false)
            self.rejectEventInvitation(eventId: eventId)
        }))

        present(alert, animated: true, completion: nil)
    }
    
    func actionAcceptBtn(eventId:Int) {
        let alert = UIAlertController(title: "Alert", message: "Are you sure you want to accept the invitation", preferredStyle: UIAlertController.Style.alert)

        alert.addAction(UIAlertAction(title: "No", style: .default, handler: { (action: UIAlertAction!) in
            
        }))

        alert.addAction(UIAlertAction(title: "Yes", style: .cancel, handler: { (action: UIAlertAction!) in
            print(eventId)
//            self.AcceptOrCancelBtnApi(eventId: eventId, isGoing: true)
            self.acceptEventInvitation(eventId: eventId)
        }))

        present(alert, animated: true, completion: nil)

    }
    
    func actionOpenMap(event:EventViewModel?){
        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "InvitationMapViewController") as? InvitationMapViewController{
            vc.event = event
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func actionInvitationMessage(description: String){
        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "InvitationMessageViewController") as? InvitationMessageViewController{
            vc.eventDescription = description
            self.present(vc, animated: true, completion: nil)
        }
    }
    
    func AcceptOrCancelBtnApi(eventId:Int,isGoing:Bool){
        let params =
            [
                "eventId" : eventId,
                "isGoing" : isGoing
            ] as [String : Any]
        let service = Services()
        GCD.async(.Default) {
            SVProgressHUD.show()
            service.eventGoingOrMaybeRequest(params: params) { (serviceResponse) in

                switch serviceResponse.serviceResponseType {
                case .Success :
                    GCD.async(.Main) {
                        self.getActivityListing()
                        
                    }
                case .Failure :
                    GCD.async(.Main) {
                        print("No Events Found!,Failed")
                    }
                default :
                    GCD.async(.Main) {
                        print("No Events Found!")
                    }
                }
            }
        }
    }
}

//MARK:-

extension InvitationsViewController{
    
    func getActivityListing(){
        self.eventList.removeAll()
        self.isGoingEvent.removeAll()
        var params: [String:Any] = [String:Any]()
        params = [
            //            "userId" : "",
            //            "userLatitude" : 31.43123116444423,
            //            "userLongitude" : 74.2935532173374,
                        "radius" : 25
        ] as [String : Any]
        
//        params = ["createdById": Global.shared.currentUser.userId!]
            as [String : Any]
        print(params)

        let service = Services()
        SVProgressHUD.show()
        GCD.async(.Default) {
            service.getEventsListRequest(params: params) { (serviceResponse) in
                GCD.async(.Main) {
                    SVProgressHUD.dismiss()
                }
                switch serviceResponse.serviceResponseType {
                case .Success :
                    GCD.async(.Main) {
                        if let eventsList = serviceResponse.data as? [EventViewModel] {
                            //self.eventList = eventsList
                            print(eventsList.count)
                            for event in 0...eventsList.count-1{
                                if eventsList[event].isGoing == true{
                                    print("Event is Going is true")
                                    self.isGoingEvent.append(eventsList[event])
                                }
                                else{
                                    self.eventList.append(eventsList[event])
                                }
                                
                            }
                            if self.isGoingEvent.count > 1{
                                for event in 0...self.isGoingEvent.count-1{
                                    self.eventList.append(self.isGoingEvent[event])
                                }

                            }
                                                        

                            self.tableView.reloadData()
                            SVProgressHUD.dismiss()
                    }
                    else {
                        print("No Events Found!")
                    }
                }
                case .Failure :
                    GCD.async(.Main) {
                        print("No Events Found!,Failed")
                    }
                default :
                    GCD.async(.Main) {
                        print("No Events Found!")
                    }
                }
            }
        }
    }
    
    
    
    func getInvitationList(){
        
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
            
//            getTruckInvitationList
            service.getTruckInvitationList(params: params, truckId: Global.shared.currentUser.truckId!) { (serviceResponse) in
//            service.getInvitationList(params: params, truckId: Global.shared.currentUser.truckId!) { (serviceResponse) in
                GCD.async(.Main) {
//                    SVProgressHUD.dismiss()
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
    
    
    //acceptInvitationRequestOfEvent
    
    func acceptEventInvitation(eventId:Int){
        
        self.eventList.removeAll()
        var params: [String:Any] = [String:Any]()
        params = [ : ]  as [String : Any]
        
        let eventIdForInvitation = eventId
        print(params)
        let service = Services()
//        SVProgressHUD.show()
        GCD.async(.Main) {
            self.startActivityWithMessage(msg: "")

        }
        GCD.async(.Default) {

            service.acceptInvitationRequestOfEvent(params: params, eventId: eventIdForInvitation, truckId: Global.shared.currentUser.truckId!) { (serviceResponse) in

                GCD.async(.Main) {
//                    SVProgressHUD.dismiss()
                    self.stopActivity()

                }
                switch serviceResponse.serviceResponseType {
                case .Success :
                    GCD.async(.Main) {
                        
                        if let invitationList = serviceResponse.data as? [EventViewModel] {
                            print(invitationList)
                            self.eventList = invitationList
//                            print(self.eventList)
                            self.simpleAlert(title: "Alert", msg: "Invitation was accepeted successfully")
                            self.getInvitationList()
                            self.tableView.reloadData()
                            print("Item found....")
                        }
                        else {
                            self.simpleAlert(title: "Alert", msg: "Invitation was accepeted successfully")
                            self.getInvitationList()
                            self.tableView.reloadData()
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
    
    //rejectInvitationRequestOfEvent
    
    func rejectEventInvitation(eventId:Int){
        
        self.eventList.removeAll()
        var params: [String:Any] = [String:Any]()
        params = [ : ]  as [String : Any]
        
        let eventIdForInvitation = eventId
        print(params)
        let service = Services()
//        SVProgressHUD.show()
        GCD.async(.Main) {
            self.startActivityWithMessage(msg: "")

        }
        GCD.async(.Default) {

            service.rejectInvitationRequestOfEvent(params: params, eventId: eventIdForInvitation, truckId: Global.shared.currentUser.truckId!) { (serviceResponse) in

                GCD.async(.Main) {
//                    SVProgressHUD.dismiss()
                    self.stopActivity()

                }
                switch serviceResponse.serviceResponseType {
                case .Success :
                    GCD.async(.Main) {
                        
                        if let invitationList = serviceResponse.data as? [EventViewModel] {
                            print(invitationList)
                            self.eventList = invitationList
//                            print(self.eventList)
                            self.simpleAlert(title: "Alert", msg: "Invitation was rejected successfully")
                            self.getInvitationList()
                            self.tableView.reloadData()
                            print("Item found....")
                        }
                        else {
                            self.simpleAlert(title: "Alert", msg: "Invitation was rejected successfully")
                            self.getInvitationList()
                            self.tableView.reloadData()
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
