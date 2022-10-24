//
//  DatePickerViewController.swift
//  Trough_Driver
//
//  Created by Imed on 23/07/2021.
//

import UIKit

protocol DatePickerViewControllerDelegate {
    func didSelectDate(date: Date, pickerIdentifier: String)
    func didSelectInterval(interval: TimeInterval, pickerIdentifier: String)
}

extension DatePickerViewControllerDelegate {
    func didSelectDate(date: Date, pickerIdentifier: String) {}
    func didSelectInterval(interval: TimeInterval, pickerIdentifier: String) {}
}

class DatePickerViewController: UIViewController {

    
    
    @IBOutlet weak var datePicker: UIDatePicker!
    
    
    var delegate: DatePickerViewControllerDelegate?
    var pickerIdentifier: String = ""
    var minimumDate: Date?
    var maximumDate: Date?
    var datePickerMode: UIDatePicker.Mode?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.preferredContentSize = CGSize(width: 320, height: 320 * 1.1)
        setDatePickerSettings()
    }
    func setDatePickerSettings() {
        if let pickerMode = datePickerMode {
            datePicker.datePickerMode = pickerMode
            if pickerMode == .countDownTimer {
//                datePicker.datePickerStyle = UIDatePickerStyle.wheels
            }
        }
        if let date = minimumDate {
            datePicker.minimumDate = date
        }
        if let date = maximumDate {
            datePicker.maximumDate = date
        }
    }
    
    @IBAction func doneAction(_ sender: UIButton) {
        if let datePickerMode = datePickerMode, datePickerMode == .countDownTimer {
            self.delegate?.didSelectInterval(interval: datePicker.countDownDuration, pickerIdentifier: pickerIdentifier)
            self.dismiss(animated: true, completion: nil)
            return
        }
        delegate?.didSelectDate(date: datePicker.date, pickerIdentifier: pickerIdentifier)
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func cancelAction(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
