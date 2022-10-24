//
//  EventTableViewCell.swift
//  traf
//
//  Created by Mateen Nawaz on 12/01/2021.
//

import UIKit
protocol EventCommentsTableViewCellDelegate {
    func pleaseReloadSection(index: Int)
    
}

class EventCommentsTableViewCell: UITableViewCell {

//
//    @IBOutlet weak var tableView: UITableView!
//    @IBOutlet weak var tableViewHeigthConstraint: NSLayoutConstraint!
//
    @IBOutlet weak var commentLabel: UILabel!
    
    @IBOutlet weak var commentImageView: UIImageView!
    @IBOutlet weak var commentDateLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var commentLikeImage: UIImageView!
    
    @IBOutlet weak var commentLikeCount: UILabel!
    
    var replies = commentModel()
    var pos = -1
    var delegate:EventCommentsTableViewCellDelegate?

    var onInvite: (() -> Void)?
    var onLike : (()-> Void)?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
//        self.tableView.delegate = self
//        self.tableView.dataSource = self
//        self.tableView.register(UINib(nibName: "RepliesTableViewCell", bundle: nil), forCellReuseIdentifier: "RepliesTableViewCell")
//        self.tableView.register(UINib(nibName: "SeeReplyTableViewCell", bundle: nil), forCellReuseIdentifier: "SeeReplyTableViewCell")
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        
        super.setSelected(selected, animated: animated)
    }
    
    func commentData(data: CommentViewModel){
        
        self.commentLikeCount.text = "\(data.commentLikeCount ?? 0)"
        
        if data.isCommentLiked ?? false{
//        if data.isCommentLiked == true{
            self.commentLikeImage.image = UIImage(named: "likedButton")
        }else{
            self.commentLikeImage.image = UIImage(named: "likeButton")
        }
        
        
//        if data.profileUrl != "" && data.profileUrl != nil{
//            let url = URL(string: BASE_URL+data.profileUrl!) ?? URL.init(string: "https://www.google.com")!
//            self.commentImageView.setImage(url: url)
//        }else{
//
//        }
        
        if data.profileUrl != "" && data.profileUrl  != nil{
            if let url = URL(string: data.profileUrl  ?? "") {
                DispatchQueue.main.async {
                    self.commentImageView.setImage(url: url)
                }
            }
        }else{}

    }
    
    func config(reples:commentModel){
        self.replies = reples

//        self.tableView.reloadData()
    }
 
    
    @IBAction func actionLike(_ sender: UIButton) {
        onLike?()
    }
    
    @IBAction func actionReply(_ sender: Any) {
        onInvite?()
    }
}
//
//extension EventCommentsTableViewCell: UITableViewDelegate,UITableViewDataSource{
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        if !self.replies.isSeeMore && self.replies.replies.count > 0{
//
//            return 1
//
//        }
//        return self.replies.replies.count
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) ->
//    UITableViewCell {
//
//        if self.replies.isSeeMore{
//            let cell = tableView.dequeueReusableCell(withIdentifier: "RepliesTableViewCell",for: indexPath) as! RepliesTableViewCell
//            cell.replyLabel.text = self.replies.replies[indexPath.row].comment
//
//            return cell
//        }else{
//            let cell = tableView.dequeueReusableCell(withIdentifier: "SeeReplyTableViewCell",for: indexPath) as! SeeReplyTableViewCell
//            cell.index = self.replies.replies[indexPath.row].commentId!
//            cell.delegate = self
//
//
//            return cell
//        }
//    }
//
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        if self.replies.isSeeMore{
//            return 117
//        }else{
//            return 44
//        }
//    }
//
//   // func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//
//    //}
//
//
//}

extension EventCommentsTableViewCell: SeeReplyTableViewCellDelegate{
    func seeMorePressed(index: Int) {
        self.replies.isSeeMore = true
        self.delegate?.pleaseReloadSection(index: pos)
       // self.tableView.reloadData()
        
    }
    
    
}

