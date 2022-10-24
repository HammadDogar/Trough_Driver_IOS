//
//  PRE_Order_SummaryCell.swift
//  Trough_Driver
//
//  Created by Mateen Nawaz on 01/09/2022.
//

import UIKit

class PRE_Order_SummaryCell: UITableViewCell {
    
    @IBOutlet weak var preOrdertotatquantity: UILabel!
    @IBOutlet weak var preOrdertotalPrice: UILabel!
    @IBOutlet weak var preOrderMenuName: UILabel!
    
    var userOrder : GetOrderByTruckModelDetail?

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    func orderDetial(orders : GetOrderByTruckModelDetail){
        self.userOrder = orders
        self.preOrdertotatquantity.text = "\(orders.quantity ?? 0)x"
        self.preOrdertotalPrice.text = "$ \(orders.price ?? 0)"
        self.preOrderMenuName.text = "\(orders.title ?? "")"
    }
    

}
