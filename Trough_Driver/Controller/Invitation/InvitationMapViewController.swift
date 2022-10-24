//
//  InvitationMapViewController.swift
//  Trough_Driver
//
//  Created by Macbook on 01/03/2021.
//

import UIKit

import GoogleMaps

class InvitationMapViewController: UIViewController,GMSMapViewDelegate,CLLocationManagerDelegate {

    @IBOutlet weak var mapView: GMSMapView!
    
    var locationManager = CLLocationManager()
    
    var currentLocation:CLLocation?
    
    var eventLatitude:Double = 31.481353
    var eventLongitude:Double = 74.328607
    
    var distance:Double = 0.0
    
    var event:EventViewModel?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        self.mapView.delegate = self
        
        loadData()
        
        
    }
    
    fileprivate func loadData() {
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
        //mapView.isMyLocationEnabled = true
        //self.showLocationOnMap()
    }

    func showLocationOnMap(currentLat:Double,currentLng:Double){
        
        let coordinate0 = CLLocation(latitude: currentLat, longitude: currentLng)
        let coordinate1 = CLLocation(latitude: (event?.latitude)!, longitude: (event?.longitude)!)
        let distanceInMeters = coordinate0.distance(from: coordinate1)
        distance = distanceInMeters/1609.34
        print(distanceInMeters/1609.34)
        
        
        let camera = GMSCameraPosition.camera(withLatitude: (event?.latitude)!, longitude: (event?.longitude)!, zoom: 12)
        mapView.camera = camera
        
        let marker = GMSMarker()
        let location = CLLocationCoordinate2D(latitude: currentLat, longitude: currentLng)
        marker.position = location
        marker.title = "Map"
        marker.snippet = "My Location"
        marker.icon = UIImage(named: "delivery-truck 2")
        marker.isTappable = true
        marker.tracksInfoWindowChanges = true
        
        if distance <= 10.0{
        //set Circle around marker
        let circ = GMSCircle(position: marker.position , radius: distanceInMeters + 300.00)
        circ.fillColor = UIColor(red: 0.0, green: 0.7, blue: 0, alpha: 0.1)
        circ.strokeColor = UIColor(red: 255/255, green: 153/255, blue: 51/255, alpha: 0.5)
        circ.strokeWidth = 2.5;
        circ.map = self.mapView
        }
        marker.map = mapView
        //mapView.selectedMarker = marker
        
        
        showEventLocation()
    }
    func showEventLocation(){
        
        
        
        let locationEvent = CLLocationCoordinate2D(latitude: (event?.latitude)!, longitude: (event?.longitude)!)
        let eventMarker = GMSMarker()
        //Define attributes of the mapMarker.
        eventMarker.icon = UIImage(named: "locationIcon")
        eventMarker.position = locationEvent
        eventMarker.title = "Map"
        eventMarker.accessibilityLabel = "0"
        //eventMarker.snippet = "Event Location"
        
        
        eventMarker.map = mapView
        mapView.selectedMarker = eventMarker
        
        
    }
    
    @IBAction func actionBackBtn(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last
        let lat = (location?.coordinate.latitude)!
        let lng = (location?.coordinate.longitude)!
        self.showLocationOnMap(currentLat: lat, currentLng: lng)
        self.locationManager.stopUpdatingLocation()

    }
    
    // MARK:- GMSMapViewDelegate

    func mapView(_ mapView: GMSMapView, markerInfoWindow marker: GMSMarker) -> UIView? {
        if marker.accessibilityLabel == "0"{
            let markerWindowView = Bundle.main.loadNibNamed("MarkerWindow", owner: self, options: nil)?.first as! MarkerWindow
            let frame = CGRect(x: 10, y: 10, width: 280, height: markerWindowView.frame.height)
            markerWindowView.frame = frame
            let y = Double(round(100*distance)/100)
//            let startTime = "\(event?.eventSlots?.first?.startTime ?? "") : \(event?.eventSlots?.first?.startTime ?? "")".timeConversion12()
//            let endTime = "\(event?.eventSlots?.first?.endTime ?? "") : \(event?.eventSlots?.first?.endTime ?? "")".timeConversion12()
            
            markerWindowView.lblDistance.text = "\(String(y)) Miles Away"
            markerWindowView.lblEventName.text = event?.eventName
            markerWindowView.lblLocation.text = event?.locationName
            
//            if event?.imageUrl != "" && event?.imageUrl != nil{
//                let url = URL(string: BASE_URL+(event?.imageUrl!)!) ?? URL.init(string: "https://www.google.com")!
//                markerWindowView.eventIImage.setImage(url: url)
//            }else{    }
            
            if event?.imageUrl != "" && event?.imageUrl != nil{
                if let url = URL(string: event?.imageUrl! ?? "" ) {
                    DispatchQueue.main.async {
                        markerWindowView.eventIImage.setImage(url: url)
                    }
                }
            }else{
                
            }
//            markerWindowView.lblStartTime.text = "Start at: \(startTime)"
//            markerWindowView.lblEndTime.text = "End at: \(endTime)"
            return markerWindowView
        }
        else{
            return nil
        }
        
    }
    func mapView(_ mapView: GMSMapView, didTapInfoWindowOf marker: GMSMarker) {
        print("tapped")
        
        
        
        
        
        
    }

}
