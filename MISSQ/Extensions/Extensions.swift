//
//  Extensions.swift
//  Caveman
//
//  Created by Jitendra Kumar on 28/11/16.
//  Copyright © 2016 AsthaSachdeva. All rights reserved.
//

import UIKit
import Dispatch
import Foundation
import AVFoundation
struct ScreenSize {
    static let width = UIScreen.main.bounds.size.width
    static let height = UIScreen.main.bounds.size.height
    static let frame = CGRect(x: 0, y: 0, width: ScreenSize.width, height: ScreenSize.height)
    static let maxWH = max(ScreenSize.width, ScreenSize.height)
}
struct DeviceType {
    static let iPhone4orLess  = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.maxWH < 568.0
    static let iPhone5orSE    = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.maxWH == 568.0
    static let iPhone678      = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.maxWH == 667.0
    static let iPhone678p     = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.maxWH == 736.0
    static let iPhoneX_Xs        = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.maxWH == 812.0
    static let iPhoneXR_XSMAx        = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.maxWH == 896.0
}

//--------------MARK:- NSUserDefaults Extension -
enum PRODUCT_TYPE {
    case new
    case edit
}

enum SHARE_TYPE {
    case invite
    case share
}

enum REPORT_TYPE {
    case user
    case item
}

enum RATE_TYPE {
    case user
    case item
}
enum BLOCK_TYPE {
    case fromMsg
    case fromProfile
}

enum HOME_TYPE {
    case normal
    case category
    case follow
    case evrything
}

enum PICKER_TYPE {
    case profile
    case signUp
}
enum CODE_PICKER_TYPE {
    case settings
    case signUp

}
extension UIView {
    func pushTransition(duration:CFTimeInterval) {
        let animation:CATransition = CATransition()
        animation.timingFunction = CAMediaTimingFunction(name:
            CAMediaTimingFunctionName.easeInEaseOut)
        animation.type = CATransitionType.moveIn
        animation.subtype = CATransitionSubtype.fromLeft
        animation.duration = duration
        animation.repeatCount = 99
        self.layer.add(animation, forKey: CATransitionType.push.rawValue)
    }
  
        
        func roundCorners(_ corners: UIRectCorner, radius: CGFloat) {
            if #available(iOS 11.0, *) {
                ///clipsToBounds = true
                layer.cornerRadius = radius
                layer.maskedCorners = CACornerMask(rawValue: corners.rawValue)
            } else{
            let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
            let mask = CAShapeLayer()
            mask.path = path.cgPath
            self.layer.mask = mask
            }
            
        }
        
    
}

extension TimeInterval {
    private var milliseconds: Int {
        return Int((truncatingRemainder(dividingBy: 1)) * 1000)
    }
    private var seconds: Int {
        return Int(self) % 60
    }
    private var minutes: Int {
        return (Int(self) / 60 ) % 60
    }
    private var hours: Int {
        return Int(self) / 3600
    }
    
    var stringTime: String {
        if hours != 0 {
            return "\(hours).\(minutes).\(seconds)"
        } else if minutes != 0 {
            return "\(minutes).\(seconds)"
        } else {
            return "0.\(seconds)"
        }
    }
}
extension UISegmentedControl{
    func selectedSegmentTintColor(_ color: UIColor) {
        self.setTitleTextAttributes([.foregroundColor: color], for: .selected)
    }
    func unselectedSegmentTintColor(_ color: UIColor) {
        self.setTitleTextAttributes([.foregroundColor: color], for: .normal)
    }
}
extension String {
    func format(f: String) -> String {
        let myDouble = Double(f)
        let doubleStr = String(format: "%.2f", myDouble!) // "3.14"
        return doubleStr
    }
}
 extension  UILabel {
    func letsRotateLabel(rotatedValue : CGFloat)  {
        let radians = CGFloat(CGFloat(Double.pi) * rotatedValue / CGFloat(180.0))
        self.transform = CGAffineTransform(rotationAngle: radians)
    }
}

extension UserDefaults
{
    class func hasValue(key: String) -> Bool {
        return nil != self.standard.object(forKey: key)
    }
    class func SFSDefault(setIntegerValue integer: Int , forKey key : String)
    {
        UserDefaults.standard.set(integer, forKey: key)
        UserDefaults.standard.synchronize()
    }
    class func SFSDefault(setObject object: Any , forKey key : String)
    {
        UserDefaults.standard.set(object, forKey: key)
        UserDefaults.standard.synchronize()
    }
    class func SFSDefault(setValue object: Any , forKey key : String)
    {
        UserDefaults.standard.setValue(object, forKey: key)
        UserDefaults.standard.synchronize()
    }
    class func SFSDefault(setBool boolObject:Bool  , forKey key : String)
    {
        UserDefaults.standard.set(boolObject, forKey : key)
        UserDefaults.standard.synchronize()
    }
    
    
    class func SFSDefault(integerForKey  key: String) -> Int
    {
        let integerValue : Int = UserDefaults.standard.integer(forKey: key) as Int
        UserDefaults.standard.synchronize()
        
