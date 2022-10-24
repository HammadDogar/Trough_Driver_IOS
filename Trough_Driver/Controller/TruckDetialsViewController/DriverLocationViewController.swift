//
//  DriverLocationViewController.swift
//  Trough_Driver
//
//  Created by Imed on 09/04/2021.
//
//
//import UIKit
//import GoogleMaps
//import CoreLocation
//
//class DriverLocationViewController:  BaseViewController, UITextFieldDelegate{
//
//    @IBOutlet weak var mapView: GMSMapView!
//    @IBOutlet weak var locationTextField: UITextField!
//
//    var lat:Double = 0.0
//    var lng:Double = 0.0
//
//    var locationTitle:String = ""
//
//    var locationManager = CLLocationManager()
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        self.configure()
//
//        locationTextField.delegate = self
//        self.mapView.clear()
//
//    }
//
//    override func viewWillAppear(_ animated: Bool) {
//        self.navigationController?.isNavigationBarHidden = true
//    }
//    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
//        if textField.isEqual(locationTextField){
//            getLocation()
//            self.view.endEditing(true)
//            return false
//        }
//        return false
//    }
//
//    func getLocation(){
//
//        let sb = UIStoryboard(name: "Main", bundle: nil)
//        if #available(iOS 13.0, *) {
//            let vc = sb.instantiateViewController(identifier: "mapViewController") as! mapViewController
//
//            vc.delegate = self
//            self.navigationController?.pushViewController(vc, animated: true)
//
//        } else {
//            // Fallback on earlier versions
//        }
//
//    }
//    func configure(){
//        if (CLLocationManager.locationServicesEnabled())
//        {
//            locationManager = CLLocationManager()
//            locationManager.delegate = self
//            locationManager.desiredAccuracy = kCLLocationAccuracyBest
//            locationManager.requestAlwaysAuthorization()
//            locationManager.startUpdatingLocation()
//        }
//        self.locationManager.delegate = self
//        self.mapView.delegate = self
//        self.mapView.clear()
//
//    }
//
//    @IBAction func updateTimeAndDate(_ sender: UIButton) {
//
//        let sb = UIStoryboard(name: "Main", bundle: nil)
//        if #available(iOS 13.0, *) {
//            let mainVC = sb.instantiateViewController(identifier: "DaysViewController") as! DaysViewController
//
//            self.navigationController?.pushViewController( mainVC, animated: true)
//
//        } else {
//            // Fallback on earlier versions
//        }
//    }
//
//
//
//    @IBAction func actionBack(_ sender: UIButton) {
//
//        self.navigationController?.popViewController(animated: true)
//    }
//
//    @IBAction func actionSaveLocationBtn(_ sender: UIButton){
//        self.locationTitle = "Home"
//
//        if self.locationTitle != "" && self.locationTextField.text != ""{
//            self.saveLocation()
//        }
//        else{
//            simpleAlert(title: "Alert", msg: "Add Location")
//        }
//    }
//    @IBAction func seeSavedLocation(_ sender: UIButton) {
//        let sb = UIStoryboard(name: "Others", bundle: nil)
//        if #available(iOS 13.0, *) {
//            let mainVC = sb.instantiateViewController(identifier: "SavedLocationViewController") as! SavedLocationViewController
//
//            self.navigationController?.pushViewController( mainVC, animated: true)
//
//        } else {
//            // Fallback on earlier versions
//        }
//    }
//
//    func saveLocation(){
//        let params:[String:Any] = [
//            "id": 0,
//            "title": self.locationTitle,
//            "userId":Global.shared.currentUser.userId!,
//            "longitude":self.lng,
//            "latitude": self.lat
//
//                            ]
//
//        print(params)
//        let service = UserServices()
//        GCD.async(.Default) {
//            service.SaveUserLocation(params: params) { (serviceResponse) in
//                GCD.async(.Main) {
//
//                }
//                switch serviceResponse.serviceResponseType {
//                case .Success :
//                    GCD.async(.Main) {
//                        if let data = serviceResponse.data {
//                            print(data)
//
//                            self.simpleAlert(title: "Alert!", msg: "Location Added Successfully Successfully")
//
//                        }
//                        else {
//                            self.simpleAlert(title: "Alert!", msg: "Error Adding new Location")
//                        }
//                    }
//                case .Failure :
//                    GCD.async(.Main) {
//                        self.simpleAlert(title: "Alert!", msg: "Error Adding new Location")
//                    }
//                default :
//                    GCD.async(.Main) {
//                        self.simpleAlert(title: "Alert!", msg: "Error Adding new Location")
//                    }
//                }
//            }
//        }
//    }
//
//
//}
////MARK:- Location Delegate
//extension DriverLocationViewController: GMSMapViewDelegate,CLLocationManagerDelegate{
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        guard let location = locations.first else {
//            return
//        }
//        self.mapView.clear()
//        if location.coordinate.latitude != 0.0{
//
//            self.locationManager.stopUpdatingLocation()
//
//        }
//        mapView.camera = GMSCameraPosition(target: location.coordinate, zoom: 15, bearing: 0, viewingAngle: 0)
//        let marker1 = GMSMarker()
//        let currentLocation = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
//        marker1.position = currentLocation
//        marker1.title = "Map"
//        marker1.snippet = "My Location"
//        marker1.map = self.mapView
//        self.mapView.clear()
//
//    }
//
//}
//
//extension DriverLocationViewController: LOCATIONSELECT{
//    func locationSelect(address: String, latitude: Double, lognitude: Double, title: String) {
//        self.locationTextField.text = address
//        self.lat = latitude
//        self.lng = lognitude
//    }
//
//
//}


import UIKit
import GoogleMaps
import CoreLocation

class DriverLocationViewController:  BaseViewController, UITextFieldDelegate{

    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var locationTextField: UITextField!

    var lat:Double = 0.0
    var lng:Double = 0.0

    var locationTitle:String = "Work"
    var locationManager = CLLocationManager()
    var location:CLLocation!

    override func viewDidLoad() {
        super.viewDidLoad()
        locationTextField.delegate = self
        self.configure()

//        self.mapView.clear()

    }

    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
        self.askPermission()
    }
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField.isEqual(locationTextField){
            getLocation()
            self.view.endEditing(true)
            return false
        }
        return false
    }

        func getLocation(){
    
            let sb = UIStoryboard(name: "Main", bundle: nil)
            if #available(iOS 13.0, *) {
                let vc = sb.instantiateViewController(identifier: "mapViewController") as! mapViewController
    
                vc.delegate = self
                self.navigationController?.pushViewController(vc, animated: true)
    
            } else {
                // Fallback on earlier versions
            }
    
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

