//
//  NewEventDetailViewController.swift
//  Trough_Driver
//
//  Created by Imed on 27/10/2021.
//

import UIKit
import Kingfisher
import SVProgressHUD

class NewEventDetailViewController: BaseViewController {
    
    @IBOutlet weak var eventImageView: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var eventUserImage: UIImageView!
    @IBOutlet weak var eventUserName: UILabel!
    @IBOutlet weak var eventNameLabel: UILabel!
    @IBOutlet weak var eventDateLabel: UILabel!
    @IBOutlet weak var eventTimeLabel: UILabel!
    @IBOutlet weak var eventAddressLabel: UILabel!
    @IBOutlet weak var eventDescriptionLabel: UILabel!
    @IBOutlet weak var eventCreatedLabel: UILabel!
    @IBOutlet weak var eventLikeImageView: UIImageView!
    @IBOutlet weak var eventLikeCountLabel: UILabel!
    @IBOutlet weak var eventCommentCountLabel: UILabel!
    @IBOutlet weak var eventGoingImageView: UIImageView!
    @IBOutlet weak var eventMayBeImageView: UIImageView!
    @IBOutlet weak var commentTextField: UITextField!
    
    var event :EventViewModel?
    var comment = [CommentViewModel]()
    var reply = [CommentViewModel]()
    var replymodel = [replyModel]()
    var commentmodel : [commentModel] = []
    var myEvent: EventViewModel?
    var eventId:Int = -1
    var index = -1
    var id = 0
    var notifications = [NotificationViewModel]()
    var eventList = [EventViewModel]()
    var eventListFiltered = [EventViewModel]()
    
    var commentID = 0
    let ccomment : CommentViewModel? = nil

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.eventDescriptionLabel.sizeToFit()
        self.eventMapping(data: event!)
        self.getComments()
        self.getEventsListing()
        
        self.tableView.register(UINib(nibName: "EventCommentsTableViewCell", bundle: nil), forCellReuseIdentifier: "EventCommentsTableViewCell")
        