        return integerValue
    }
    class func SFSDefault(objectForKey key: String) -> Any
    {
        let object : Any = UserDefaults.standard.object(forKey: key)! as Any
        if UserDefaults.standard.object(forKey: key) != nil
        {
          return object
        }
       return ""
    }
    class func SFSDefault(valueForKey  key: String) -> Any
    {
        let value : Any = UserDefaults.standard.value(forKey: key)! as Any
        UserDefaults.standard.synchronize()
        return value
    }
    class func SFSDefault(boolForKey  key : String) -> Bool
    {
        let booleanValue : Bool = UserDefaults.standard.bool(forKey: key) as Bool
        UserDefaults.standard.synchronize()
        return booleanValue
    }
    
    class func SFSDefault(removeObjectForKey key: String)
    {
        UserDefaults.standard.removeObject(forKey: key)
        UserDefaults.standard.synchronize()
    }
    
    //Save no-premitive data
    class func SFSDefault(setArchivedDataObject object: Any , forKey key : String)
    {
        if let data  = NSKeyedArchiver.archivedData(withRootObject: object) as?  Data{
            UserDefaults.standard.set(data, forKey: key)
           UserDefaults.standard.synchronize()
        }
    }
    class func SFSDefault(getUnArchiveObjectforKey key: String) -> Any?
    {
        var objectValue : Any?
        if  let storedData  = UserDefaults.standard.object(forKey: key) as? Data
        {
            objectValue   =  NSKeyedUnarchiver.unarchiveObject(with: storedData) as Any?
            UserDefaults.standard.synchronize()
            return objectValue!;
        }
        else
        {
            objectValue = "" as Any?
            return objectValue!
        }
    }
}
extension Array {
    func randomItem() -> Element? {
        if isEmpty { return nil }
        let index = Int(arc4random_uniform(UInt32(self.count)))
        return self[index]
    }
}
extension UIColor {
   convenience init(red: Int, green: Int, blue: Int) {
       assert(red >= 0 && red <= 255, "Invalid red component")
       assert(green >= 0 && green <= 255, "Invalid green component")
       assert(blue >= 0 && blue <= 255, "Invalid blue component")

       self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
   }

   convenience init(rgb: Int) {
       self.init(
           red: (rgb >> 16) & 0xFF,
           green: (rgb >> 8) & 0xFF,
           blue: rgb & 0xFF
       )
   }
}
extension Date {
    
    func getElapsedInterval() -> String {
        
        let interval = Calendar.current.dateComponents([.year, .month, .day,.hour,.minute,.second], from: self, to: Date())
        
        if let year = interval.year, year > 0 {
            return year == 1 ? "\(year)" + " " + "year ago" :
                "\(year)" + " " + "years ago"
        } else if let month = interval.month, month > 0 {
            return month == 1 ? "\(month)" + " " + "month ago" :
                "\(month)" + " " + "months ago"
        } else if let day = interval.day, day > 0 {
            return day == 1 ? "\(day)" + " " + "day ago" :
                "\(day)" + " " + "days ago"
        }else if let hour = interval.hour, hour > 0 {
            return hour == 1 ? "\(hour)" + " " + "hour ago" :
                "\(hour)" + " " + "hours ago"
        }else if let min = interval.minute, min > 0 {
            return min == 1 ? "\(min)" + " " + "min ago" :
                "\(min)" + " " + "minutes ago"
        }else if let sec = interval.second, sec > 0 {
            return sec == 1 ? "\(sec)" + " " + "sec ago" :
                "\(sec)" + " " + "seconds ago"
        } else {
            return "a moment ago"
            
        }
        
    }
}
extension AVURLAsset {
    var fileSize: Int? {
        let keys: Set<URLResourceKey> = [.totalFileSizeKey, .fileSizeKey]
        let resourceValues = try? url.resourceValues(forKeys: keys)
        return resourceValues?.fileSize ?? resourceValues?.totalFileSize
    }
}
extension UIApplication {
    var statusBarView: UIView? {
        if responds(to: Selector("statusBar")) {
            return value(forKey: "statusBar") as? UIView
        }
        return nil
    }
}
extension Locale {
    static let currency: [String: (code: String?, symbol: String?)] = Locale.isoRegionCodes.reduce(into: [:]) {
        let locale = Locale(identifier: Locale.identifier(fromComponents: [NSLocale.Key.countryCode.rawValue: $1]))
        $0[$1] = (locale.currencyCode, locale.currencySymbol)
    }
}
extension UIColor
{
    class  func AppColor()->UIColor
    {
        return UIColor(named: "appColor")!
        
    }
    class  func AppOrangeColor()->UIColor
    {
        return UIColor(named: "AppOrangeColor")!
        
    }
    class  func AppGrayColor()->UIColor
    {
        return UIColor(named: "AppGrayColor")!
        
    }
    class  func AppLightBlueColor()->UIColor
    {
        return UIColor(red: 92.0/255.0, green: 188.0/255.0, blue: 249.0/255.0, alpha: 1.0)
        
    }
    class  func AppBlueColor()->UIColor
    {
        return UIColor(red: 34.0/255.0, green: 141.0/255.0, blue: 254.0/255.0, alpha: 1.0)
        
    }
    class  func AppBGColor()->UIColor
    {
        return UIColor(red: 239.0/255.0, green: 239.0/255.0, blue: 244.0/255.0, alpha: 1.0)
        
    }
    class  func AppTabBarIconColor()->UIColor
    {
        return UIColor(red: 126.0/255.0, green: 250.0/255.0, blue: 255.0/255.0, alpha: 1.0)
        
    }
    
