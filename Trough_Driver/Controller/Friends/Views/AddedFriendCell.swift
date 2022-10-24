//
//  AddedFriendCell.swift
//  Trough_Driver
//
//  Created by Mateen Nawaz on 30/08/2022.
//

import UIKit

class AddedFriendCell: UITableViewCell {

    @IBOutlet weak var friendImage: UIImageView!
    @IBOutlet weak var friendName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    func config(list:FriendListViewModel){
        
        self.friendName.text = list.fullName!
//        if list.profileUrl != "" && list.profileUrl != nil{
//            let url = URL(string: BASE_URL+list.profileUrl!) ?? URL.init(string: "https://www.google.com")!
//            print(url)
//            self.friendImage.setImage(url: url)
//        }else{}
        
        if list.profileUrl  != "" && list.profileUrl   != nil{
            if let url = URL(string: list.profileUrl   ?? "") {
                DispatchQueue.main.async {
                    self.friendImage.setImage(url: url)
                }
            }
        }else{}
        
    }

}
