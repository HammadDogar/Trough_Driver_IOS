//
//  InvitationDetailTableViewCell.swift
//  Trough_Driver
//
//  Created by Macbook on 03/03/2021.
//

import UIKit

protocol InvitationDetailBtnClickDelegate {
    func mapBtnClick(latitude:Double,longitude:Double)
    func descriptionBtnClick()
}

class InvitationDetailTableViewCell: UITableViewCell {

    @IBOutlet weak var eventImageView: UIImageView!
    @IBOutlet weak var lblEventName: UILabel!
    @IBOutlet weak var lblEventDateAndTime: UILabel!
    @IBOutlet weak var lblEventFullName: UILabel!
    @IBOutlet weak var lblEventLocation: UILabel!
    @IBOutlet weak var lblEventTotalPerson: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var eventDes: UILabel!
    
    
    
    var lat:Double?
    var long:Double?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    var delegate:InvitationDetailBtnClickDelegate?

    @IBAction func actionMapBtn(_ sender: UIButton) {
        delegate?.mapBtnClick(latitude:lat!,longitude:long!)
    }
    @IBAction func actionDescriptionBtn(_ sender: UIButton) {
        delegate?.descriptionBtnClick()
    }
}