    class  func MapPolylineColor()->UIColor
    {
        return UIColor(red: 0.0/255.0, green: 183.0/255.0, blue: 225.0/255.0, alpha: 1.0)
        
    }
    class  func textFieldBorderColor()->UIColor
    {
        return UIColor(red: 244.0/255.0, green: 244.0/255.0, blue: 244.0/255.0, alpha: 1.0)
        
    }

    class  func smRedColor()->UIColor
    {
        return UIColor(red: 199.0/255.0, green: 49.0/255.0, blue: 32.0/255.0, alpha: 1.0)
        
    }
    class  func smCellBackGroundColor()->UIColor
    {
        return UIColor(red: 245.0/255.0, green: 245.0/255.0, blue: 245.0/255.0, alpha: 1.0)
    }
    class  func smCellSelectedColor()->UIColor
    {
        return UIColor(red: 230.0/255.0, green: 232.0/255.0, blue: 235.0/255.0, alpha: 1.0)
    }
    
    
    class func smPlaceHolderColor()->UIColor{
        
        return UIColor(red: 161.0/255.0, green: 161.0/255.0, blue: 162.0/255.0, alpha: 1.0)
    }
    class func smSeparatorColor()->UIColor{

        return UIColor(red: 249.0/255.0, green: 249.0/255.0, blue: 2492.0/255.0, alpha: 1.0)
    }
    
    class func smRGB(smRed r:CGFloat , smGrean g: CGFloat , smBlue b: CGFloat)->UIColor
    {
        return UIColor(red: r/255.0, green: g/255.0, blue: b/255.0, alpha: 1.0)
        
    }
    class  func getRandomColor() -> UIColor{
        return UIColor(red: CGFloat(drand48()), green: CGFloat(drand48()), blue: CGFloat(drand48()), alpha: 1.0)
        
    }
    
    class func smBlueColor()->UIColor{
        return UIColor(red: 82.0/255.0, green: 158.0/255.0, blue: 179.0/255.0, alpha: 1.0)
        
    }
    
    class func smLightBlueColor()->UIColor{
        return UIColor(red: 187.0/255.0, green: 216.0/255.0, blue: 224.0/255.0, alpha: 1.0)
        
    }
    
    class func smVioletColor()->UIColor{
        return UIColor(red: 158.0/255.0, green: 0.0/255.0, blue: 93.0/255.0, alpha: 1.0)
        
    }
}

extension UITabBar {
    override open func sizeThatFits(_ size: CGSize) -> CGSize {
        var sizeThatFits = super.sizeThatFits(size)
        if DeviceType.iPhone678 || DeviceType.iPhone678p{
            sizeThatFits.height = 50
        }else{
            sizeThatFits.height = 95
        }// adjust your size here
        return sizeThatFits
    }

}
extension UITableView {
    func registerNibCell(_ name: NibConstants) {
        self.register(UINib(nibName: name.rawValue, bundle: nil), forCellReuseIdentifier: name.rawValue)
    }
    func isCellVisible(section:Int, row: Int) -> Bool {
        guard let indexes = self.indexPathsForVisibleRows else {
            return false
        }
        return indexes.contains {$0.section == section && $0.row == row }
    }
}
extension UITextField
{
    func borderAndRound(color : UIColor)  {
      //  self.layer.cornerRadius = self.frame.size.height/2
     //   self.clipsToBounds = true
//        self.backgroundColor = UIColor.clear
        self.layer.borderWidth = 1.0
        self.layer.borderColor = color.cgColor
    }
    func textFieldPlaceholderColor(_ color:UIColor){
        let attibutedStr:NSAttributedString=NSAttributedString(string: self.placeholder!, attributes: [NSAttributedString.Key.foregroundColor: color]);
        //        self.attributedPlaceholder = NSAttributedString(string:placeholder,
        //            attributes:[NSForegroundColorAttributeName: color])
        
        self.attributedPlaceholder=attibutedStr
    }
    
