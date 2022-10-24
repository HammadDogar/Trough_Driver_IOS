//
//  TruckOrderTableViewCell.swift
//  Trough_Driver
//
//  Created by Imed on 16/04/2021.
//

import UIKit

class TruckOrderTableViewCell: UITableViewCell {

    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var totalAmmount: UILabel!
    @IBOutlet weak var orderUserName: UILabel!
    @IBOutlet weak var address: UILabel!
    
    var myOrder : GetOrderByTruckModel?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }
    func configure(getOrder : GetOrderByTruckModel){
        self.myOrder = getOrder
        self.orderUserName.text = "\(getOrder.fullName ?? "")"
        self.address.text = "\(getOrder.deliveryAddress ?? "")"
        self.totalAmmount.text = "\(getOrder.totalAmount ?? 0)"
        
    }
    

}
//
//struct OrderList {
//
//    let userImage: String
//    let userName: String
//    let totalAmmount: String
//    let orderPrice: Double
//    let totalPrice: Double
//    let orderName: String
//}
