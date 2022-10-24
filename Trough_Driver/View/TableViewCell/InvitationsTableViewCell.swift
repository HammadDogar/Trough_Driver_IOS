//
//  InvitationsTableViewCell.swift
//  Trough_Driver
//
//  Created by Macbook on 01/03/2021.
//

import UIKit

protocol InvitationBtnDelegate {
    func actionCancelBtn(eventId:Int)
    func actionAcceptBtn(eventId:Int)
    func actionOpenMap(event:EventViewModel?)
    func actionInvitationMessage(description:String)

}

class InvitationsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var lblEventTitle: UILabel!
    @IBOutlet weak var lblCity: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var lblPeople: UILabel!
    
    @IBOutlet weak var acceptAndCancelView: UIView!
    @IBOutlet weak var mapAndBtnView: UIView!
    
    var index = -1
    var myEvent: EventViewModel?
    
    var eventDescription:String = ""

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    var delegate:InvitationBtnDelegate?
    
    var eventId:Int = -1
    
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
        
        //self.eventCreaterNameLabel.text = "\(event.fullName ?? "")"
        
//        let startTime = "\(event.eventSlots?.first?.startTime ?? "") : \(event.eventSlots?.first?.startTime ?? "")".timeConversion12()
//        let endTime = "\(event.eventSlots?.first?.endTime ?? "") : \(event.eventSlots?.first?.endTime ?? "")".timeConversion12()
//
//        self.lblTime.text = "\(startTime) - \(endTime)"
        
        let startTime = event.eventSlots?.first?.startTime?.timeConversion12()
        let endTime = event.eventSlots?.first?.endTime?.timeConversion12()
        
        self.lblTime.text = "\(startTime ?? "") - \(endTime ?? "")"
        
        
        let eventStartDate = event.eventSlots?.first?.startDate?.date(with: .DATE_TIME_FORMAT_ISO8601)
        self.lblDate.text = "\(eventStartDate?.string(with: .custom("dd MMMM yyyy")) ?? "No Date Found")"
        self.lblCity.text = "\(event.locationName ?? "")"
        self.eventDescription = "\(event.description ?? "")"
        self.lblPeople.text = "\(event.peopleComing ?? 0)"
        
        
    }

    @IBAction func actionCancel(_ sender: UIButton) {
        delegate?.actionCancelBtn(eventId: self.eventId)
    }
    @IBAction func actionAccept(_ sender: UIButton) {
        delegate?.actionAcceptBtn(eventId: self.eventId)
    }
    @IBAction func actionShowMessage(_ sender: UIButton) {
        delegate?.actionInvitationMessage(description: eventDescription)
    }
    @IBAction func actionShowLocation(_ sender: UIButton) {
        
        delegate?.actionOpenMap(event: myEvent)
    }
}
