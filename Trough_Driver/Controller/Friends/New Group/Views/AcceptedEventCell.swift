//
//  AcceptedEventCell.swift
//  Trough_Driver
//
//  Created by Mateen Nawaz on 03/09/2022.
//

import UIKit

class AcceptedEventCell: UITableViewCell {
    
    @IBOutlet weak var lblEventTitle: UILabel!
    @IBOutlet weak var lblCity: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var lblPeople: UILabel!
    
    var index = -1
    var myEvent: EventViewModel?
    
    var eventDescription:String = ""
    var eventId:Int = -1
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    func configure(event: EventViewModel){
        
//        if event.isGoing!{
//            self.acceptAndCancelView.isHidden = true
//        }
//        else{
//            self.acceptAndCancelView.isHidden = false
//        }
        
        self.myEvent = event
        self.eventId = event.eventId!
        self.lblEventTitle.text = "\(event.eventName ?? "")"

        
        let startTime = event.eventSlots?.first?.startTime?.timeConversion12()
        let endTime = event.eventSlots?.first?.endTime?.timeConversion12()
        
        self.lblTime.text = "\(startTime ?? "") - \(endTime ?? "")"
        
        
        let eventStartDate = event.eventSlots?.first?.startDate?.date(with: .DATE_TIME_FORMAT_ISO8601)
        self.lblDate.text = "\(eventStartDate?.string(with: .custom("dd MMMM yyyy")) ?? "No Date Found")"
        self.lblCity.text = "\(event.locationName ?? "")"
        self.eventDescription = "\(event.description ?? "")"
        self.lblPeople.text = "\(event.peopleComing ?? 0)"
        
        
    }

}
