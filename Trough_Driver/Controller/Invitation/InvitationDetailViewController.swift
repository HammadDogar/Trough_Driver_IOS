//
//  InvitationDetailViewController.swift
//  Trough_Driver
//
//  Created by Macbook on 03/03/2021.
//

import UIKit

class InvitationDetailViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var event:EventViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func actionBackBtn(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
}
//MARK:-
extension InvitationDetailViewController:UITableViewDataSource,InvitationDetailBtnClickDelegate{
    
        
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell1", for: indexPath)
            return cell

        }
        else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell2", for: indexPath) as! InvitationDetailTableViewCell
            cell.delegate = self
            cell.lblEventName.text = event?.eventName ?? ""
            cell.lblEventFullName.text = event?.fullName ?? ""
            
//            let startTime = "\(event?.eventSlots?.first?.startTime ?? "") : \(event?.eventSlots?.first?.startTime ?? "")".timeConversion12()
//            let endTime = "\(event?.eventSlots?.first?.endTime ?? "") : \(event?.eventSlots?.first?.endTime ?? "")".timeConversion12()
//            let eventStartDate = event?.eventSlots?.first?.startDate?.date(with: .DATE_TIME_FORMAT_ISO8601)
//
            
            
//            cell.lblEventDateAndTime.text = "\(eventStartDate?.string(with: .custom("dd MMMM yyyy")) ?? "No Date Found") \(startTime) \(endTime)"
            
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
                if let url = URL(string: event.imageUrl! ) {
                    DispatchQueue.main.async {
                        cell.eventImageView.setImage(url: url)
                    }
                }
            }else{
                
            }
            
//            if event?.imageUrl != "" && event?.imageUrl != nil{
//                let url = URL(string: BASE_URL+(event?.imageUrl!)!) ?? URL.init(string: "https://www.google.com")!
//                print(BASE_URL+(event?.imageUrl!)!)
//                GCD.async(.Main) {
//                    cell.eventImageView.getImage(url:"https://troughapi.xevensolutions.com/Uploads/propertyFile20210111062824384.jpg")
//                }
//                
//            }else{
//                
//            }
            
            cell.lat = event?.latitude
            cell.long = event?.longitude
            
            return cell

        }
        
    }
    
    func mapBtnClick(latitude:Double,longitude:Double) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "InvitationMapViewController") as? InvitationMapViewController{
        
            vc.event = event
            
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }

    func descriptionBtnClick() {
        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "InvitationMessageViewController") as? InvitationMessageViewController{
            vc.eventDescription = event?.description ?? "No Description Message"
            self.present(vc, animated: true, completion: nil)
        }
    }
    
}