        self.tableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Hide the navigation bar on the this view controller=
        self.navigationController?.setNavigationBarHidden(true, animated: animated)

    }
    //
        override func viewWillDisappear(_ animated: Bool) {
            super.viewWillDisappear(animated)
            // Show the navigation bar on other view controllers
            self.navigationController?.setNavigationBarHidden(false, animated: animated)
        }
    
    
    func eventMapping(data : EventViewModel){
        self.eventId = data.eventId ?? -1
        self.event = data
        
        self.eventNameLabel.text = "\(data.eventName ??  "")"
        self.eventUserName.text = "\(data.fullName ?? "")"
        
        let eventStartDate = data.eventSlots?.first?.startDate?.date(with: .DATE_TIME_FORMAT_ISO8601)
        self.eventDateLabel.text = "\(eventStartDate?.string(with: .custom("dd MMMM yyyy")) ?? "")"

        let startTime = data.eventSlots?.first?.startTime?.timeConversion12()
        let endTime = data.eventSlots?.first?.endTime?.timeConversion12()
        self.eventTimeLabel.text = "\(startTime ?? "") - \(endTime ?? "")"
        
        self.eventDescriptionLabel.text = "\(data.description ?? "")"
        self.eventAddressLabel.text = "\(data.address ?? "")"
        
        let eventcreateDateWithTime = data.createdDate?.date(with: .DATE_TIME_FORMAT_ISO8601)
        
        
        
//        let createDate = eventcreateDateWithTime?.getOnlyDate()
//        self.eventCreatedLabel.text = "\(createDate?.getPastTime() ?? "")"
        
        
        let timeArray  : String = data.createdDate ?? ""
        let dateTime = timeArray.components(separatedBy: ".")
        let commentDate : String = dateTime[0]
        
        self.eventCreatedLabel.text  = commentDate.date(with: .DATE_TIME_FORMAT_ISO8601)?.toLocalTime().getPastTime()
        
        
        
//        if data.imageUrl != "" && data.imageUrl != nil{
//            let url = URL(string: BASE_URL+data.imageUrl!) ?? URL.init(string: "https://www.google.com")!
//            self.eventImageView.setImage(url: url)
//        }else{
//
//        }
        
        if data.imageUrl != "" && data.imageUrl != nil{
            if let url = URL(string: data.imageUrl! ) {
                DispatchQueue.main.async {
                    self.eventImageView.setImage(url: url)
                }
            }
        }else{
            
        }
        
//        if data.profileUrl != "" && data.profileUrl != nil{
//            let url = URL(string: BASE_URL+data.profileUrl!) ?? URL.init(string: "https://www.google.com")!
//            DispatchQueue.main.async {
//                self.eventUserImage.setImage(url: url)
//            }
//        }else{
//            self.eventUserImage.image = UIImage(named: "personFilled")
//        }
        
        if data.profileUrl  != "" && data.profileUrl   != nil{
            if let url = URL(string: data.profileUrl   ?? "") {
                DispatchQueue.main.async {
                    self.eventUserImage.setImage(url: url)
                }
            }
        }else{
            self.eventUserImage.image = UIImage(named: "personFilled")
        }

        
        if data.isLiked ?? false{
            self.eventLikeImageView.image = UIImage(named: "likedButton")
        }else{
            self.eventLikeImageView.image = UIImage(named: "likeButton")
        }
        if data.isGoing ?? false {
            self.eventGoingImageView.image = UIImage(named: "orangeIcon")
        }else{
            self.eventGoingImageView.image = UIImage(named: "tickGray")
        }
        
        if data.isMaybe ?? false {
            self.eventMayBeImageView.image = UIImage(named: "orangeIcon")
        }else{
            self.eventMayBeImageView.image = UIImage(named: "tickGray")
        }
        if ((data.isGoing ?? false) == false) && ((data.isMaybe ?? false) == false){
            self.eventGoingImageView.image = UIImage(named: "tickGray")
            self.eventMayBeImageView.image = UIImage(named: "tickGray")
        }
        self.eventLikeCountLabel.text = "\(data.likeCount ?? 0)"
        self.eventCommentCountLabel.text = "\(data.commentCount ?? 0)"
    }

    @IBAction func actionBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func actionImageView(_ sender: UIButton) {
        let imageInfo = GSImageInfo(image: self.eventImageView.image!, imageMode: .aspectFit)
         let transitionInfo = GSTransitionInfo(fromView: self.eventImageView)
         let imageViewer = GSImageViewerController(imageInfo: imageInfo, transitionInfo: transitionInfo)
        present(imageViewer, animated: true, completion: nil)
    }
    @IBAction func actionComment(_ sender: UIButton) {
        if commentTextField.isValidInput(){
            self.addCommentApi()
        }
    }
    
}


extension NewEventDetailViewController {
    
