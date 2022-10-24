//
//  FilterMapViewController.swift
//  Trough_Driver
//
//  Created by Macbook on 26/02/2021.
//

import UIKit
import BEMCheckBox

protocol MapCotrollerDelegate {
    func backToMapVC()
}

class FilterMapViewController: UIViewController,UITableViewDataSource,UITableViewDelegate, BEMCheckBoxDelegate,actionSaveBtnDelegate {
    
    
    @IBOutlet weak var tableView: UITableView!
    
    var isTruck = GlobalVariable.isTruckShow
    var isEvent = GlobalVariable.isEventShow
    
    var range:Double = GlobalVariable.totalRange
    
    var delegate:MapCotrollerDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
    }
    
    @IBAction func actionBackButton(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! FilterMapTableViewCell
        cell.checkBox1.delegate = self
        cell.checkBox2.delegate = self
        cell.checkBox3.delegate = self
        cell.checkBox4.delegate = self
        cell.checkBox5.delegate = self
        cell.checkBox6.delegate = self
        cell.checkBox7.delegate = self
        cell.delegate = self
        
        //Set Distance CheckBox Data
        if GlobalVariable.totalRange == 0.5{
            cell.checkBox1.on = true
        }
        else if GlobalVariable.totalRange == 1.0{
            cell.checkBox2.on = true
        }
        else if GlobalVariable.totalRange == 2.0{
            cell.checkBox3.on = true
        }
        else if GlobalVariable.totalRange == 5.0{
            cell.checkBox4.on = true
        }
        else{
            cell.checkBox5.on = true
        }
        
        //set truck CheckBox
        
        if GlobalVariable.isTruckShow == true{
            cell.checkBox6.on = true
        }
        else{
            cell.checkBox6.on = false
        }
        
        //set Event CheckBox
        
        if GlobalVariable.isEventShow == true{
            cell.checkBox7.on = true
        }
        else{
            cell.checkBox7.on = false
        }

        return cell
    }
    
    
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 560
    }
    
    func didTap(_ checkBox: BEMCheckBox) {
        let path = NSIndexPath.init(row: 0, section: 0)
        let cell = tableView.cellForRow(at: path as IndexPath) as! FilterMapTableViewCell
        if checkBox.tag == 1{
            cell.checkBox2.on = false
            cell.checkBox3.on = false
            cell.checkBox4.on = false
            cell.checkBox5.on = false
            range = 0.5
            
            checkBox.on = true
        }
        else if checkBox.tag == 2{
            cell.checkBox1.on = false
            cell.checkBox3.on = false
            cell.checkBox4.on = false
            cell.checkBox5.on = false
            checkBox.on = true
            range = 1.0
        }
        else if checkBox.tag == 3{
            cell.checkBox1.on = false
            cell.checkBox2.on = false
            cell.checkBox4.on = false
            cell.checkBox5.on = false
            checkBox.on = true
            
            range = 2.0
        }
        else if checkBox.tag == 4{
            cell.checkBox1.on = false
            cell.checkBox2.on = false
            cell.checkBox3.on = false
            cell.checkBox5.on = false
            checkBox.on = true
            
            range = 5.0
        }
        else if checkBox.tag == 5{
            cell.checkBox1.on = false
            cell.checkBox2.on = false
            cell.checkBox3.on = false
            cell.checkBox4.on = false
            checkBox.on = true
            
            range = 10.0
        }
        else if checkBox.tag == 6{
            
            if isTruck{
                checkBox.on = false
                self.isTruck = false
            }
            else{
                checkBox.on = true
                self.isTruck = true
            }

        }
        else if checkBox.tag == 7{
            if isEvent{
                checkBox.on = false
                self.isEvent = false
            }
            else{
                checkBox.on = true
                self.isEvent = true
            }
        }



        print(checkBox.tag)
        print(range)
    }
    
    func backToMapViewController() {
        GlobalVariable.totalRange = range
        GlobalVariable.isTruckShow = isTruck
        GlobalVariable.isEventShow = isEvent
        delegate?.backToMapVC()
        self.navigationController?.popViewController(animated: true)
    }

}
