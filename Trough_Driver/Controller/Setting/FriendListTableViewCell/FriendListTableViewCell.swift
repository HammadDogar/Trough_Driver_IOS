//
//  FriendListTableViewCell.swift
//  Trough_Driver
//
//  Created by Imed on 28/09/2021.
//

import UIKit

class FriendListTableViewCell: UITableViewCell {

    
    @IBOutlet weak var friendImage: UIImageView!
    @IBOutlet weak var friendName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func config(list:FriendListViewModel){
        
        self.friendName.text = list.fullName!
//        if list.profileUrl != "" && list.profileUrl != nil{
//            let url = URL(string: BASE_URL+list.profileUrl!) ?? URL.init(string: "https://www.google.com")!
//            print(url)
//            self.friendImage.setImage(url: url)
//        }else{
//
//        }
    }
}
