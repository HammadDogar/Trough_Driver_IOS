//
//  EditedViewController.swift
//  Trough_Driver
//
//  Created by Imed on 27/09/2021.
//

import UIKit
import GoogleMaps
import CoreLocation
import MobileCoreServices

protocol EditEventViewDelegate {
    func didEdit(tapped : Bool)
}

class EditEventViewController: BaseViewController, UITextViewDelegate {

    @IBOutlet weak var eventDateTextField: UITextField!
    @IBOutlet weak var startTimeTextField: UITextField!
    @IBOutlet weak var endTimeTextField: UITextField!
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var eventTitleTextField: UITextField!
    @IBOutlet weak var eventDetailsTextView: UITextView!
    @IBOutlet weak var btnCameraImage: UIButton!
    @IBOutlet weak var eventImageView: UIImageView!
    
    let myPickerView = UIPickerView()
    var currentList:[String] = []
    var activeTextField:UITextField!
    var newEventModel = EventViewModel()
    var newEventViewModel = CreateEventViewModel()
    var dateString = ""
   
    var isImageAdded : Bool = false
    var isCreateNew = false
    
    var parameters :[String: Any] = [:]
    var firstCellVisible = false
    var eventId:Int = -1
    var index = -1
    var myEvent: EventViewModel?
    var getUser = [GetUserViewModel]()
    var selectionArray = [Int]()

    var tapped = true
    
