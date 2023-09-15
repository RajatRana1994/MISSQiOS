//
//  NotificationView.swift
//  MobiDoctor
//
//  Created by Ankit Kumar on 11/01/18.
//  Copyright © 2018 Sunfoucus Solutions Pvt. Ltd. All rights reserved.
//


import UIKit
extension NotificationView{
    
}
class NotificationUtility: NSObject
{
    
    override init() {
        super.init()
    }
    static let notifViewheight:CGFloat = 64.0
    static let titleFontSize:Float = 14.0
    static let titleColor:UIColor = UIColor.darkGray
    static let messageHeight:CGFloat = 35.0
    static let messageFontSize:Float = 13.0
    static let messageColor:UIColor = UIColor.darkGray
    static let iconCornerRadius:Float = 3.0
    static let iconFrame:CGRect = CGRect(x:15.0,y: 8.0,width: 20.0,height: 20.0)
    static let ShowingDuration:TimeInterval =   0.5
    static let hidingDuration:TimeInterval =   7.0
    
    
    
    class func dragHandlerFrame()->CGRect {
        return  CGRect(x:  UIScreen.main.bounds.size.width/2 - 30.0 ,y: self.notifViewheight - 5.0,width: 60.0,height: 3.0)
    }
    
    class func titleFrame(isImage:Bool = true)->CGRect {
        if isImage {
            return  CGRect(x:45.0,y: 3.0,width: UIScreen.main.bounds.size.width-45.0,height: 26.0)
        }else{
            return  CGRect(x:5.0,y: 3.0,width: UIScreen.main.bounds.size.width-5.0,height: 26.0)
        }
    }
    
    
    class func messageFrame(isImage:Bool = true)->CGRect {
        if isImage {
            return CGRect(x:45.0,y: 25.0,width: UIScreen.main.bounds.size.width-45.0,height: messageHeight)
        }else{
            return  CGRect(x:5.0,y: 25.0,width: UIScreen.main.bounds.size.width-5.0,height: messageHeight)
        }
    }
    
    
    
    
}

typealias NotificationOnComplition = (_ animated:Bool)->Void

class NotificationView: UIToolbar , UIGestureRecognizerDelegate{
    var _isDragging : Bool! = false
    var isVerticalPan : Bool! = false
    var _timerHideAuto : Timer?
    
    var onTouchHandler : NotificationOnComplition? = nil
    class var shared: NotificationView {
        struct Static {
            static let instance: NotificationView = NotificationView()
        }
        return Static.instance
    }
    
    
    lazy var imgIcon :UIImageView = {
        let launcher = UIImageView()
        return launcher
    }()
    lazy var _lblTitle :UILabel = {
        let launcher = UILabel()
        return launcher
    }()
    lazy var _lblMessage :UILabel = {
        let launcher = UILabel()
        return launcher
    }()
    lazy var _dragHandler :UIView = {
        let launcher = UIView()
        
        return launcher
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    init(){
        let rect:CGRect = CGRect(x: 0.0, y: 0.0, width:UIScreen.main.bounds.size.width, height: NotificationUtility.notifViewheight)
        super.init(frame: rect)
        if UIDevice.current.isGeneratingDeviceOrientationNotifications == false{
            UIDevice.current.beginGeneratingDeviceOrientationNotifications()
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(NotificationView.orientationStatusDidChange), name:UIDevice.orientationDidChangeNotification, object: nil)
        setUpUI()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUpUI(){
        self.barTintColor = UIColor.white
        self.isTranslucent = true
        self.barStyle = .default
        self.layer.zPosition = CGFloat(MAXFLOAT)
        self.backgroundColor = UIColor.clear
        self.isMultipleTouchEnabled = false
        self.isExclusiveTouch = true
        self.frame = CGRect(x: 0.0, y: 0.0, width:UIScreen.main.bounds.size.width, height: NotificationUtility.notifViewheight)
        /// Icon
        imgIcon.frame = NotificationUtility.iconFrame//IMAGE_VIEW_ICON_FRAME
        imgIcon.contentMode = .scaleAspectFill
        imgIcon.layer.cornerRadius = CGFloat(NotificationUtility.iconCornerRadius)
        imgIcon.clipsToBounds = true
        
        if (imgIcon.superview == nil) {
            self.addSubview(imgIcon)
        }
        /// Title
        _lblTitle.frame = NotificationUtility.titleFrame()//LABEL_TITLE_FRAME
        _lblTitle.textColor = NotificationUtility.titleColor//LABEL_TITLE_COLOR
        _lblTitle.font = UIFont(name: "HelveticaNeue-Bold", size: CGFloat(NotificationUtility.titleFontSize))
        _lblTitle.numberOfLines = 1
        if (_lblTitle.superview == nil) {
            self.addSubview(_lblTitle)
        }
        
        /// Message
        _lblMessage.frame = NotificationUtility.messageFrame()//LABEL_MESSAGE_FRAME
        _lblMessage.textColor = NotificationUtility.messageColor///LABEL_MESSAGE_COLOR
        _lblMessage.font = UIFont(name: "HelveticaNeue", size: CGFloat(NotificationUtility.messageFontSize))
        _lblMessage.numberOfLines = 2
        _lblMessage.lineBreakMode = .byTruncatingTail
        if (_lblMessage.superview == nil) {
            self.addSubview(_lblMessage)
        }
        fixLabelMessageSize()
        //Drag Handler
        
        _dragHandler.frame = NotificationUtility.dragHandlerFrame() //DRAG_HANDLER_FRAME
        _dragHandler.layer.cornerRadius = 2
        _dragHandler.backgroundColor = UIColor.white
        if (_dragHandler.superview == nil) {
            self.addSubview(_dragHandler)
        }
        
        let tapGesture : UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(NotificationView.notificationViewDidTap))
        self.addGestureRecognizer(tapGesture)
        tapGesture.delegate = self
        let panGesture : UIPanGestureRecognizer = UIPanGestureRecognizer(target: self, action:#selector(NotificationView.notificationViewDidPan))
        panGesture.delegate = self
        
        self.addGestureRecognizer(panGesture)
        
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let shadowPath : UIBezierPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: 4.0)
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width:0, height:3);
        self.layer.shadowOpacity = 0.5;
        self.layer.shadowRadius = 8
        self.layer.shadowPath = shadowPath.cgPath;
        
    }
    
