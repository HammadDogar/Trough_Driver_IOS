//
//  GoogleMapViewController.swift
//  Trough_Driver
//
//  Created by Macbook on 25/02/2021.
//

import UIKit
import GoogleMaps
import SVProgressHUD
import CoreLocation

class GoogleMapViewController: UIViewController,MapCotrollerDelegate{
    
        
    var currentTruckLocation:CLLocation?
    
    @IBOutlet weak var mapView: GMSMapView!
    
    let locationManager = CLLocationManager()
    
    var total:Double = 0.5
    
    let SwitchBtn = UISwitch()
    
    var nearByList = [NearbyTrucksViewModel]()
    var eventList = [EventViewModel]()
    var truckId:String?
    var eventId:String?
    
    var truckLatitude: [Double] = [31.464767,31.468643,31.481756]
    var truckLongitude: [Double] = [74.255555,74.262643,74.281090]
    
    var eventLatitude: [Double] = [31.481353,31.472836,31.453029]
    var eventLongitude: [Double] = [74.328607,74.347443,74.334276]

    //var name: [String] = ["Location1","Location2","Location3"]
    var markers = [GMSMarker]()

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        ConfigureSwitchButton()
                
        self.mapView.delegate = self
        
        loadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
  
    }
    
    func ConfigureSwitchButton(){
        
        SwitchBtn.frame = CGRect(x: self.view.frame.width - 70, y: 80, width: 50, height: 50)
        SwitchBtn.backgroundColor = UIColor.red
        SwitchBtn.layer.cornerRadius = 16
        
        if Global.shared.userIsAvailable == true{
            SwitchBtn.isOn = true
            self.locationManager.startUpdatingLocation()
            GlobalVariable.appDelegate.loadMap()
            
        }
        else{
            SwitchBtn.isOn = false
            GlobalVariable.appDelegate.locationManager.stopUpdatingLocation()
        }
        self.view.addSubview(SwitchBtn)
        
        SwitchBtn.addTarget(self, action: #selector(didChangeSwitchBtn), for: .valueChanged)

    }
    
    @objc func didChangeSwitchBtn(){
        
        var params:[String:Any] = [:]
        
        if SwitchBtn.isOn == true {
            print("On")
            self.getActivityListing()
            params =
                [
                    "isAvailable"        : true
                    
                ] as [String : Any]
            self.locationManager.startUpdatingLocation()
            GlobalVariable.appDelegate.loadMap()
            Global.shared.userIsAvailable = true
        }
        else{
            print("Off")
            params =
                [
                    "isAvailable"        : false
                    
                    
                ] as [String : Any]
            GlobalVariable.appDelegate.locationManager.stopUpdatingLocation()
            Global.shared.userIsAvailable = false
        }
        
        let service = Services()
        SVProgressHUD.show()
        GCD.async(.Default) {
            service.updateTruckUserAvailability(params: params) { (serviceResponse) in
                GCD.async(.Main) {
                    SVProgressHUD.dismiss()
                  
                }
                switch serviceResponse.serviceResponseType {
                case .Success :
                    GCD.async(.Main) {
                        if let data = serviceResponse.data {
                            print(data)
                            
                            
                            
                            if params["isAvailable"]! as! Bool == true{
                                Global.shared.userIsAvailable = true
                                print(Global.shared.userIsAvailable)
                            }
                            else{
                                Global.shared.userIsAvailable = false
                                print(Global.shared.userIsAvailable)
                            }
                            
                            SVProgressHUD.dismiss()
                        }
                        else {
                            self.simpleAlert(title: "Alert!", msg: "Error Updating User Status")
                        }
                    }
                case .Failure :
                    GCD.async(.Main) {
                        self.simpleAlert(title: "Alert!", msg: "Error Updating User Status")
                    }
                default :
                    GCD.async(.Main) {
                        self.simpleAlert(title: "Alert!", msg: "Error Updating User Status")
                    }
                }
            }
        }
    }
    
    fileprivate func loadData() {
        if CLLocationManager.locationServicesEnabled() {
            switch CLLocationManager.authorizationStatus() {
                case .notDetermined, .restricted, .denied:
                    print("No access")
                    self.simpleAlert(title: "Alert", msg: "Please Enable Location Service in Setting")
                case .authorizedAlways, .authorizedWhenInUse:
                    print("Access")
                    self.locationManager.delegate = self
                    self.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
                    self.locationManager.requestWhenInUseAuthorization()
                    self.locationManager.startUpdatingLocation()
                    self.locationManager.allowsBackgroundLocationUpdates = true
//                    mapView.isMyLocationEnabled = false
                    self.mapView.isMyLocationEnabled = true
                    self.mapView.settings.myLocationButton = true
                    self.getActivityListing()
                @unknown default:
                break
            }
            } else {
                print("Location services are not enabled")
        }
        
    }


    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.mapView.clear()

        guard let location = locations.last else {
            return
        }
        
        if location.coordinate.latitude != 0 {
            print("location \(location)")
            self.locationManager.stopUpdatingLocation()
            self.currentTruckLocation = location
            self.updateLocation(location: location)
        }
//        if location.coordinate.longitude == currentTruckLocation?.coordinate.longitude {
//                    print("location \(location)")
//                    self.locationManager.stopUpdatingLocation()
//        //            self.currentTruckLocation = location
//        //            self.updateLocation(location: location)
//                }
//        else{
//            print("location \(location) currentLocation \(currentTruckLocation)")
//            self.mapView.clear()
//            self.currentTruckLocation = location
//            self.updateLocation(location: location)
//        }
    }
    
    func updateLocation(location: CLLocation?){
        self.getNearByTruckListing(location: location)
        mapView.camera = GMSCameraPosition(target: location!.coordinate, zoom: 13, bearing: 0, viewingAngle: 0)
        let marker = GMSMarker()
        let currentLocation = CLLocationCoordinate2D(latitude: location!.coordinate.latitude, longitude: location!.coordinate.longitude)
        marker.position = currentLocation
        marker.title = "Map"
        marker.snippet = "My Location"
//        marker.icon = UIImage(named: "delivery-truck 2")
        marker.icon = UIImage(named: "TruckMapPic")

        
        //set Circle around marker
        let circ = GMSCircle(position: marker.position , radius: GlobalVariable.totalRange * 1609.34)
        circ.fillColor = UIColor(red: 0.0, green: 0.7, blue: 0, alpha: 0.1)
        circ.strokeColor = UIColor(red: 255/255, green: 153/255, blue: 51/255, alpha: 0.5)
        circ.strokeWidth = 2.5;
        circ.map = self.mapView
        
        marker.map = mapView
        self.mapView.selectedMarker = marker
    }
    
    @IBAction func action3Dot(_ sender: UIButton) {
        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "FilterMapViewController") as? FilterMapViewController{
            vc.delegate = self
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func backToMapVC() {
        mapView.clear()
        loadData()
    }
    
}


