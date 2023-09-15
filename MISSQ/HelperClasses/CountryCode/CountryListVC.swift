//
//  CountryListVC.swift
//  JobPortal
//
//  Created by sfs17 on 4/27/17.
//  Copyright © 2017 Apple02Sunfocus. All rights reserved.
//

import UIKit
import Foundation

typealias CountryCodeCallBack = (_ objGym : String,_ country : String, _ image : UIImage)->Void

class CountryListVC: UIViewController ,UITableViewDelegate ,UITableViewDataSource ,UITextFieldDelegate{
    
    // MARK: - Properties
    
    @IBOutlet var lblTitle: UILabel!
    @IBOutlet weak var tfSearchField: UITextField!
    @IBOutlet weak var tableCountry: UITableView!
    @IBOutlet weak var countryTableBottomConstraint: NSLayoutConstraint!
    
    // MARK: - Variables
    var arrayCountry = [Country]()
    var arrayFiltered = [Country]()
    var hasSelected : Bool = false
    var strTitle : String = ""
    // MARK: Variables
    var countryCodeBlock : CountryCodeCallBack!
    
    // MARK: UIView Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setCountryData()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:) ), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:) ), name: UIResponder.keyboardWillHideNotification, object: nil)
        if strTitle != ""{
         lblTitle.text = "Search Country"
        }else{
        lblTitle.text = "Search Country Code"
        }
        tfSearchField.placeholder = NSLocalizedString("search", comment: "")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
//        IQKeyboardManager.shared.enable = false
//        IQKeyboardManager.shared.enableAutoToolbar = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
//        IQKeyboardManager.shared.enable = true
//        IQKeyboardManager.shared.enableAutoToolbar = true
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    //MARK: NSNotification Methods
    
    @objc func keyboardWillShow(notification:NSNotification) {
        let userInfo  = notification.userInfo as! Dictionary<String, Any>
        let keyboardFrame: NSValue = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue
        let keyboardRectangle = keyboardFrame.cgRectValue
        let keyboardHeight = keyboardRectangle.height
        print(keyboardHeight)
        self.countryTableBottomConstraint.constant = keyboardHeight
    }
    
    @objc func keyboardWillHide(notification:NSNotification) {
        self.countryTableBottomConstraint.constant = 0.0
    }
    
    
    // MARK: - UITextField Delegate  Methods
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool{
        let textFieldText: NSString = (textField.text ?? "") as NSString
        let searchStringLocal = textFieldText.replacingCharacters(in: range, with: string)
        
        if searchStringLocal.count == 0{
            self.arrayFiltered.removeAll()
            self.arrayFiltered = self.arrayCountry
            tableCountry.delegate = self
            tableCountry.dataSource = self
            self.tableCountry.reloadData()
        }
        else{
            arrayFiltered = searchStringLocal.isEmpty ? arrayCountry : arrayCountry.filter({(objCity: Country) -> Bool in
                return objCity.countryName.range(of: searchStringLocal, options: .caseInsensitive) != nil
            })
            tableCountry.delegate = self
            tableCountry.dataSource = self
            self.tableCountry.reloadData()
            
        }
        return true
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        tfSearchField.resignFirstResponder()
        return true
    }
    
    
    // MARK: - UITableView Delegate and DataSource Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return arrayFiltered.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell  = tableView.dequeueReusableCell(withIdentifier: "CountryListCell") as! CountryListCell
        
        let countryData  = arrayFiltered[indexPath.row]
        cell.lblDialingCode.text = countryData.countryDialingCode
        cell.lblCountryName.text = countryData.countryName
        let strImage = countryData.contryCode
        cell.imgCountry.image = UIImage.init(named: (strImage.uppercased()))
        if strTitle != ""{
            cell.lblDialingCode.isHidden = true
        }else{
            cell.lblDialingCode.isHidden = false
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        hasSelected = true
        let countryData  = arrayFiltered[indexPath.row]
        tfSearchField.text = countryData.countryDialingCode
        if (self.countryCodeBlock != nil){
            let strImage = countryData.contryCode
            let iimg = UIImage.init(named: (strImage.uppercased()))!
            self.countryCodeBlock(countryData.countryDialingCode ,"\(countryData.countryName)", iimg)
        }
        self.dismiss(animated: true, completion: nil)
        
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        return 50
    }
    
    
    // MARK: - Custom Methods
    
    func setCountryData()  {
        //Getting Path of Plist
        let pathOfPlist = Bundle.main.path(forResource: "DiallingCodes", ofType: "plist")
        //fetching Vlaues from Plist
        if let dic = NSDictionary(contentsOfFile: pathOfPlist!) as? [String: Any] {
            let arrayDialingCode = [Any] (dic.values) as NSArray
            let arrayCountryCode = [String] (dic.keys) as NSArray
            
            //Generate country data dictionary
            for i in 0..<arrayCountryCode.count{
                let countryObj = Country()
                countryObj.countryDialingCode = "+\(arrayDialingCode[i] as! String)"
                countryObj.contryCode = arrayCountryCode[i] as! String
                
                let currentLocale : NSLocale = NSLocale.init(localeIdentifier :  NSLocale.current.identifier)
                let countryName : String? = currentLocale.displayName(forKey: NSLocale.Key.countryCode, value: arrayCountryCode[i])
                
                if countryName?.count == 0 {
                    countryObj.countryName = arrayCountryCode[i] as! String
                    
                }else{
                    countryObj.countryName  = countryName!
                    
                }
                arrayCountry.append(countryObj)
                
            }
            let sortedUser = arrayCountry.sorted(by:  { $0.countryName.lowercased() < $1.countryName.lowercased() })
            self.arrayCountry.removeAll()
            self.arrayCountry = sortedUser
            self.arrayFiltered = sortedUser
            
            
        }
        tableCountry.delegate = self
        tableCountry.dataSource = self
        tableCountry.reloadData()
    }
    
    
    
    @IBAction func btnBackAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func updateCountryCode(didUpdateCompletion:@escaping CountryCodeCallBack){
        if countryCodeBlock != nil {
            countryCodeBlock = nil
        }
        countryCodeBlock = didUpdateCompletion
        
    }
}