    func setLeftPaddingImageIcon(_ imageicon:UIImage){
      self.layer.cornerRadius = self.frame.size.height/2
        self.clipsToBounds = true
//        self.backgroundColor = UIColor.clear
        self.layer.borderWidth = 1.0
        self.layer.borderColor = UIColor.smBlueColor().cgColor

        let image1: UIImage? = imageicon
        if image1 != nil {
            let view: UIView? = UIView()
            view!.frame = CGRect(x: 0, y: 0, width: self.frame.size.height, height: self.frame.size.height)
            let imageView=UIImageView()
            imageView.frame=CGRect(x: 16, y: 8, width: self.frame.size.height - 24, height: self.frame.size.height - 16)
            imageView.image=imageicon
            imageView.contentMode = .scaleAspectFit
            view?.addSubview(imageView)
            self.leftView=view
            self.leftViewMode=UITextField.ViewMode.always
            
        }
       // self.setRightPaddingView()
    }
    
    func setLeftPaddingView(){
        let paddingView=UIView()
        paddingView.frame=CGRect(x: 0, y: 0, width: 10, height: 30)
        self.leftView=paddingView
        self.layer.borderColor = UIColor.init(red: 153.0/255.0, green: 153.0/255.0, blue: 153.0/255.0, alpha: 1.0).cgColor

        self.autocorrectionType = .no
        self.leftViewMode=UITextField.ViewMode.always
    }
    
    func setRightPaddingImageIcon(_ imageicon:UIImage){
        self.layer.cornerRadius = self.frame.size.height/2
        self.clipsToBounds = true
        self.layer.borderWidth = 1.0

        let image1: UIImage? = imageicon
        if image1 != nil {
//            let view: UIView? = UIView()
//            view!.frame = CGRect(x: 0, y: 0, width: self.frame.size.height - 16, height: self.frame.size.height)

            let button = UIButton(type: .custom)
            button.setImage(imageicon, for: .normal)
            button.frame = CGRect(x: 0, y: 0, width: 10, height: 10)
            
            button.tag = tag
          //  button.addTarget(viewController, action: #selector(tapAction(_:)), for: .touchUpInside)

//            let imageView=UIImageView()
//            imageView.frame=CGRect(x: 0, y: 8, width: self.frame.size.height-30, height: self.frame.size.height-16)
//            imageView.image=imageicon
//            imageView.contentMode = .scaleAspectFit
//            imageView.isUserInteractionEnabled = true
//            let tap = UITapGestureRecognizer.init(target: <#T##Any?#>, action: )
//
//
//
//
//
//            view?.addSubview(imageView)
            self.rightView=button
            self.rightViewMode=UITextField.ViewMode.always

            
        }
    }
    
    func setRightPaddingView(){
        let paddingView=UIView()
        paddingView.frame=CGRect(x: 0, y: 0, width: 10, height: 10)
        self.rightView=paddingView
        self.rightViewMode=UITextField.ViewMode.always
    }
    
    func setLeftAndRightPadding() {
        self.setLeftPaddingView()
        self.setRightPaddingView()
       // self.setTextAlginmentWithLanguage()
    }
    
//    func setPaddingImageWithAlignment(_ paddingImage: UIImage) {
//        if AppManager.getLanguage() == kEnglish {
//            self.textAlignment = .left
//            self.setLeftPaddingImageIcon(paddingImage)
//            self.setRightPaddingView()
//        }
//        else{
//            self.textAlignment = .right
//            self.setRightPaddingImageIcon(paddingImage)
//            self.setLeftPaddingView()
//        }
//    }
//    
//    func setTextAlginmentWithLanguage() {
//        if AppManager.getLanguage() == kArbic {
//            self.textAlignment = .right
//        }else{
//            self.textAlignment = .left
//        }
//    }
    
    func setTextFieldRadiusCorner(_ cornerRadius:CGFloat){
        self.layer.cornerRadius=cornerRadius;
        self.layer.masksToBounds=true;
    }
    