//        self.locationManager.delegate = self
        self.mapView.delegate = self
        self.mapView.clear()

    }

    @IBAction func updateTimeAndDate(_ sender: UIButton) {

        let sb = UIStoryboard(name: "Main", bundle: nil)
        if #available(iOS 13.0, *) {
            let mainVC = sb.instantiateViewController(identifier: "DaysViewController") as! DaysViewController

            self.navigationController?.pushViewController( mainVC, animated: true)

        } else {
            // Fallback on earlier versions
        }
    }



    @IBAction func actionBack(_ sender: UIButton) {

        self.navigationController?.popViewController(animated: true)
    }

    @IBAction func actionSaveLocationBtn(_ sender: UIButton){

        self.locationTitle = "Work"

        if self.locationTitle != "" && self.locationTextField.text != ""{

            self.saveLocation()
        }
        else{
            simpleAlert(title: "Alert", msg: "Add Location")
        }

    }
    @IBAction func seeSavedLocation(_ sender: UIButton) {
        let sb = UIStoryboard(name: "Others", bundle: nil)
        if #available(iOS 13.0, *) {
            let mainVC = sb.instantiateViewController(identifier: "SavedLocationViewController") as! SavedLocationViewController

            self.navigationController?.pushViewController( mainVC, animated: true)

        } else {
            // Fallback on earlier versions
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

            self.locationManager.delegate = self
            self.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters

            self.locationManager.startMonitoringSignificantLocationChanges()
            self.mapView.isMyLocationEnabled = true
            self.mapView.mapType = .normal
        //5
            self.mapView.settings.myLocationButton = true
        case .notDetermined, .restricted, .denied:
            // redirect the users to settings
            self.locationManager.requestWhenInUseAuthorization()
            self.locationManager.requestAlwaysAuthorization()
        //            self.askPermission()
        //            self.present(alertController, animated: true, completion: nil)

        }
    }
    func saveLocation(){
        let params:[String:Any] = [
            "id": 0,
            "title": self.locationTitle,
            "userId":Global.shared.currentUser.userId!,
            "longitude":self.lng,
            "latitude": self.lat,
            "addres": self.locationTextField.text!
        ]
        print(params)
        let service = UserServices()
        GCD.async(.Default) {
            service.SaveUserLocation(params: params) { (serviceResponse) in
                GCD.async(.Main) {}
                switch serviceResponse.serviceResponseType {
                case .Success :
                    GCD.async(.Main) {
                        if let data = serviceResponse.data {
                            print(data)

                            self.simpleAlert(title: "Alert!", msg: "Location Added Successfully")
                            print("Updated")
                        }
                        else {
                            self.simpleAlert(title: "Alert!", msg: "Error Adding new Location")
                        }
                    }
                case .Failure :
                    GCD.async(.Main) {
                        self.simpleAlert(title: "Alert!", msg: "Error Adding new Location---")
                    }
                default :
                    GCD.async(.Main) {
                        self.simpleAlert(title: "Alert!", msg: "Error Adding new Location----")
                    }
                }
            }
        }
    }

}

//MARK:- Location Delegate
extension DriverLocationViewController: GMSMapViewDelegate,CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else {
            return
        }
        self.mapView.clear()
        if location.coordinate.latitude != 0.0{

            self.locationManager.stopUpdatingLocation()

        }
        mapView.camera = GMSCameraPosition(target: location.coordinate, zoom: 15, bearing: 0, viewingAngle: 0)
        let marker1 = GMSMarker()
        let currentLocation = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        marker1.position = currentLocation
        //        marker1.title = "Map"
        //        marker1.snippet = "My Location"
        marker1.icon = UIImage(named: "blue dot")
        marker1.map = self.mapView
        self.mapView.clear()

    }
}


extension DriverLocationViewController : LOCATIONSELECT {
    func locationSelect(address: String, latitude: Double, lognitude: Double, title: String) {
        self.locationTextField.text = address
        self.lat = latitude
        self.lng = lognitude
    }
}
