//
//  NotificationViewController.swift
//  Trough_Driver
//
//  Created by Macbook on 25/02/2021.
//

import UIKit
import SVProgressHUD

class NotificationViewController: BaseViewController
{
    var refreshControl = UIRefreshControl()
    var notifications = [NotificationViewModel]()
    var orders = [GetOrderByTruckModel]()
    var orderByTruckList = GetOrderByTruckModel()
    var selectedArray = [Any]()
    var id = 0
    var orderID = 0
    var preOrderID = 0
    
    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.getNotificationList()
        
//        self.getOrderList()
//        if segmentControl.selectedSegmentIndex == 0 {
//            self.getNotificationList()
//        }
//        self.selectedArray = notifications
//
        self.refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        self.tableView.addSubview(refreshControl)
        self.tableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Hide the navigation bar on the this view controller
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // Show the navigation bar on other view controllers
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    
    
    @IBAction func actionBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
        
    }
    
    @IBAction func actionChangeView(_ sender: UISegmentedControl) {
//        switch sender.selectedSegmentIndex {
//        case 0:
//            self.toogle(isNotification: true)
////            selectedArray = notifications
////            tableView.rowHeight = UITableView.automaticDimension
//        case 1:
//            self.toogle(isNotification: false)
////            selectedArray = orders
////            tableView.rowHeight = 400
//        default:
//            print("------------")
//        }
        tableView.reloadData()
    }
    
    @objc func refresh(_ sender: AnyObject) {
        if BReachability.isConnectedToNetwork(){
            self.getNotificationList()
        }else{
            self.simpleAlert(title: "Alert", msg: "Please check Your Internet Connection")
            self.refreshControl.endRefreshing()
        }
    }
    
    func toogle(isNotification : Bool){
        if isNotification == true{
            selectedArray = notifications
            tableView.rowHeight = UITableView.automaticDimension
        }
        else{
            selectedArray = orders
            tableView.rowHeight = 400

        }
            
    }
    
}

//MARK:- Table View Data Source
extension NotificationViewController:UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return selectedArray.count
        return notifications.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        if segmentControl.selectedSegmentIndex == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "NotificationTableViewCell", for: indexPath) as! NotificationTableViewCell
            cell.selectionStyle = .none
            let item = self.notifications[indexPath.row]
            print(item.createdDate!)
            cell.configure(notification: item)
            return cell
//        }
//        else {
//            let cell = tableView.dequeueReusableCell(withIdentifier: "TruckOrderTableViewCell", for: indexPath) as! TruckOrderTableViewCell
//            let item = self.orders[indexPath.row]
//            cell.configure(getOrder: item)
//            return cell
//        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if self.notifications[indexPath.row].redirectionId != 0 {
            print("---- to event details")
            let eventid = self.notifications[indexPath.row].redirectionId ?? 0
            self.id = eventid
            self.getEventsListing()
        }
        
        else if  self.notifications[indexPath.row].preOrderId != 0  {
            print("----  to pre order details")
            let order = self.notifications[indexPath.row].preOrderId ?? 0
            self.preOrderID = order
            self.getPreOrderList()
        }
        
        else if self.notifications[indexPath.row].orderId != 0 {
            print("---- to order details")
            let order = self.notifications[indexPath.row].orderId ?? 0
            self.orderID = order
            self.getOrderList()
        }
        
        else if self.notifications[indexPath.row].isFriendRequest == true {
            print("---- to friends request")
            let sb = UIStoryboard(name: "Friends", bundle: nil)
            if #available(iOS 13.0, *) {
                let vc = sb.instantiateViewController(identifier: "FriendRequestViewController") as! FriendRequestViewController
                self.navigationController?.pushViewController( vc, animated: true)
            } else {
                // Fallback on earlier versions
            }
        }
        
        
        else if  self.notifications[indexPath.row].preOrderId != 0 && self.notifications[indexPath.row].isFriendRequest == true  {
            print("----  to pre order details from notification")
            let order = self.notifications[indexPath.row].preOrderId ?? 0
            self.preOrderID = order
            self.getPreOrderList()
        }
        
        else if self.notifications[indexPath.row].orderId != 0  && self.notifications[indexPath.row].isFriendRequest == true {
            print("---- to order details from notification")
            let order = self.notifications[indexPath.row].orderId ?? 0
            self.orderID = order
            self.getOrderList()
        }
        
        
        
//        let sb = UIStoryboard(name: "Main", bundle: nil)
//        if #available(iOS 13.0, *) {
////            let vc = sb.instantiateViewController(identifier: "EventDetailsViewController") as! EventDetailsViewController
////            vc.id = self.notifications[indexPath.row].redirectionId ?? 0
//            let vc = sb.instantiateViewController(identifier: "OrderSummaryViewController") as! OrderSummaryViewController
//            let order = self.orders[indexPath.row]
//            vc.order = order
//            vc.id = self.notifications[indexPath.row].orderId ?? 0
//            self.navigationController?.pushViewController( vc, animated: true)
//        } else {
//            // Fallback on earlier versions
//        }
        
    }
}
extension NotificationViewController{
    
