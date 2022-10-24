//
//  TruckInfoViewController.swift
//  Trough_Driver
//
//  Created by Imed on 23/03/2021.
//

import UIKit
import SVProgressHUD
import MobileCoreServices
import Kingfisher
import GoogleMaps
import CoreLocation

class TruckInfoViewController: BaseViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate,UITextViewDelegate, UITextFieldDelegate{
    
    var isProfilePicture = false
    
    @IBOutlet weak var textFieldName: UITextField!
    @IBOutlet weak var textFieldTime: UITextField!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var textFieldAddress: UITextField!
    @IBOutlet weak var textFieldDescription: UITextView!
    @IBOutlet weak var totalDistanceLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var collectionViewContainer: UIView!
    @IBOutlet weak var collectionViewContainerHeight: NSLayoutConstraint!
    @IBOutlet weak var collectionViewHeight: NSLayoutConstraint!
    @IBOutlet weak var mapView: GMSMapView!
    
    
    var lat:Double = 0.0
    var lng:Double = 0.0
    
    var locationManager = CLLocationManager()
    var location:CLLocation!
    
    //    var truckID = [UserViewModel]()
    var truckInfo:  [GetTruckInfoModel] = []
    var updateTruckInfo = [UpdateTruckInfoModel]()
    
    
    
    var categoryObj : GetTruckInfoModel?
    var selectionArray = [Int]()
    var stringArray = String()
    
    
    
    var id = 0
    var evntId = 0

