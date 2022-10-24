//
//  PaymentMethodViewController.swift
//  Trough_Driver
//
//  Created by Imed on 19/07/2021.
//

import UIKit

class PaymentMethodViewController: BaseViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var cardList = [PaymentMethodViewModel].init()
    var selectedIndex = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.register(UINib.init(nibName: "PaymentMethodTableViewCell", bundle: nil), forCellReuseIdentifier: "PaymentMethodTableViewCell")
        self.tableView.register(UINib.init(nibName: "AddNewCardTableViewCell", bundle: nil), forCellReuseIdentifier: "AddNewCardTableViewCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.getAllPaymentListRequest()

    }
    
    @IBAction func actionBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
}

extension PaymentMethodViewController: UITableViewDataSource,UITableViewDelegate{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 15
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            return self.cardList.count
        }else{
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0{
            if let cell = tableView.dequeueReusableCell(withIdentifier: "PaymentMethodTableViewCell", for: indexPath) as? PaymentMethodTableViewCell{
                cell.selectionStyle = .none
                cell.cardNumberLabel.text = "Visa Ending In " + (self.cardList[indexPath.row].card?.last4)!
                if indexPath.row == self.selectedIndex{
                    cell.selectedImageView.isHidden = false
                }else{
                    cell.selectedImageView.isHidden = true
                }
                return cell
            }
        }else{
            if let cell = tableView.dequeueReusableCell(withIdentifier: "AddNewCardTableViewCell", for: indexPath) as? AddNewCardTableViewCell{
                return cell
            }
        }
        return UITableViewCell.init()
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0{
            self.selectedIndex = indexPath.row
            self.tableView.reloadData()
//            let alertController = UIAlertController(title: "Payment Method Added", message:
//                    "Visa Card Selected", preferredStyle: .alert)
//                alertController.addAction(UIAlertAction(title: "Dismiss", style: .default))
//
//        self.present(alertController, animated: true)
        }else{
            self.gotoCardDetailViewController()
        }
    }
    
    func gotoCardDetailViewController(){
        if let vc = storyboard?.instantiateViewController(withIdentifier: "CardDetailsViewController") as? CardDetailsViewController{
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
extension PaymentMethodViewController{
    func getAllPaymentListRequest(){
        let params =
            [:] as [String : Any]
        let service = ProposalServices()
        GCD.async(.Main) {
//            self.startActivityWithMessage(msg: "")
        }
        GCD.async(.Default) {
            service.getAllPaymentRequest(params: params) { (serviceResponse) in
                GCD.async(.Main) {
//                    self.stopActivity()
                }
                switch serviceResponse.serviceResponseType {
                case .Success :
                    GCD.async(.Main) {
                        if let cardList = serviceResponse.data as? [PaymentMethodViewModel] {
                            self.cardList = cardList
                            self.tableView.reloadData()
//                            self.stopActivity()
                        }
                    }
                case .Failure :
                    GCD.async(.Main) {
                        self.tableView.reloadData()
                        self.simpleAlert(title: "Alert", msg: serviceResponse.message)
                    }
                default :
                    GCD.async(.Main) {
                        self.simpleAlert(title: "Alert", msg: serviceResponse.message)
                    }
                }
            }
        }
    }
}
