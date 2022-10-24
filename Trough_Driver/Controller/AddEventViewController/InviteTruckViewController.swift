//
//  InviteTruckViewController.swift
//  Trough_Driver
//
//  Created by Macbook on 20/04/2021.
//

import UIKit
import GoogleMaps
import CoreLocation

import SVProgressHUD

class InviteTruckViewController: BaseViewController, CLLocationManagerDelegate, GMSMapViewDelegate{

    
      @IBOutlet weak var searchBarBottom: NSLayoutConstraint!
      @IBOutlet weak var navBarHeight: NSLayoutConstraint!
      @IBOutlet weak var tableView: UITableView!
      @IBOutlet weak var mapView: GMSMapView!
     // @IBOutlet weak var truckViewBtn: UIView!
      @IBOutlet weak var titleLabel: UILabel!
      @IBOutlet weak var EventsFilterBtnView: UIView!
      @IBOutlet weak var TrucksFilterBtnView: UIView!
      @IBOutlet weak var titleImageView: UIImageView!
      //@IBOutlet weak var eventViewBtn: UIView!
      @IBOutlet weak var btnNext: UIButton!
      @IBOutlet weak var btnBack: UIButton!
      @IBOutlet weak var btnFilter: UIButton!
      @IBOutlet weak var stepperProgressBarView: UIView!
      @IBOutlet weak var mainTopViewHeightConstraint:NSLayoutConstraint!
      @IBOutlet weak var stepperProgressBarViewHeightConstraint:NSLayoutConstraint!
      @IBOutlet weak var searchViewheightConstraint:NSLayoutConstraint!

    @IBOutlet weak var scrollButton: UIButton!
    @IBOutlet var buttons: [UIButton]!
      
      
      var firstCellVisible = false
      private var shouldCalculateScrollDirection = false
      private var lastContentOffset: CGFloat = 0
      private var scrollDirection: ScrollDirection = .up
      var locationManager = CLLocationManager()
      var isCreateNew = false
      var newEventModel = CreateEventViewModel()
      var location:CLLocation!
      var nearByList = [NearbyTrucksViewModel]()
      var parameters :[String: Any] = [:]
      var selectionArray = [Int]()

      override func viewDidLoad() {
          super.viewDidLoad()
          self.configure()
        
        self.mapView.clear()
      }
      
      func configure(){
          if (CLLocationManager.locationServicesEnabled())
          {
              locationManager = CLLocationManager()
              locationManager.delegate = self
            
              locationManager.desiredAccuracy = kCLLocationAccuracyBest
              locationManager.requestAlwaysAuthorization()
              locationManager.startUpdatingLocation()
          }

          if self.isCreateNew{
              self.titleLabel.text = "Invite Truck"
              self.EventsFilterBtnView.isHidden = true
              self.TrucksFilterBtnView.isHidden = true
              self.btnNext.isHidden = false
              self.stepperProgressBarViewHeightConstraint.constant = 90
              self.stepperProgressBarView.isHidden = false
              self.btnBack.isHidden = false
              self.btnFilter.isHidden = true
              navBarHeight.constant = 50
              searchBarBottom.constant = -20
              
          }
        
          self.locationManager.delegate = self
          self.mapView.delegate = self
          self.searchViewheightConstraint.constant = 40
          self.tableView.register(UINib(nibName: "NearByTableViewCell", bundle: nil), forCellReuseIdentifier: "NearByTableViewCell")
      }
      override func viewWillAppear(_ animated: Bool) {
          super.viewWillAppear(true)
          self.askPermission()
      }
      
      @IBAction func actionBack(_ sender:Any){
          self.mainContainer.currenController?.popViewController(animated: true)
      }
      
