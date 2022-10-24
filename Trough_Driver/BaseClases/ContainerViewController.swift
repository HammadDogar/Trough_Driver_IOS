//
//  ContainerViewController.swift
//  Trough_Driver
//
//  Created by Macbook on 24/02/2021.
//

import UIKit

protocol ContainerViewDelegate {
    func logout()
}


class ContainerViewController: BaseViewController {
    //UIVIEW
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var bottomNavView: UIView!
    //UIBUTTON
    @IBOutlet weak var eventBtn: UIButton!
    @IBOutlet weak var nearByBtn: UIButton!
    @IBOutlet weak var activityBtn: UIButton!
    @IBOutlet weak var notificationBtn: UIButton!
    @IBOutlet weak var settingsBtn: UIButton!
    
    @IBOutlet weak var eventIcon: UIImageView!
    @IBOutlet weak var activityIcon: UIImageView!
    @IBOutlet weak var nearByIcon: UIImageView!
    @IBOutlet weak var notificationIcon: UIImageView!
    @IBOutlet weak var settingIcon: UIImageView!

    @IBOutlet weak var eventBtnBackView: UIView!
    @IBOutlet weak var nearByBtnBackView: UIView!
    @IBOutlet weak var activityBtnBackView: UIView!
    @IBOutlet weak var notificationBtnBackView: UIView!
    @IBOutlet weak var settingsBtnBackView: UIView!

    @IBOutlet weak var eventLabel: UILabel!
    @IBOutlet weak var nearByLabel: UILabel!
    @IBOutlet weak var activityLabel: UILabel!
    @IBOutlet weak var notificationLabel: UILabel!
    @IBOutlet weak var settingsLabel: UILabel!
    
    //Constraint
    @IBOutlet weak var bottomViewBottomConstraint: NSLayoutConstraint!

    var currenController : BaseNavigationViewController?
    var previousController : BaseNavigationViewController?
    var delegate:ContainerViewDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        Global.shared.currentController = "BaseNavigationViewController"
        self.setSubView()
    }
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
    }
    
    
    func setSubView(){
        GCD.async(.Main) {
            self.previousController = self.currenController
            let vc = self.storyboard?.instantiateViewController(withIdentifier: Global.shared.currentController) as! BaseNavigationViewController
            vc.view.frame = CGRect.init(x: self.containerView.frame.origin.x, y: self.containerView.bounds.origin.y, width: self.containerView.bounds.width, height: self.containerView.bounds.height)
            self.currenController = vc
            Global.shared.currentNavigationController = vc
            if self.previousController?.restorationIdentifier == self.currenController?.restorationIdentifier {
                self.previousController?.viewDidDisappear(true)
                self.previousController?.view.removeFromSuperview()
                self.containerView.addSubview(vc.view)
            }
            else {
                self.containerView.addSubview(vc.view)
                self.previousController?.viewDidDisappear(true)
                self.previousController?.view.removeFromSuperview()
            }
        }
    }
    
    @IBAction func actionEvents(_ sender:Any){
        self.setColor(tag: 0)
        Global.shared.currentController = "BaseNavigationViewController"
        self.setSubView()
        self.currenController?.popToRootViewController(animated: true)
    }
    
    @IBAction func actionNearBy(_ sender:Any){
        self.setColor(tag: 2)
        Global.shared.currentController = "GoogleMapNavigationViewController"
        self.setSubView()
    }
    
    @IBAction func actionActivity(_ sender:Any){
        self.setColor(tag: 3)
        Global.shared.currentController = "InvitationsViewController"
        self.setSubView()

    }
    
    @IBAction func actionNotification(_ sender:Any){
        self.setColor(tag: 1)
        Global.shared.currentController = "TruckMenuNavigationController"
        self.setSubView()
    }
    
    @IBAction func actionSettings(_ sender:Any){
        self.setColor(tag: 4)
        Global.shared.currentController = "SettingNavigationController"
        self.setSubView()

    }
    
    func setColor(tag : Int){
        self.eventLabel.textColor = #colorLiteral(red: 0.7019607843, green: 0.7019607843, blue: 0.7019607843, alpha: 1)
        self.notificationLabel.textColor = #colorLiteral(red: 0.7019607843, green: 0.7019607843, blue: 0.7019607843, alpha: 1)
        self.nearByLabel.textColor = #colorLiteral(red: 0.7019607843, green: 0.7019607843, blue: 0.7019607843, alpha: 1)
        self.activityLabel.textColor = #colorLiteral(red: 0.7019607843, green: 0.7019607843, blue: 0.7019607843, alpha: 1)
        self.settingsLabel.textColor = #colorLiteral(red: 0.7019607843, green: 0.7019607843, blue: 0.7019607843, alpha: 1)
        
        self.eventIcon.tintColor = #colorLiteral(red: 0.7019607843, green: 0.7019607843, blue: 0.7019607843, alpha: 1)
        self.notificationIcon.tintColor = #colorLiteral(red: 0.7019607843, green: 0.7019607843, blue: 0.7019607843, alpha: 1)
        self.nearByIcon.tintColor = #colorLiteral(red: 0.7019607843, green: 0.7019607843, blue: 0.7019607843, alpha: 1)
        self.activityIcon.tintColor = #colorLiteral(red: 0.7019607843, green: 0.7019607843, blue: 0.7019607843, alpha: 1)
        self.settingIcon.tintColor = #colorLiteral(red: 0.7019607843, green: 0.7019607843, blue: 0.7019607843, alpha: 1)

        if tag == 0{
            self.eventLabel.textColor = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
            self.eventIcon.tintColor = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
        }
        else if tag == 1{
            self.notificationLabel.textColor = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
            self.notificationIcon.tintColor = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
        }
        else if tag == 2{
            self.nearByLabel.textColor = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
            self.nearByIcon.tintColor = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
        }
        else if tag == 3 {
            self.activityLabel.textColor = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
            self.activityIcon.tintColor = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
        }
        else if tag == 4 {
            self.settingsLabel.textColor = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
            self.settingIcon.tintColor = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
        }
    }
}
