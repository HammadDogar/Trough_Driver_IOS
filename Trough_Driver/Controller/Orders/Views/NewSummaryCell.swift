//
//  NewSummaryCell.swift
//  Trough_Driver
//
//  Created by Mateen Nawaz on 01/09/2022.
//

import UIKit

class NewSummaryCell: UITableViewCell {
    
//    @IBOutlet weak var orderQuantityLabel: UILabel!
//    @IBOutlet weak var orderMenuName: UILabel!
//    @IBOutlet weak var orderPriceLabel: UILabel!
//
    @IBOutlet weak var order : UILabel!
    
    
    var driverOrder : GetOrderByTruckModelDetail?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func orderDetial(orders : GetOrderByTruckModelDetail){
        self.driverOrder = orders
        self.order.text = "\(orders.quantity ?? 0)x"
//        self.orderMenuName.text = "\(orders.price ?? 0)"
//        self.orderPriceLabel.text = "\(orders.title ?? "")"
    }
    
}