// MARK:- GMSMapViewDelegate

extension GoogleMapViewController:GMSMapViewDelegate,CLLocationManagerDelegate{
    
    func mapView(_ mapView: GMSMapView, markerInfoWindow marker: GMSMarker) -> UIView? {
        
        print(marker.accessibilityLabel!)
        
        if marker.title == "Truck"{
            for place in self.nearByList{
                
                let coordinate0 = CLLocation(latitude: (currentTruckLocation?.coordinate.latitude)!, longitude: (currentTruckLocation?.coordinate.longitude)!)
                let coordinate1 = CLLocation(latitude: place.permanentLatitude!, longitude: place.permanentLongitude!)
                let distanceInMeters = coordinate0.distance(from: coordinate1)
                let distanceInMiles = distanceInMeters/1609.34
                print(distanceInMiles)
                let y = Double(round(100*distanceInMiles)/100)
                    if marker.accessibilityLabel! == String(place.truckId!){
                        print(marker.accessibilityLabel!)
                        print(place.truckId!)
                        let markerWindowView = Bundle.main.loadNibNamed("MarkerTruckWindow", owner: self, options: nil)?.first as! MarkerTruckWindow
                        let frame = CGRect(x: 10, y: 10, width: 150, height: markerWindowView.frame.height)
                        markerWindowView.lblDistance.text = "\(y) Miles Away"
                        markerWindowView.lblName.text = place.name ?? ""
                        markerWindowView.lblCity.text = place.address ?? ""
                        
                        markerWindowView.frame = frame
                        return markerWindowView
                        
                    }
                
            }

        }
        else if marker.title == "Event"{
            
            for event in self.eventList{
                
                if marker.accessibilityLabel! == String(event.eventId!){
                        print(marker.accessibilityLabel!)
                        print(event.eventId!)
                        let markerWindowView = Bundle.main.loadNibNamed("MarkerWindow", owner: self, options: nil)?.first as! MarkerWindow
                            
                        let frame = CGRect(x: 10, y: 10, width: 280, height: markerWindowView.frame.height)
                        markerWindowView.frame = frame
                    
                    let coordinate0 = CLLocation(latitude: (currentTruckLocation?.coordinate.latitude)!, longitude: (currentTruckLocation?.coordinate.longitude)!)
                    let coordinate1 = CLLocation(latitude: event.latitude!, longitude: event.longitude!)
                    let distanceInMeters = coordinate0.distance(from: coordinate1)
                    let distanceInMiles = distanceInMeters/1609.34
                    print(distanceInMiles)
                    
                    let y = Double(round(100*distanceInMiles)/100)

                    markerWindowView.lblDistance.text = "\(String(y)) Miles Away"
                    markerWindowView.lblEventName.text = event.eventName!
                    markerWindowView.lblLocation.text = event.locationName!
                    
//                    if event.imageUrl != "" && event.imageUrl != nil{
//                        let url = URL(string: BASE_URL+event.imageUrl!) ?? URL.init(string: "https://www.google.com")!
//                        markerWindowView.eventIImage.setImage(url: url)
//                    }else{    }
                    
                    if event.imageUrl != "" && event.imageUrl != nil{
                        if let url = URL(string: event.imageUrl! ) {
                            DispatchQueue.main.async {
                                markerWindowView.eventIImage.setImage(url: url)
                            }
                        }
                    }else{
                        
                    }
                    
                    markers.append(marker)

                    return markerWindowView
                    }
            }
            
            
//            for event in self.eventList{
//
//                if marker.accessibilityLabel! == String(event.eventId!){
//                        print(marker.accessibilityLabel!)
//                        print(event.eventId!)
//                        let markerWindowView = Bundle.main.loadNibNamed("MarkerWindow", owner: self, options: nil)?.first as! MarkerWindow
//
//                        let frame = CGRect(x: 10, y: 10, width: 280, height: markerWindowView.frame.height)
//                        markerWindowView.frame = frame
//
//                    let coordinate0 = CLLocation(latitude: (currentTruckLocation?.coordinate.latitude)!, longitude: (currentTruckLocation?.coordinate.longitude)!)
//                    let coordinate1 = CLLocation(latitude: event.latitude!, longitude: event.longitude!)
//                    let distanceInMeters = coordinate0.distance(from: coordinate1)
//                    let distanceInMiles = distanceInMeters/1609.34
//                    print(distanceInMiles)
//
//                    let y = Double(round(100*distanceInMiles)/100)
//
//                    let startTime = "\(event.eventSlots?.first?.startTime ?? "") : \(event.eventSlots?.first?.startTime ?? "")".timeConversion12()
//                    let endTime = "\(event.eventSlots?.first?.endTime ?? "") : \(event.eventSlots?.first?.endTime ?? "")".timeConversion12()
//
//                    markerWindowView.lblDistance.text = "\(String(y)) Miles Away"
//                    markerWindowView.lblEventName.text = event.eventName!
//                    markerWindowView.lblLocation.text = event.locationName!
////                    markerWindowView.lblStartTime.text = "Start at: \(startTime)"
////                    markerWindowView.lblEndTime.text = "End at: \(endTime)"
////                    markerWindowView.lblStartTime.text = "\(startTime ) - \(endTime )"
//                    return markerWindowView
//                    }
//            }
        }
            return nil
    }
    func mapView(_ mapView: GMSMapView, didTapInfoWindowOf marker: GMSMarker) {
        print("tapped")

        
        
        
        
        
//        if marker.title == "Map"{
//            for place in self.nearByList{
//                if marker.accessibilityLabel! == String(place.truckId!){
//                    print(marker.accessibilityLabel!)
//                    print(place.truckId!)
//                    let sb = UIStoryboard(name: "Main", bundle: nil)
//                    if #available(iOS 13.0, *) {
//                        let vc = sb.instantiateViewController(identifier: "TruckInfoViewController") as! TruckInfoViewController
//                        vc.id = place.truckId ?? 0
//                        self.navigationController?.pushViewController( vc, animated: true)
//                    } else {
//                        // Fallback on earlier versions
//                    }
//                }
//            }
//
//
//
////            let sb = UIStoryboard(name: "Main", bundle: nil)
////
////            if #available(iOS 13.0, *) {
////                let mainVC = sb.instantiateViewController(identifier: "TruckInfoViewController") as! TruckInfoViewController
////
////                self.navigationController?.pushViewController( mainVC, animated: true)
////
////            } else {
////                // Fallback on earlier versions
////            }
//        }
        if marker.title == "Event"{
            for place in self.eventList{
                if marker.accessibilityLabel! == String(place.eventId!){
                    print(marker.accessibilityLabel!)
                    print(place.eventId!)

                    let sb = UIStoryboard(name: "Main", bundle: nil)
                    if #available(iOS 13.0, *) {
                        let vc = sb.instantiateViewController(identifier: "NewEventDetailViewController") as! NewEventDetailViewController
                        vc.id = place.eventId ?? 0
                        
//                        if let index = markers.firstIndex(where:  {$0.title == marker.title}) {
                            let tappedState = place// eventList[index]
                            vc.event = tappedState
                        //}
                        
//                        if let index = markers.index(of: marker) {
//
//                            }

//                        for i in 0 ..< eventList.count {
//                            print(i)
//                        }
//                        for (index, list) in eventList.enumerated() {
//                            vc.event = list
//                            print("Item \(index): \(list)")
//                        }
                        self.navigationController?.pushViewController( vc, animated: true)
                    } else {
                        // Fallback on earlier versions
                    }
                }
            }
        }
        
