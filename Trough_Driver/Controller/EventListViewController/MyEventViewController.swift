//
//  MyEventViewController.swift
//  Trough_Driver
//
//  Created by Imed on 27/09/2021.
//

import UIKit

class MyEventViewController: BaseViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var noResultLabel: UILabel!
    var eventList = [EventViewModel]()
    var isInvite = false
    var eventFilter : NearbyTrucksViewModel?
    var tapped = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.noResultLabel.isHidden = true
        self.getEventsListing()
        self.tableView.register(UINib(nibName: "EventTableViewCell", bundle: nil), forCellReuseIdentifier: "EventTableViewCell")
        tableView.reloadData()
    }
    @IBAction func actionBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
}

extension MyEventViewController : UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.eventList.count > 0{
            self.noResultLabel.isHidden = true
            return self.eventList.count
        }
        else{
            self.noResultLabel.isHidden = false
        }
        return self.eventList.count

    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "EventTableViewCell", for: indexPath) as? EventTableViewCell{
            
            cell.selectionStyle = .none
            cell.index = indexPath.row
            cell.mainView.shadow = true
            cell.eventEditButton.isHidden = false

            cell.delegate = self
    
            let  item = self.eventList[indexPath.row]
            cell.configure(event: item)
            
            cell.onEdited = { [self] in
                let vc =  UIStoryboard.init(name: StoryBoard.AddEvent.rawValue, bundle: nil) .instantiateViewController(withIdentifier:"EditEventViewController") as! EditEventViewController
                //passing data
                vc.newEventModel = item
                vc.delegateEdit = self
                self.mainContainer.currenController?.pushViewController(vc, animated: true)
            }

            let height = item.description?.heightWithConstrainedWidth(width: cell.eventDescriptionLabel.frame.width, font: UIFont(name: "Poppins-Medium", size: 10)!)
            
            cell.eventDescriptionHeightConstraint.constant = (((height ?? 10) > 80 ? 80 : height) ?? 30)
            
            
            return cell
        }
        return UITableViewCell.init()

    }
    
    
}
extension MyEventViewController {
    func getEventsListing(isloader:Bool = true,isReloadData:Bool = true){
        var params: [String:Any] = [String:Any]()

            params = ["createdById": Global.shared.currentUser.userId!]
                as [String : Any]
        
        let service = EventsServices()
        if isloader{
            GCD.async(.Main) {
                self.startActivityWithMessage(msg: "")
            }
        }
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
                            self.eventList = eventsList
                            
//                            let truckId = self.eventFilter?.truckId ?? 0
//                            var array = eventsList.filter { event -> Bool in
//                                let trucks = event.invitedTrucks ?? []
//                                if trucks.contains(where: { (truck) -> Bool in
//                                    (truck.truckId ?? 0) == truckId
//                                }) {
//                                    return false
//                                }
//                                return true
//                            }
                            
//                            print(array)
                            self.tableView.reloadData()
                            self.stopActivity()
                    }
                    else {
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
extension MyEventViewController :  EventTableViewCellDelegate {
    func eventActionPerform(index: Int, btnTitle: String, complete: @escaping ((Bool) -> Void)) {
        //
    }
    
    func eventImageAction(index: Int) {
        //
    }
    
    func didSelectTruck(truckId: Int, eventId: Int) {
        //
    }
    
    
}

extension  MyEventViewController : EditEventViewDelegate{
    func didEdit(tapped: Bool) {
        if (self.tapped == tapped){
            self.getEventsListing()
        }
    }
}
