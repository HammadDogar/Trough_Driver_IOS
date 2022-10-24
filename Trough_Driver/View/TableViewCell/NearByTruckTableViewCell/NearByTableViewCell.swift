//
//  NearByTableViewCell.swift
//  Trough_Driver
//
//  Created by Macbook on 20/04/2021.
//

import UIKit
import Cosmos

protocol NearByTableViewCellDelegate: AnyObject {
    func truckInvite(index: Int)
}

class NearByTableViewCell: UITableViewCell {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var btnRight: UIButton!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var totalNoOfRatingLabel: UILabel!
    @IBOutlet weak var truckTitleLabel: UILabel!
    @IBOutlet weak var btnInvite: UIButton!
    @IBOutlet weak var truckInviteImageView: UIImageView!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var ratingView: CosmosView!
    
    @IBOutlet weak var truckInviteImageViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var truckInviteImageViewWidth: NSLayoutConstraint!
    
    var nearBy: NearbyTrucksViewModel?
    weak var delegate: NearByTableViewCellDelegate?
    var index = -1
    
    var selectionArray = [Int]()
    var onInvite: (() -> Void)?

    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.register(UINib(nibName: "NearByCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "NearByCollectionViewCell")

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configure(nearBy: NearbyTrucksViewModel){
        self.nearBy = nearBy
        self.collectionView.reloadData()
        let date = Date()
        let calendar = Calendar.current
        let weekDay = calendar.component(.weekday, from: date)
        let time = nearBy.workHours?.filter{$0.dayOfWeek == weekDay}
        self.truckTitleLabel.text = "\(nearBy.name ?? "")"
        self.locationLabel.text = "\(nearBy.address ?? "")"
        self.timeLabel.text = "\(time?.first?.startTime ?? "") - \(time?.first?.endTime ?? "")"
        self.dateLabel.text = "\(nearBy.createdDate?.date(with: .DATE_TIME_FORMAT_ISO8601)?.string(with: .custom("dd MMMM yyyy")) ?? "")"
        self.totalNoOfRatingLabel.text = "(\(nearBy.totalReviews ?? 0))"
        self.ratingLabel.text = "\(nearBy.averageRating ?? 2)"
        self.ratingView.rating = nearBy.averageRating ?? 2.0

    }
    
    @IBAction func actionInvite(_ sender: Any){
//        self.delegate?.truckInvite(index: self.index)
        onInvite?()
    }
    
}


extension NearByTableViewCell: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return  1//self.nearBy?.bannerUrl != nil ? 1 : 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NearByCollectionViewCell", for: indexPath) as! NearByCollectionViewCell
        
        cell.configure(bannerUrl: BASE_URL+((self.nearBy?.bannerUrl ?? "")))
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: ((self.collectionView.frame.size.width/2)-10), height: self.collectionView.frame.size.height)
    }
}