    func setTextFieldBoader(_ borderW:CGFloat,borderC:UIColor){
        self.layer.borderWidth=borderW;
        self.layer.borderColor=borderC.cgColor;
    }
}
extension UITextView
{
    func setTextViewBoader(_ borderW:CGFloat,borderC:UIColor){
        self.layer.borderWidth=borderW;
        self.layer.borderColor=borderC.cgColor;
    }
}
//MARK
//MARK :- UILabel Extension
extension UILabel{
func lblEdgeCorner(){
    self.layer.cornerRadius = 5;
    self.clipsToBounds = true
}
}
//MARK
//MARK :- UIButton Extension
extension UIButton{
  
    func borderAndRound(color : UIColor,radius:CGFloat)  {
        self.layer.cornerRadius = radius
        self.clipsToBounds = true
        self.layer.borderWidth = 1.0
        self.layer.borderColor = color.cgColor
    }

    func btnBackgroundColor(){
        self.backgroundColor = UIColor.init(red: 236.0/255.0, green: 82.0/255.0, blue: 77.0/255.0, alpha: 1.0)
    }
    
    func btnDropShadow(color : UIColor,radius:CGFloat,opacity:Float) {
        self.layer.masksToBounds = false
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOpacity = opacity
        self.layer.shadowOffset = CGSize(width: -1, height: 1)
        self.layer.shadowRadius = radius
        //        self.layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        self.layer.shouldRasterize = true
        
        self.layer.rasterizationScale = UIScreen.main.scale
        
    }
    
    func enable() {
        self.backgroundColor = UIColor.AppColor()
        self.setTitleColor(UIColor.white, for: .normal)
        self.isUserInteractionEnabled = true
    }
    func desable() {
        if #available(iOS 13.0, *) {
            self.backgroundColor = UIColor.systemGray4
        } else {
            self.backgroundColor = UIColor.lightGray
        }
        self.setTitleColor(UIColor.black, for: .normal)
        self.isUserInteractionEnabled = false
    }

}
extension UIViewController{
    func AddShadow() {
        self.navigationController?.navigationBar.layer.masksToBounds = false
        self.navigationController?.navigationBar.layer.shadowColor = UIColor.lightGray.cgColor
        self.navigationController?.navigationBar.layer.shadowOpacity = 0.8
        self.navigationController?.navigationBar.layer.shadowOffset = CGSize(width: 0, height: 2.0)
        self.navigationController?.navigationBar.layer.shadowRadius = 8
    }
}
//MARK: - UINAvigationBarItems as UIView
extension UIView{
    func addAsBarButtonItem(view:UIView) -> UIView {
        view.frame = CGRect.init(x: 0, y: 20, width: 44, height: 44)
        return view
    }
    func ViewDropShadow(color : UIColor,radius:CGFloat,opacity:Float) {
        self.layer.masksToBounds = false
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOpacity = opacity
        self.layer.shadowOffset = CGSize(width: -1, height: 1)
        self.layer.shadowRadius = radius
        //        self.layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        self.layer.shouldRasterize = true
        
        self.layer.rasterizationScale = UIScreen.main.scale
        
    }
    func viewborderAndRound(color : UIColor,radius:CGFloat)  {
        self.layer.cornerRadius = radius
        self.clipsToBounds = true
        self.layer.borderWidth = 0.3
        self.layer.borderColor = color.cgColor
    }

}

//--------------MARK: - UIAlertController Extension -
let UIAlertControllerBlocksCancelButtonIndex : Int = 0;
let UIAlertControllerBlocksDestructiveButtonIndex : Int = 1;
let UIAlertControllerBlocksFirstOtherButtonIndex : Int = 2;
typealias UIAlertControllerPopoverPresentationControllerBlock = (_ popover:UIPopoverPresentationController?)->Void
typealias UIAlertControllerCompletionBlock = (_ alertController:UIAlertController?,_ action:UIAlertAction?,_ buttonIndex:Int?)->Void
extension UIAlertController{
     //MARK: - showInViewController -
    class func showInViewController(viewController:UIViewController!,withTitle title:String?,withMessage message:String?,withpreferredStyle preferredStyle:UIAlertController.Style?,cancelButtonTitle cancelTitle:String?,destructiveButtonTitle destructiveTitle:String?,otherButtonTitles otherTitles:[String?]?,popoverPresentationControllerBlock:UIAlertControllerPopoverPresentationControllerBlock?,tapBlock:UIAlertControllerCompletionBlock?) -> UIAlertController!{
        
