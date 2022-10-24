//
//  EventDateViewController.swift
//  Trough_Driver
//
//  Created by Imed on 24/09/2021.
//

import UIKit

class EventDateViewController: BaseViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
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

    @IBOutlet weak var eventDate: UITextField!
    @IBOutlet weak var eventTime: UITextField!
    @IBOutlet weak var eventEndTime: UITextField!
    
    var newEventModel = CreateEventViewModel()
    let myPickerView = UIPickerView()
    var currentList:[String] = []
    var activeTextField:UITextField!
    var dateString = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configure()
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
        self.eventDate.inputView = pickerDate
        pickerDate.addTarget(self, action: #selector(dateIsChanged(sender:)), for: .valueChanged)
        
        let pickerTime = UIDatePicker()
        pickerTime.datePickerMode = .time
        pickerTime.locale = Locale.init(identifier: "en_gb")
        
        if #available(iOS 13.4, *) {
            pickerTime.preferredDatePickerStyle = .wheels
        } else {
            // Fallback on earlier versions
        }
        
        self.eventTime.inputView = pickerTime
        pickerTime.addTarget(self, action: #selector(TimeIsChanged(sender:)), for: .valueChanged)
        
        let pickerEndTime = UIDatePicker()
        pickerEndTime.datePickerMode = .time
        pickerEndTime.locale = Locale.init(identifier: "en_gb")
        
        if #available(iOS 13.4, *) {
            pickerEndTime.preferredDatePickerStyle = .wheels
        } else {
            // Fallback on earlier versions
        }
        
        self.eventEndTime.inputView = pickerEndTime
        pickerEndTime.addTarget(self, action: #selector(EndTimeIsChanged(sender:)), for: .valueChanged)
    }
    
    @objc func dateIsChanged(sender: UIDatePicker){
        print("date is selected")
        let convertedDate = sender.date.string(with: .DATE_TIME_FORMAT_ISO8601)
        
        self.dateString = convertedDate
        
        let onlyDate = sender.date.string(with: .DATE_FORMAT_M)
 
        self.eventDate.text = onlyDate
        print("Date: ", convertedDate)
        //        self.newEventModel.EventSlots.startDate = convertedDate
    }
    
    @objc func TimeIsChanged(sender: UIDatePicker){
        print("Time is selected")
        
        let convertedTime = sender.date.string(with: .TIME_FORMAT_24)
        self.eventTime.text = convertedTime
        print("Time: ", convertedTime)
        //        self.newEventModel.EventSlots[0].startTime = convertedTime
        
    }
    
    @objc func EndTimeIsChanged(sender: UIDatePicker){
        print("Time is selected")
        let convertedTime = sender.date.string(with: .TIME_FORMAT_24)
        self.eventEndTime.text = convertedTime
        print("Time: ", convertedTime)
        //        self.newEventModel.EventSlots[0].endTime = convertedTime
    }

    
    @IBAction func actionBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func actionEventDate(_ sender: Any) {
        if eventDate.text == "Select Date"  {
            let onlyDate = Date().string(with: .DATE_FORMAT_M)
            self.eventDate.text = onlyDate
        }
    }
    @IBAction func actionEventTime(_ sender: Any) {
        if eventTime.text == "Select Time"{
            let time = Date().string(with: .TIME_FORMAT_24)
            self.eventTime.text = time
        }
    }
    
    @IBAction func actionEventEndTime(_ sender: Any) {
        if eventEndTime.text == "Select Time"{
            let converted = Date().string(with: .TIME_FORMAT_24)
            self.eventEndTime.text = converted
        }
    }
    @IBAction func actionNExt(_ sender: Any) {

        if #available(iOS 13.0, *) {
            let vc = self.storyboard?.instantiateViewController(identifier: "AddEventViewController") as! AddEventViewController
            
            self.newEventModel.EventSlots.removeAll()
            self.newEventModel.EventSlots.append(NewEventSlotsViewModel(sDate: dateString, sTime: self.eventTime.text!, eTime: self.eventEndTime.text!))
            
            if self.newEventModel.EventSlots[0].startDate == ""{
                simpleAlert(title: "Alert", msg: "Date is Required")
                return
            }
            if self.newEventModel.EventSlots[0].startTime == "Select Time" || self.newEventModel.EventSlots[0].endTime == "Select Time"{
                simpleAlert(title: "Alert", msg: "Time is Required")
                return
            }
           
            vc.newEventModel = self.newEventModel
            
            self.mainContainer.currenController?.pushViewController(vc, animated: true)
        } else {
            // Fallback on earlier versions
        }
    }
}
    
