//
//  FilterMapTableViewCell.swift
//  Trough_Driver
//
//  Created by Macbook on 01/03/2021.
//

import UIKit
import BEMCheckBox

protocol actionSaveBtnDelegate {
    func backToMapViewController()
}

class FilterMapTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var checkBox1: BEMCheckBox!
    @IBOutlet weak var checkBox2: BEMCheckBox!
    @IBOutlet weak var checkBox3: BEMCheckBox!
    @IBOutlet weak var checkBox4: BEMCheckBox!
    @IBOutlet weak var checkBox5: BEMCheckBox!
    @IBOutlet weak var checkBox6: BEMCheckBox!
    @IBOutlet weak var checkBox7: BEMCheckBox!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    var delegate : actionSaveBtnDelegate?
    
    @IBAction func actionSaveBtn(_ sender: UIButton) {
        
        delegate?.backToMapViewController()
    }
    
}
