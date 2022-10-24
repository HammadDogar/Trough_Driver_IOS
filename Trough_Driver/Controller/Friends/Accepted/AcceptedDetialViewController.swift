//
//  AcceptedDetialViewController.swift
//  Trough_Driver
//
//  Created by Mateen Nawaz on 03/09/2022.
//

import UIKit

class AcceptedDetialViewController: BaseViewController {

    @IBOutlet weak var tableView: UITableView!
    var event:EventViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func actionBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
}

extension AcceptedDetialViewController : UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2

    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: "AcceptedEventDetialCell1", for: indexPath)
            return cell

        }
        else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "AcceptedEventDetialCell22", for: indexPath) as! AcceptedEventDetialCell
//            cell.delegate = self
            cell.lblEventName.text = event?.eventName ?? ""
            cell.lblEventFullName.text = event?.fullName ?? ""
            
            let eventStartDate = event.eventSlots?.first?.startDate?.date(with: .DATE_TIME_FORMAT_ISO8601)
            cell.lblEventDateAndTime.text = "\(eventStartDate?.string(with: .custom("dd MMMM yyyy")) ?? "")"
            
            let startTime = event.eventSlots?.first?.startTime?.timeConversion12()
            let endTime = event.eventSlots?.first?.endTime?.timeConversion12()
            
            cell.timeLabel.text = "\(startTime ?? "") - \(endTime ?? "")"
            
            cell.eventDes.text = event.description ?? ""
                        
            cell.lblEventLocation.text = event?.locationName ?? ""
            cell.lblEventTotalPerson.text = "\(event?.peopleComing ?? 0) People comming"
            
            let image = UIImageView()
            
//            if event.imageUrl != "" && event.imageUrl != nil{
//                let url = URL(string: BASE_URL+event.imageUrl!) ?? URL.init(string: "https://www.google.com")!
//                image.setImage(url: url)
//            }
//
//            DispatchQueue.main.async {
//                cell.eventImageView = image
//            }

            if event.imageUrl != "" && event.imageUrl != nil{
                if let url = URL(string: event.imageUrl ?? "") {
                    DispatchQueue.main.async {
                        cell.eventImageView.setImage(url: url)
                    }
                }
            }else{
//                cell.eventImageView.image = UIImage(named: "PlaceHolder2")
            }
            
            cell.lat = event?.latitude
            cell.long = event?.longitude
            
            return cell

        }
    }
    
    
}
