//
//  AddEventViewController.swift
//  Trough_Driver
//
//  Created by Imed on 24/09/2021.
//

import UIKit
import MapKit
import MobileCoreServices
import GoogleMaps
import CoreLocation
import GooglePlaces

class AddEventViewController: BaseViewController, UITextViewDelegate, LOCATIONEVENTSELECTS   {
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var detailsTextView: UITextView!
    @IBOutlet weak var locationButton: UIButton!
    @IBOutlet weak var eventMapView: GMSMapView!
    @IBOutlet weak var eventMapViewHeight: NSLayoutConstraint!
    @IBOutlet weak var photoButton: UIView!
    @IBOutlet weak var addDateTime: UITextField!
    @IBOutlet weak var dateTimeButton: UIButton!
    @IBOutlet weak var inviteFriendButton: UIButton!
    @IBOutlet weak var inviteTruckButton: UIButton!
    @IBOutlet weak var imageContianerView: UIView!
    @IBOutlet weak var contianerImage: UIImageView!
    @IBOutlet weak var imageContianerViewHeight: NSLayoutConstraint!
    
    var isImageAdded : Bool = false
    var locationManager = CLLocationManager()
    var location:CLLocation!
    var parameters :[String: Any] = [:]
    var truckIDS  : [Int] = []
    var selectedTruck = 0
    let key = "AIzaSyBrMcsZZbYR-LL8bX4BAffCyWMTVlD4gbs"
    var lat:Double = 0.0
    var lng:Double = 0.0
    var newEventModel = CreateEventViewModel()
    
    var invitedfiendlist = [FriendListViewModel]()
    var invitedTruckList = [NearbyTrucksViewModel]()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configure()
        addDateTime.inputView = dateTimePicker.inputView
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
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
        
        self.locationManager.delegate = self
        self.eventMapView.delegate = self
        
        self.newEventModel.EventName = titleTextField.text ?? ""
        self.detailsTextView.delegate = self
        self.detailsTextView.text = "Event Details..."
        self.detailsTextView.textColor = UIColor.lightGray
        self.eventMapView.isHidden = true
        self.eventMapViewHeight.constant = 1
        self.imageContianerView.clipsToBounds = false
        self.imageContianerView.isHidden = true
        self.imageContianerViewHeight.constant = 1
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if self.detailsTextView.textColor == UIColor.lightGray {
            self.detailsTextView.text = ""
            self.detailsTextView.textColor = UIColor.black
        }
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if self.detailsTextView.text == "" {
            self.detailsTextView.text = "Event Details...."
            self.detailsTextView.textColor = UIColor.lightGray
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
            // self.locationManager.requestAlwaysAuthorization()
            self.locationManager.startUpdatingLocation()
            self.locationManager.startMonitoringSignificantLocationChanges()
            self.eventMapView.isMyLocationEnabled = true
            self.eventMapView.mapType = .normal
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
    
    private lazy var dateTimePicker : DateTimePicker = {
        let picker = DateTimePicker()
        picker.setup()
        picker.didSelectDates = { [weak self] (startDate , endDate) in let text = Date.buildTimeRangeString(startDate: startDate, endDate: endDate)
            self?.addDateTime.text = text
        }
        return picker
    }()
    
    @IBAction func actionBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func actionPostEvent(_ sender: UIButton) {
        
        if isImageAdded == false{
            simpleAlert(title: "Alert", msg: "Please add Event Image")
            return
        }
        if self.titleTextField.text  == ""{
            simpleAlert(title: "Alert", msg: "Please add Event name")
            return
        }
//        createEvent()
        uploadImage()
    }
    
    @IBAction func actionAddLocation(_ sender: UIButton) {
        getLocation()
        self.eventMapView.isHidden = false
        self.eventMapViewHeight.constant = 160
    }
    
    func getLocation(){
        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "AddMapViewController") as? AddMapViewController{
//        if let vc = self.storyboard?.instantiateViewController(identifier: "addEventMapViewController") as? addEventMapViewController{
            vc.delegate = self
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }

    @IBAction func actionInviteFriends(_ sender: UIButton) {
        
                if #available(iOS 13.0, *) {
                let vc = self.storyboard?.instantiateViewController(identifier: "AddInviteFriendViewController") as! AddInviteFriendViewController
//                vc.delegate = self
                self.mainContainer.currenController?.pushViewController(vc, animated: true)
            } else {
                // Fallback on earlier versionsr
            }
    }
    
    @IBAction func actionInviiteTruck(_ sender: UIButton) {
                if #available(iOS 13.0, *) {
                let vc = self.storyboard?.instantiateViewController(identifier: "AddTruckViewController") as! AddTruckViewController
                vc.delegate = self
                self.mainContainer.currenController?.pushViewController(vc, animated: true)
            } else {
                // Fallback on earlier versions
            }
    }
    
    @IBAction func actionCamera(_ sender: UIButton) {
        let alert = UIAlertController(title: "", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Choose from Library", style: .default, handler: { (action) in
            self.chooseFromLibrary(presentFrom: sender)
        }))
        alert.addAction(UIAlertAction(title: "Capture", style: .default, handler: { (action) in
            self.capturePhoto(presentFrom: sender)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: .none))
        self.present(alert, animated: true, completion: nil)
    }
    
}
extension AddEventViewController {
    
