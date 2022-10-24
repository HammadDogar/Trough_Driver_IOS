//
//  OrderSummaryTableViewCell.swift
//  Trough_Driver
//
//  Created by Imed on 30/07/2021.
//

import UIKit

class OrderSummaryTableViewCell: UITableViewCell {

    @IBOutlet weak var quantityLabel: UILabel!
    @IBOutlet weak var menuName: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    
    var driverOrder : GetOrderByTruckModelDetail?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    func orderDetial(orders : GetOrderByTruckModelDetail){
        self.driverOrder = orders
        
        self.quantityLabel.text = "\(orders.quantity ?? 0)"
        self.priceLabel.text = "\(orders.price ?? 0)"
        self.menuName.text = "\(orders.title ?? "")"
    }
    
}
