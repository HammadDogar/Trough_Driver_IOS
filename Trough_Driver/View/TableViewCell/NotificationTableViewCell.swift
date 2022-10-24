//
//  NotificationTableViewCell.swift
//  Trough_Driver
//
//  Created by Macbook on 12/03/2021.
//

import UIKit

class NotificationTableViewCell: UITableViewCell {
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblContent: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var lblNewStatus: UILabel!
    
    var mynotification : NotificationViewModel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(notification: NotificationViewModel){

        self.mynotification = notification
        let notificationcreateDateWithTime = notification.createdDate?.date(with: .DATE_TIME_FORMAT_ISO8601)?.string(with: .TIME_FORMAT) ?? ""

        self.lblTitle.text = "\(notification.notificationTitle ?? "")"
        self.lblContent.text = "\(notification.notificationBody ?? "")"
        self.lblTime.text = "\(notificationcreateDateWithTime )"

    }

}
