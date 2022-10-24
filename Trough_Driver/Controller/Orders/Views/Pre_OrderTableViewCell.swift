//
//  Pre_OrderTableViewCell.swift
//  Trough_Driver
//
//  Created by Mateen Nawaz on 30/08/2022.
//

import UIKit

class Pre_OrderTableViewCell: UITableViewCell {

    @IBOutlet weak var preuserImage: UIImageView!
    @IBOutlet weak var pretotalAmmount: UILabel!
    @IBOutlet weak var preorderUserName: UILabel!
    @IBOutlet weak var preorderByLabel: UILabel!
    @IBOutlet weak var preorderDate: UILabel!
    @IBOutlet weak var prefoodTitle: UILabel!
    
    var myOrder : GetOrderByTruckModel?

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func configure(getOrder : GetOrderByTruckModel){
        self.myOrder = getOrder
        self.preorderUserName.text = "\(getOrder.fullName ?? "")"
        self.pretotalAmmount.text = "\(getOrder.totalAmount ?? 0)"
//        self.preorderDate.text = "\(getOrder.createdDate ?? "")"
        
        let orderDates = getOrder.createdDate?.date(with: .DATE_TIME_FORMAT_ISO8601)
        
        self.preorderDate.text = "\(orderDates?.string(with: .custom("dd MMMM yyyy")) ?? "No Date Found")"
        
        
//        self.preorderUserName.text = "\(getOrder.fullName ?? "")"
        self.preorderByLabel.text = "Order by \(getOrder.fullName ?? "")"
        self.prefoodTitle.text = "\(getOrder.orderDetail?[0].quantity ?? 0)x" + " \(getOrder.orderDetail?[0].title ?? "")"
        
//        if getOrder.orderDetail?[0].imageUrl != "" && getOrder.orderDetail?[0].imageUrl != nil{
//            let url = URL(string: BASE_URL+(getOrder.orderDetail?[0].imageUrl!)!) ?? URL.init(string: "https://www.google.com")!
//            self.preuserImage.setImage(url: url)
//        }else{
//            self.preuserImage.image = UIImage(named: "Fastfood")
//
//        }
        if getOrder.orderDetail?[0].imageUrl != "" && getOrder.orderDetail?[0].imageUrl != nil{
            if let url = URL(string: getOrder.orderDetail?[0].imageUrl! ?? "") {
                DispatchQueue.main.async {
                    self.preuserImage.setImage(url: url)
                }
            }
        }else{
                self.preuserImage.image = UIImage(named: "Fastfood")
        }
    }
    
}