        let strongController : UIAlertController! = UIAlertController(title: title, message: message, preferredStyle: preferredStyle!)
        strongController.view.tintColor = UIColor.black
        if (cancelTitle != nil)
        {
            let cancelAction : UIAlertAction = UIAlertAction(title: cancelTitle, style: .cancel, handler: { (action:UIAlertAction) in
                if (tapBlock != nil){
                    tapBlock!(strongController,action,UIAlertControllerBlocksCancelButtonIndex)
                }
            })
            strongController.addAction(cancelAction)
        }
        if (destructiveTitle != nil)
        {
            let destructiveAction : UIAlertAction = UIAlertAction(title: destructiveTitle, style:.destructive, handler: { (action:UIAlertAction) in
                if (tapBlock != nil){
                    tapBlock!(strongController,action,UIAlertControllerBlocksDestructiveButtonIndex)
                }
            })
            strongController.addAction(destructiveAction)
        }
        if (otherTitles != nil)
        {
            for btnx in 0..<otherTitles!.count
            {
                let otherButtonTitle:String = otherTitles![btnx]!
                
                let otherAction : UIAlertAction = UIAlertAction(title: otherButtonTitle, style: .default, handler: { (action:UIAlertAction) in
                    if (tapBlock != nil){
                        tapBlock!(strongController,action,UIAlertControllerBlocksFirstOtherButtonIndex+btnx)
                    }
                })
                strongController.addAction(otherAction)
                
            }
        }
        
        if (popoverPresentationControllerBlock != nil)
        {
            popoverPresentationControllerBlock!(strongController.popoverPresentationController!)
        }
        
        DispatchQueue.main.async {
            viewController.present(strongController, animated: true, completion:{})
        }
        
        return strongController
    }
    //MARK:- showAlertInViewController -
    class func showAlertInViewController(viewController:UIViewController!,withTitle title:String?,message:String?,cancelButtonTitle cancelTitle:String?,destructiveButtonTitle destructiveTitle:String?,otherButtonTitles otherTitles:[String?]?,tapBlock:UIAlertControllerCompletionBlock?) -> UIAlertController!{
        
        return self.showInViewController(viewController: viewController, withTitle: title, withMessage: message, withpreferredStyle:.alert, cancelButtonTitle: cancelTitle, destructiveButtonTitle: destructiveTitle, otherButtonTitles: otherTitles, popoverPresentationControllerBlock: nil, tapBlock: tapBlock)
    }
    //MARK:- showActionSheetInViewController -
    class func showActionSheetInViewController(viewController:UIViewController!,withTitle title:String?,message:String?,cancelButtonTitle cancelTitle:String?,destructiveButtonTitle destructiveTitle:String?,otherButtonTitles otherTitles:[String?]?,tapBlock:UIAlertControllerCompletionBlock?) -> UIAlertController!{
        
        return self.showInViewController(viewController: viewController, withTitle: title, withMessage: message, withpreferredStyle:.actionSheet, cancelButtonTitle: cancelTitle, destructiveButtonTitle: destructiveTitle, otherButtonTitles: otherTitles, popoverPresentationControllerBlock: nil, tapBlock: tapBlock)
    }
    class func showActionSheetInViewController(viewController:UIViewController!,withTitle title:String?,message:String?,cancelButtonTitle cancelTitle:String?,destructiveButtonTitle destructiveTitle:String?,otherButtonTitles otherTitles:[String?]?,popoverPresentationControllerBlock:UIAlertControllerPopoverPresentationControllerBlock?,tapBlock:UIAlertControllerCompletionBlock?) -> UIAlertController!{
        
        return self.showInViewController(viewController: viewController, withTitle: title, withMessage: message, withpreferredStyle:.actionSheet, cancelButtonTitle: cancelTitle, destructiveButtonTitle: destructiveTitle, otherButtonTitles: otherTitles, popoverPresentationControllerBlock: popoverPresentationControllerBlock, tapBlock: tapBlock)
    }
    
}

extension String{
    func floatValue() -> Float? {
        if let floatval = Float(self) {
            return floatval
        }
        return nil
    }

    var isValidateSecialPassword : Bool {
        
        if(self.count>=8 && self.count<=20){
        }else{
            return false
        }
        let nonUpperCase = CharacterSet(charactersIn: "ABCDEFGHIJKLMNOPQRSTUVWXYZ").inverted
        let letters = self.components(separatedBy: nonUpperCase)
        let strUpper: String = letters.joined()
        
        let smallLetterRegEx  = ".*[a-z]+.*"
        let samlltest = NSPredicate(format:"SELF MATCHES %@", smallLetterRegEx)
        let smallresult = samlltest.evaluate(with: self)
        
        let numberRegEx  = ".*[0-9]+.*"
        let numbertest = NSPredicate(format:"SELF MATCHES %@", numberRegEx)
        let numberresult = numbertest.evaluate(with: self)
        
        let regex = try! NSRegularExpression(pattern: ".*[^A-Za-z0-9].*", options: NSRegularExpression.Options())
        var isSpecial :Bool = false
        if regex.firstMatch(in: self, options: NSRegularExpression.MatchingOptions(), range:NSMakeRange(0, self.count)) != nil {
            print("could not handle special characters")
            isSpecial = true
        }else{
            isSpecial = false
        }
        return (strUpper.count >= 1) && smallresult && numberresult && isSpecial
    }

