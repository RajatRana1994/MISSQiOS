//
//  BookServiceVC.swift
//  MISSQ
//
//  Created by Vikas Kumar on 03/04/22.
//

import UIKit
import Localize_Swift
import SwiftyJSON
class BookServiceVC: UIViewController {
    @IBOutlet weak var collSlider: UICollectionView!
    @IBOutlet weak var collCat: UICollectionView!
    var arrService = [JSON]()
    var index : Int = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        let timer =  Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.scrollAutomatically), userInfo: nil, repeats: true)


        self.apiGetData()
    }
    @objc func scrollAutomatically(_ timer1: Timer) {
        if index < 9{
            index += 1
            let indexPath1: IndexPath?
            indexPath1 = IndexPath.init(row: index, section: 0)
            self.collSlider.scrollToItem(at: indexPath1!, at: .right, animated: true)
        }else if index == 9{
            index = 0
            let indexPath1: IndexPath?
            indexPath1 = IndexPath.init(row: index, section: 0)
            self.collSlider.scrollToItem(at: indexPath1!, at: .left, animated: true)
        }
    }
    @IBAction func btnBackAction(sender: UIButton){
        self.navigationController?.popViewController(animated: true)
    }
    func apiGetData() {
        ServerManager.shared.showHud()
        ServerManager.shared.httpGet(request:API_BASE_URL + "services") { (response) in
            ServerManager.shared.hidHud()
            AlertManager.shared.hideErrorView()
            if response["status"].intValue == 200 {
                self.arrService = response["data"]["result"].arrayValue
                self.collCat.delegate = self
                self.collCat.dataSource = self
                self.collCat.reloadData()
            }else{
                AlertToastManager.shared.addToast(self.view, message: response["error_message"].stringValue, position: .top)
                
            }
        } failureHandler: { (error) in
            ServerManager.shared.hidHud()
            AlertManager.shared.showErrorView(in: self.view,text:AppManager.getErrorMessage(error! as NSError),  onCompletion: {
                self.apiGetData()
            })
        } progressHandler: { (progress) in
            
        }
    }
}
extension BookServiceVC:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    //12237596
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.collSlider{
        return 10
        }
        return self.arrService.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.collSlider{
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collCell", for: indexPath as IndexPath) as! collCell
        cell.layer.cornerRadius = 8
        cell.layer.borderColor = UIColor.gray.cgColor
        cell.layer.borderWidth = 2
            if indexPath.row == 0{
                cell.imgview.image = UIImage(named: "one")
                cell.lblTitle.text = "a".localized()
                cell.lblName.text = ""
                cell.bottomCons.constant = 40
            }else if indexPath.row == 1{
                cell.imgview.image = UIImage(named: "two")
                cell.lblTitle.text = "a".localized()
                cell.lblName.text = ""
                cell.bottomCons.constant = 40
            }else if indexPath.row == 2{
                cell.imgview.image = UIImage(named: "three")
                cell.lblTitle.text = "b".localized()
                cell.lblName.text = ""
                cell.bottomCons.constant = 40
            }else if indexPath.row == 3{
                cell.imgview.image = UIImage(named: "four")
                cell.lblTitle.text = "b".localized()
                cell.lblName.text = ""
                cell.bottomCons.constant = 40
            }else if indexPath.row == 4{
                cell.imgview.image = UIImage(named: "five")
                cell.lblTitle.text = "c1".localized()
                cell.lblName.text = "c2".localized()
                cell.bottomCons.constant = 80
            }else if indexPath.row == 5{
                cell.imgview.image = UIImage(named: "six")
                cell.lblTitle.text = "c1".localized()
                cell.lblName.text = "c2".localized()
                cell.bottomCons.constant = 80
            }else if indexPath.row == 6{
                cell.imgview.image = UIImage(named: "seven")
                cell.lblTitle.text = "d".localized()
                cell.lblName.text = "c2".localized()
                cell.bottomCons.constant = 80
            }else if indexPath.row == 7{
                cell.imgview.image = UIImage(named: "eight")
                cell.lblTitle.text = "d".localized()
                cell.lblName.text = "c2".localized()
                cell.bottomCons.constant = 80
            }else if indexPath.row == 8{
                cell.imgview.image = UIImage(named: "nine")
                cell.lblTitle.text = "e".localized()
                cell.lblName.text = ""
                cell.bottomCons.constant = 125
            }else if indexPath.row == 10{
                cell.imgview.image = UIImage(named: "ten")
                cell.lblTitle.text = "e".localized()
                cell.lblName.text = ""
                cell.bottomCons.constant = 125
            }
            return cell
        }else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collCell", for: indexPath as IndexPath) as! collCell
            let dict = self.arrService[indexPath.row]
            cell.imgview.sd_setImage(with: URL(string: dict["image"].stringValue), placeholderImage: UIImage(named: "app_logo"))
            cell.lblName.text = dict["name"].stringValue
                return cell
        }
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView != self.collSlider{
            let dict = self.arrService[indexPath.row]
//        let vc = AppDelegate.getViewController(identifire: "ProviderListVC") as! ProviderListVC
//        vc.hidesBottomBarWhenPushed = true
//            vc.serviceID = dict["id"].stringValue
//        self.navigationController?.pushViewController(vc, animated: true)
            
            
            let vc = AppDelegate.getViewController(identifire: "CheckOutVC") as! CheckOutVC
            vc.hidesBottomBarWhenPushed = true
            vc.dict = dict
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == self.collSlider{
        return CGSize(width: (UIScreen.main.bounds.width), height: collectionView.frame.height)
        }else{
            return CGSize(width: (UIScreen.main.bounds.width/5), height: (UIScreen.main.bounds.width/5) + 25)
        }
    }
    
  
}

