//
//  PaymentMethodTableViewCell.swift
//  Trough_Driver
//
//  Created by Imed on 19/07/2021.
//

import UIKit

class PaymentMethodTableViewCell: UITableViewCell {

    @IBOutlet weak var cardTypeImageView: UIImageView!
    @IBOutlet weak var cardNumberLabel: UILabel!
    @IBOutlet weak var selectedImageView: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