        func fromBase64() -> String? {
            guard let data = Data(base64Encoded: self) else {
                return nil
            }

            return String(data: data, encoding: .utf8)
        }

        func toBase64() -> String {
            return Data(self.utf8).base64EncodedString()
        }

    
        }

extension UIImageView{
    func ImageDropShadow(color : UIColor,radius:CGFloat,opacity:Float) {
       // self.layer.masksToBounds = false
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOpacity = opacity
        self.layer.shadowOffset = CGSize(width: -1, height: 1)
        self.layer.shadowRadius = radius
        //        self.layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        self.layer.shouldRasterize = true
        
        self.layer.rasterizationScale = UIScreen.main.scale
        
    }
    func ImageborderAndRound(color : UIColor,radius:CGFloat)  {
        self.layer.cornerRadius = radius
        self.clipsToBounds = true
        self.layer.borderWidth = 1.0
        self.layer.borderColor = color.cgColor
    }
}

extension UIImage {
    class func colorForNavBar(color: UIColor) -> UIImage {
        //let rect = CGRectMake(0.0, 0.0, 1.0, 1.0)
        
        let rect = CGRect(origin: CGPoint(x: 0,y :0), size: CGSize(width: 1.0, height: 1.0))
        
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        
        context!.setFillColor(color.cgColor)
        context!.fill(rect)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        
        return image!
    } 
    class func imageWithView(view: UIView) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(view.bounds.size, view.isOpaque, 0.0)
        view.drawHierarchy(in: view.bounds, afterScreenUpdates: true)
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return img!
    }
    
    func setParmentCard(cardType: String) -> UIImage{
        switch cardType {
        case "American Express":
            return #imageLiteral(resourceName: "amex")
        case "MasterCard":
            return #imageLiteral(resourceName: "mastercard")
        case "Discover":
            return #imageLiteral(resourceName: "discover")
        case "Visa":
            return #imageLiteral(resourceName: "visa")
        case "Diners Club":
            return #imageLiteral(resourceName: "diners_club")
        case "JCB":
            return #imageLiteral(resourceName: "jcb")
        case "Amazon":
            return #imageLiteral(resourceName: "amazon")
        case "Citi":
            return #imageLiteral(resourceName: "citi")
        case "Apple Pay":
            return #imageLiteral(resourceName: "apple")
        case "Android Pay":
            return #imageLiteral(resourceName: "android_pay")
        case "PayPal":
            return #imageLiteral(resourceName: "paypal")
        case "Wallet":
            return #imageLiteral(resourceName: "wallet")
        default:
            return #imageLiteral(resourceName: "reverse")
        }
    }
    
    func maskWithColor(color: UIColor) -> UIImage? {
        let maskImage = cgImage!
        
        let width = size.width
        let height = size.height
        let bounds = CGRect(x: 0, y: 0, width: width, height: height)
        
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue)
        let context = CGContext(data: nil, width: Int(width), height: Int(height), bitsPerComponent: 8, bytesPerRow: 0, space: colorSpace, bitmapInfo: bitmapInfo.rawValue)!
        
        context.clip(to: bounds, mask: maskImage)
        context.setFillColor(color.cgColor)
        context.fill(bounds)
        
        if let cgImage = context.makeImage() {
            let coloredImage = UIImage(cgImage: cgImage)
            return coloredImage
        } else {
            return nil
        }
    }

}

extension UIView {
    
    func addConstraintsWithFormat(_ format: String, views: UIView...) {
        var viewsDictionary = [String: UIView]()
        for (index, view) in views.enumerated() {
            let key = "v\(index)"
            view.translatesAutoresizingMaskIntoConstraints = false
            viewsDictionary[key] = view
        }
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: format, options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: viewsDictionary))
    }
    func addCenterConstraintsOf(item:UIView ,itemSize size:CGSize!){
        item.translatesAutoresizingMaskIntoConstraints = false
        let width : NSLayoutConstraint = NSLayoutConstraint(item: item, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1, constant: size.width)
        let height : NSLayoutConstraint = NSLayoutConstraint(item: item, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: size.height)
        let xConstraint : NSLayoutConstraint = NSLayoutConstraint(item: item, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0)
        let yConstraint : NSLayoutConstraint = NSLayoutConstraint(item: item, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0)
        NSLayoutConstraint.activate([width,height,xConstraint,yConstraint])
        item.setNeedsDisplay()
    }
}