    var nearByList = [NearbyTrucksViewModel]()
    var near :  NearbyTrucksViewModel?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        eventMapping(data: near!)
        self.collectionView.register(UINib(nibName: "TruckCategoryCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "TruckCategoryCollectionViewCell")
        textFieldName.sizeToFit()
        textFieldDescription.delegate = self
        textFieldAddress.delegate = self
        textFieldDescription.text = "Write About US-(Truck Infomation) Here"
        textFieldDescription.textColor = UIColor.lightGray
        self.getTruckInfo()
        collectionView.reloadData()
    }
    

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.isNavigationBarHidden = true
        self.askPermission()
    }
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField.isEqual(textFieldAddress){
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

    
    
    
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textFieldDescription.textColor == UIColor.lightGray {
            textFieldDescription.text = nil
            textFieldDescription.textColor = UIColor.black
        }
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if textFieldDescription.text.isEmpty {
            textFieldDescription.text = "Write About US(Truck Infomation) Here"
            textFieldDescription.textColor = UIColor.lightGray
        }
    }
    
    
    func eventMapping(data : NearbyTrucksViewModel){
        self.id = data.truckId ?? -1
        self.near = data
        
        self.textFieldName.text = "\(data.name)"
        
        self.textFieldAddress.text = "\(data.address)"
        self.textFieldDescription.text = "\(data.description)"
        
//        if data.bannerUrl != "" && data.bannerUrl != nil{
//            let url = URL(string: BASE_URL+data.bannerUrl!) ?? URL.init(string: "https://www.google.com")!
//            self.profileImageView.setImage(url: url)
//        }
//        else{}
        
        if data.bannerUrl != "" && data.bannerUrl != nil{
            if let url = URL(string: data.bannerUrl ?? "") {
                DispatchQueue.main.async {
                    self.profileImageView.setImage(url: url)
                }
            }
        }else{}
        
    }
    
    
    @IBAction func backButton(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func actionCamera(_ sender: UIButton){
        
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
    
    @IBAction func actionNotification(_ sender: UIButton) {
        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "NotificationViewController") as? NotificationViewController{
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    @IBAction func actionAddTime(_ sender: UIButton) {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        if #available(iOS 13.0, *) {
            let mainVC = sb.instantiateViewController(identifier: "DaysViewController") as! DaysViewController
            self.navigationController?.pushViewController( mainVC, animated: true)
            
        } else {
            // Fallback on earlier versions
        }
    }
    
    
    
    @IBAction func actionFoodCategory(_ sender: UIButton) {
        let vc =  UIStoryboard.init(name: StoryBoard.Main.rawValue, bundle: nil) .instantiateViewController(withIdentifier:"CategoryViewController") as! CategoryViewController
        vc.delegate = self
        self.mainContainer.currenController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func actionSavebtn(_ sender: UIButton) {
        
        if isAllValidationWorks(){
            self.uploadImage()
        }
        else{
            print("Validation not Passed")
        }
    }
    
    func isAllValidationWorks()->Bool{
        
        if self.profileImageView.image == nil{
            self.simpleAlert(title: "Alert", msg: "Select  Image")
            return false
        }
        
        if textFieldName.isTextFieldEmpty(){
            self.simpleAlert(title: "Alert", msg: "Name field is empty!")
            return false
        }
        
        return true
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
}

extension TruckInfoViewController {
    
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

extension TruckInfoViewController {
    
    func imagePickerController(_ picker:  UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            if let imageData = image.jpegData(compressionQuality: 0.1) {
                self.profileImageView.image = image
                self.isProfilePicture = true
            }
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}


extension TruckInfoViewController {
    
    func getTruckInfo(){
        
        var params: [String:Any] = [String:Any]()
        
        params =
            [:] as [String : Any]
        let service = Services()
        SVProgressHUD.show()

        GCD.async(.Main) {
        }
        GCD.async(.Default) {
            service.GetTruckInfomation(params: params) { (serviceResponse) in
                GCD.async(.Main) {
                }
                switch serviceResponse.serviceResponseType {
                case .Success :
                    GCD.async(.Main) { [self] in
                        if let info = serviceResponse.data as? [GetTruckInfoModel] {
                            self.truckInfo = info
                            collectionView.reloadData()
                            
                            //                            let currentDate = Date()
                            //                            let formatter = DateFormatter()
                            //                            formatter.dateStyle = .medium
                            //
                            //                            let dateString = formatter.string(from: currentDate)
                            //                            self.textFieldTime.text = dateString
                            let date = Date()
                            let dateFormatter = DateFormatter()
                            dateFormatter.dateFormat = "EEEE"
                            let dayInWeek = dateFormatter.string(from: date)
                            self.textFieldTime.text = dayInWeek
                            
                            let dateVarible = info[0].workHours?.count ?? 0
                            print(dateVarible)
                            
                            self.textFieldName.text = info[0].name
                            self.textFieldAddress.text = info[0].address
                            self.textFieldDescription.text = info[0].description
                            
//                            if info[0].bannerUrl != "" && info[0].bannerUrl != nil{
//                                let url = URL(string: BASE_URL+info[0].bannerUrl!) ?? URL.init(string: "https://www.google.com")!
//                                self.profileImageView.setImage(url: url)
//                            }
//                            else{
//                                
//                            }
                            
                            if info[0].bannerUrl != "" && info[0].bannerUrl != nil{
                                if let url = URL(string: info[0].bannerUrl ?? "") {
                                    DispatchQueue.main.async {
                                        self.profileImageView.setImage(url: url)
                                    }
                                }
                            }else{}
                            
                            
                            
                            print("")
                            print(info)
                            print("---")
                            SVProgressHUD.dismiss()

                        }
                        else {
                            print("No Item Found!")
                        }
                    }
                case .Failure :
                    GCD.async(.Main) {
                        print("No Item Found")
                    }
                default :
                    GCD.async(.Main) {
                        print("No Item Found!!")
                    }
                }
            }
        }
    }
}

extension TruckInfoViewController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if self.truckInfo.count > 0 {
            if self.truckInfo[0].truckCategories != nil{
                //                self.collectionView.backgroundColor = .brown
                self.collectionView.isHidden = false
                self.collectionViewContainer.isHidden = false
                self.collectionViewContainerHeight?.constant = 180
                return self.truckInfo[0].truckCategories?.count ?? 0
            }
            return self.truckInfo[0].truckCategories?.count ?? 0
        }else {
            self.collectionViewContainer.isHidden = true
            self.collectionView.isHidden = true
            self.collectionViewContainerHeight.constant = 1
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TruckCategoryCollectionViewCell", for: indexPath) as! TruckCategoryCollectionViewCell
        cell.truckCategoryNameLabel.text = self.truckInfo[0].truckCategories?[indexPath.row].name
        
//        if self.truckInfo[0].truckCategories?[indexPath.row].imageUrl != "" && self.truckInfo[0].truckCategories?[indexPath.row].imageUrl != nil{
//            let url = URL(string: BASE_URL+(self.truckInfo[0].truckCategories?[indexPath.row].imageUrl!)!) ?? URL.init(string: "https://www.google.com")!
//            cell.truckCategoryImageView?.setImage(url: url)
//        }else{
//
//        }
        
        if self.truckInfo[0].truckCategories?[indexPath.row].imageUrl != "" && self.truckInfo[0].truckCategories?[indexPath.row].imageUrl != nil{
            if let url = URL(string: self.truckInfo[0].truckCategories?[indexPath.row].imageUrl! ?? "") {
                DispatchQueue.main.async {
                    cell.truckCategoryImageView.setImage(url: url)
                }
            }
        }else{
               
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 150, height: 150.0)
    }
    
}

extension TruckInfoViewController : CategoryViewDelegate{
    func didSelectCategory(categoryID: [Int]) {
        self.selectionArray = categoryID
        print(selectionArray)
        let formattedArray = (selectionArray.map{String($0)}).joined(separator: ",")
        self.stringArray = formattedArray
        print(stringArray)
    }
    
}


//MARK:- Location Delegate
extension TruckInfoViewController: GMSMapViewDelegate,CLLocationManagerDelegate{
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
//                marker1.title = "Map"
//                marker1.snippet = "My Location"
        marker1.icon = UIImage(named: "blue dot")
        marker1.map = self.mapView
        self.mapView.clear()

    }
}


extension TruckInfoViewController : LOCATIONSELECT {
    func locationSelect(address: String, latitude: Double, lognitude: Double, title: String) {
        self.textFieldAddress.text = address
        self.lat = latitude
        self.lng = lognitude
    }
}


extension TruckInfoViewController{
    
    func uploadImage(){
        if let image = self.profileImageView.image {
            BlobUploadManager.shared.uploadFile(fileData: image.jpegData(compressionQuality: 0.5) ?? Data() , fileName: UUID().uuidString + ".jpg", folder: "User") { fileUrl, isCompleted in
                if isCompleted {
                    let urlString = BlobUploadManager.shared.imagesBaseUrl + fileUrl
                    self.saveInfo(urlString: urlString)
                }
            }
        }
    }
    
    func saveInfo(urlString: String){
        let params: [String:Any] = [
            "Name":self.textFieldName.text!,
            "Address":self.textFieldAddress.text!,
            "Description":self.textFieldDescription.text!,
            "File": urlString,
            "PermanentLatitude":self.lat,
            "PermanentLongitude":self.lng,
            "CategoryIds" : self.stringArray
            //                    self.selectionArray
        ]
        print(params)
        let service = Services()
        GCD.async(.Default) {
            SVProgressHUD.show()
            service.updateTruckInfo(params: params) { (serviceResponse) in
                GCD.async(.Main) {
                    //self.stopActivity()
                    SVProgressHUD.dismiss()
                }
                switch serviceResponse.serviceResponseType {
                case .Success :
                    GCD.async(.Main) {
                        if let data = serviceResponse.data {
                            print(data)
                            self.simpleAlert(title: "Alert!", msg: "Truck Info Updated Successfully")
                        }
                        else {
                            self.simpleAlert(title: "Alert!", msg: "Error Updating Truck Info")
                        }
                    }
                case .Failure :
                    GCD.async(.Main) {
                        print("Failed to Update")
                    }
                default :
                    GCD.async(.Main) {
                        print("Failed to Update")
                    }
                }
            }
        }
        
    }
    
    
}
