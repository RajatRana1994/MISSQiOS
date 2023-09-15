//
//  PaymentTipPopupController.swift
//  IBeLaughing
//
//  Created by iOS on 11/02/22.
//  Copyright © 2022 Mac 2. All rights reserved.
//

import UIKit

class PaymentTipPopupController: UIViewController {

    //MARK: - IBOutlets
    @IBOutlet weak var viewBg: UIView!
    
    //MARK: - Variables
    var makePayment: (() -> Void)?
    
    //MARK: - View Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        configView()
    }
    
    //MARK: - Configure View
    func configView(){
        self.viewBg.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(actionback)))
    }
    
    //MARK: - Back Action
    @objc func actionback(){
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Button Action for payment
    @IBAction func actionPayment(_ sender: Any) {
        self.dismiss(animated: true) {
            self.makePayment!()
        }
    }
}