    func getNotificationList(){
        var params: [String:Any] = [String:Any]()
        params = [
            "take" : 50
        ] as [String : Any]
        let service = Services()
        GCD.async(.Main) {
            self.startActivityWithMessage(msg: "")
        }
//        SVProgressHUD.show()
        GCD.async(.Default) {
            service.notificatons(params: params) { (serviceResponse) in
                GCD.async(.Main) {
                    self.stopActivity()
//                    SVProgressHUD.dismiss()
                    self.refreshControl.endRefreshing()
                }
                switch serviceResponse.serviceResponseType {
                case .Success :
                    GCD.async(.Main) {
                        if let notificationList = serviceResponse.data as? [NotificationViewModel] {
                            self.notifications = notificationList
                            let sortedNotififactionByDate = self.notifications.sorted { (date1, date2) -> Bool in
                                date1.createdDate! > date2.createdDate!
                            }
                            self.notifications = sortedNotififactionByDate
                            self.toogle(isNotification: true)
                            self.tableView.reloadData()
                        }
                        else {
                            print("No Notification Found!")
                        }
                    }
                case .Failure :
                    GCD.async(.Main) {
                        print("No Notification Found!")
                    }
                default :
                    GCD.async(.Main) {
                        print("No Notification Found!")
                    }
                }
            }
        }
    }
}

extension NotificationViewController{
    
    func getOrderList(){
        
        var params: [String:Any] = [String:Any]()
        params =
            [:] as [String : Any]
        let service = UserServices()
        GCD.async(.Main) {
        }
        GCD.async(.Default) {
            service.GetOrderByTruck(params: params) { (serviceResponse) in
                GCD.async(.Main) {
                }
                switch serviceResponse.serviceResponseType {
                case .Success :
                    GCD.async(.Main) { [self] in
//                        if let orderList = serviceResponse.data as? [GetOrderByTruckModel] {
//                            //print(orderList)
//                            self.orders = orderList
//                            self.tableView.reloadData()
//                            print("order list found")
//                        }
                        if let ordersDetials = serviceResponse.data as? [GetOrderByTruckModel] {
                            //for showing orderdetails
                            if let obj = ordersDetials.first(where: {$0.orderId == self.orderID}) {
                                let sb = UIStoryboard(name: "Orders", bundle: nil)
                                if #available(iOS 13.0, *) {
                                    let vc = sb.instantiateViewController(identifier: "Orders_DetialViewController") as! Orders_DetialViewController
                                    vc.order = obj
                                    self.navigationController?.pushViewController( vc, animated: true)
                                } else {
                                    // Fallback on earlier versions
                                }
                            }
                            self.tableView.reloadData()
                            self.stopActivity()
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
    
    
    
    func getPreOrderList(){
        
        var params: [String:Any] = [String:Any]()
        params =
            [:] as [String : Any]
        let service = UserServices()
        GCD.async(.Main) {
            self.startActivityWithMessage(msg: "")
        }
        GCD.async(.Default) {
            service.GetPreOrderByTruck(params: params) { (serviceResponse) in
                GCD.async(.Main) {
                    self.stopActivity()

                }
                switch serviceResponse.serviceResponseType {
                case .Success :
                    GCD.async(.Main) { [self] in
//                        if let orderList = serviceResponse.data as? [GetOrderByTruckModel] {
//                            //print(orderList)
//                            self.orders = orderList
//                            self.tableView.reloadData()
//                            print("order list found")
//                        }
//                        else {
//                            print("order list not found!")
//                        }
                        if let ordersDetials = serviceResponse.data as? [GetOrderByTruckModel] {
                            //for showing orderdetails
                            if let obj = ordersDetials.first(where: {$0.preOrderId == self.preOrderID}) {
                                let sb = UIStoryboard(name: "Orders", bundle: nil)
                                if #available(iOS 13.0, *) {
                                    let vc = sb.instantiateViewController(identifier: "Pre_Order_DetailViewController") as! Pre_Order_DetailViewController
                                    vc.order = obj
                                    self.navigationController?.pushViewController( vc, animated: true)
                                } else {
                                    // Fallback on earlier versions
                                }
                            }
                            self.tableView.reloadData()
                            self.stopActivity()
                    }
                        else {
                            print("No Item Found!")
                        }
                    }
                case .Failure :
                    GCD.async(.Main) {
                        print("order list not found!!")
                    }
                default :
                    GCD.async(.Main) {
                        print("order list not found!!!")
                    }
                }
            }
        }
    }
    
}


extension NotificationViewController{
    func getEventsListing(){
        var params: [String:Any] = [String:Any]()
            params = (["eventId" : id])
        print(params)
        let service = EventsServices()
            GCD.async(.Default) {
            service.getEventsListRequest(params: params) { (serviceResponse) in
                GCD.async(.Main) {
                    self.stopActivity()
                    self.view.isUserInteractionEnabled = true
                }
            switch serviceResponse.serviceResponseType {
            case .Success :
                GCD.async(.Main) {
                    if let eventsDetials = serviceResponse.data as? [EventViewModel] {
                        //for showing eventdetails
                        if let obj = eventsDetials.first(where: {$0.eventId == self.id}) {
                            let sb = UIStoryboard(name: "Main", bundle: nil)
                            if #available(iOS 13.0, *) {
                                let vc = sb.instantiateViewController(identifier: "NewEventDetailViewController") as! NewEventDetailViewController
                                vc.event = obj
                                self.navigationController?.pushViewController( vc, animated: true)
                            } else {
                                // Fallback on earlier versions
                            }
                        }
                        self.tableView.reloadData()
                        self.stopActivity()
                }
                else {
                    self.tableView.reloadData()
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
}
