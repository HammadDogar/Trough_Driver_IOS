//
//  DaysViewController.swift
//  Trough_Driver
//
//  Created by Macbook on 18/03/2021.
//

import UIKit
import SVProgressHUD
import MobileCoreServices
import Kingfisher

class DaysViewController: BaseViewController {
    
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var hoursView: UIView!
    @IBOutlet weak var popView: UIView!
    @IBOutlet weak var startTimeTextField: UITextField!
    @IBOutlet weak var endTimeTextField: UITextField!
    @IBOutlet weak var switchOnOf: UISwitch!
    @IBOutlet weak var popViewDayLabel: UILabel!
    
    var toTime = Date()
    var fromTime = Date()
    var index : Int = 0
    
    var daysArray = [WorkingHours]()
    var daysArrayForServer =  [[String:Any]]()
    
    var Days = ["Monday","Tuesday","Wednesday","Thursday","Friday","Saturday"]
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        tableview.tableFooterView = UIView()
        self.tableview.backgroundColor  = .white
        setView(hidden: true)
        
        self.configure()
    }
    func configure(){
        
        for _ in 0...5{
            self.daysArray.append(WorkingHours.init(day_id: -1, title: "", fromHours: "", toHours: "", isAvailable: 0))
        }
        
        popView.layer.cornerRadius = 20
        popView.clipsToBounds = true
        
        
    }
    func setView(hidden: Bool) {
        UIView.transition(with: hoursView, duration: 0.5, options: .transitionCrossDissolve, animations: {
            self.hoursView.isHidden = hidden
            
        })
        
        
    }
    
    @IBAction func actionDoneBtn(_ sender: UIButton) {
        var object =  WorkingHours()
        if switchOnOf.isOn
        {
            if endTimeTextField.isTextFieldEmpty() || startTimeTextField.isTextFieldEmpty()
            {
                simpleAlert(title: "Alert", msg: "Fill Empty Field")
                return
            }
//            let fHours = String(describing:convertDateIntoTimeStamp(date: fromTime))
//            let tHours = String(describing:convertDateIntoTimeStamp(date: toTime))
            
            
            let fHours = converDateIntoTime(date: fromTime)
            let tHours = converDateIntoTime(date: toTime)
            daysArray[index] = WorkingHours.init(day_id: index, title: Days[index], fromHours: fHours, toHours: tHours, isAvailable: 1)
//           daysArray[index] = WorkingHours.init(day_id: index, title: Days[index], fromHours: fHours, toHours: tHours, isAvailable: 1)
//            for item in daysArray {
//                daysArrayForServer.append(item.toJson())
//            }
            daysArrayForServer = [daysArray[index].toJson()]

//            daysArrayForServer =
        self.updateTime()
        }
        if switchOnOf.isOn
        {
            object.isAvailable = 1
        }
        else
        {
            object.isAvailable = 0
        }
        setView(hidden: true)
        self.tableview.reloadData()
        
    }
    @IBAction func actionCancelBtn(_ sender: UIButton) {
        
        setView(hidden: true)
    }
    
    
    @IBAction func actionBackbtn(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func actionUpdateBtn(_ sender: UIButton) {
//                self.updateTime()


    }
    
}

extension DaysViewController:UITableViewDataSource,UITableViewDelegate{
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.Days.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? DaysTableViewCell
        cell?.lblDay.text = self.Days[indexPath.row]
        if daysArray[indexPath.row].isAvailable != 0{
            print(indexPath.row)
//            cell?.lblTime.text = String(describing:convertTimeStampToTime(timeStamp: daysArray[index].fromHours)) + " - " +  String(describing:convertTimeStampToTime(timeStamp: daysArray[index].toHours))
            
            let v = daysArray[index].fromHours + "-" + daysArray[index].toHours
            cell?.lblTime.text = v
        }
        else{
            cell?.lblTime.text = "+"
        }
        return cell!
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        index = indexPath.row
        setView(hidden: false)
        self.popViewDayLabel.text = self.Days[indexPath.row]
    }
}
extension DaysViewController:UITextFieldDelegate{
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        if textField.isEqual(endTimeTextField)
        {
            if startTimeTextField.isTextFieldEmpty()
            {
                return false
            }
        }
        
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if textField.isEqual(startTimeTextField)
        {
            endTimeTextField.text = ""
            
        }
        
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .time
        if #available(iOS 13.4, *) {
            datePicker.preferredDatePickerStyle = .wheels
        } else {
            // Fallback on earlier versions
        }
        datePicker.minuteInterval = 15
        
        if textField.isEqual(startTimeTextField)
        {
            
            //From Time Date Picker
            //
            
            self.startTimeTextField.inputView = datePicker
            datePicker.addTarget(self, action: #selector(fromTime(_:)), for: .valueChanged)
        }
        else if textField.isEqual(endTimeTextField)
        {
            
            datePicker.minimumDate = self.fromTime
            
            self.endTimeTextField.inputView = datePicker
            datePicker.addTarget(self, action: #selector(self.toTime(_:)), for: .valueChanged)
            
            //  }
            
            
        }
        
    }
    
    @objc func fromTime(_ sender: UIDatePicker) {
        
        fromTime = sender.date
        
        startTimeTextField.text = converDateIntoTime(date: fromTime)
    }
    
    
    @objc func toTime(_ sender: UIDatePicker) {
        
        toTime = sender.date
        endTimeTextField.text = converDateIntoTime(date: toTime)
          
    }
}

extension DaysViewController {
    
    func updateTime() {
        
//        let params : [String : Any] = [
//            "dayOfWeek" : index,
//            "startTime" : self.startTimeTextField.text ?? "",
//            "endTime"   : self.endTimeTextField.text ?? "",
//            "isActive"  : true
//        ]
//        let params : [[String : Any]] = [[
//            "dayOfWeek" : index,
//            "startTime" : self.startTimeTextField.text ?? "",
//            "endTime"   : self.endTimeTextField.text ?? "",
//            "isActive"  : true
//        ]]
        
        let params = daysArrayForServer
        
        print(params)
        let service = Services()
        GCD.async(.Default) {
            SVProgressHUD.show()
            service.updateWorkingHour(params: params) { (serviceResponse) in
                GCD.async(.Main) {
                    //self.stopActivity()
                    SVProgressHUD.dismiss()
                }
                switch serviceResponse.serviceResponseType {
                case .Success :
                    GCD.async(.Main) {
                        
                        if let data = serviceResponse.data {
                            print(data)
                            print("Time added Successfully")
                        }
                        else {
                            print("Time Not added")
                        }
                    }
                case .Failure :
                    GCD.async(.Main) {
                        print("Failed to Add Time")
                    }
                default :
                    GCD.async(.Main) {
                        print("Failed to Add Time....")
                    }
                }
            }
        }
    }
}
