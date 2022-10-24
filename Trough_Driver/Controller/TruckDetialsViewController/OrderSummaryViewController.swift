//
//  OrderSummaryViewController.swift
//  Trough_Driver
//
//  Created by Imed on 30/07/2021.
//

import UIKit

class OrderSummaryViewController: BaseViewController {

    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var deliveryAddress: UILabel!
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var totalAmountLabel: UILabel!
    @IBOutlet weak var paymentCheckBox: UIButton!
  
    var order : GetOrderByTruckModel?
    var id = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.mapping()
    }
 
    @IBAction func actionBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func mapping(){
        self.userName.text = order?.fullName ?? ""
        self.deliveryAddress.text = order?.deliveryAddress ?? ""
        if order?.isCOD != false && order?.isCOD != nil{
            paymentCheckBox.isSelected = true
        }
        else {
            paymentCheckBox.isHighlighted = true
        }
        
//        if order?.profileUrl != "" && order?.profileUrl != nil {
//            let url = URL(string: BASE_URL+(order?.profileUrl!)!) ?? URL.init(string: "https://www.google.com")!
//            self.userImage.setImage(url: url)
//        }else{}
        
        if order?.profileUrl  != "" && order?.profileUrl   != nil{
            if let url = URL(string: order?.profileUrl   ?? "") {
                DispatchQueue.main.async {
                    self.userImage.setImage(url: url)
                }
            }
        }else{}
        
        var price = 0
        for i in 0...(self.order?.orderDetail?.count)! - 1 {
            price += (self.order?.orderDetail?[i].price!)!
        }
        self.totalAmountLabel.text = "$ \(price)"
    }
}

extension OrderSummaryViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return order?.orderDetail?.count ?? 0

    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OrderSummaryCell", for: indexPath) as! OrderSummaryTableViewCell
        if let item = self.order?.orderDetail?[indexPath.row] {
            cell.orderDetial(orders: item)
        }

        return cell
    }
    
    
    
}