    var delegateEdit : EditEventViewDelegate?
    var lat:Double = 0.0
    var lng:Double = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addressTextField.delegate = self
        self.configure()
        self.mapping(event: newEventModel)
//        print(mapping(event: newEventModel))

    }
    override func viewWillAppear(_ animated: Bool) {
        self.addressTextField.delegate = self
        self.navigationController?.isNavigationBarHidden = true

    }
    func mapping(event: EventViewModel){
        self.eventId = event.eventId ?? -1
        self.myEvent = event
        
        self.eventTitleTextField.text = "\(event.eventName ?? "")"
        self.eventDetailsTextView.text = "\(event.description ?? "")"
        let eventStartDate = event.eventSlots?.first?.startDate?.date(with: .DATE_TIME_FORMAT_ISO8601)
        self.eventDateTextField.text = "\(eventStartDate?.string(with: .custom("MMMM-dd-yyyy")) ?? "")"
        self.addressTextField.text = "\(event.address ?? "")"
//        let startTime = "\(event.eventSlots?.first?.startTime?.hours ?? 0) : \(event.eventSlots?.first?.startTime?.minutes ?? 0)".timeConversion12()
//        let endTime = "\(event.eventSlots?.first?.endTime?.hours ?? 0) : \(event.eventSlots?.first?.endTime?.minutes ?? 0)".timeConversion12()
        
        self.startTimeTextField.text =  "\(event.eventSlots?.first?.startTime ?? "")"
//            "\(event.eventSlots?.first?.startTime ?? "") : \(event.eventSlots?.first?.startTime ?? "")".timeConversion12()
        
//        event.eventSlots?.first?.startTime?.timeConversion12()
        self.endTimeTextField.text = "\(event.eventSlots?.first?.endTime ?? "")"
//            "\(event.eventSlots?.first?.endTime?.hours ?? 0) : \(event.eventSlots?.first?.endTime?.minutes ?? 0)".timeConversion12()
        
//            event.eventSlots?.first?.endTime?.timeConversion12()
//
//         if event.imageUrl != "" && event.imageUrl != nil{
//             let url = URL(string: BASE_URL+event.imageUrl!) ?? URL.init(string: "https://www.google.com")!
//             self.eventImageView.setImage(url: url)
//         }else{ }
        
        if event.imageUrl != "" && event.imageUrl != nil{
            if let url = URL(string: event.imageUrl! ) {
                DispatchQueue.main.async {
                    self.eventImageView.setImage(url: url)
                }
            }
        }else{
            
        }

    }
    
    func configure(){

        self.myPickerView.delegate = self
        self.myPickerView.dataSource = self
        
        let pickerDate = UIDatePicker()
        pickerDate.datePickerMode = .date
        pickerDate.minimumDate = Date()
        if #available(iOS 13.4, *) {
            pickerDate.preferredDatePickerStyle = .wheels
        } else {
            // Fallback on earlier versions
        }
        self.eventDateTextField.inputView = pickerDate
        pickerDate.addTarget(self, action: #selector(dateIsChanged(sender:)), for: .valueChanged)
        
        let pickerTime = UIDatePicker()
        pickerTime.datePickerMode = .time
        pickerTime.locale = Locale.init(identifier: "en_gb")
        
        if #available(iOS 13.4, *) {
            pickerTime.preferredDatePickerStyle = .wheels
        } else {
            // Fallback on earlier versions
        }
        self.startTimeTextField.inputView = pickerTime
        pickerTime.addTarget(self, action: #selector(TimeIsChanged(sender:)), for: .valueChanged)
        
        let pickerEndTime = UIDatePicker()
        pickerEndTime.datePickerMode = .time
        pickerEndTime.locale = Locale.init(identifier: "en_gb")
        
        if #available(iOS 13.4, *) {
            pickerEndTime.preferredDatePickerStyle = .wheels
        } else {
            // Fallback on earlier versions
        }
        self.endTimeTextField.inputView = pickerEndTime
        pickerEndTime.addTarget(self, action: #selector(EndTimeIsChanged(sender:)), for: .valueChanged)
        
//        self.imageContainView.clipsToBounds = false
        self.eventDetailsTextView.delegate = self
        self.eventDetailsTextView.text = "Event Details..."
        self.eventDetailsTextView.textColor = UIColor.lightGray
    }
    @objc func dateIsChanged(sender: UIDatePicker){
        print("date is selected")
        let convertedDate = sender.date.string(with: .DATE_TIME_FORMAT_ISO8601)
        self.dateString = convertedDate
        let onlyDate = sender.date.string(with: .DATE_FORMAT_M)
        self.eventDateTextField.text = onlyDate
        print("Date: ", convertedDate)
    }
    @objc func TimeIsChanged(sender: UIDatePicker){
        print("Time is selected")
        let convertedTime = sender.date.string(with: .TIME_FORMAT_24)
        self.startTimeTextField.text = convertedTime
        print("Time: ", convertedTime)
    }
    @objc func EndTimeIsChanged(sender: UIDatePicker){
        print("Time is selected")
        let convertedTime = sender.date.string(with: .TIME_FORMAT_24)
        self.endTimeTextField.text = convertedTime
        print("Time: ", convertedTime)
    }
    func textViewDidBeginEditing(_ textView: UITextView) {
        if self.eventDetailsTextView.textColor == UIColor.lightGray {
            self.eventDetailsTextView.text = ""
            self.eventDetailsTextView.textColor = UIColor.black
        }
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if self.eventDetailsTextView.text == "" {
            self.eventDetailsTextView.text = "Placeholder text ..."
            self.eventDetailsTextView.textColor = UIColor.lightGray
        }
    }
    @IBAction func actionBAck(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func enterDate(_ sender: Any) {
        if eventDateTextField.text == "Select Date" {
        let onlyDate = Date().string(with: .DATE_FORMAT_M)
            self.eventDateTextField.text = onlyDate
        }
    }
    @IBAction func actionImage(_ sender: UIButton) {
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
    
    
    @IBAction func actionSave(_ sender: UIButton) {
        
        self.newEventModel.eventType = "public"
//        delegateEdit?.didEdit(tapped: tapped)
        self.editEvent()
    }
    
}

extension EditEventViewController : UITextFieldDelegate,LOCATIONEVENTSELECT{
    func locationSelect(address: String, latitude: Double, lognitude: Double) {
        self.addressTextField.text = address
        self.lat = latitude
        self.lng = lognitude
    }
func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
    self.activeTextField = textField
    
    if textField.isEqual(addressTextField){
        getLocation()
        self.view.endEditing(true)
        return false
    }
    self.myPickerView.reloadAllComponents()
    self.myPickerView.selectRow(0, inComponent: 0, animated: true)
    return true
}
func getLocation(){
    if let vc = self.storyboard?.instantiateViewController(withIdentifier: "addEventMapViewController") as? addEventMapViewController
    {
        vc.delegate = self
        self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
extension EditEventViewController:UIPickerViewDelegate,UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.currentList.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.currentList[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
    }
}
extension EditEventViewController{
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
extension EditEventViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    func imagePickerController(_ picker:  UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            if let imageData = image.jpegData(compressionQuality: 0.1) {
                self.eventImageView.image = image
                self.newEventViewModel.ImageFile = image
                self.isImageAdded = true
            }
        }
        picker.dismiss(animated: true, completion: nil)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
extension EditEventViewController{
    func editEvent(){
        let eventModel = CreateEventViewModel()
        eventModel.EventSlots.removeAll()
        eventModel.EventSlots.append(NewEventSlotsViewModel(sDate: self.eventDateTextField.text ?? "", sTime: self.startTimeTextField.text ?? "", eTime: self.endTimeTextField.text ?? ""))
        let encoder = JSONEncoder()
        let data = try! encoder.encode(eventModel.EventSlots)
        let slots = String(data: data, encoding: .utf8)!
        do {
            if let jsonArray = try JSONSerialization.jsonObject(with: data, options : [.allowFragments]) as? [String:AnyObject]
            {
               print(jsonArray) // use the json here
            } else {
                print("bad json")
            }
        } catch let error as NSError {
            print(error)
        }
        let params = [
            "EventId"           : self.newEventModel.eventId ?? 0,
            "EventName"         : self.eventTitleTextField.text ?? "",
            "Description"       : self.eventDetailsTextView.text ?? "",
            "LocationName"      : self.addressTextField.text ?? "",
            "Address"           : self.addressTextField.text ?? "",
            "Type"              : self.newEventModel.eventType,
            "EventSlots"        : slots,
            "ImageUrl"         : self.newEventModel.imageUrl ?? "",
            "ImageFile"        : self.eventImageView.image ?? UIImage(),
            "Latitude"          : self.newEventModel.Latitude,
            "Longitude"         : self.newEventModel.Longitude
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
                        self.delegateEdit?.didEdit(tapped: self.tapped)
                        self.navigationController?.popViewController(animated: true)
                }
                case .Failure :
                    GCD.async(.Main) {
                        print("Event is not Saved")
                    }
                default :
                    GCD.async(.Main) {
                        print("Event is not Saved")
                    }
                }
            }
        }
    }
}
