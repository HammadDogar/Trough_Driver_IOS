//
//  EventTableViewCell.swift
//  Trough
//
//  Created by Irfan Malik on 18/12/2020.
//

import UIKit
import Kingfisher

protocol EventTableViewCellDelegate: AnyObject{
    func eventActionPerform(index: Int, btnTitle: String, complete:@escaping((_ success: Bool)->Void))
    func eventImageAction(index:Int)
    func didSelectTruck(truckId: Int,eventId: Int)
}

class EventTableViewCell: BaseTableViewCell, NearByTableViewCellDelegate {
    func truckInvite(index: Int) {
        //
    }
    
    @IBOutlet weak var mainView: UIView!
    
    @IBOutlet weak var eventTitleLabel: UILabel!
    @IBOutlet weak var eventCreaterNameLabel: UILabel!
    @IBOutlet weak var eventCreaterImageView: UIImageView!

    @IBOutlet weak var eventTimeLabel: UILabel!
    @IBOutlet weak var eventDateLabel: UILabel!
    @IBOutlet weak var eventLocationLabel: UILabel!
    @IBOutlet weak var eventDescriptionLabel: UILabel!
    @IBOutlet weak var eventImageView: UIImageView!
    @IBOutlet weak var eventCreatedLabel: UILabel!
    @IBOutlet weak var btnEventMore: UIButton!
    
    @IBOutlet weak var btnLike: UIButton!
    @IBOutlet weak var btnComment: UIButton!
    @IBOutlet weak var btnGoing: UIButton!
    @IBOutlet weak var btnMayBe: UIButton!
    @IBOutlet weak var eventLikeImageView: UIImageView!
    @IBOutlet weak var eventGoingImageView: UIImageView!
    @IBOutlet weak var eventMayBeImageView: UIImageView!

    
    @IBOutlet weak var eventLikeCountLabel: UILabel!
    @IBOutlet weak var eventCommentCountLabel: UILabel!
    
    @IBOutlet weak var eventDescriptionHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var eventEditButton: UIButton!
    
    var eventId:Int = -1
    var index = -1
    weak var delegate: EventTableViewCellDelegate?
    var myEvent: EventViewModel?
    var nearByList = [NearbyTrucksViewModel]()

    var myTrucks = [InvitedTrucks]()
    
    var onEdited: (()->())?
    var selectedIndex = -1
    
