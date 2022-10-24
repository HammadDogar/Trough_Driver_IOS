//
//  MenuCell.swift
//  Trough_Driver
//
//  Created by Imed on 24/03/2021.
//

import UIKit

class MenuCell: UITableViewCell {

    @IBOutlet weak var dishImage: UIImageView!
    @IBOutlet weak var dishNameLabel: UILabel!
    @IBOutlet weak var dishDesLabel: UILabel!
    @IBOutlet weak var dishPrice: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()

//        self.contentView.backgroundColor = .yellow
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func setUpData(dish: MenuCategoryViewModel){
        
//        if dish.imageUrl != "" && dish.imageUrl != nil{
//            let url = URL(string: BASE_URL+dish.imageUrl!) ?? URL.init(string: "https://www.google.com")!
//            self.dishImage.setImage(url: url)
//        }else{
//
//        }
//
        
        if dish.imageUrl != "" && dish.imageUrl != nil{
            if let url = URL(string: dish.imageUrl ?? "") {
                DispatchQueue.main.async {
                    self.dishImage.setImage(url: url)
                }
            }
        }else{
            self.dishImage.image = UIImage(named: "personFilled")
        }
        
        dishNameLabel.text = dish.title
        dishDesLabel.text = dish.description
        dishPrice.text = String(dish.price!)
    }

}


