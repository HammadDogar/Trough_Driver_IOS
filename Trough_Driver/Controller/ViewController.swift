//
//  ViewController.swift
//  Trough_Driver
//
//  Created by Macbook on 04/03/2021.
//

import UIKit
import GoogleMaps


class ViewController: UIViewController,GMSMapViewDelegate {
    
    var eventLatitude:Double = 31.481353
    var eventLongitude:Double = 74.328607

    @IBOutlet weak var mapView: GMSMapView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        mapView.delegate = self
        
        currentLocation()
        
    }
    
    func currentLocation(){
        let camera = GMSCameraPosition.camera(withLatitude: eventLatitude, longitude: eventLongitude, zoom: 12.5)
        mapView.camera = camera
        
        let marker = GMSMarker()
        let location = CLLocationCoordinate2D(latitude: eventLatitude, longitude: eventLongitude)
        marker.position = location
        marker.title = "Map"
        marker.snippet = "My Location"
        //marker.isTappable = true
        //marker.tracksInfoWindowChanges = true
        //marker.accessibilityLabel = "0"
        //mapView.selectedMarker = marker
        marker.map = mapView
        mapView.selectedMarker = marker
    }
    
//    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
//        print("Marker Tapped")
//        return true
//    }
    func mapView(_ mapView: GMSMapView, markerInfoWindow marker: GMSMarker) -> UIView? {
        print("hello")
        let markerWindowView = Bundle.main.loadNibNamed("MarkerWindow", owner: self, options: nil)?.first as! MarkerWindow
        return markerWindowView
    }

}