        else if marker.title == "Truck"{
            for place in self.nearByList{
                if marker.accessibilityLabel! == String(place.truckId!){
                    print(marker.accessibilityLabel!)
                    print(place.truckId!)
                    let sb = UIStoryboard(name: "Main", bundle: nil)
                    if #available(iOS 13.0, *) {
                        let vc = sb.instantiateViewController(identifier: "TruckInfoViewController") as! TruckInfoViewController
//                        vc.id = place.truckId ?? 0
                        
                        let tappedState = place// eventList[index]
                        vc.near = tappedState
                        
                        
                        self.navigationController?.pushViewController( vc, animated: true)
                    } else {
                        // Fallback on earlier versions
                    }
                }
            }
        }
        
        
    }
}

//MARK:- Get and show Truck Data
    extension GoogleMapViewController{
    
        func getNearByTruckListing(location: CLLocation?){
            
            let params =
                [
                    "radius"        : 25
                    
                ] as [String : Any]
            
            let service = Services()
//            SVProgressHUD.show()
            GCD.async(.Default) {
                service.getNearByTrucksListRequest(params: params) { (serviceResponse) in
                    GCD.async(.Main) {
//                        SVProgressHUD.dismiss()
                      
                    }
                    switch serviceResponse.serviceResponseType {
                    case .Success :
                        GCD.async(.Main) {
                            if let nearByTruckList = serviceResponse.data as? [NearbyTrucksViewModel] {
                                self.nearByList = nearByTruckList
                                //self.trucksSlotCalculate()
                                
                                if GlobalVariable.isTruckShow{
                                    self.placeMarkers(location: location)
                                }
                                print(nearByTruckList.count)
                                SVProgressHUD.dismiss()
                            }
                            else {
                                print("No Truck Found!")
                            }
                        }
                    case .Failure :
                        GCD.async(.Main) {
                            print("No Truck Found!,Failed")
                        }
                    default :
                        GCD.async(.Main) {
                            print("No Truck Found!")
                        }
                    }
                }
            }
        }
        
        func placeMarkers(location: CLLocation?){
            
            
            for place in self.nearByList{
                DispatchQueue.main.async
                {
                    self.marker(latitude: place.permanentLatitude!, longitude: place.permanentLongitude!, truckId: place.truckId!)
                }
            }
        }
        
        func marker(latitude : Double, longitude : Double,truckId:Int){
            
            let coordinate0 = CLLocation(latitude: (self.currentTruckLocation?.coordinate.latitude)!, longitude: (self.currentTruckLocation?.coordinate.longitude)!)
            let coordinate1 = CLLocation(latitude: latitude, longitude: longitude)
            let distanceInMeters = coordinate0.distance(from: coordinate1)
            
            if distanceInMeters >= GlobalVariable.totalRange * 1609.34{
                
            }
            
            else{
                print(GlobalVariable.totalRange)
                print("Truck: \(distanceInMeters)")
                let marker = GMSMarker()
                marker.position = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                marker.isDraggable = true
                //marker.title = "20 Min away"
                marker.icon = UIImage(named: "delivery-truck 2")
                marker.title = "Truck"
                self.truckId = String(truckId)
                marker.accessibilityLabel = self.truckId!
                marker.map = self.mapView
                //self.mapView.selectedMarker = marker

            }
        }
}

