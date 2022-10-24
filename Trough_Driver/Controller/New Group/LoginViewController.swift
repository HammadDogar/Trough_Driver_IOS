//
//  LoginViewController.swift
//  Trough_Driver
//
//  Created by Imed on 17/02/2021.
//

import UIKit
import SVProgressHUD

class LoginViewController: BaseViewController {
    @IBOutlet weak var textFieldEmail: UITextField!
    @IBOutlet weak var textFieldPassword: UITextField!
    @IBOutlet weak var buttonPassword: UIButton!
    
    var passwordButtonClick = true
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        textFieldPassword.clearsOnBeginEditing = false
        self.textFieldEmail.text = UserDefaults.standard.value(forKey: "email") as? String ?? ""

        Global.shared.loadLoginUserData()
        
        
        GCD.async(.Main, delay: 0.3) {
            
            if Global.shared.currentUser.userId != nil{
                Global.shared.headerToken = Global.shared.currentUser.token!
                self.textFieldEmail.text = UserDefaults.standard.value(forKey: "email") as? String ?? ""

//                self.emailTextField.text = "name1@gmail.com"
//                self.passwordTextField.text = "asdasd"
//                self.moveToHome()
            }else{
                self.textFieldEmail.text = UserDefaults.standard.value(forKey: "email") as? String ?? ""

//                self.emailTextField.text = "name1@gmail.com"
//                self.passwordTextField.text = "asdasd"
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }
    
    @IBAction func actionSignUp(_ sender: UIButton) {
        
        if let vc = storyboard?.instantiateViewController(withIdentifier: "SignUpViewController") as? SignUpViewController{
            self.navigationController?.pushViewController(vc, animated: true)
            
        }
    }
    
    @IBAction func actionBtnPassword(_ sender: UIButton) {
        
        if passwordButtonClick == true{
            passwordButtonClick = false
                    textFieldPassword.isSecureTextEntry = false
            buttonPassword.setImage(UIImage(named: "hidePassword"), for: .normal)
                    
                }
                else{
                    passwordButtonClick = true
                    textFieldPassword.isSecureTextEntry = true
                    buttonPassword.setImage(UIImage(named: "showPassword"), for: .normal)
                }
        
    }
    
    
    

    @IBAction func actionSignIn(_ sender: UIButton) {
        
        
        if textFieldEmail.isTextFieldEmpty() || textFieldPassword.isTextFieldEmpty(){
            print("Fill Empty Field")
            self.simpleAlert(title: "Alert", msg: "Fill Empty Field")
            return
        }
        else{
            //SignInRequest()
            SignIn()
        }
        
    }
    
    @IBAction func actionForgotPassword(_ sender: UIButton) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "ForgotPasswordViewController") as? ForgotPasswordViewController{
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    func SignInRequest(){
        
        let params: [String:Any] = ["email": textFieldEmail.text!,
                                    "password": textFieldPassword.text!,
                                    "fcmDeviceToken":UserDefaults.standard.string(forKey: "FCMToken") ?? "",
                                    "deviceTypeId":12
                                     ]
        let service = UserServices()
        GCD.async(.Default) {
            SVProgressHUD.show()
            service.userLoginRequest(params: params) { (serviceResponse) in
                GCD.async(.Main) {
                    SVProgressHUD.dismiss()
                }
                switch serviceResponse.serviceResponseType {
                case .Success :
                    GCD.async(.Main) {
                        if let user = serviceResponse.data as? UserViewModel {
                            Global.shared.currentUser = user
                            Global.shared.saveLoginUserData()
                            if user.isActive ?? false {
                                self.moveToHome()
                            }else{
                                self.simpleAlert(title: "Access denied", msg: "Please contact app administrator")
                            }
                        }
                        else {
                            print("User email already exists!")
                        }
                    }
                case .Failure :
                    GCD.async(.Main) {
                        print("Failed1")
                        print("User failed to Login")
                    }
                default :
                    GCD.async(.Main) {
                        print("Failed2")
                        print("User failed to Login")
                    }
                }
            }
        }
        
    }
    func SignIn(){
        let params: [String:Any] = ["email": textFieldEmail.text!,
                                    "password": textFieldPassword.text!,
                                    "fcmDeviceToken":UserDefaults.standard.string(forKey: "FCMToken") ?? "",
                                    "deviceTypeId":12
                                     ]
        self.view.isUserInteractionEnabled = false
        print(params)
        ApiManager.sharedInstance.loginApiCall(params: params, url: LOGIN_API, method: POST_METHOD) { (response) in
            self.view.isUserInteractionEnabled = true
            GCD.async(.Main){
            switch response{
                case .success(let user):
                    Global.shared.currentUser = user.data!
                    Global.shared.saveLoginUserData()
                    Global.shared.headerToken = user.data?.token ?? ""
                    print("Header Token: \(Global.shared.headerToken)")
                    let defaults = UserDefaults.standard
                    defaults.setValue(self.textFieldEmail.text!, forKey: "email")
                    self.moveToHome()
                case .failure(let error):
                    print(error.localizedDescription)
                    self.simpleAlert(title: "Alert", msg: error.localizedDescription)
                }
            }
            
        } completionString: { (error) in
            self.view.isUserInteractionEnabled = true
            self.simpleAlert(title: "Alert", msg: error)
        }

    }
}
