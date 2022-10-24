//
//  BaseViewController.swift
//  Trough_Driver
//
//  Created by Macbook on 24/02/2021.
//

import UIKit
import MBProgressHUD
import SDWebImage

class BaseViewController: UIViewController {

    
    var isFromNotification = false
    
    var hud = MBProgressHUD()

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    func startActivityWithMessage (msg:String, detailMsg: String = "") {
        self.view.endEditing(true)
        self.hud = MBProgressHUD.showAdded(to: self.view, animated:true)
        self.hud.labelText = msg
        self.hud.detailsLabelText = detailMsg
    }
    func stopActivity (containerView: UIView? = nil) {
        if let v = containerView{
            MBProgressHUD.hide(for: v, animated: true)
        }else{
            MBProgressHUD.hide(for: self.view, animated: true)
        }
    }
    

    func converDateIntoTime(date:Date) -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .short
        let dateStr : String = dateFormatter.string(from: date)
        return dateStr
    }
    
    func convertDateIntoTimeStamp(date:Date) -> Int
    {
        let timeStamp = date.timeIntervalSince1970
//        print(Int(timeStamp))
        return Int(timeStamp)
    }
    
    func convertTimeStampToTime(timeStamp: String) -> String {
        
        let timeStampDate = NSDate(timeIntervalSince1970: TimeInterval(timeStamp) ?? 0.0)
        let dateFormatter = DateFormatter()
        dateFormatter.doesRelativeDateFormatting = true
        
        dateFormatter.locale =  NSLocale.init(localeIdentifier: "en") as Locale
        
        //    dateFormatter.locale = NSLocale.current
        dateFormatter.dateStyle = .none
        dateFormatter.timeStyle = .short
        
        return dateFormatter.string(from: timeStampDate as Date)
        
    }

}

extension UIView {
    var parentViewController: UIViewController? {
        var parentResponder: UIResponder? = self
        while parentResponder != nil {
            parentResponder = parentResponder!.next
            if let viewController = parentResponder as? UIViewController {
                return viewController
            }
        }
        return nil
    }
}

extension BaseViewController{
    func moveToHome(){
        if let vc = storyboard?.instantiateViewController(withIdentifier: "ContainerViewController") as? ContainerViewController{
            self.navigationController?.pushViewController(vc, animated: true)
            
        }
    }
    
}

extension BaseViewController{
    func openNotification(){
//        if let notiVC = UIStoryboard.init(name: "Home", bundle: nil).instantiateViewController(withIdentifier: "NotificationsViewController") as? NotificationsViewController{
        if self.mainContainer.currenController != nil && Global.shared.currentUser.userId != nil {
                Global.shared.currentController = "NotificationsNavigationViewController"
                self.mainContainer.setSubView()
                //                self.mainContainer.currenController?.pushViewController(notiVC, animated: true)
//                self.navigationController?.pushViewController(notiVC, animated: true)
                
            }
        }
}
