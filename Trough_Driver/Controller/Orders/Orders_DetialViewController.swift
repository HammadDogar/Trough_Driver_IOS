//
//  Orders_DetialViewController.swift
//  Trough_Driver
//
//  Created by Mateen Nawaz on 30/08/2022.
//

import UIKit

class Orders_DetialViewController: BaseViewController {

    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var totalAmountLabel: UILabel!
    @IBOutlet weak var invoiceNumberLabel: UILabel!
    @IBOutlet weak var tableView: SelfSizingTableView!
    
    
    @IBOutlet weak var paymentCheckBox: UIButton!
    @IBOutlet weak var completeButton: UIButton!
    @IBOutlet weak var createdDate: UILabel!
    
    var order : GetOrderByTruckModel?
    var id = 0
    var invoiceID = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.hidesBackButton = true
        self.startActivityWithMessage(msg: "")

        configure()
        self.mapping()
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
    
    func configure(){
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "NewCell", bundle: nil), forCellReuseIdentifier: "NewCell")
        tableView.register(UINib(nibName: "PRE_Order_SummaryCell", bundle: nil), forCellReuseIdentifier: "PRE_Order_SummaryCell")
    }
    
    func mapping(){
        
        self.userName.text = order?.fullName ?? ""
        if order?.isCOD != false && order?.isCOD != nil{
            paymentCheckBox.isSelected = true
        }
        else {
            paymentCheckBox.isHighlighted = true
        }
//        if order?.orderDetail?[0].imageUrl != "" &&  order?.orderDetail?[0].imageUrl != nil {
//            let url = URL(string: BASE_URL+( order?.orderDetail?[0].imageUrl!)!) ?? URL.init(string: "https://www.google.com")!
//            self.userImage.setImage(url: url)
//        }else{}
        
        if order?.orderDetail?[0].imageUrl != "" && order?.orderDetail?[0].imageUrl != nil{
            if let url = URL(string: order?.orderDetail?[0].imageUrl! ?? "") {
                DispatchQueue.main.async {
                    self.userImage.setImage(url: url)
                }
            }
        }else{
            
        }
//        var price = 0
//        for i in 0...(self.order?.orderDetail?.count)! - 1 {
//            price += (self.order?.orderDetail?[i].price!)!
//        }
//        self.totalAmountLabel.text = "$ \(price)"
        self.totalAmountLabel.text = "$ \(order?.totalAmount ?? 0)"
        self.invoiceNumberLabel.text = order?.invoiceNumber ?? ""
        
        self.invoiceID = order?.invoiceNumber ?? ""
        
        
//        self.createdDate.text = order?.createdDate ?? ""
//
        let orderDates = order?.createdDate?.date(with: .DATE_TIME_FORMAT_ISO8601)
        
        self.createdDate.text = "\(orderDates?.string(with: .custom("dd MMMM yyyy")) ?? "No Date Found")"
        

        if order?.isCompleted == true{
            self.completeButton.backgroundColor = .gray
            self.completeButton.isEnabled = false
            self.completeButton.titleLabel?.text = "Order was completed"
        }
        self.stopActivity()
    }
    
    
    @IBAction func actionBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func actionComplete(_ sender: Any) {
        self.completeOrder()
    }
}

extension Orders_DetialViewController : UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return order?.orderDetail?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NewCell", for: indexPath) as! NewCell
        let item = self.order?.orderDetail?[indexPath.row]
        cell.orderDetial(orders: item!)
        return cell
    }
    
    
//
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return order?.orderDetail?.count ?? 0
//    }
//
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "Order_SummaryCell", for: indexPath) as! Order_SummaryCell
//        if let item = self.order?.orderDetail?[indexPath.row] {
//        cell.orderDetial(driverOrders: item)
//        }
//        return cell
//    }
//
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 60
//    }
    
}

extension Orders_DetialViewController{
    
    func completeOrder(){
        var params: [String:Any] = [String:Any]()
        params =
            [
                "invoiceNumber": invoiceID
            ] as [String : Any]
        let invoiceNo:String = invoiceID
        GCD.async(.Main) {
            self.startActivityWithMessage(msg: "")
        }
        print(params)
        let service = UserServices()
        GCD.async(.Default) {
            service.completeOrder(params: params,invoiceNumber: invoiceNo) { (serviceResponse) in
                GCD.async(.Main) {
                    self.stopActivity()
                }
                switch serviceResponse.serviceResponseType {
                case .Success :
                    GCD.async(.Main) {
                        if let data = serviceResponse.data {
                            print(data)
                            self.mapping()
                            self.simpleAlert(title: "Success", msg: "Order was completed")
                            self.navigationController?.popViewController(animated: true)
                        }
                        else {
                            print("Error completed order")
                        }
                    }
                case .Failure :
                    GCD.async(.Main) {
                        print("Error completed order!")
                    }
                default :
                    GCD.async(.Main) {
                        print("Error completed order!!")                                    }
                }
            }
        }
    }
}
