//
//  MenuDetailViewController.swift
//  Trough_Driver
//
//  Created by Imed on 26/03/2021.
//

import UIKit
import MobileCoreServices
import SVProgressHUD
import Kingfisher

class MenuDetailViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextViewDelegate {
    
    
    @IBOutlet weak var addImageBtn: UIButton!
    @IBOutlet weak var menuImage: UIImageView!
    @IBOutlet weak var menuDescription: UITextView!
    @IBOutlet weak var menuPrice: UITextField!
    @IBOutlet weak var addMenuBtn: UIButton!
    @IBOutlet weak var menuTitle: UITextField!
    
    var dish:MenuCategoryViewModel?
    
    var isMenuImage = false
    
    var TypeId = 0
    
    var menuType = "Show"
    var MenuId: Int = -1
    var CategoryId:Int = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.hidesBackButton = true
        
        menuDescription.delegate = self
    
        menuDescription.text = "Write menu description here"
        menuDescription.textColor = UIColor.lightGray
        
        self.SetMenu()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Hide the navigation bar on the this view controller
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // Show the navigation bar on other view controllers
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if menuDescription.textColor == UIColor.lightGray {
            menuDescription.text = nil
            menuDescription.textColor = UIColor.black
        }
        }
    
        func textViewDidEndEditing(_ textView: UITextView) {
            if menuDescription.text.isEmpty {
                menuDescription.text = "Write menu description here"
                menuDescription.textColor = UIColor.lightGray
            }
        }
    
    @IBAction func actionBack(_ sender: UIButton) {
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
    
    func SetMenu(){
        if menuType == "Show"{
            addImageBtn.isUserInteractionEnabled = false
            self.addMenuBtn.isHidden = true
            self.menuDescription.isUserInteractionEnabled = false
            self.menuPrice.isUserInteractionEnabled = false
            self.menuTitle.isUserInteractionEnabled = false
            
        }
        else if menuType == "Add"{
            addImageBtn.isUserInteractionEnabled = true
            self.addMenuBtn.isHidden = false
            self.menuDescription.isUserInteractionEnabled = true
            self.menuPrice.isUserInteractionEnabled = true
            self.menuTitle.isUserInteractionEnabled = true
        }
        else{
            addImageBtn.isUserInteractionEnabled = true
            self.addMenuBtn.isHidden = false
            self.menuDescription.isUserInteractionEnabled = true
            self.menuPrice.isUserInteractionEnabled = true
            self.menuTitle.isUserInteractionEnabled = true
            
            self.menuDescription.text = dish?.description!
            self.menuPrice.text = String((dish?.price!)!)
            self.menuTitle.text = dish?.title!
            
//            if dish?.imageUrl != nil && dish?.imageUrl != ""{
//                self.menuImage.kf.setImage(with: URL(string: BASE_URL + (dish?.imageUrl!)!))
//            }
            
            if dish?.imageUrl != "" && dish?.imageUrl != nil{
                 if let url = URL(string: dish?.imageUrl ?? "") {
                     DispatchQueue.main.async {
                         self.menuImage.setImage(url: url)
                     }
                 }
     //            let url = URL(string: BASE_URL+event.profileUrl!) ?? URL.init(string: "https://www.google.com")!
             }

        }
    }
    
 
    
    @IBAction func actionAddorUpdateMenu(_ sender: UIButton) {
        
        if isAllValidationWorks(){
        
            self.uploadImage()
//            self.menu(urlString: "")
    }
        else{
            print("Validation not Passed")
        }

    
    }

    
    func isAllValidationWorks()->Bool{
        
        if !isMenuImage{
            self.simpleAlert(title: "Alert", msg: "Add Food Picture")
            return false
        }
        
        if menuTitle.isTextFieldEmpty(){
            self.simpleAlert(title: "Alert", msg: "Name of food item is missing!")
            return false
        }
        

        if menuPrice.isTextFieldEmpty(){
            self.simpleAlert(title: "Alert", msg: "Add price for food item")
            return false
        }
        return true
    }
}

extension MenuDetailViewController{
    
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

extension MenuDetailViewController
{
    func imagePickerController(_ picker:  UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            if let imageData = image.jpegData(compressionQuality: 0.1) {
                self.menuImage.image = image
                self.isMenuImage = true

              
            }
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}

extension MenuDetailViewController{
    
    func uploadImage(){
        if let image = self.menuImage.image {
            BlobUploadManager.shared.uploadFile(fileData: image.jpegData(compressionQuality: 0.5) ?? Data() , fileName: UUID().uuidString + ".jpg", folder: "User") { fileUrl, isCompleted in
                if isCompleted {
                    let urlString = BlobUploadManager.shared.imagesBaseUrl + fileUrl
                    self.menu(urlString: urlString)
                }
            }
        }
    }
    
    func menu(urlString: String){
        if menuType == "Add"{
            let Price = Double(self.menuPrice.text!)
            
            let parameter: [String:Any] = ["Title":self.menuTitle.text!,
                                           "Description":self.menuDescription.text!,
                                           "Price":Price ?? 0.0,
                                           "ImageFile": urlString,
                                           "TypeId" : TypeId
                                           ]
            
            print(parameter)
            
            let service = Services()
            GCD.async(.Default) {
                SVProgressHUD.show()
                service.addMenuRequest(params: parameter) { (serviceResponse) in
                    GCD.async(.Main) {
                        //self.stopActivity()
                        SVProgressHUD.dismiss()
                    }
                    switch serviceResponse.serviceResponseType {
                    case .Success :
                        GCD.async(.Main) {
                            self.navigationController?.popViewController(animated: true)
                    }
                    case .Failure :
                        GCD.async(.Main) {
                            print("Deal Not Added")
                        }
                    default :
                        GCD.async(.Main) {
                            print("Deal Not Added..")
                        }
                    }
                }
            }

        }
        
        else{
            let Price = Double(self.menuPrice.text!)
            
            let parameter: [String:Any] = ["Title":self.menuTitle.text!,
                                           "Description":self.menuDescription.text!,
                                           "Price":Price ?? 0.0,
                                           "ImageFile": urlString,
                                           "MenuId": self.MenuId,
                                           "CategoryId": self.CategoryId
                                           ]
            
            print(parameter)
            
            let service = Services()
            GCD.async(.Default) {
                SVProgressHUD.show()
                service.editMenuRequest(params: parameter) { (serviceResponse) in
                    GCD.async(.Main) {
                        //self.stopActivity()
                        SVProgressHUD.dismiss()
                    }
                    switch serviceResponse.serviceResponseType {
                    case .Success :
                        GCD.async(.Main) {
                            self.navigationController?.popViewController(animated: true)
                    }
                    case .Failure :
                        GCD.async(.Main) {
                            print("Deal Not Updated")
                        }
                    default :
                        GCD.async(.Main) {
                            print("Deal Not Updated..")
                        }
                    }
                }
            }

        }
    }
    
}
