//
//  ViewControllerExtension.swift
//  Trough_Driver
//
//  Created by Imed on 18/02/2021.
//

import UIKit

extension UIViewController{
    
    func simpleAlert(title : String , msg : String) {
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    
    var mainContainer : ContainerViewController {
        get {
            var foundController : ContainerViewController? = nil
            var currentController : UIViewController? = self
            if self.isKind(of: ContainerViewController.self){
                foundController = self as! ContainerViewController
            }
            else {
                while true {
                    if let parent = currentController?.parent {
                        if parent.isKind(of: ContainerViewController.self) {
                            foundController = parent as! ContainerViewController
                            break
                        }
                        else if parent.isKind(of: BaseNavigationViewController.self) {
                            let navController = parent as! BaseNavigationViewController
                            if let parentViewController = navController.view.superview?.parentViewController{
                                if parentViewController.isKind(of: ContainerViewController.self) {
                                    foundController = parentViewController as! ContainerViewController
                                    break
                                }
                            }
                        }
                    }
                    else {
                        break
                    }
                    currentController = currentController?.parent
                }
            }
            return foundController!
        }
    }

}