      @IBAction func actionFilter(_ sender:Any){
          let vc = UIStoryboard.init(name: "Filter", bundle: nil).instantiateViewController(withIdentifier: "FiltersViewController") as! FiltersViewController
          //vc.delegate = self
          vc.modalPresentationStyle = .fullScreen
          self.mainContainer.present(vc, animated: true, completion: nil)
      }

      
      @IBAction func actionNext(_ sender:Any){
          let vc =  UIStoryboard.init(name: "AddEvent", bundle: nil) .instantiateViewController(withIdentifier: "InviteFriendViewController") as! InviteFriendViewController
          self.newEventModel.TrucksInEvents = self.selectionArray
          vc.newEventModel = self.newEventModel
          self.mainContainer.currenController?.pushViewController(vc, animated: true)

      }

    
    @IBAction func buttonPressToggle(_ sender: UIButton) {
          
          //buttons -> your outlet collection
              for btn in buttons {
                  if btn == sender {
                      btn.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
                  } else {
                      btn.backgroundColor = #colorLiteral(red: 0.9511117339, green: 0.7289424539, blue: 0.2410626411, alpha: 1)
                  }
              }
      }
      
   
    @IBAction func actionScroll(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        if sender.isSelected {
            self.searchViewheightConstraint.constant = 40
            
            UIView.animate(withDuration: 0.2) {
                self.view.layoutIfNeeded()
            }
            if self.mainTopViewHeightConstraint.constant == 220{
                self.mainTopViewHeightConstraint.constant = self.view.frame.height*0.7
                UIView.animate(withDuration: 0.2) {
                    self.view.layoutIfNeeded()
                }
            }
        } else{
            self.searchViewheightConstraint.constant = 40
        UIView.animate(withDuration: 0.2) {
            self.view.layoutIfNeeded()
        }
        if self.mainTopViewHeightConstraint.constant != 220{
            self.mainTopViewHeightConstraint.constant = 220
            UIView.animate(withDuration: 0.2) {
                self.view.layoutIfNeeded()
            }
        }
            }
        
    }
      
      //MARK: - Ask Location Access Permission
      func askPermission() {
          let alertController = UIAlertController(title: "Turn on", message: "Please go to Settings and turn on the location permissions", preferredStyle: .alert)
          let settingsAction = UIAlertAction(title: "Settings", style: .default) { (_) -> Void in
              guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                  return
              }
              if UIApplication.shared.canOpenURL(settingsUrl) {
                  UIApplication.shared.open(settingsUrl, completionHandler: { (success) in })
              }
          }
          let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
          alertController.addAction(cancelAction)
          alertController.addAction(settingsAction)
          
          // check the permission status
          switch(CLLocationManager.authorizationStatus()) {
          case .authorizedAlways, .authorizedWhenInUse:
              print("Authorize.")
              // get the user location
  //            self.locationManager.requestAlwaysAuthorization()
              self.locationManager.startUpdatingLocation()
              self.locationManager.startMonitoringSignificantLocationChanges()
              self.mapView.isMyLocationEnabled = true
              self.mapView.mapType = .normal
              //5
  //            self.mapView.settings.myLocationButton = true
          case .notDetermined, .restricted, .denied:
              // redirect the users to settings
              self.locationManager.requestWhenInUseAuthorization()
              self.locationManager.requestAlwaysAuthorization()
  //            self.askPermission()
  //            self.present(alertController, animated: true, completion: nil)
         
          }
      }
  }

  extension InviteTruckViewController//: GMSMapViewDelegate,CLLocationManagerDelegate
  {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations:[CLLocation]) {
          guard let location = locations.first else {
              return
          }
          if location.coordinate.latitude != 0.0{
              print(location)
              print("Stop")
              self.locationManager.stopUpdatingLocation()
              let params =
                  [
                      "userLatitude"  : nil,
                      "userLongitude" : nil,
                      "radius"        : 25,
                      "rating"        : nil,
                      "categoryIds"   : []
                  ] as [String : Any]
              self.getNearByTruckListing(location: location, params: params)
          }
          mapView.camera = GMSCameraPosition(target: location.coordinate, zoom: 15, bearing: 0, viewingAngle: 0)
          self.mapView.selectedMarker = nil
          self.mapView.clear()
      }
      
      func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
          if self.mainTopViewHeightConstraint.constant == 220
          
          {
              self.mainTopViewHeightConstraint.constant = self.view.frame.height*0.7
              UIView.animate(withDuration: 0.2) {
                  self.view.layoutIfNeeded()
              }
          }else{
             
          }
      }
  }


  extension InviteTruckViewController: UITableViewDelegate,UITableViewDataSource{
      func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
          return self.nearByList.count
      }
      
      func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NearByTableViewCell", for: indexPath) as! NearByTableViewCell
        cell.selectionStyle = .none
        cell.index = indexPath.row
        cell.delegate = self
        cell.configure(nearBy: self.nearByList[indexPath.row])
