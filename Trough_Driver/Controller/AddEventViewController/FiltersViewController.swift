//
//  FiltersViewController.swift
//  Trough_Driver
//
//  Created by Macbook on 20/04/2021.
//

import UIKit
protocol FiltersViewControllerDelegate:AnyObject {
    func apiCallWithFilters(userLat: Double?,userLong: Double?,rating:Int?,radius: Double?, Ids:[Int]?, workHours:WorkHours?, isFilter:Bool)
}

class FiltersViewController: BaseViewController {

    @IBOutlet weak var tableView: UITableView!
    var ratingArray = ["2 And Above","3 And Above","4 And Above"]
    var slotsArray = ["09:00AM - 12:00PM","12:00PM - 03:00PM","03:00PM - 06:00PM", "06:00PM - 09:00PM","09:00PM - 12:00AM","12:00AM - 03:00AM"]

    var slotIndex = -1
    var foodIndexes = [Int]()
    var ratingIndex = -1
    var minValue = 0
    var maxValue = 25
    var isClear = false
    
    var delegate:FiltersViewControllerDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.config()
    }
    
    func config(){
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(UINib(nibName: "DistanceTableViewCell", bundle: nil), forCellReuseIdentifier: "DistanceTableViewCell")
        self.tableView.register(UINib(nibName: "RatingsTableViewCell", bundle: nil), forCellReuseIdentifier: "RatingsTableViewCell")
        self.tableView.register(UINib(nibName: "FoodCategoryTableViewCell", bundle: nil), forCellReuseIdentifier: "FoodCategoryTableViewCell")
        self.tableView.register(UINib(nibName: "EventSlotsTableViewCell", bundle: nil), forCellReuseIdentifier: "EventSlotsTableViewCell")

    }
    @IBAction func actionBack(_ sender:Any){

        self.delegate?.apiCallWithFilters(userLat: nil, userLong: nil, rating: nil, radius: nil, Ids: nil, workHours: nil, isFilter: false)
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func actionClear(_ sender:Any){
        self.slotIndex      = -1
        self.foodIndexes.removeAll()
        self.ratingIndex    = -1
        self.minValue       = 0
        self.maxValue       = 25
        self.isClear        = true
        self.tableView.reloadData()
    }
    
    @IBAction func actionApply(_ sender:Any){
        
        let params =
            [
                "userLatitude"  : nil,
                "userLongitude" : nil,
                "radius"        : self.maxValue,
                "rating"        : self.ratingIndex+2,
                "categoryIds"   : self.foodIndexes ,
                "truckSlot"     : Global.shared.truckTimeSlot[self.slotIndex]
            ] as [String : Any?]
        self.delegate?.apiCallWithFilters(userLat: nil, userLong: nil, rating: self.ratingIndex+2, radius: Double(self.maxValue), Ids: self.foodIndexes, workHours: Global.shared.truckTimeSlot[self.slotIndex], isFilter: true)
        self.dismiss(animated: true, completion: nil)
    }
}

extension FiltersViewController:UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: "DistanceTableViewCell", for: indexPath) as! DistanceTableViewCell
            cell.selectionStyle = .none
            cell.delegate = self
            if isClear{
                cell.config()
            }
            return cell
        }else if indexPath.row == 1{
            let cell = tableView.dequeueReusableCell(withIdentifier: "RatingsTableViewCell", for: indexPath) as! RatingsTableViewCell
            cell.selectionStyle = .none
            cell.delegate = self

            cell.config(ratings: self.ratingArray,isClear: self.isClear)

            return cell
        }else if indexPath.row == 2{
            let cell = tableView.dequeueReusableCell(withIdentifier: "FoodCategoryTableViewCell", for: indexPath) as! FoodCategoryTableViewCell
            cell.selectionStyle = .none
            cell.delegate = self
            if self.isClear{
                cell.config()
            }
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "EventSlotsTableViewCell", for: indexPath) as! EventSlotsTableViewCell
            cell.selectionStyle = .none
            cell.delegate = self
            cell.config(slots: self.slotsArray,isClear:self.isClear)
            return cell
        }
    }
}

extension FiltersViewController: EventSlotsTableViewCellDelegate,FoodCategoryTableViewCellDelegate,RatingsTableViewCellDelegate,DistanceTableViewCellDelagate{
    func selectedRadius(min: Int, max: Int) {
        self.minValue = min
        self.maxValue = max
    }
    
    func ratingSelected(index: Int) {
        self.ratingIndex = index
    }
    
    func categorySelected(indexes: [Int]) {
        self.foodIndexes = indexes
    }
    
    func slotSelected(index: Int) {
        self.slotIndex = index
    }
}
