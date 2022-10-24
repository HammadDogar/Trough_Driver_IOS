//
//  EventDetailViewController.swift
//  Trough_Driver
//
//  Created by Macbook on 15/04/2021.
//

import UIKit

class EventDetailsViewController: BaseViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var event :EventViewModel?
    @IBOutlet weak var commentTextField: UITextField!
    
    var comment = [CommentViewModel]()
    var reply = [CommentViewModel]()
    
    var replymodel = [replyModel]()
    var commentmodel = [commentModel]()
    var id = 0
    var eventList = [EventViewModel]()


    override func viewDidLoad() {
        super.viewDidLoad()
        self.config()
        
        self.getComments()
        self.getEventsListing()

    }
    
    func config(){
        self.tableView.delegate   = self
        self.tableView.dataSource = self
        self.tableView.register(UINib(nibName: "EventTableViewCell", bundle: nil), forCellReuseIdentifier: "EventTableViewCell")
        self.tableView.register(UINib(nibName: "EventCommentsTableViewCell", bundle: nil), forCellReuseIdentifier: "EventCommentsTableViewCell")

        
    }
        
    @IBAction func actionBack(_ sender: Any){
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func actionNotification(_ sender: UIButton) {
        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "NotificationViewController") as? NotificationViewController{
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}

extension EventDetailsViewController:UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        if section == 0{
//            return 1
//        }
        if section == 0{
            // showing diff section
            if event == nil{
                return 0 }
            else{
                return 1
            }
        }
        else{
            print(commentmodel.count)
            
            return self.commentmodel.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: "EventTableViewCell", for: indexPath) as! EventTableViewCell
            cell.backgroundColor = UIColor.white
            cell.mainView.shadow = false
            cell.eventEditButton.isHidden = true

            cell.configure(event: event!)
            
            return cell
        }else{
            
            let cell  =  tableView.dequeueReusableCell(withIdentifier:
                                                        "EventCommentsTableViewCell", for: indexPath) as! EventCommentsTableViewCell

            cell.config(reples: self.commentmodel[indexPath.row])
            cell.pos = indexPath.row
            cell.delegate = self
            
            if self.commentmodel[indexPath.row].replies.count > 0{
                
//                cell.tableViewHeigthConstraint.constant = self.commentmodel[indexPath.row].isSeeMore ? CGFloat(117 * self.commentmodel[indexPath.row].replies.count) : 44

            }else{
                
//                cell.tableViewHeigthConstraint.constant = 0
            }
            cell.commentLabel.sizeToFit()

            cell.commentLabel.text = self.commentmodel[indexPath.row].comment
            cell.userNameLabel.text = self.commentmodel[indexPath.row].fullName
            let timeArray  : String = commentmodel[indexPath.row].createdDate ?? ""
            let dateTime = timeArray.components(separatedBy: ".")
            let commentDate : String = dateTime[0]
            
            cell.commentDateLabel.text  = commentDate.date(with: .DATE_TIME_FORMAT_ISO8601)?.toLocalTime().getPastTime()
            
            cell.onInvite = {
//                self.commentTextField.becomeFirstResponder()
            }
           
            return cell
            

        }
    }
    
    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//
//        if indexPath.section == 1{
//            return 140 + self.comments[indexPath.row].commentText.heightWithConstrainedWidth(width: self.view.frame.width-125, font: UIFont.init(name: "poppins-regular", size: 8)!)
//        }else{
//            return UITableView.automaticDimension
//        }
//    }
}
extension EventDetailsViewController: EventCommentsTableViewCellDelegate{
    func pleaseReloadSection(index: Int) {
//        let pos = self.comments.firstIndex{$0.commentId == index}
        
        DispatchQueue.main.async {
            let indexP = IndexPath(row: index, section: 1)
            self.commentmodel[index].isSeeMore = true
            self.tableView.reloadRows(at: [indexP], with: .automatic)
        }
        
        
    }
    
    
}
extension EventDetailsViewController{
    
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
//            service.getCommentRequest(params: params,eventId:(self.event?.eventId!)!) { (serviceResponse) in
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


extension EventDetailsViewController {
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
//                    self.stopActivity()
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
//                        self.stopActivrity()
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


