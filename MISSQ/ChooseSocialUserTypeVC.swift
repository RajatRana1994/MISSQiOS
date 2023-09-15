//
//  ChooseSocialUserTypeVC.swift
//  MISSQ
//
//  Created by Vikas Kumar on 13/06/22.
//

import UIKit

class ChooseSocialUserTypeVC: UIViewController {
    typealias chooseType = (_ isCustoemr: Bool) -> Void
    var choseTypeCompilation: chooseType?
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    @IBAction func btnCustomerAction(sender: UIButton){
        if self.choseTypeCompilation != nil{
            self.choseTypeCompilation!(true)
            self.dismiss(animated: true, completion: nil)
        }
    }

    @IBAction func btnProviderAction(sender: UIButton){
        if self.choseTypeCompilation != nil{
            self.choseTypeCompilation!(false)
            self.dismiss(animated: true, completion: nil)
        }
    }

}
