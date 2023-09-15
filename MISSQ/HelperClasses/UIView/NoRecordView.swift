//
//  NoRecordView.swift
//  MobiDoctor
//
//  Created by Ankit Kumar on 22/02/18.
//  Copyright © 2018 Sunfoucus Solutions Pvt. Ltd. All rights reserved.
//

import UIKit

class NoRecordView: UIView {
    typealias NoRecordViewBlock = ()->Void
    fileprivate var handler:NoRecordViewBlock!
    @IBOutlet fileprivate var btnNoRecord: UIButton!
    @IBOutlet fileprivate var customView: UIView!
    @IBOutlet fileprivate var lblNoRecord: UILabel!
    // other outlets
    
    override init(frame: CGRect) { // for using CustomView in code
        super.init(frame: frame)
        self.commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) { // for using CustomView in IB
        super.init(coder: aDecoder)
        self.commonInit()
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed("NoRecordView", owner: self, options: nil)
        guard let content = customView else { return }
      
        content.frame = self.bounds
        content.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        self.addSubview(content)
    }
    
    func onTapToRety(onCompletion:@escaping NoRecordViewBlock){
        handler = onCompletion
    }
    
    @IBAction fileprivate func btnNoRecordAction(_ sender: Any) {
        if (handler != nil) {
            handler()
        }
    }
}

class AlertManager:NSObject{
    class var shared:AlertManager{
        struct  Singlton{
            static let instance = AlertManager()
        }
        return Singlton.instance
    }
    
    lazy var errorView:NoRecordView  = {
        let view = NoRecordView(frame: .zero)
        return view
    }()
    
    func showErrorView(in view:UIView,text: String , onCompletion:
        @escaping ()->Void){
        // errorView.frame = view.frame
        view.addSubview(errorView)
        errorView.lblNoRecord.text =  text
        errorView.btnNoRecord.setTitle("Retry", for: .normal)
        AppManager.setSubViewlayout(errorView, mainView: view)
        errorView.onTapToRety {
            onCompletion()
        }
        
    }
    func showErrorViewWithoutAction(in view:UIView , text: String ){
        view.addSubview(errorView)
        errorView.lblNoRecord.text =  text
        errorView.btnNoRecord.isHidden = true
        AppManager.setSubViewlayout(errorView, mainView: view)
    }
    func hideErrorView(){
        errorView.removeFromSuperview()
        
    }
}
