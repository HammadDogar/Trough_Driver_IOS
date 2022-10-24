//
//  UserProfileViewController.swift
//  Trough_Driver
//
//  Created by Imed on 09/04/2021.
//

import UIKit

class UserProfileViewController: BaseViewController {

    
    @IBOutlet weak var userTitle: UILabel!
    @IBOutlet weak var userNumber: UILabel!
    @IBOutlet weak var userMail: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.setData()
    }
    
    func setData(){
        self.userTitle.text = Global.shared.currentUser.fullName
        self.userNumber.text = Global.shared.currentUser.phone
        self.userMail.text = Global.shared.currentUser.email
    }
    
    
    
    
    @IBAction func actionBack(_ sender: UIButton) {
        
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func editProfiel(_ sender: UIButton) {
        let sb = UIStoryboard(name: "Others", bundle: nil)
        if #available(iOS 13.0, *) {
            let mainVC = sb.instantiateViewController(identifier: "EditProfileViewController") as! EditProfileViewController

            self.navigationController?.pushViewController( mainVC, animated: true)

        } else {
            // Fallback on earlier versions
        }

        
    }
    @IBAction func changePassword(_ sender: UIButton) {
        let sb = UIStoryboard(name: "Others", bundle: nil)
        if #available(iOS 13.0, *) {
            let mainVC = sb.instantiateViewController(identifier: "ChangePasswordViewController") as! ChangePasswordViewController

            self.navigationController?.pushViewController( mainVC, animated: true)

        } else {
            // Fallback on earlier versions
        }
    }
    
    @IBAction func TrcukInfo(_ sender: UIButton) {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        
        if #available(iOS 13.0, *) {
            let vc = sb.instantiateViewController(identifier: "TruckInfoViewController") as! TruckInfoViewController

            self.navigationController?.pushViewController( vc, animated: true)

        } else {
            // Fallback on earlier versions
        }
    }

    @IBAction func actionPayment(_ sender: UIButton) {
        let alert = UIAlertController(title: "", message: "You have to create your stripe account?", preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "Create Account", style: UIAlertAction.Style.default, handler: { (_) in
            self.openDatePickerToCreateStripeAccount()
            print("Create account")
        }))
        
        alert.addAction(UIAlertAction(title: "Add Account", style: UIAlertAction.Style.default, handler: { (_) in
            if let vc = self.storyboard?.instantiateViewController(withIdentifier: "PaymentMethodViewController") as? PaymentMethodViewController{
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: { (_) in
        }))
        self.present(alert, animated: true, completion: nil)
        
    }
    @IBAction func actionAddPaymentMethod(_ sender: UIButton) {
        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "PaymentMethodViewController") as? PaymentMethodViewController{
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func openDatePickerToCreateStripeAccount(){
        let datePickerVC = UIStoryboard.init(name: "Common", bundle: nil).instantiateViewController(withIdentifier: "DatePickerViewController") as! DatePickerViewController
        datePickerVC.modalPresentationStyle = .popover
        datePickerVC.pickerIdentifier = "startDate"
        datePickerVC.maximumDate = Date()
        datePickerVC.delegate = self
        if let popoverPresentationController = datePickerVC.popoverPresentationController {
            popoverPresentationController.permittedArrowDirections = .up
            //                popoverPresentationController.sourceView = sender
            //                popoverPresentationController.sourceRect = sender.bounds
            popoverPresentationController.delegate = self
            self.present(datePickerVC, animated: true, completion: nil)
        }
    }
    
}
extension UserProfileViewController:  DatePickerViewControllerDelegate, UIPopoverPresentationControllerDelegate{
    func didSelectDate(date: Date, pickerIdentifier: String) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
        let dateString = formatter.string(from: date)
        createStripeConnectAccount(dateOfBirth: dateString) { (isValid,message) in
            if isValid{
                if let link = URL(string: message) {
                  UIApplication.shared.open(link)
                }
            }else{
                self.simpleAlert(title: "Failed", msg: message)
            }
        }
    }
    
}

extension UserProfileViewController{
    
    func createStripeConnectAccount(dateOfBirth: String, complete : @escaping((Bool,String)->Void)){

        let params: [String : Any] = ["dateOfBirth": dateOfBirth]
        let service = ModeSelectionService()
        print(params)
        GCD.async(.Main) {
//            self.startActivityWithMessage(msg: "")
        }
        GCD.async(.Default) {
            service.createStripeConnectAccount(params: params) { (serviceResponse) in
                GCD.async(.Main) {
//                    self.stopActivity()
                }
                switch serviceResponse.serviceResponseType {
                case .Success :
                    GCD.async(.Main) {
                        complete(true,serviceResponse.data as! String)
                    }
                case .Failure :
                    GCD.async(.Main) {
                        complete(false,serviceResponse.message)
                    }
                default :
                    GCD.async(.Main) {
                        complete(false,serviceResponse.message)
                    }
                }
            }
        }
    }
    
}