extension DispatchQueue {
    
    static var userInteractive: DispatchQueue { return DispatchQueue.global(qos: .userInteractive) }
    static var userInitiated: DispatchQueue { return DispatchQueue.global(qos: .userInitiated) }
    static var utility: DispatchQueue { return DispatchQueue.global(qos: .utility) }
    static var background: DispatchQueue { return DispatchQueue.global(qos: .background) }
    
    func after(_ delay: TimeInterval, execute closure: @escaping () -> Void) {
        asyncAfter(deadline: .now() + delay, execute: closure)
    }
    
    func syncResult<T>(_ closure: () -> T) -> T {
        var result: T!
        sync { result = closure() }
        return result
    }
}

extension UIImageView{
    open override func awakeFromNib() {
        super.awakeFromNib()
        let tag = self.tag
        if tag == 999 {
            let img = UIImage(named: "drop")?.maskWithColor(color: UIColor.AppColor())
            self.image =  img
            self.contentMode = .scaleAspectFit
        }
    }
}
extension UITabBarController {

    func setBadges(badgeValues: [Int]) {

        for view in self.tabBar.subviews {
            if view is CustomTabBadge {
                view.removeFromSuperview()
            }
        }

        for index in 0...badgeValues.count-1 {
            if badgeValues[index] != 0 {
                addBadge(index: index, value: badgeValues[index], color: UIColor.blue, font: UIFont(name: "Helvetica-Light", size: 11)!)
            }
        }
    }

    func addBadge(index: Int, value: Int, color: UIColor, font: UIFont) {
        let badgeView = CustomTabBadge()

        badgeView.clipsToBounds = true
        badgeView.textColor = UIColor.white
        badgeView.textAlignment = .center
        badgeView.font = font
        badgeView.text = value == 0 ? "" : String(value)
        badgeView.textColor = .AppColor()
        badgeView.backgroundColor = color
        badgeView.tag = index
        tabBar.addSubview(badgeView)
        if value == 0{
            for v in tabBar.subviews{
               if v is UILabel{
                  v.removeFromSuperview()
               }
            }
            badgeView.isHidden = true
        }else{
            badgeView.isHidden = false
        }
        self.positionBadges()
    }

    override open func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.positionBadges()
    }

    // Positioning
    func positionBadges() {

        var tabbarButtons = self.tabBar.subviews.filter { (view: UIView) -> Bool in
            return view.isUserInteractionEnabled // only UITabBarButton are userInteractionEnabled
        }

        tabbarButtons = tabbarButtons.sorted(by: { $0.frame.origin.x < $1.frame.origin.x })

        for view in self.tabBar.subviews {
            if view is CustomTabBadge {
                let badgeView = view as! CustomTabBadge
                self.positionBadge(badgeView: badgeView, items:tabbarButtons, index: badgeView.tag)
            }
        }
    }
    

    func positionBadge(badgeView: UIView, items: [UIView], index: Int) {

        let itemView = items[index]
        let center = itemView.center

        let xOffset: CGFloat = 12
        let yOffset: CGFloat = -14
        badgeView.frame.size = CGSize(width: 17, height: 17)
        badgeView.center = CGPoint(x: center.x + xOffset, y: center.y + yOffset)
        badgeView.layer.cornerRadius = badgeView.bounds.width/2
        tabBar.bringSubviewToFront(badgeView)
    }
}
class CustomTabBadge: UILabel {}
extension UILabel{
    open override func awakeFromNib() {
        super.awakeFromNib()
        if self.tag != 5{
        let text = self.text
        let updated = text?.replacingOccurrences(of: " ", with: "_").lowercased()
        self.text = updated?.localized()
        }
    }
}
extension UITextView{
    open override func awakeFromNib() {
        super.awakeFromNib()
        let text = self.text
        let updated = text?.replacingOccurrences(of: " ", with: "_").lowercased()
        self.text = updated?.localized()
    }
}
extension UITextField{
    open override func awakeFromNib() {
        super.awakeFromNib()
        let text = self.placeholder
        let updated = text?.replacingOccurrences(of: " ", with: "_").lowercased()
       // self.text = updated?.localized()
        self.placeholder = updated?.localized()
    }
}
extension UIButton{
    open override func awakeFromNib() {
        super.awakeFromNib()
        let text = self.titleLabel?.text
        let updated = text?.replacingOccurrences(of: " ", with: "_").lowercased()
        self.setTitle(updated?.localized(), for: .normal)
      //  self.setAttributedTitle(NSAttributedString(string: updated?.localized() ?? ""), for: .normal)
    }
}
