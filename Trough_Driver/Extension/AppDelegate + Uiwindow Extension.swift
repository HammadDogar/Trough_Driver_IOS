//
//  AppDelegate + Uiwindow Extension.swift
//  Trough_Driver
//
//  Created by Imed on 17/02/2021.
//

import UIKit


extension UIWindow {
    func topViewController() -> UIViewController? {
     
            
            var top = self.rootViewController
                 while true {
                     if let presented = top?.presentedViewController {
                         top = presented
                     } else if let nav = top as? UINavigationController {
                         top = nav.visibleViewController
                     } else if let tab = top as? UITabBarController {
                         top = tab.selectedViewController
                     } else {
                         break
                     }
                 }
                 return top
        
     
    }
}