    func chooseFromLibrary(presentFrom sender: UIButton) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        imagePicker.mediaTypes = [kUTTypeImage as String]
        imagePicker.modalPresentationStyle = .formSheet
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    func capturePhoto(presentFrom sender: UIButton) {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .camera
        imagePicker.mediaTypes = [kUTTypeImage as String]
        imagePicker.delegate = self
        imagePicker.modalPresentationStyle = .formSheet
        self.present(imagePicker, animated: true, completion: nil)
    }
}

extension AddEventViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker:  UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            if let imageData = image.jpegData(compressionQuality: 0.1) {
                self.contianerImage.image = image
//                self.newEventModel.ImageFile = image
                print(self.newEventModel.ImageFile)
                self.isImageAdded = true
                self.imageContianerView.isHidden = false
                self.imageContianerViewHeight.constant = 160
            }
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}

extension AddEventViewController : CLLocationManagerDelegate, GMSMapViewDelegate{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else {
            return
        }
        eventMapView.camera = GMSCameraPosition(target: location.coordinate, zoom: 15, bearing: 0, viewingAngle: 0)
        //        self.mapView.selectedMarker = nil
        self.eventMapView.clear()
    }
    
    func marker(latitude : Double, longitude : Double){
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        marker.isDraggable = true
        marker.map = self.eventMapView
        marker.icon = UIImage(named:  "blue dot")
        let camera = GMSCameraPosition.camera(withLatitude: latitude, longitude: longitude, zoom: 15)
        self.eventMapView?.animate(to: camera)
//        self.eventMapView.selectedMarker = marker
        //        marker(latitude: self.lat, longitude: self.lng)
    }
}
extension AddEventViewController : LOCATIONEVENTSELECT {
    func locationSelect(address: String, latitude: Double, lognitude: Double) {
        
        self.lat = latitude
        self.lng = lognitude
        
        eventMapView.clear()
        marker(latitude: latitude, longitude: lognitude)
        
        self.newEventModel.Latitude     = self.lat
        self.newEventModel.Longitude    = self.lng
        self.newEventModel.Address      = address
        
    }
}

extension AddEventViewController {
    
    
    func uploadImage(){
        if let image = self.contianerImage.image {
            BlobUploadManager.shared.uploadFile(fileData: image.jpegData(compressionQuality: 0.5) ?? Data() , fileName: UUID().uuidString + ".jpg", folder: "Truck") { fileUrl, isCompleted in
                if isCompleted {
                    let urlString = BlobUploadManager.shared.imagesBaseUrl + fileUrl
                    self.createEvent(urlString: urlString)
                }
            }
        }
    }

    
    
    func createEvent(urlString: String){
   
        let slots =  self.newEventModel.EventSlots.map({ $0.toDictionary() })
        
        let params = [
            "EventId"           : self.newEventModel.eventId,
            "EventName"         : self.titleTextField.text ?? "",
            "Description"       : self.detailsTextView.text ?? "",
            "LocationName"      : self.newEventModel.Address,
            //                "Pakistan",
            "Address"           : self.newEventModel.Address,
            "Latitude"          : self.newEventModel.Latitude,
            "Longitude"         : self.newEventModel.Longitude,
            "Type"              : "public",

            "EventSlots"        : slots,
//            "ImageFile"         : self.newEventModel.ImageFile,
            "ImageFile": urlString,

            "TruckIds"          :  self.newEventModel.truckIds,
            "UserIds"               : self.newEventModel.userIds
//            "UserIds"               : "42"
//            "UserIds"               : self.newEventModel.userIds,
        ] as [String : Any]
        let service = EventsServices()
        print(params)
        
        GCD.async(.Main) {
            self.startActivityWithMessage(msg: "")
        }
        GCD.async(.Default) {
            service.postEventRequest(params: params) { (serviceResponse) in
                GCD.async(.Main) {
                    self.stopActivity()
                }
                switch serviceResponse.serviceResponseType {
                case .Success :
                    GCD.async(.Main) {
                        if "Added" == serviceResponse.message {
                            self.mainContainer.currenController?.popToRootViewController(animated: true)
                        }
                        else {
                            print("Event is not created")
                        }
                    }
                case .Failure :
                    GCD.async(.Main) {
                        print("Event is not created")
                    }
                default :
                    GCD.async(.Main) {
                        print("Event is not created")
                    }
                }
            }
        }
    }
}

extension AddEventViewController :  AddTruckViewControllerDelegate    {
    func addTruck(truckID: [NearbyTrucksViewModel]) {
    
        let idArray = truckID.map({ (id: NearbyTrucksViewModel) -> Int in
            id.truckId ?? 0
            
        })
        let array = idArray.map{String($0)}.joined(separator: ",")
        self.newEventModel.truckIds = array
        
        self.invitedTruckList = truckID
        print(truckID)
    }
//    func addTruck(truckID: [Int]) {
//        let array  = truckID.map{String($0)}.joined(separator: ",")
//        self.newEventModel.truckIds = array
//    }
}

extension AddEventViewController : AddInviteFriendViewControllerDelegate{
    func addFriend(friendList: [FriendListViewModel]) {
        let idArray = friendList.map({ (id: FriendListViewModel) -> Int in
            id.userId ?? 0
        })
        let array = idArray.map{String($0)}.joined(separator: ",")
        self.newEventModel.userIds = array
        
        self.invitedfiendlist = friendList
        print(friendList)
    }
    
//    func addFriend(friendID: [Int]) {
//        let array  = friendID.map{String($0)}.joined(separator: ",")
//        self.newEventModel.userIds = array
//    }
}
