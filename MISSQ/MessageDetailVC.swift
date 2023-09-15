//
//  MessageDetailVC.swift
//  SocketDemo
//
//  Created by Ankit Kumar on 06/09/18.
//  Copyright © 2018 Sunfoucus Solutions Pvt. Ltd. All rights reserved.
//

import UIKit
import Localize_Swift
import SocketIO
import IQKeyboardManagerSwift
import AVFoundation
import IDMPhotoBrowser


class MessageDetailVC: UIViewController ,UITableViewDataSource,UITableViewDelegate , InputbarDelegate , UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    //Properties
    @IBOutlet var tableMessage: UITableView!
    @IBOutlet weak var inputbar:Inputbar!
    @IBOutlet var toolbarBottomConstant: NSLayoutConstraint!
    @IBOutlet var toolbarHeight: NSLayoutConstraint!
    
    
    //Variables
    var arrayMessages = Array<Message> ()
    var initialsHeight : Int = 0
    var opponentID: String = ""
    var bookingID: String = ""
    var opponentImage: String = ""
   
    //MARK: Override Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
       // IQKeyboardManager.shared.enable = false
      //  MBProgressHUD.showAdded(to: self.view, animated: true)
        IQKeyboardManager.shared.disabledDistanceHandlingClasses.append(MessageDetailVC.self)
        AppManager.getLoggedInUser()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:) ), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidShow(notification:) ), name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:) ), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        self.setInputbar()
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
        
       self.GetAllMessage()
        //AppDelegate.sharedDelegate.opponentID = self.opponentID
        NotificationCenter.default.addObserver(self, selector: #selector(self.methodOfReceivedNotification), name: NSNotification.Name(rawValue: "chatNoti"), object: nil)
        
    }
    //MARK:- GET NOTIFICATION CHAT DATA
    @objc func methodOfReceivedNotification(notification: Notification){
        if let userInfoVal =   notification.object as? [String:Any] {
            let body = userInfoVal
            /*
             let dict = ["sender_id":"\(opponentID)",
                         "message": "\(message ?? "")",
                         "name" : "\(opponentName)",
                         "id" : "\(messageID)",
                         "type" : "\(messageType)"
             */
            let result = Message()
            let message = "\(body["message"] ?? "")"
            let sender_id = "\(body["sender_id"] ?? "")"
            let id = "\(body["id"] ?? "")"
            let name = "\(body["name"] ?? "")"
            let created = "\(body["created"] ?? "")"
            let message_type = "\(body["type"] ?? "")"
            let createdStr = created.split(separator: "T").first
            result.message = message
            result.opponentname = name
            result.createdAt = "\(AppManager.convertTimeStampToDate(timeStamp:Double(Int(Date().timeIntervalSince1970)), dt: "EEE MMM dd"))"
                            result.messageType = message_type
                            result.idd = id
                            result.opponentId = sender_id
            
            self.arrayMessages.append(result)
            self.tableMessage.reloadData()
            self.scrollToBottom()
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
      //  AppDelegate.sharedDelegate.opponentID = ""
     //   self.navigationController?.setNavigationBarHidden(false, animated: false)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewDidDisappear(_ animated:Bool) {
        super.viewDidDisappear(animated)
        self.view.endEditing(true)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func setInputbar() {
        self.inputbar.placeholder = nil
        self.inputbar.inputDelegate = self
        //self.inputbar.leftButton = nil
        self.inputbar.isComment = false
        // self.inputbar.leftButtonImage = #imageLiteral(resourceName: "plus")
        // self.inputbar.rightButtonTextColor = UIColor.smGreenColor()
    }
    @IBAction func BackButtonAction(sender:UIButton){
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK: - UITableview delegate methods
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  arrayMessages.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let dict = self.arrayMessages[indexPath.row]
        
        if  dict.opponentId == AppManager.getUserID()
        {
            
                let cell  = tableMessage.dequeueReusableCell(withIdentifier: "MessageSenderCell") as! MessageCell
            cell.backgroundColor = .clear
                if cell.viewContainer != nil {
                    cell.viewContainer.layer.cornerRadius = 15.0
                    cell.viewContainer.clipsToBounds = true
                }
                cell.lblText.text = dict.message
            cell.imgView.sd_setImage(with: URL(string: loggedInUser.image))
                return cell
            
            
        }else{
           
            let cell  = tableMessage.dequeueReusableCell(withIdentifier: "MessageReceiverCell") as! MessageCell
            if cell.viewContainer != nil {
                cell.viewContainer.layer.cornerRadius = 15.0
                cell.viewContainer.clipsToBounds = true
            }
            cell.backgroundColor = .clear
            cell.lblText.text = dict.message
            cell.imgView.sd_setImage(with: URL(string: self.opponentImage))
            
            return cell
            
        }
        
        
        
        
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 175
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        let dict = self.arrayMessages[indexPath.row]
        
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat{
        return 0.01
    }
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        let dict = self.arrayMessages[tapGestureRecognizer.view?.tag ?? 0]
      //  let tappedImage = tapGestureRecognizer.view as! UIImageView
        let objPhoto: IDMPhoto!
       objPhoto = IDMPhoto.init(url: URL.init(string:dict.message))
        let obJPhotoBrowser: IDMPhotoBrowser = IDMPhotoBrowser(photos: [objPhoto] ?? [])
         obJPhotoBrowser.displayActionButton = false
         self.present(obJPhotoBrowser, animated: true, completion: nil)
        
    }
    
    @objc func image(_ image: UIImage,
           didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
           if let error = error {
               print("ERROR: \(error)")
           }
       }
    @objc func ZoomImageAction(_ sender:AnyObject){
       
        print("you tap image number : \(sender.view.tag)")
        let message = arrayMessages[sender.view.tag]
        
    }
    //MARK: NSNotification Methods
    
    @objc func keyboardWillShow(notification:NSNotification) {
        let userInfo  = notification.userInfo as! Dictionary<String, Any>
        let keyboardFrame: NSValue = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue //userInfo.valueForKey(UIKeyboardFrameEndUserInfoKey) as! NSValue
        let keyboardRectangle = keyboardFrame.cgRectValue
        let keyboardHeight = keyboardRectangle.height
        print(keyboardHeight)
        self.toolbarBottomConstant.constant = keyboardHeight
        self.perform(#selector(scrollTbale), with: nil, afterDelay: 0.01)
        
    }
    
    @objc func keyboardDidShow(notification:NSNotification) {
        //self.scrollToBottom()
    }
    
    
    @objc func keyboardWillHide(notification:NSNotification) {
        self.toolbarBottomConstant.constant = 0 + CGFloat(initialsHeight)
    }
    
    // MARK: - Inputbar Delegate Methods
    
    func inputbarDidPressRightButton(inputbar:Inputbar) {
        print(opponentID)
        
        self.SendMessageApi(str: inputbar.text)
        
        
        
        
    }
    
    func inputbarDidPressLeftButton(inputbar:Inputbar) {
        self.ChooseTypeOfImage()
        
    }
    //MARK: Select Photo
    func ChooseTypeOfImage() {
        _ = UIAlertController.showActionSheetInViewController(viewController: self, withTitle:"ChooseType", message: nil, cancelButtonTitle: "Cancel", destructiveButtonTitle: nil, otherButtonTitles: ["Camera","Gallery"]) { (controller, action, index) in
            if index == 2 {
                if AVCaptureDevice.authorizationStatus(for: .video) ==  .authorized {
                    self.showCamera()
                } else {
                    AVCaptureDevice.requestAccess(for: .video, completionHandler: { (granted: Bool) in
                        if granted {
                            self.showCamera()
                        } else {
                            _ = UIAlertController.showAlertInViewController(viewController: self, withTitle:kAlertTitle , message: "Please allow camera from setting", cancelButtonTitle: "No", destructiveButtonTitle: nil, otherButtonTitles: ["Setting"], tapBlock: { (c, a, i) in
                                if i == 2 {
                                    
                                    UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
                                }
                            })
                        }
                    })
                }
            }else if index == 3 {
                self.showGallery()
            }
        }
    }
    func showCamera(){
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .camera
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    func showGallery(){
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum){
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .photoLibrary;
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    //MARK:Image Picker Delegate
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        // The info dictionary may contain multiple representations of the image. You want to use the original.
        guard let image = info[.originalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        picker.dismiss(animated: true, completion: nil);
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.SendImageApi(img:image )
        }
        
        
        
    }
    func inputbarDidChangeText(inputbar: String) {
        
    }
    func inputbarDidChangeHeight(newHeight:CGFloat) {
        toolbarHeight.constant = newHeight
    }
   
    //MARK: Custom Methods
    
    @IBAction func btnBackAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func scrollToBottom(){
        if arrayMessages.count > 0 {
            let indexPath = IndexPath(row: arrayMessages.count - 1, section: 0)
            self.tableMessage.scrollToRow(at: indexPath, at: .bottom, animated: false)
        }
    }
    
    @objc func scrollTbale(){
        self.scrollToBottom()
    }
    
    //MARK:Get MyDiaryDetail
    func GetAllMessage(){
        //get-message/1
       // ServerManager.shared.showHud()
        ServerManager.shared.httpGet(request:API_BASE_URL + "get-message/\(self.bookingID)") { (response) in
            ServerManager.shared.hidHud()
            AlertManager.shared.hideErrorView()
            if response["status"].intValue == 200 {
                self.arrayMessages.removeAll()
                let data = response["data"].arrayValue
                for msg in data{
                    let message = Message.init(parser: msg)
                    self.arrayMessages.append(message)
                }
                
                
                self.tableMessage.reloadData()
                self.scrollToBottom()
            }else{
                AlertToastManager.shared.addToast(self.view, message: response["error_message"].stringValue, position: .top)
                
            }
        } failureHandler: { (error) in
            ServerManager.shared.hidHud()
            AlertManager.shared.showErrorView(in: self.view,text:AppManager.getErrorMessage(error! as NSError),  onCompletion: {
                self.GetAllMessage()
            })
        } progressHandler: { (progress) in
            
        }
       
        
    }
    
    func SendImageApi(img:UIImage) {
              var parameter = Dictionary<String, Any>()
              parameter["otherUserId"] = self.opponentID
              parameter["type"] = "1"
              var temp = [MultipartData]()
              temp.append(MultipartData.init(medaiObject:img, mediaKey: "message"))
              ServerManager.shared.showHud()
              ServerManager.shared.httpUploadWithHeader(api: API_BASE_URL + "sendMessage",method: .post, params: parameter, multipartObject: temp, successHandler: { (JSON) in
                MBProgressHUD.hide(for: self.view, animated: true)
                  ServerManager.shared.hidHud()
                  if JSON["code"].intValue == 200{
                      let dict = JSON["body"]
                               //     let time =  AppManager.convertTimeStampToDate(timeStamp:dict["createdAt"].doubleValue, dt: "HH:mm a")
                     let created = dict["createdAt"].stringValue.split(separator: "T").first
                                      let msg = Message()
                                      msg.createdAt = "\(created ?? "")"
                                      msg.messageType = "1"
                                      msg.idd = dict["id"].stringValue
                                      msg.opponentId = AppManager.getUserID()
                                      msg.opponentname = loggedInUser.username
                      //                 msg.isOffer = dict["is_offer"].stringValue
                                      msg.message = dict["message"].stringValue
                                      self.arrayMessages.append(msg)
                                      self.tableMessage.reloadData()
                                      self.scrollToBottom()
                    return
                  }else{
                       AlertToastManager.shared.addToast(self.view, message: JSON["message"].stringValue, duration: 2.0, position: .top)
                  }
              }, failureHandler: { (error) in
                  ServerManager.shared.hidHud()
                MBProgressHUD.hide(for: self.view, animated: true)
                  AppManager.showErrorDialog(viewControler: self, message: AppManager.getErrorMessage(error! as NSError))
              }) { (progress) in
                  //self.SendImageApi(img: img)
              }
              
          }
    
    func SendMessageApi(str:String)  {
        var parameter = Dictionary<String, String>()
        parameter["friend_id"] = self.opponentID
        parameter["bookingId"] = self.bookingID
        parameter["message_type"] = "0"
        parameter["message"] = str
        
        print(parameter)
        ServerManager.shared.showHud()
        ServerManager.shared.httpPost(request: API_BASE_URL + "send-message", params: parameter, successHandler: { (response) in
            print(response)
            ServerManager.shared.hidHud()
            AlertManager.shared.hideErrorView()
            if response["status"].intValue == 200 {
                let dict = response["data"]
           //   let time =  AppManager.convertTimeStampToDate(timeStamp:dict["createdAt"].doubleValue, dt: "HH:mm a")
                let created = dict["createdAt"].stringValue.split(separator: "T").first
                let msg = Message()
                msg.createdAt = "\(created ?? "")"
                msg.messageType = "0"
                msg.idd = dict["id"].stringValue
                msg.opponentId = AppManager.getUserID()
                msg.opponentname = loggedInUser.username
//                 msg.isOffer = dict["is_offer"].stringValue
                msg.message = dict["message"].stringValue
                self.arrayMessages.append(msg)
                self.tableMessage.reloadData()
                self.scrollToBottom()
            }else{
                ServerManager.shared.errorMessage(errorCode
                    : response["success"].intValue, errorMessage: response["message"].stringValue, viewController: self)
            }
        }){ (error) in
            ServerManager.shared.hidHud()
            AlertManager.shared.showErrorView(in: self.view,text:AppManager.getErrorMessage(error! as NSError),  onCompletion: {
                 self.SendMessageApi(str: str)
            })
        }
    }
    
    @IBAction func BlockBtnAction(){
       
       }

   
}