//          if self.isCreateNew{
            if self.selectionArray.contains(indexPath.row){
                cell.truckInviteImageView.image = UIImage(named: "greenTick")
            }else{
                cell.truckInviteImageView.image = UIImage(named: "inviteTruckImage")
            }
            
//          }
        
        return cell
      }
      
      func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
          tableView.deselectRow(at: indexPath, animated: true)
          if self.mainTopViewHeightConstraint.constant != 220{
              self.mainTopViewHeightConstraint.constant = 220
              UIView.animate(withDuration: 0.2) {
                  self.view.layoutIfNeeded()
              }
          }
      }
      
      func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
          self.firstCellVisible = indexPath.row == 0 ? true : false
      }
      
      func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
          return  190
      }
  }

//  extension InviteTruckViewController: UIScrollViewDelegate{
//
//      func scrollViewDidScroll(_ scrollView: UIScrollView) {
//          // The current offset
//          let offset = scrollView.contentOffset.y
//
//          // Determine the scolling direction
//          if lastContentOffset > offset && shouldCalculateScrollDirection {
//              scrollDirection = .down
//          }
//          else if lastContentOffset < offset && shouldCalculateScrollDirection {
//              scrollDirection = .up
//          }
//          switch scrollDirection {
//          case .down:
//              self.searchViewheightConstraint.constant = 40
//              UIView.animate(withDuration: 0.2) {
//                  self.view.layoutIfNeeded()
//              }
//              if self.mainTopViewHeightConstraint.constant == 220{
//                  self.mainTopViewHeightConstraint.constant = self.view.frame.height*0.7
//                  UIView.animate(withDuration: 0.2) {
//                      self.view.layoutIfNeeded()
//                  }
//              }
//          case .up:
//              self.searchViewheightConstraint.constant = 40
//              UIView.animate(withDuration: 0.2) {
//                  self.view.layoutIfNeeded()
//              }
//              if self.mainTopViewHeightConstraint.constant != 220{
//                  self.mainTopViewHeightConstraint.constant = 220
//                  UIView.animate(withDuration: 0.2) {
//                      self.view.layoutIfNeeded()
//                  }
//              }
//          }
//  //        if self.mainTopViewHeightConstraint.constant != 220{
//  //            self.mainTopViewHeightConstraint.constant = 220
//  //            UIView.animate(withDuration: 0.2) {
//  //                self.view.layoutIfNeeded()
//  //            }
//  //        }
//          // This needs to be in the last line
//          lastContentOffset = offset
//          print("the user scrolled down",self.tableView.contentOffset.y)
//             if (self.lastContentOffset > tableView.contentOffset.y) {
//                 //scrolling up
//             }
//             else if (self.lastContentOffset < tableView.contentOffset.y) {
//                 // scrolling down
//             }
//             if tableView.contentOffset.y < 5 {
//                 // the following code will be called when the user scrolls back up
//  //            if self.mainTopViewHeightConstraint.constant == 220{
//  //
//  //                self.mainTopViewHeightConstraint.constant = self.view.frame.height*0.7
//  //                UIView.animate(withDuration: 0.2) {
//  //                    self.view.layoutIfNeeded()
//  //                }
//  //            }
//                 // show the view again if thats what you need
//             }
//             self.lastContentOffset = scrollView.contentOffset.y
//      }
//      
//      func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
//          guard !decelerate else { return }
//          shouldCalculateScrollDirection = false
//      }
//      
//      func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
//          shouldCalculateScrollDirection = false
//      }
//      
//      func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
//          shouldCalculateScrollDirection = true
//      }
//  }

  extension InviteTruckViewController: FiltersViewControllerDelegate{
     func apiCallWithFilters(userLat: Double?, userLong: Double?, rating: Int?, radius: Double?, Ids: [Int]?, workHours: WorkHours?, isFilter: Bool) {
          
          if isFilter{
              let encoder = JSONEncoder()
              let data = try! encoder.encode(workHours!)
              let slots = String(data: data, encoding: .utf8)!
              do {
                  if let jsonArray = try JSONSerialization.jsonObject(with: data, options : [.allowFragments]) as? AnyObject
                  
                  {
                      print(jsonArray) // use the json here
                      let params =
                          [
                              //                "userLatitude"  : userLat,
                              //                "userLongitude" : userLong,
                              "radius"        : radius!,
                              "rating"        : rating!,
                              "categoryIds"   : Ids!,
                              "truckSlot"     : jsonArray
                          ] as [String : Any]
                      self.getNearByTruckListing(location: nil,params: params)
                  } else {
                      print("bad json")
                  }
              } catch let error as NSError {
                  print(error)
              }
              
          }else{
              let params =
                  [
                      "userLatitude"  : nil,
                      "userLongitude" : nil,
                      "radius"        : 25,
                      "rating"        : nil,
                      "categoryIds"   : []
                  ] as [String : Any]
              self.getNearByTruckListing(location: nil,params: params)
          }
      }
  }

  // Get Event Listing Api Request
  extension InviteTruckViewController{
      func getNearByTruckListing(location: CLLocation?,params: [String : Any]){
          
          let service = Services()
          GCD.async(.Main) {
            SVProgressHUD.show()
            
          }
          GCD.async(.Default) {
              service.getNearByTrucksListRequest(params: params) { (serviceResponse) in
                  GCD.async(.Main) {
                    SVProgressHUD.dismiss()
                    
                  }
                  switch serviceResponse.serviceResponseType {
                  case .Success :
                      GCD.async(.Main) {
                          if let nearByTruckList = serviceResponse.data as? [NearbyTrucksViewModel] {
                              self.nearByList = nearByTruckList
                              self.trucksSlotCalculate()
                              self.tableView.reloadData()
                              self.placeMarkers()
                            SVProgressHUD.dismiss()
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
      
      func trucksSlotCalculate(){
          for slot in self.nearByList{
              let date = Date()
              let calendar = Calendar.current
              let weekDay = calendar.component(.weekday, from: date)
//              let time = (slot.workHours?.filter{$0.dayOfWeek == weekDay})!
//              if Global.shared.truckTimeSlot.count>0{
//                  for truck in Global.shared.truckTimeSlot{
//                      if truck.startTime == time.first!.startTime && truck.endTime == time.first!.endTime {
//
//                      }else{
//                          Global.shared.truckTimeSlot.append(contentsOf: time)
//                      }
//                  }
//              }else{
//                  Global.shared.truckTimeSlot.append(contentsOf: time)
//              }
          }
      }
      
      func placeMarkers(){
          for place in self.nearByList{
              DispatchQueue.main.async
              {
                  self.marker(latitude: place.permanentLatitude!, longitude: place.permanentLongitude!)
              }
          }
      }
      
      func marker(latitude : Double, longitude : Double){
          let marker = GMSMarker()
          marker.position = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
          marker.isDraggable = true
          marker.title = "20 Min away"
          marker.map = self.mapView
          self.mapView.selectedMarker = marker
        
        self.mapView.clear()
      }
  }


  extension InviteTruckViewController: NearByTableViewCellDelegate{
      func truckInvite(index: Int) {
//          if self.isCreateNew{
//              if self.selectionArray.contains(index){
//                  let pos = self.selectionArray.firstIndex(of:index)
//                  self.selectionArray.remove(at: pos!)
//              }else{
//                  self.selectionArray.append(index)
//              }
//              let index = IndexPath(row: index, section: 0)
//              self.tableView.reloadRows(at: [index], with: .automatic)
//          }else{
//            if #available(iOS 13.0, *) {
//                if let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(identifier: "EventsListViewController") as? EventsListViewController{
//                    vc.isInvite = true
//                    vc.eventFilter = self.nearByList[index]
//                    self.mainContainer.present(vc, animated: true, completion: nil)
//                }
//            } else {
//                // Fallback on earlier versions
//            }
//          }
//        let alertController = UIAlertController(title: "Food Truck", message:
//                "Food Truck, added!", preferredStyle: .alert)
//            alertController.addAction(UIAlertAction(title: "Dismiss", style: .default))
//            self.present(alertController, animated: true, completion: {
                
        let id = "\(self.nearByList[index].truckId ?? -1)"
        if self.newEventModel.truckIds == "" {
            self.newEventModel.truckIds.append(id)
        }else {
            self.newEventModel.truckIds.append(",\(id)")
        }
        if self.selectionArray.contains(index){
            let pos = self.selectionArray.firstIndex(of: index)
            self.selectionArray.remove(at: pos!)
        }else{
            self.selectionArray.append(index)
        }
        let index = IndexPath(row: index, section: 0)
        self.tableView.reloadRows(at: [index], with: .automatic)
//            })
        
      }
  }