    func showNotificationView(image : UIImage? , withTitle title: String?,withMessage message:String?,AutoHide isAutoHide:Bool!,onTouchHandler onTouch:NotificationOnComplition? ){
        /// Invalidate _timerHideAuto
        if ((_timerHideAuto) != nil) {
            _timerHideAuto?.invalidate()
            _timerHideAuto = nil;
        }
        
        /// onTouch
        onTouchHandler = onTouch
        //Image
        if (image != nil) {
            
            imgIcon.image = image
            
        }
        else{
            imgIcon.image = nil
            _lblTitle.frame = NotificationUtility.titleFrame(isImage: false)//LABEL_TITLE_FRAME_WITHOUT_IMAGE
            _lblMessage.frame = NotificationUtility.messageFrame(isImage: false)//LABEL_MESSAGE_FRAME_WITHOUT_IMAGE
        }
        
        //Title
        
        if (title != nil)
        {
            _lblTitle.text = title!
        }
        else{
            _lblTitle.text = ""
        }
        
        //Message
        
        if (message != nil)
        {
            _lblMessage.text = message!
        }
        else{
            _lblMessage.text = ""
        }
        
        fixLabelMessageSize()
        /// Prepare frame
        var frame : CGRect = self.frame
        frame.origin.y = -frame.size.height
        
        self.frame = frame
        
        //Add to window
        UIApplication.shared.delegate?.window??.windowLevel = UIWindow.Level.statusBar
        UIApplication.shared.delegate?.window??.addSubview(self)
        
        // show animation
        
        UIView.animate( withDuration: NotificationUtility.ShowingDuration, delay: 0.0, options: .curveEaseOut, animations: {
            var frame : CGRect = self.frame
            frame.origin.y = frame.origin.y+frame.size.height
            self.frame = frame
        }) { (finished:Bool) in
            
        }
        // Schedule to hide
        if isAutoHide  == true
        {
            
            _timerHideAuto = Timer.scheduledTimer(timeInterval: NotificationUtility.ShowingDuration, target: self, selector: #selector(NotificationView.hideNotificationView), userInfo: nil, repeats: false)
            
        }
    }
    
    func hideNotificationView(){
        self.hideNotificationView(onComplete: nil)
    }
    func hideNotificationView(onComplete : NotificationOnComplition?){
        if _isDragging == false
        {
            
            UIView.animate( withDuration: NotificationUtility.hidingDuration, delay: 0.0, options: .curveEaseOut, animations: {
                var frame : CGRect = self.frame
                frame.origin.y = frame.origin.y-frame.size.height
                self.frame = frame
            }) { (finished:Bool) in
                self.removeFromSuperview()
                UIApplication.shared.delegate?.window??.windowLevel = UIWindow.Level.normal
                /// Invalidate _timerHideAuto
                if ((self._timerHideAuto) != nil) {
                    self._timerHideAuto?.invalidate()
                    self._timerHideAuto = nil;
                }
                if (onComplete != nil){
                    onComplete!(true)
                }
            }
        }
        else{
            /// Invalidate _timerHideAuto
            if ((self._timerHideAuto) != nil) {
                self._timerHideAuto?.invalidate()
                self._timerHideAuto = nil;
            }
        }
    }
    //MARK:-notificationViewDidTap
    @objc func notificationViewDidTap(gesture : UIGestureRecognizer){
        
        if (onTouchHandler != nil) {
            onTouchHandler!(true)
        }
    }
    //MARK:-notificationViewDidPan
    @objc  func notificationViewDidPan(gesture : UIPanGestureRecognizer){
        
        if gesture.state == .ended {
            _isDragging = false
            if self.frame.origin.y < 0 || _timerHideAuto == nil
            {
                hideNotificationView()
            }
        }
        else if gesture.state == .began{
            _isDragging = true
        }
        else if gesture.state == .changed{
            let translation : CGPoint = gesture.translation(in: self.superview)
            // Figure out where the user is trying to drag the view.
            let newCenter : CGPoint = CGPoint(x: self.superview!.bounds.size.width / 2, y: gesture.view!.center.y + translation.y)
            // See if the new position is in bounds.
            if newCenter.y >= (-1*NotificationUtility.notifViewheight/2) && newCenter.y <= NotificationUtility.notifViewheight/2 {
                gesture.view?.center = newCenter
                
                gesture.setTranslation(.zero, in: self.superview)
            }
        }
        
    }
    
    //MARK:-GESTURE DELEGATE
    override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        
        if gestureRecognizer.isKind(of:UIPanGestureRecognizer.self) {
            let panGestureRecognizer : UIPanGestureRecognizer = gestureRecognizer as! UIPanGestureRecognizer
            let translation : CGPoint = panGestureRecognizer.translation(in: self)
            isVerticalPan = fabs(translation.y) > fabs(translation.x) // BOOL property
            return true
        }
        else if gestureRecognizer.isKind(of: UITapGestureRecognizer.self){
            let tapGestureRecognizer : UITapGestureRecognizer = gestureRecognizer as! UITapGestureRecognizer
            notificationViewDidTap(gesture: tapGestureRecognizer)
            return false
        }
        else{
            return false
        }
    }
    
