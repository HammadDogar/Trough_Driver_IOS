//
//  SignUpViewController.swift
//  Trough_Driver
//
//  Created by Imed on 18/02/2021.
//

import UIKit
import SVProgressHUD

class SignUpViewController: BaseViewController,UITextFieldDelegate {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var textFieldFullName: UITextField!
    @IBOutlet weak var textFieldEmail: UITextField!
    @IBOutlet weak var textFieldPhone: UITextField!
    @IBOutlet weak var textFieldPassword: UITextField!
    @IBOutlet weak var textFieldConfirmPassword: UITextField!
    @IBOutlet weak var btnPassword: UIButton!
    @IBOutlet weak var textFieldMapAddress: UITextField!
    @IBOutlet weak var textFieldAddress: UITextField!
    @IBOutlet weak var btnConfirmPassword: UIButton!
    
    @IBOutlet weak var signButton: UIButton!
    @IBOutlet weak var checkButton: UIButton!
    
    @IBOutlet weak var textFieldTruckName: UITextField!
    
    var passwordBtnClick = true
    var confirmPasswordBtnClick = true
    var isProfilePicture = false
    
    var lat:Double = 0.0
    var lng:Double = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.textFieldAddress.isHidden = true
        textFieldMapAddress.delegate = self

    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField.isEqual(textFieldMapAddress){
            
            getLocation()
            
            self.view.endEditing(true)
            return false
        }
        return false
    }
    
    func getLocation(){
        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "mapViewController") as? mapViewController
        {
            
            vc.delegate = self
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    

    @IBAction func loginAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func actionUploadImage(_ sender: UIButton) {
        
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
    
    @IBAction func actionBtnPassword(_ sender: UIButton) {
        if passwordBtnClick == true{
            passwordBtnClick = false
                    textFieldPassword.isSecureTextEntry = false
            btnPassword.setImage(UIImage(named: "showPassword"), for: .normal)

                }
                else{
                    passwordBtnClick = true
                    textFieldPassword.isSecureTextEntry = true
                    btnPassword.setImage(UIImage(named: "hidePassword"), for: .normal)
                }
    }
    @IBAction func actionConfirmPassword(_ sender: UIButton) {
        if confirmPasswordBtnClick == true{
            confirmPasswordBtnClick = false
                    textFieldConfirmPassword.isSecureTextEntry = false
            btnConfirmPassword.setImage(UIImage(named: "showPassword"), for: .normal)
                    
                }
                else{
                    confirmPasswordBtnClick = true
                    textFieldConfirmPassword.isSecureTextEntry = true
                    btnConfirmPassword.setImage(UIImage(named: "hidePassword"), for: .normal)
                }

    }
    
    
    @IBAction func actionCheckBox(_ sender: UIButton) {
        
        if sender.isSelected{
            sender.isSelected = false
            self.signButton.tintColor = #colorLiteral(red: 0.9511117339, green: 0.7289424539, blue: 0.2410626411, alpha: 1)
        } else{
            sender.isSelected = true
//            self.signButton.tintColor = #colorLiteral(red: 0.9511117339, green: 0.7289424539, blue: 0.2410626411, alpha: 1)
        }
    }
    
    
    @IBAction func actionSignUp(_ sender: UIButton) {
        
        if isAllValidationWorks(){
            self.uploadImage()
        }
        else{
            print("Validation not Passed")
        }
    }
    
    func isAllValidationWorks()->Bool{
        
        if !isProfilePicture{
            self.simpleAlert(title: "Alert", msg: "Add Profile Picture")
            return false
        }
        
        if textFieldFullName.isTextFieldEmpty(){
            self.simpleAlert(title: "Alert", msg: "Name field is empty!")
            return false
        }
        if textFieldTruckName.isTextFieldEmpty(){
            self.simpleAlert(title: "Alert", msg: "Truck Name field is empty!")
            return false
        }
        
        if !textFieldEmail.isEmailValid(){
            self.simpleAlert(title: "Alert", msg: "Enter Valid Email")
            return false
        }
        if textFieldPhone.text?.count ?? 0 < 8{
            self.simpleAlert(title: "Alert", msg: "Phone must be atleast 8 character long")
            
            return false
        }
        if textFieldMapAddress.isTextFieldEmpty(){
            self.simpleAlert(title: "Alert", msg: "Add address from map")
            return false
        }
        
//        if textFieldAddress.isTextFieldEmpty(){
//            self.simpleAlert(title: "Alert", msg: "Add address field is empty")
//            return false
//        }
        
//        if !(textFieldPassword.text?.isStrongPassword ?? false) {
//            self.simpleAlert(title: "Alert", msg: "Password must have 8 characters long including uppercase, lowercase, digits and special character")
//            return false
//        }
        
        if !textFieldPassword.isPasswordTextFieldValid(){
            self.simpleAlert(title: "Alert", msg: "Password must have 8 characters long including uppercase, lowercase, digits and special character")
            return false
        }
        if !textFieldConfirmPassword.isPasswordTextFieldValid(){
            self.simpleAlert(title: "Alert", msg: "Comfirm Password must have 8 characters long including uppercase, lowercase, digits and special character")
            return false
        }
        
        
        if textFieldPassword.text != textFieldConfirmPassword.text{
            self.simpleAlert(title: "Alert", msg: "Password not Matched")
            return false
        }
        if !checkButton.isSelected{
            self.simpleAlert(title: "Alert", msg: "Confirm Terms & Condition")
            return false
        }
        return true
    }
    
    
    @IBAction func actionPrivacy(_ sender: UIButton) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "PrivacyViewController") as? PrivacyViewController{
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    
    @IBAction func actionTerms(_ sender: UIButton) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "TermsViewController") as? TermsViewController{
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}


extension SignUpViewController{
    func chooseFromLibrary(presentFrom sender: UIButton) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        imagePicker.modalPresentationStyle = .formSheet
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    func capturePhoto(presentFrom sender: UIButton) {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .camera
        imagePicker.delegate = self
        imagePicker.modalPresentationStyle = .formSheet
        self.present(imagePicker, animated: true, completion: nil)
    }
    

}

extension SignUpViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
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
extension SignUpViewController : LOCATIONSELECT
{
    func locationSelect(address: String, latitude: Double, lognitude: Double, title: String) {
        self.textFieldMapAddress.text = address
        
        self.lat = latitude
        self.lng = lognitude
    }
   
    
}

extension SignUpViewController{
    
    func uploadImage(){
        if let image = self.profileImageView.image {
            BlobUploadManager.shared.uploadFile(fileData: image.jpegData(compressionQuality: 0.5) ?? Data() , fileName: UUID().uuidString + ".jpg", folder: "Truck") { fileUrl, isCompleted in
                if isCompleted {
                    let urlString = BlobUploadManager.shared.imagesBaseUrl + fileUrl
                    self.userResgister(urlString: urlString)
                }
            }
        }
    }
    
    func userResgister(urlString : String){
        //Call Register Api
        let parameter: [String:Any] = [
            "Name": textFieldTruckName.text,
//                                           "Address":textFieldAddress.text!,
                                       "Address":textFieldMapAddress.text!,
                                       "FullName":textFieldFullName.text!,
                                       "PermanentLatitude":self.lat,
                                       "PermanentLongitude":self.lng,
                                       "Phone":textFieldPhone.text!,
                                        "ProfileFile": urlString,
                                       "Email":self.textFieldEmail.text!,
                                       "Password":self.textFieldPassword.text!,
                                       "DeviceTypeId":12,
                                       "FcmDeviceToken":UserDefaults.standard.string(forKey: "FCMToken") ?? ""
                                       ]
        print(textFieldMapAddress.text as Any)
        print(parameter)
        let service = UserServices()
        GCD.async(.Default) {
            SVProgressHUD.show()
            service.userRegistrationRequest(params: parameter) { (serviceResponse) in
                GCD.async(.Main) {
                    //self.stopActivity()
                    SVProgressHUD.dismiss()
                }
                switch serviceResponse.serviceResponseType {
                case .Success :
                    GCD.async(.Main) {
                        if let user = serviceResponse.data as? UserViewModel {
                            Global.shared.currentUser = user
                            Global.shared.saveLoginUserData()
                            if user.isActive ?? false {
                                Global.shared.headerToken = user.token ?? ""
                                self.moveToHome()
                            }else{
                                self.simpleAlert(title: "Access denied", msg: "Please contact app administrator")
                            }
                        }else {
                            
                            let alert = UIAlertController(title: "Alert", message: "Resgitered Successfully!", preferredStyle: UIAlertController.Style.alert)

                            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
                                
                                self.navigationController?.popViewController(animated: true)
                                
                            }))

                            
                            self.present(alert, animated: true, completion: nil)
                            
                        //print("User email already exists!")
                    }
                }
                case .Failure :
                    GCD.async(.Main) {
                        print("User failed to Register")
                    }
                default :
                    GCD.async(.Main) {
                        print("User failed to Register")
                    }
                }
            }
        }

    }
}
