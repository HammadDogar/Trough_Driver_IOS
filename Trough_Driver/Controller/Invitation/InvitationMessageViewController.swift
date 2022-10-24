//
//  InvitationMessageViewController.swift
//  Trough_Driver
//
//  Created by Macbook on 02/03/2021.
//

import UIKit

class InvitationMessageViewController: UIViewController {

    @IBOutlet weak var lblDescription: UILabel!
    var eventDescription:String = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.lblDescription.text = eventDescription
    }
    
    

    @IBAction func actionOkBtn(_ sender: UIButton) {
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
}
