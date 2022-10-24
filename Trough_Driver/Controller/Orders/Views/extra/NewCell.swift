//
//  NewCell.swift
//  Trough_Driver
//
//  Created by Mateen Nawaz on 01/09/2022.
//

import UIKit

class NewCell: UITableViewCell {
    
    
    @IBOutlet weak var orderTotalNo: UILabel!
    @IBOutlet weak var orderMenuNames: UILabel!
    @IBOutlet weak var orderMenusTotal: UILabel!
    
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
        self.orderTotalNo.text = "\(orders.quantity ?? 0)x"
        self.orderMenuNames.text = "\(orders.title ?? "")"
        self.orderMenusTotal.text = "$ \(orders.price ?? 0)"
    }
    
}
