//
//  Order_SummaryCell.swift
//  Trough_Driver
//
//  Created by Mateen Nawaz on 30/08/2022.
//

import UIKit

class Order_SummaryCell: UITableViewCell {

    @IBOutlet weak var orderquantityLabel: UILabel!
    @IBOutlet weak var ordermenuName: UILabel!
    @IBOutlet weak var orderpriceLabel: UILabel!
    
    var driverOrder : GetOrderByTruckModelDetail?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func orderDetial(driverOrders : GetOrderByTruckModelDetail){
        self.driverOrder = driverOrders
        self.orderquantityLabel.text = "\(driverOrders.quantity ?? 0)x"
        self.orderpriceLabel.text = "$ \(driverOrders.price ?? 0)"
        self.ordermenuName.text = "\(driverOrders.title ?? "")"
    }
    
}
