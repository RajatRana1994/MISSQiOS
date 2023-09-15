//
//  PaymentCardsVC.swift
//  ValetIT
//
//  Created by iOS on 01/04/21.
//

import UIKit
import SwiftyJSON

class PaymentCardsVC: UIViewController {
    
    //MARK:- Properties
    @IBOutlet weak var tblPaymentCard : UITableView!
    @IBOutlet weak var noCardView : UIView!
    @IBOutlet weak var lblNoDataFound : UILabel!
    @IBOutlet weak var cardView : UIView!
    @IBOutlet weak var btnHeightConstraints : NSLayoutConstraint!
    @IBOutlet weak var btnPay : UIButton!
    
    //MARK:- Variable
    var arrCards = [CardInfo]()
    var stripeManager = StripeManager()
    var params = Dictionary<String, Any>()
    var cardID = String()
    var receiverAccountID: String = ""
  //  var payeeUserDetail: UserDetails?
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.getAllCards()
       self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        // self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    @IBAction func btnBackAction(sender:UIButton){
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnAddCardAction(sender:UIButton){
        let vc = AppDelegate.getViewController(identifire: "AddNewCardVC") as! AddNewCardVC
        vc.accessibilityHint = self.accessibilityHint
         vc.params = self.params
        vc.isCardAddedDelegate = { (isCardAdded) in
            if isCardAdded{
                self.getAllCards()
            }
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
   
    
    //MARK:- Custom Methods For Delete & edit card
    @objc func btnMenuAction(sender:UIButton) {
        let optionMenu = UIAlertController(title: nil, message: "SELECT_OPTION".localized(), preferredStyle: .actionSheet)
        
        let deleteAction = UIAlertAction(title: "delete".localized(), style: .destructive, handler:{(alert: UIAlertAction!) -> Void in
            print(self.arrCards.count)
            let dict = self.arrCards[sender.tag]
//            if dict.id == UserDefaults.standard.object(forKey: GConstant.UserDefaults.defaultCard) as? String{
//                AlertManager.shared.addToast(self.view, message: "You can't delete default card.")
//            }else{
            self.removeCard(cardId: dict.id, index: sender.tag)
          //  }
        })
        
        let cancelAction = UIAlertAction(title: "cancel".localized(), style: .cancel, handler:{(alert: UIAlertAction!) -> Void in
            self.dismiss(animated: true, completion: nil)
        })
        optionMenu.addAction(deleteAction)
        optionMenu.addAction(cancelAction)
        self.present(optionMenu, animated: true, completion: nil)
    }
    
    @objc func btnSetDefaultCardAction(sender:UIButton) {
        print(self.arrCards[sender.tag].id)
        self.updateCustomerInfo(cardId: self.arrCards[sender.tag].id)
    }
    
    
    
}

//MARK:Table view Methods
extension PaymentCardsVC:UITableViewDelegate,UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrCards.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PaymentCardCell")as! PaymentCardCell
        let dict = arrCards[indexPath.row]
        cell.lblCardNumber.text = "XXXX XXXX XXXX \(dict.last4)"
        cell.selectionStyle = .none
        cell.imgCardBrand.image = AppManager.getCardImage(cardBrandName:dict.brand.lowercased())
        if dict.id == UserDefaults.standard.object(forKey: Constants.UserDefaults.defaultCard) as? String{
            self.cardID = dict.id
            cell.btnCheckPayment.isSelected = true
        }else{
            cell.btnCheckPayment.isSelected = false
        }
        cell.btnEditDel?.tag = indexPath.row
        cell.btnEditDel?.addTarget(self, action: #selector(btnMenuAction(sender:)), for: UIControl.Event.touchUpInside)
        cell.btnCheckPayment?.tag = indexPath.row
        cell.btnCheckPayment?.addTarget(self, action: #selector(btnSetDefaultCardAction(sender:)), for: UIControl.Event.touchUpInside)
      
        return cell;
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 81
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.cardID = arrCards[indexPath.row].id
    }
}

extension PaymentCardsVC{
    
    //MARK:- getAllCards()
    func getAllCards(){
        self.stripeManager.apiGetAllCards(param: [:], view: self.view){ (response) in
            print(response)
            let dataArray = response["data"].arrayValue
            self.arrCards.removeAll()
            for obj in dataArray {
                let objDoc = CardInfo.init(objData: obj)
                self.arrCards.append(objDoc)
            }
            self.reloadTable()
        }
    }
    
    //MARK:- getCustomerInfo
    func getCustomerInfo(){
        self.stripeManager.apiGetCustomerInfo(){ (response) in
            print(response)
            UserDefaults.standard.set(response["default_source"].stringValue, forKey: Constants.UserDefaults.defaultCard)
            self.getAllCards()
        }
    }
    
    //MARK:- updateCustomerInfo
    func updateCustomerInfo(cardId:String){
        var params = Dictionary<String, Any>()
        params["default_source"] = cardId
        self.stripeManager.apiUpdateCustomerInfo(param: params){ (response) in
            print(response)
            UserDefaults.standard.set(response["default_source"].stringValue, forKey: Constants.UserDefaults.defaultCard)
            self.cardID = cardId
            self.tblPaymentCard.reloadData()
        }
    }
    
    //MARK:- Customer Remove Card Api
    func removeCard(cardId:String, index: Int){
        self.stripeManager.apiDeleteCard(cardId: cardId){ (response) in
            print(response)
            self.arrCards.remove(at: index)
            if cardId == UserDefaults.standard.object(forKey: Constants.UserDefaults.defaultCard) as? String{
                UserDefaults.standard.removeObject(forKey: Constants.UserDefaults.defaultCard)
                self.getCustomerInfo()
            }
            self.reloadTable()
        }
    }
    
    func reloadTable() {
        if self.arrCards.count == 0 {
            self.tblPaymentCard.isHidden = true
            self.lblNoDataFound.isHidden = false
        }else{
            self.tblPaymentCard.isHidden = false
            self.lblNoDataFound.isHidden = true
        }
        self.tblPaymentCard.reloadData()
    }
}

