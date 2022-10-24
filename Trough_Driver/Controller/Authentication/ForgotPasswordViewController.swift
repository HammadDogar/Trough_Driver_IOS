//
//  ForgotPasswordViewController.swift
//  Trough_Driver
//
//  Created by Macbook on 24/02/2021.
//

import UIKit
import SVProgressHUD

class ForgotPasswordViewController: UIViewController {

    @IBOutlet weak var textFieldEmail: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func actionForgotPassword(_ sender: UIButton) {
        if !textFieldEmail.isEmailValid(){
            self.simpleAlert(title: "Alert", msg: "Enter Valid Email")
        }
        else{
            self.ForgotPasswordApi()
        }
    }
    
    @IBAction func actionBackButton(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    func ForgotPasswordApi(){
        let params =
            [:
                
//                "email"        : self.textFieldEmail.text!,
//                "userRoleId"        : 3
                
            ] as [String : Any]
        let email:String = self.textFieldEmail.text!
        SVProgressHUD.show()
        print(params)
        let service = Services()
        GCD.async(.Default) {
            service.ForgotpasswordApi(params: params,email: email, userRoleId: 3) { (serviceResponse) in
                SVProgressHUD.dismiss()
                switch serviceResponse.serviceResponseType {
                case .Success :
                    GCD.async(.Main) {
                        if let data = serviceResponse.data {
                            print(data)
                            self.simpleAlert(title: "Success", msg: "Please check Your Email")
                        }
                        else {
                            print("Error Sending Email")
                        }
                    }
                case .Failure :
                    GCD.async(.Main) {
                        print("Error Sending Email")
                    }
                default :
                    GCD.async(.Main) {
                        print("Error Sending Email")                                    }
                }
            }
        }
    }
}