    func addCommentApi(){
        var params: [String:Any] = [String:Any]()
        params = [
            "commentId": 0,
            "comment": self.commentTextField.text ?? "",
            "eventId": self.event?.eventId! ?? -1,
              "commentTypeId": 5,
              
              "isDeleteComment": false
        ] as [String : Any]
        print(params)
        let service = EventsServices()
        
        GCD.async(.Default) {
            service.addCommentRequest(params: params) { (serviceResponse) in
                
            switch serviceResponse.serviceResponseType {
                case .Success :
                    GCD.async(.Main) {
                        if let data = serviceResponse.data {
                            print(data)
                            print("Comment Added Successfully")
                            self.commentTextField.text = ""
                            self.getComments(scrolToBottom: true)
                        }
                        else {
                            print("Error adding Comment")
                        }
                }
                case .Failure :
                    GCD.async(.Main) {
                        print("Error adding Comment")
                    }
                default :
                    GCD.async(.Main) {
                        print("Error adding Comment")
                    }
                }
            }
        }
    }
    
    
    func getComments(scrolToBottom: Bool = false){
        var params: [String:Any] = [String:Any]()
        params = [
            :
        ] as [String : Any]

        let service = EventsServices()
        GCD.async(.Default) {
            //to check is from notifications or events
            var newID: Int = 0
            if let id = self.event?.eventId {
                newID = id
            }else {
                newID = self.id
            }
            service.getCommentRequest(params: params,eventId: newID) { (serviceResponse) in
                switch serviceResponse.serviceResponseType {
                case .Success :
                    GCD.async(.Main) {
                        if let commentList = serviceResponse.data as? [CommentViewModel] {
                            self.comment.removeAll()
                            self.reply.removeAll()
                            for com in commentList{
                                print(com.parentId!)
                                if com.parentId! == -1{
                                    self.comment.append(com)

                                }
                                else{
                                    self.reply.append(com)
                                }
                            }
                            self.commentmodel.removeAll()
                            for comm in self.comment{
                                self.replymodel.removeAll()
                                for rep in self.reply{
                                    if comm.commentId! == rep.parentId{
                                        self.replymodel.append(replyModel.init(cId: rep.commentId!, c: rep.comment!, eId: rep.eventId!, ctId: rep.commentTypeId!, pId: rep.parentId!, cDate: rep.createdDate!, fName: rep.fullName!))
                                    }
                                }
                                self.commentmodel.append(commentModel.init(cId: comm.commentId!, c: comm.comment!, eId: comm.eventId!, ctId: comm.commentTypeId!, pId: comm.parentId ?? -1, cDate: comm.createdDate!, fName: comm.fullName!, iSMore: false, r: self.replymodel))

                            }
                            if scrolToBottom{
                                DispatchQueue.main.async {
                                    self.tableView.reloadData()
                                    if self.commentmodel.count >= 3{
                                        let indexpath = IndexPath(row: self.commentmodel.count-1, section: 1)
                                        self.tableView.scrollToRow(at: indexpath, at: .top, animated: true)
                                        self.updateTableContentInset()
                                    }
                                    
                                }

                            }
                            else{
                                self.tableView.reloadData()
                            }
                            
                    }
                    else {
                        print("Error Fetching Comment!")
                    }
                }
                case .Failure :
                    GCD.async(.Main) {
                        print("No Comment Found!")
                    }
                default :
                    GCD.async(.Main) {
                        print("Comment not Found!")
                    }
                }
            }
        }
    }
    
    func getEventsListing(){
        var params: [String:Any] = [String:Any]()
        if (event != nil){
            params = ["eventId": self.event?.eventId! ?? 0]
        }else{
            params = (["eventId" : id])
        }
        let service = EventsServices()
            GCD.async(.Default) {
            service.getEventsListRequest(params: params) { (serviceResponse) in
                GCD.async(.Main) {
                    self.stopActivity()
                    self.view.isUserInteractionEnabled = true
                }
            switch serviceResponse.serviceResponseType {
            case .Success :
                GCD.async(.Main) {
                    if let eventsList = serviceResponse.data as? [EventViewModel] {
                        //for showing eventdetails
                        self.eventList = eventsList
                        if self.eventList.count > 0{
                            self.event = eventsList[0]
                        }
                        
                        self.tableView.reloadData()
                        self.stopActivity()
                }
                else {
                    self.tableView.reloadData()
                    print("No Events Found!")
                }
            }
            case .Failure :
                GCD.async(.Main) {
                    print("No Events Found!,Failed")
                }
            default :
                GCD.async(.Main) {
                    print("No Events Found!")
                }
            }
        }
    }
  }
}

extension NewEventDetailViewController : UITableViewDelegate, UITableViewDataSource {
    
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return 2
//    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        if section == 0{
//            return 0
//        }
//        else {
//            return self.commentmodel.count
//        }
                    return self.commentmodel.count

    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "EventCommentsTableViewCell", for: indexPath) as! EventCommentsTableViewCell
        