    //MARK:-HELPER
    func fixLabelMessageSize(){
        let size : CGSize = _lblMessage.sizeThatFits(CGSize(width: UIScreen.main.bounds.size.width - 45.0, height: CGFloat(MAXFLOAT)))
        var frame : CGRect  = _lblMessage.frame
        
        frame.size.height = (size.height > NotificationUtility.messageHeight ? NotificationUtility.messageHeight : size.height)
        _lblMessage.frame = frame
        
        
    }
    //MARK:- - ORIENTATION NOTIFICATION
    
    @objc func orientationStatusDidChange(notification:NSNotification){
        
        setUpUI()
    }
    
    //MARK:- UTILITY FUNCS
    class func showNotificationView(image : UIImage? , withTitle title: String?,withMessage message:String?){
        NotificationView.shared.showNotificationView(image: image, withTitle: title, withMessage: message, AutoHide: true, onTouchHandler: nil)
    }
    
    class func showNotificationView(image : UIImage? , withTitle title: String?,withMessage message:String?,AutoHide isAutoHide:Bool!){
        
        NotificationView.shared.showNotificationView(image: image, withTitle: title, withMessage: message, AutoHide: isAutoHide, onTouchHandler: nil)
    }
    class func showNotificationView(image : UIImage? , withTitle title: String?,withMessage message:String?,AutoHide isAutoHide:Bool!,onTouchHandler onTouch:NotificationOnComplition? ){
        NotificationView.shared.showNotificationView(image: image, withTitle: title, withMessage: message, AutoHide: isAutoHide, onTouchHandler: onTouch)
    }
    @objc class func hideNotificationView(){
        NotificationView.hideNotificationViewOnComplete(onComplete: nil)
    }
    class func hideNotificationViewOnComplete(onComplete : NotificationOnComplition?){
        NotificationView.shared.hideNotificationView(onComplete: onComplete)
    }
    
}




