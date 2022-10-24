//
//  TermsViewController.swift
//  Trough_Driver
//
//  Created by Imed on 23/07/2021.
//

import UIKit

class TermsViewController: BaseViewController {

    
    @IBOutlet weak var termTextView: UITextView!
    
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var acceptBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.conditions()
    }

    
    @IBAction func actionCancel(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func actionAccept(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
//        self.moveToHome()

    }
    
    @IBAction func actionDone(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
}

extension TermsViewController{
    func conditions(){
        
        var params: [String:Any] = [String:Any]()
        params = [
            :  ] as [String : Any]

        let service = UserServices()
        GCD.async(.Main) {
            self.startActivityWithMessage(msg: "")
        }
        GCD.async(.Default) {
            
            service.GetTerms(params: params) { (serviceResponse) in
                GCD.async(.Main) {
                    self.stopActivity()
                }
                switch serviceResponse.serviceResponseType {
                case .Success :
                    GCD.async(.Main) { [self] in
                        
                        if let termsList = serviceResponse.data as? [TermsViewModel] {
                            print(termsList)
//                            self.terms = termsList
                            let text = termsList.filter { $0.type == "DriverTerms"}.first
                            self.termTextView.text = text?.privacyText
                            
                        }
                        else {
                            print("No Item Found!")
                        }
                    }
                case .Failure :
                    GCD.async(.Main) {
                        print("No Item Found!!!")
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