    override func awakeFromNib() {
        
        super.awakeFromNib()

    }
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        // handling code
        delegate?.eventImageAction(index: index)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configure(event: EventViewModel){
        if self.index == 0{
            self.eventDescriptionHeightConstraint.constant = 10

        }else{
            self.eventDescriptionHeightConstraint.constant = 30
        }
        self.eventId = event.eventId ?? -1
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        self.eventCreaterImageView.addGestureRecognizer(tap)
        
        self.myEvent = event
        let eventcreateDateWithTime = event.createdDate?.date(with: .DATE_TIME_FORMAT_ISO8601)
        let createDate = eventcreateDateWithTime?.getOnlyDate()
        self.eventTitleLabel.text = "\(event.eventName ?? "")"
        self.eventCreaterNameLabel.text = "\(event.fullName ?? "")"
        
//        let startTime = "\(event.eventSlots?.first?.startTime?.hours ?? 0) : \(event.eventSlots?.first?.startTime?.minutes ?? 0)".timeConversion12()
//        let endTime = "\(event.eventSlots?.first?.endTime?.hours ?? 0) : \(event.eventSlots?.first?.endTime?.minutes ?? 0)".timeConversion12()
        
        
        
        let startTime = event.eventSlots?.first?.startTime?.timeConversion12()
        let endTime = event.eventSlots?.first?.endTime?.timeConversion12()
        
        self.eventTimeLabel.text = "\(startTime ?? "") - \(endTime ?? "")"
        let eventStartDate = event.eventSlots?.first?.startDate?.date(with: .DATE_TIME_FORMAT_ISO8601)
        self.eventDateLabel.text = "\(eventStartDate?.string(with: .custom("dd MMMM yyyy")) ?? "")"
        self.eventLocationLabel.text = "\(event.locationName ?? "")"
        self.eventDescriptionLabel.text = "\(event.description ?? "")"
        
//commented 31 mar
//        self.eventCreatedLabel.text = "\(createDate?.getPastTime() ?? "")"
        
        let timeArray  : String = event.createdDate ?? ""
        let dateTime = timeArray.components(separatedBy: ".")
        let commentDate : String = dateTime[0]
        
        self.eventCreatedLabel.text  = commentDate.date(with: .DATE_TIME_FORMAT_ISO8601)?.toLocalTime().getPastTime()
        
        self.eventLikeCountLabel.text = "\(event.likeCount ?? 0)"
        self.eventCommentCountLabel.text = "\(event.commentCount ?? 0)"
        
        if event.isLiked ?? false{
            self.eventLikeImageView.image = UIImage(named: "likedButton")
        }else{
            self.eventLikeImageView.image = UIImage(named: "likeButton")
        }
        
        if event.imageUrl != "" && event.imageUrl != nil{
            if let url = URL(string: event.imageUrl ?? "") {
                DispatchQueue.main.async {
                    self.eventImageView.setImage(url: url)
                }
            }
        }else{
                self.eventImageView.image = UIImage(named: "PlaceHolder2")
        }
        
        
        
        if event.profileUrl != "" && event.profileUrl != nil{
            if let url = URL(string: event.profileUrl ?? "") {
                DispatchQueue.main.async {
                    self.eventCreaterImageView.setImage(url: url)
                }
            }
//            let url = URL(string: BASE_URL+event.profileUrl!) ?? URL.init(string: "https://www.google.com")!
        }else{
            self.eventCreaterImageView.image = UIImage(named: "personFilled")
        }
        
//        if event.imageUrl != "" && event.imageUrl != nil{
//            let url = URL(string: BASE_URL+event.imageUrl!) ?? URL.init(string: "https://www.google.com")!
//            self.eventImageView.setImage(url: url)
//        }else{    }
//
//        if event.profileUrl != "" && event.profileUrl != nil{
//            let url = URL(string: BASE_URL+event.profileUrl!) ?? URL.init(string: "https://www.google.com")!
//
//            DispatchQueue.main.async {
//                self.eventCreaterImageView.setImage(url: url)
//            }
//
//        }else{
//            self.eventCreaterImageView.image = UIImage(named: "personFilled")
//        }
        
        self.updateStatus(event: event)
    }
    func updateStatus(event: EventViewModel){
        if event.isGoing ?? false {
            self.eventGoingImageView.image = UIImage(named: "orangeIcon")
        }else{
            self.eventGoingImageView.image = UIImage(named: "tickGray")
        }
        
        if event.isMaybe ?? false {
            self.eventMayBeImageView.image = UIImage(named: "orangeIcon")
        }else{
            self.eventMayBeImageView.image = UIImage(named: "tickGray")
        }
        if ((event.isGoing ?? false) == false) && ((event.isMaybe ?? false) == false){
            self.eventGoingImageView.image = UIImage(named: "tickGray")
            self.eventMayBeImageView.image = UIImage(named: "tickGray")
        }
    }
    
    @IBAction func actionEditButton(_ sender: UIButton) {
        onEdited?()
    }
    @IBAction func actionLike(_ sender: UIButton) {
        self.delegate?.eventActionPerform(index: self.index, btnTitle: "like"){(success) in
            if success{
            }
        }
    }
    
    @IBAction func actionComment(_ sender: UIButton) {
        self.delegate?.eventActionPerform(index: self.index, btnTitle: "comment"){(success) in
            if success{
            }
        }
    }
    
    @IBAction func actionShare(_ sender: UIButton) {
        self.delegate?.eventActionPerform(index: self.index, btnTitle: "share"){ (success) in
            if success{
            }
        }
    }
    @IBAction func actionGoing(_ sender: UIButton) {
        self.delegate?.eventActionPerform(index: self.index, btnTitle: "going"){(success) in
            if success{
                if self.myEvent?.isGoing ?? false{
                    self.myEvent?.isGoing = false
                }else{
                    self.myEvent?.isGoing = true
                    self.myEvent?.isMaybe = false
                }
                self.updateStatus(event: self.myEvent!)
            }
        }

    }
    @IBAction func actionMaybe(_ sender: UIButton) {
        self.delegate?.eventActionPerform(index: self.index, btnTitle: "maybe"){(success) in
            if success{
                if self.myEvent?.isMaybe ?? false{
                    self.myEvent?.isMaybe = false
                }else{
                    self.myEvent?.isMaybe = true
                    self.myEvent?.isGoing = false
                }
                self.updateStatus(event: self.myEvent!)
            }
        }
    }
    @IBAction func actionEventMore(_ sender: UIButton) {
        self.delegate?.eventActionPerform(index: self.index, btnTitle: "eventmore"){ (success) in
            if success{
            }
        }
    }
    
}
