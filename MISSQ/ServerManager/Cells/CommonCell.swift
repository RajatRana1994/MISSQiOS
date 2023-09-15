//
//  CommonCell.swift
//  Mobile Script
//
//  Created by Vikas Rajput on 15/09/19.
//  Copyright © 2019 Vikas Rajput. All rights reserved.
//

import UIKit
import Localize_Swift
import FSCalendar
import Cosmos
import SwiftyJSON
import IDMPhotoBrowser
class CommonCell: UITableViewCell {
    @IBOutlet weak var lblName:UILabel!
    @IBOutlet weak var pgControll:UIPageControl!
    @IBOutlet weak var rateView:CosmosView!
    @IBOutlet weak var vweBase:UIView!
    @IBOutlet weak var btnAccept:UIButton!
    @IBOutlet weak var btnCategoryVideos:UIButton!
    @IBOutlet weak var btnChat:UIButton!
    @IBOutlet weak var btnUpvote1:UIButton!
    @IBOutlet weak var btnUpvote2:UIButton!
    @IBOutlet weak var btnProfileOne:UIButton!
    @IBOutlet weak var btnProfile2:UIButton!
    @IBOutlet weak var imgProfile:UIImageView!
    @IBOutlet weak var imgThumbOne:UIImageView!
    @IBOutlet weak var imgThumbTwo:UIImageView!
    @IBOutlet weak var imgUserOne:UIImageView!
    @IBOutlet weak var imgUserTwo:UIImageView!
    @IBOutlet weak var lblUserOne:UILabel!
    @IBOutlet weak var lblUserTwo:UILabel!
    @IBOutlet weak var lblDesc:UILabel!
    @IBOutlet weak var lblDate:UILabel!
    @IBOutlet weak var lblTime:UILabel!
    @IBOutlet weak var lblEmployeeID:UILabel!
    @IBOutlet weak var lblTrackingID:UILabel!
    @IBOutlet weak var lblAddress:UILabel!
    @IBOutlet weak var lblStatus:UILabel!
    @IBOutlet weak var btnDelete:UIButton!
    @IBOutlet weak var btnDetail:UIButton!
    @IBOutlet weak var tfValues:UITextField!
    @IBOutlet weak var tvValue:UITextView!
    @IBOutlet weak var btnViewRule:UIButton!
    @IBOutlet weak var btnPlayOne:UIButton!
    @IBOutlet weak var btnPlayTwo:UIButton!
    @IBOutlet weak var lowerLine:UIView!
    @IBOutlet weak var uperLine:UIView!
    @IBOutlet weak var tblContent: UITableView!
    @IBOutlet weak var collView: UICollectionView!
    @IBOutlet weak var trailingConstraint: NSLayoutConstraint!
   
    var arrService = [JSON]()
    var presentedView = UIViewController()
   typealias textFieldChanged = ((String,UITextField) -> Void)
    typealias textViewChanged = ((String,UITextView) -> Void)
    var textFieldChangedDelegate :textFieldChanged?
    var textViewChangedDelegate :textViewChanged?
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    func reloadTableView(){
        
    //    self.tblContent.estimatedRowHeight = UITableView.automaticDimension
    //    self.tblContent.rowHeight = UITableView.automaticDimension
        self.arrService = self.arrService.filter { (dt) in
            return dt["value"].stringValue != ""
        }
        self.tblContent.delegate = self
        self.tblContent.dataSource = self
        self.tblContent.reloadData()
        
    }
    func setTextFieldDelegate(){
        self.tfValues.delegate = self
    }
    func setTextViewDelegate(){
        self.tvValue.delegate = self
    }
   
}
extension CommonCell : UITextFieldDelegate{
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let text = textField.text,
            let textRange = Range(range, in: text) {
            let updatedText = text.replacingCharacters(in: textRange,
                                                       with: string)
            if self.textFieldChangedDelegate != nil{
                self.textFieldChangedDelegate!(updatedText, textField)
            }
        }
        return true
    }
}
extension CommonCell:UITextViewDelegate{
    func textViewDidChange(_ textView: UITextView) {
        if self.textViewChangedDelegate != nil{
            self.textViewChangedDelegate!(textView.text, textView)
        }
    }
}
extension CommonCell:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
//12237596

func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
    return 1
}

func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
   
    return self.arrService.count
    
}
func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
   
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collCell", for: indexPath as IndexPath) as! collCell
    cell.layoutIfNeeded()
    let dict = self.arrService[indexPath.row]
    cell.imgview.sd_setImage(with: URL.init(string: dict.stringValue), placeholderImage: UIImage(named: "logo"))
        return cell
    
    
}
func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    let cell = collectionView.cellForItem(at: indexPath)
    var arrImg = [IDMPhoto]()
    for img in self.arrService {
        arrImg.append(IDMPhoto(url: URL.init(string: img.stringValue)))
    }
    let browser = IDMPhotoBrowser.init(photos: arrImg)
    browser?.displayActionButton = false
    DispatchQueue.main.async {
        self.presentedView.present(browser!, animated: true, completion: nil)
    }
}
func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return CGSize(width: self.frame.width - 20, height: 201)
    
}
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let index = Int(scrollView.contentOffset.x) / Int(scrollView.frame.width)
        if self.pgControll != nil{
         self.pgControll.currentPage = index
        }
    }
  
}

class collCell : UICollectionViewCell {
    @IBOutlet weak var imgview:UIImageView!
    @IBOutlet weak var lblName:UILabel!
    @IBOutlet weak var lblTitle:UILabel!
    @IBOutlet weak var bottomCons:NSLayoutConstraint!
}
extension CommonCell:UITableViewDelegate,UITableViewDataSource{
    //MARK:Table view Methods
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  self.arrService.count
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CommonCellSUB", for: indexPath)as! CommonCell
        cell.selectionStyle = .none
        let dict = self.arrService[indexPath.row]
        
        cell.lblName.text = dict["title"].stringValue
        cell.lblDesc.text = dict["value"].stringValue
        
        return cell;
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return  UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return  UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
      
    }
   
}