//        cell.config(reples: self.commentmodel[indexPath.row])
        cell.commentData(data: comment[indexPath.row])
        cell.pos = indexPath.row
        if self.commentmodel[indexPath.row].replies.count > 0{
//            cell.tableViewHeigthConstraint.constant = self.commentmodel[indexPath.row].isSeeMore ? CGFloat(117 * self.commentmodel[indexPath.row].replies.count) : 44

        }else{
//            cell.tableViewHeigthConstraint.constant = 0
        }
        cell.commentLabel.sizeToFit()
        cell.commentLabel.text = self.commentmodel[indexPath.row].comment
        cell.userNameLabel.text = self.commentmodel[indexPath.row].fullName

        let timeArray  : String = commentmodel[indexPath.row].createdDate ?? ""
        let dateTime = timeArray.components(separatedBy: ".")
        let commentDate : String = dateTime[0]
        
        cell.commentDateLabel.text  = commentDate.date(with: .DATE_TIME_FORMAT_ISO8601)?.toLocalTime().getPastTime()
        
        
        
        cell.onInvite = {
            self.commentTextField.becomeFirstResponder()
        }
        
        cell.onLike = {
            self.commentID = self.commentmodel[indexPath.row].commentId ?? 0
            let indexValue =  indexPath.row
            self.LikeCommentApi(index: indexValue)
        }
        
        return cell
    }
    
    
}

extension NewEventDetailViewController {
    func updateTableContentInset() {
        let numRows = self.tableView.numberOfRows(inSection: 0)
        var contentInsetTop = self.tableView.bounds.size.height
        for i in 0..<numRows {
            let rowRect = self.tableView.rectForRow(at: IndexPath(item: i, section: 0))
            contentInsetTop -= rowRect.size.height
            if contentInsetTop <= 0 {
                contentInsetTop = 0
                break
            }
        }
        self.tableView.contentInset = UIEdgeInsets(top: 0,left: 0,bottom: 0,right: 0)
    }
}


extension NewEventDetailViewController {
    
    
    func LikeCommentApi(index : Int){
        
        var params : [String:Any] = [:]
        self.view.isUserInteractionEnabled = false
        var isLike = false
        
        if ccomment?.isCommentLiked == true{
            params = [
                "commentId" : self.commentID,
                "isDeleteComment": true,
                "commentTypeId" : 6
            ]
            isLike = true
        }
        else{
            params = [
                "commentId" : self.commentID,
                "isDeleteComment": false,
                "commentTypeId" : 6
            ]
            isLike = false
        }
        let service = EventsServices()
        SVProgressHUD.show()

        print(params)
        GCD.async(.Default) {
            service.LikeCommentApiRequest(params: params) { (serviceResponse) in
                switch serviceResponse.serviceResponseType {
                case .Success :
                    GCD.async(.Main) { [self] in
                        if let data = serviceResponse.data{
                            print(data)
                            self.getComments()
                            let path = NSIndexPath.init(row: index, section: 0)
                            print(path)
                            let cell = self.tableView.cellForRow(at: path as IndexPath) as! EventCommentsTableViewCell
                            self.tableView.reloadData()

                            if isLike{
                                cell.commentLikeImage.image = UIImage(named: "likeButton")
                                cell.commentLikeCount.text = String((self.ccomment?.commentLikeCount! ?? 0) - 1)
                            }
                            else{
                                cell.commentLikeImage.image = UIImage(named: "likedButton")
                                cell.commentLikeCount.text = String((self.ccomment?.commentLikeCount! ?? 0) + 1)
                            }
                            SVProgressHUD.dismiss()
                            self.view.isUserInteractionEnabled = true
                            self.tableView.reloadData()
                        }
                        else {
                            print("Error in Liking")
                            self.view.isUserInteractionEnabled = true
                        }
                        self.tableView.reloadData()
                    }
                case .Failure :
                    GCD.async(.Main) {
                        print("Error in Liking")
                        self.view.isUserInteractionEnabled = true
                    }
                default :
                    GCD.async(.Main) {
                        print("Error in Liking")
                        self.view.isUserInteractionEnabled = true
                    }
                }
            }
        }
    }
}