//MARK:- Get Event Data
extension GoogleMapViewController{
    func getActivityListing(){
        var params: [String:Any] = [String:Any]()
        params = [
                        "radius" : 25
        ] as [String : Any]

        let service = Services()
        SVProgressHUD.show()
        GCD.async(.Default) {
            service.getEventsListRequest(params: params) { (serviceResponse) in
                GCD.async(.Main) {
                    SVProgressHUD.dismiss()
                }
                switch serviceResponse.serviceResponseType {
                case .Success :
                    GCD.async(.Main) {
                        if let eventsList = serviceResponse.data as? [EventViewModel] {
                            self.eventList = eventsList

                            SVProgressHUD.dismiss()
                            if GlobalVariable.isEventShow{
                                self.EventPlaceMarkers()
                            }
                            
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
    func EventPlaceMarkers(){
        
        
        for event in self.eventList{
            DispatchQueue.main.async
            {
                self.EventMarker(latitude: event.latitude!, longitude: event.longitude!, eventId: event.eventId!)
            }
        }
    }
    
    func EventMarker(latitude : Double, longitude : Double,eventId:Int){
        let marker = GMSMarker()
        let coordinate0 = CLLocation(latitude: (self.currentTruckLocation?.coordinate.latitude)!, longitude: (self.currentTruckLocation?.coordinate.longitude)!)
        let coordinate1 = CLLocation(latitude: latitude, longitude: longitude)
        let distanceInMeters = coordinate0.distance(from: coordinate1)
        
        if distanceInMeters >= GlobalVariable.totalRange * 1609.34{
            
        }
        else{
            print("Event: \(distanceInMeters)")
            marker.position = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            marker.isDraggable = true
            //marker.title = "20 Min away"
//            marker.icon = UIImage(named: "locationIcon")
            marker.icon = UIImage(named: "eventsPic")

            marker.title = "Event"
            self.eventId = String(eventId)
            marker.accessibilityLabel = self.eventId!
            marker.map = self.mapView
            //self.mapView.selectedMarker = marker
        }
        
    }
}
