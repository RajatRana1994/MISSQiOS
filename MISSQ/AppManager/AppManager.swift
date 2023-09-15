    //
    //  LoginVC.swift
    //  WiiBeast
    //
    //  Created by sfs17 on 3/6/17.
    //  Copyright © 2017 sfs17. All rights reserved.
    //
    
    import UIKit
    import AVFoundation
    import DateToolsSwift
    
    class AppManager: NSObject  {
        public var moodCheck : String!
        public var miniPlayerCheck : String = ""
//        //MARK: - singleton -
        class var sharedInstance:AppManager {
            struct Singleton {
                static let instance = AppManager()
            }
            return Singleton.instance
        }
        
        class func OpenMailController(sentTo:String) {
            if let url = URL(string: "mailto:\(sentTo)") {
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(url)
                } else {
                    UIApplication.shared.openURL(url)
                }
            }

        }
        //MARK: - subview -
        class func setSubViewlayout(_ subView: UIView , mainView : UIView){
            subView.translatesAutoresizingMaskIntoConstraints = false
            mainView.addConstraint(NSLayoutConstraint(item: subView, attribute: .top, relatedBy: .equal, toItem: mainView, attribute: .top, multiplier: 1.0, constant: 0.0))
            
            mainView.addConstraint(NSLayoutConstraint(item: subView, attribute: .leading, relatedBy: .equal, toItem: mainView, attribute: .leading, multiplier: 1.0, constant: 0.0))
            
            mainView.addConstraint(NSLayoutConstraint(item: subView, attribute: .bottom, relatedBy: .equal, toItem: mainView, attribute: .bottom, multiplier: 1.0, constant: 0.0))
            mainView.addConstraint(NSLayoutConstraint(item: subView, attribute: .trailing, relatedBy: .equal, toItem: mainView, attribute: .trailing, multiplier: 1.0, constant: 0.0))
            
        }
        
      
        class func haveSpotifyPurchased() -> Bool {
            return UserDefaults.SFSDefault(boolForKey: kSpotifyPurchased) ? true:false
        }
        class func isLogin() -> Bool {
            return UserDefaults.SFSDefault(boolForKey: kIsLogin) ? true:false
        }
        class func isNotify() -> Bool {
            return UserDefaults.SFSDefault(boolForKey: kIsNotify) ? true:false
        }
        class func isSocial() -> Bool {
            return UserDefaults.SFSDefault(boolForKey: "social") ? true:false
        }
        class func isHaveToShowTempPopup() -> Bool {
            return UserDefaults.SFSDefault(boolForKey: kDontShowAgain) ? true:false
        }
        class func isSkippedWalkThrough() -> Bool {
            return UserDefaults.SFSDefault(boolForKey: kSkippedWalkThrough) ? true:false
        }
        class func getUserID() -> String {
            return UserDefaults.standard.object(forKey: kUserID) as? String ?? ""
        }
        class  func setUserLatitude(latitude:String) {
            UserDefaults.standard.setValue(latitude, forKey: "lat")
        }
        class  func setUserLongitude(longitude:String) {
            UserDefaults.standard.setValue(longitude, forKey: "lng")
        }
        class  func getUserLatitude() -> String{
            if UserDefaults.standard.object(forKey: "lat") != nil {
                return UserDefaults.standard.value(forKey: "lat") as! String
            }else{
                return ""
            }
        }
        
        class  func getUserLongitude() -> String{
            if UserDefaults.standard.object(forKey: "lng") != nil {
                return UserDefaults.standard.value(forKey: "lng") as! String
            }else{
                return ""
            }
           
        }
        class  func setTemperature(temp:String) {
            UserDefaults.standard.setValue(temp, forKey: "temp")
        }
        class  func getLastTemperature() -> String{
            if UserDefaults.standard.object(forKey: "temp") != nil {
                return UserDefaults.standard.value(forKey: "temp") as! String
            }else{
                return ""
            }
        }
        class func getAuthToken() -> String {
            if let token = UserDefaults.standard.value(forKey: kauthToken) as? String {
                if token.count > 0 {
                    return token
                }
                else{
                    return ""
                }
            }else{
                return ""
            }
        }
        class func getCurrentTimeStamp() -> Double{
            return Double(Int(NSDate().timeIntervalSince1970))
        }

        class func getDeviceToken() -> String {
            if let deviceToken = UserDefaults.standard.value(forKey: kDeviceToken) as? String {
                if deviceToken.count > 0 {
                    return deviceToken
                }
                else{
                    return "dfsgfhhfgh"
                }
            }else{
                return "dfsgfhhfgh"
            }
        }
        class func getLanguage() -> String {
            if let language = UserDefaults.standard.value(forKey: "language") as? String {
                return language
            }else{
                return "en"
            }
        }
        func duration(for resource: URL) -> Int {
            let asset = AVURLAsset(url: resource )
            return Int(CMTimeGetSeconds(asset.duration))
        }
        
        class func getValume() -> Float {
            if let value = UserDefaults.standard.value(forKey: valumeValue) as? Float {
                return value
            }else{
                return 0.0
            }
        }
        
        class  func settemperatureType(longitude:String) {
            UserDefaults.standard.setValue(longitude, forKey: "tmp_type")
        }
        class  func gettemperatureType() -> String{
            if UserDefaults.standard.object(forKey: "tmp_type") != nil {
                return UserDefaults.standard.value(forKey: "tmp_type") as! String
            }else{
                return ""
            }
        }
       
        
       
        class func saveLoggedInUser(currentUser: User) {
            let userData = NSKeyedArchiver.archivedData(withRootObject: currentUser)
            UserDefaults.SFSDefault(setObject: userData, forKey: kCurrentUser)
        }
        class func getLoggedInUser() {
            if AppManager.isLogin() {
                if let user = UserDefaults.standard.object(forKey: kCurrentUser) as? Data {
                    if let userData = NSKeyedUnarchiver.unarchiveObject(with: user) as? User {
                        loggedInUser = User.init()
                        loggedInUser = userData
                    }
                }
            }
        }
       class func apiGetNotificationCount(closure: @escaping (String) -> Void) {
         //   ServerManager.shared.showHud()
            ServerManager.shared.httpGet(request: API_BASE_URL + "unreadNotificationCount") { (json) in
                ServerManager.shared.hidHud()
                AlertManager.shared.hideErrorView()
                if json["code"].intValue == 200 {
                    let data = json["body"]["count"].stringValue
                   closure(data)
                }
            } failureHandler: { (error) in
                ServerManager.shared.hidHud()
               
            } progressHandler: { (progress) in
                
            }

        }
        //MARK:- Time Conversion
        class func getCardImage(cardBrandName: String) -> UIImage {
            var cardImage = UIImage()
            if cardBrandName == "visa"{
                cardImage = UIImage.init(named: "bt_ic_visa")!
            }else if cardBrandName == "master" || cardBrandName == "mastercard"{
                cardImage = UIImage.init(named: "bt_ic_mastercard")!
            }else if cardBrandName == "maestro"{
                cardImage = UIImage.init(named: "bt_ic_maestro")!
            }else if cardBrandName == "american" || cardBrandName == "american express"{
                cardImage = UIImage.init(named: "bt_ic_amex")!
            }else if cardBrandName == "discover"{
                cardImage = UIImage.init(named: "bt_ic_discover")!
            }else if cardBrandName == "diners" || cardBrandName == "diners club"{
                cardImage = UIImage.init(named: "bt_ic_diners_club")!
            }else if cardBrandName == "jcb"{
                cardImage = UIImage.init(named: "bt_ic_jcb")!
            }else if cardBrandName == "union" || cardBrandName == "unionpay"{
                cardImage = UIImage.init(named: "bt_ic_unionpay")!
            }else if cardBrandName == "hyper"{
                cardImage = UIImage.init(named: "bt_ic_hipercard")!
            }else if cardBrandName == "hipercard"{
                cardImage = UIImage.init(named: "bt_ic_unknown")!
            }
            return cardImage
        }
        class func apiGetChatNotificationCount(closure: @escaping (Int) -> Void) {
          //   ServerManager.shared.showHud()
             ServerManager.shared.httpGet(request: API_BASE_URL + "getUnreadMessageCount") { (json) in
                 ServerManager.shared.hidHud()
                 AlertManager.shared.hideErrorView()
                 if json["code"].intValue == 200 {
                     let data = json["body"]["unreadCount"].intValue
                    closure(data)
                 }
             } failureHandler: { (error) in
                 ServerManager.shared.hidHud()
                
             } progressHandler: { (progress) in
                 
             }

         }
        //MARK: - image Resize
        func resizeImage(image : UIImage , targetSize : CGSize) -> UIImage{
            let originalSize:CGSize =  image.size
            
            let widthRatio :CGFloat = targetSize.width/originalSize.width
            let heightRatio :CGFloat = targetSize.height/originalSize.height
            
            var newSize : CGSize!
            if widthRatio > heightRatio {
                newSize =  CGSize(width : originalSize.width*heightRatio ,  height : originalSize.height * heightRatio)
            }
            else{
                newSize = CGSize(width : originalSize.width * widthRatio , height : originalSize.height*widthRatio)
            }
            
            // preparing rect for new image
            
            let rect:CGRect =  CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
            UIGraphicsBeginImageContextWithOptions(newSize, false, UIScreen.main.scale)
            image .draw(in: rect)
            let newImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
            UIGraphicsEndImageContext()
            return newImage
        }
        //MARK: - email validaton -
        class  func isValidEmail(_ testStr:String) -> Bool {
            print("validate calendar: \(testStr)")
            let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
            
            let emailTest=NSPredicate(format: "SELF MATCHES %@", emailRegEx);
            if  emailTest.evaluate(with: testStr){
                return true
            }
            return false
        }
        //MARK: - phone number validation -
        class  func validPhoneNumber(_ value: String) -> Bool{
//            let PHONE_REGEX = "^\\d{3}-\\d{3}-\\d{4}$"
//            let phoneTest = NSPredicate(format: "SELF MATCHES %@", PHONE_REGEX)
//            if phoneTest.evaluate(with: value) {
//                return true
//            }
            if (value.count >= 8 && value.count <= 12) {
                return true
            }
            return false
        }
        //MARK: - set shadow -

        class func setShadowEffect(containerView item:UIView,shadowOffset offset:CGSize,shadowOpacity opacity: Float,shadowRadius radius:CGFloat){
            item.layer.shadowColor =  UIColor.darkGray.cgColor
            item.layer.shadowOffset =  offset
            item.layer.shadowOpacity=opacity
            item.layer.shadowRadius = radius
            item.layer.masksToBounds = true
            item.clipsToBounds = true
        }
        //MARK: - image with image -

        class func imageWithImage(_ image:UIImage ,scaledToSize newSize:CGSize) -> UIImage{
            UIGraphicsBeginImageContext( newSize )
            image.draw(in: CGRect(x: 0, y: 0, width: newSize.width,height: newSize.height))
            let newImage : UIImage = UIGraphicsGetImageFromCurrentImageContext()!
            UIGraphicsEndImageContext();
            return newImage
        }
        //MARK: - height from string -
        class func calculateHeightForString(_ inString:String,newWidth:CGFloat, font : UIFont) -> CGFloat{
            let messageString = inString
            let attributes = [NSAttributedString.Key.font:font]
            let attrString:NSAttributedString? = NSAttributedString(string: messageString, attributes: attributes )
            let rect:CGRect = attrString!.boundingRect(with: CGSize(width: newWidth,height: CGFloat.greatestFiniteMagnitude), options: NSStringDrawingOptions.usesLineFragmentOrigin, context:nil )//hear u will get nearer height not the exact value
            let requredSize:CGRect = rect
            return requredSize.height  //to include button's in your tableview
            
        }
        //MARK: - date from string -

        class func getDateToString(datepicker currentdate :Date )->String{
            let dateformatter = DateFormatter()
            dateformatter.dateStyle = DateFormatter.Style.medium
            dateformatter.dateFormat="dd-MMM-yyyy"
            let dateInStringFormated=dateformatter.string(from: currentdate)
            return dateInStringFormated
        }
        
        class func getFormatedDate(date:Date, format:String) -> String{
            let dateformatter1 = DateFormatter()
            dateformatter1.dateFormat = format
            let strDate  = dateformatter1.string(from: date) as String
            return strDate
        }
        class func getFormatedTimeFromTimeStamp(unixtimeInterval : Double,dt:String) -> String{
            let date = Date(timeIntervalSince1970: unixtimeInterval)
            let dateFormatter = DateFormatter()
          //  dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
            dateFormatter.locale = NSLocale.current
            dateFormatter.dateFormat = dt
            let strDate = dateFormatter.string(from: date)
            return strDate
            
        }
        class func GetDateFromStringDate(strDate:String) -> Date{
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.ZZZ"
            dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
            let date = dateFormatter.date(from:strDate )
            return date ?? Date()
        }
        class func getTodayDate(dt:String) -> String{
            let date = Date()
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = dt
            let dt = dateFormatter.string(from: date)
            return dt
        }
        class func getTodayDayName() -> String{
            let date = Date()
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "EEEE"
            let dayInWeek = dateFormatter.string(from: date)
            return dayInWeek
        }
        //Calling Function
        class func makeCallByPhoneNumber(dateString : String) {
            if let phoneCallURL:NSURL = NSURL(string:"tel://\(dateString)") {
                let application:UIApplication = UIApplication.shared
                if (application.canOpenURL(phoneCallURL as URL)) {
                    application.openURL(phoneCallURL as URL);
                }
                
            }
            
        }
        //MARK:Seconds to minutes and second
        func secondsToHoursMinutesSeconds (seconds : Int) -> String {
            return "\((seconds % 3600)/60):\(String(format: "%02d", (seconds % 3600) % 60))"
        }
        //MARK: - error message -

        class func getErrorMessage(_ error : NSError) -> String {
            var errorMessage: NSString = NSString()
            switch error.code {
            case -998:
                errorMessage = "Unknow Error";
                break;
            case -1000:
                errorMessage = "Bad URL request";
                break;
            case -1001:
                errorMessage = "The request time out";
                break;
            case -1002:
                errorMessage = "Unsupported URL";
                break;
            case -1003:
                errorMessage = "The host could not be found";
                break;
            case -1004:
                errorMessage = "The host could not be connect, Please try after some time";
                break;
            case -1005:
                errorMessage = "The network connection lost Please try agian";
                break;
            case -1009:
                errorMessage = "The internet connection appear to be offline" ;
                break;
            case -1103:
                errorMessage = "Data lenght exceed to maximum defined data";
                break;
            case -1100:
                errorMessage = "File does not exist";
                break;
            case -1013:
                errorMessage = "User authentication required";
                break;
            case -2102:
                errorMessage = "The request time out";
                break;
            default:
                errorMessage = "Server Error";
                break;
            }
            return errorMessage as String
        }
        
        class func showErrorDialog(viewControler : UIViewController , message : String) {
            _ = UIAlertController.showAlertInViewController(viewController: viewControler, withTitle: nil, message: message, cancelButtonTitle: NSLocalizedString("ok", comment: ""), destructiveButtonTitle: nil, otherButtonTitles: nil) { (controller, action , buttonIndex) in
                
            }
            
        }
        
       
        class func getCountryDialingCode() -> String  {
            var arrayCountry = [Country]()
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
                var tempArray = [Country]()
                if let countryCode = (Locale.current as NSLocale).object(forKey: .countryCode) as? String {
                    let name = AppManager.sharedInstance.countryName(from: countryCode)
                    tempArray = name.isEmpty ? arrayCountry : arrayCountry.filter({(objCity: Country) -> Bool in
                        if objCity.countryName.lowercased() == name.lowercased(){
                            return true
                        }else{
                            return false
                        }
                    })
                    if tempArray.count == 0 {
                        return "+7"
                    }else{
                        let obj = tempArray.first
                        return (obj?.countryDialingCode)!
                    }
                }else{
                    return "+7"
                }
            }
            
            return "+7"
            
        }
        
        func countryName(from countryCode: String) -> String {
            if let name = (Locale.current as NSLocale).displayName(forKey: .countryCode, value: countryCode) {
                // Country name was found
                return name
            } else {
                // Country name cannot be found
                return countryCode
            }
        }
        /*func DictionaryRemovingNulls( aDictionary param:[String:Any]) ->[String:Any]{
         var mutableRawData:[String:Any] = [String: Any]()
         for key in param.keys{
         if  let value:Any  = param[key] {
         mutableRawData = [key:"\(value)"]
         }else{
         mutableRawData = [key:""]
         }}
         return mutableRawData
         }
         */
        
        //MARK: - resize image -
        class func resizeImage(image : UIImage , targetSize : CGSize) -> UIImage{
            let originalSize:CGSize =  image.size
            let widthRatio :CGFloat = targetSize.width/originalSize.width
            let heightRatio :CGFloat = targetSize.height/originalSize.height
            var newSize : CGSize!
            if widthRatio > heightRatio {
                newSize =  CGSize(width : originalSize.width*heightRatio ,  height : originalSize.height * heightRatio)
            }
            else{
                newSize = CGSize(width : originalSize.width * widthRatio , height : originalSize.height*widthRatio)
            }
            // preparing rect for new image
            let rect:CGRect =  CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
            UIGraphicsBeginImageContextWithOptions(newSize, false, UIScreen.main.scale)
            image .draw(in: rect)
            let newImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
            UIGraphicsEndImageContext()
            return newImage
        }
        //MARK: - convert string to float -
        class func convertStringToFloat(value : String) -> CGFloat {
            if let n = NumberFormatter().number(from: value) {
                let f = CGFloat(n)
                return f
            }else{
                return 0.0
            }
        }
        class func calculateHeight(_ width: CGFloat , _ height: CGFloat , _ scaleWidth: CGFloat) -> CGFloat {
            let newHeight : CGFloat = (( height  / width ) * scaleWidth)
            return newHeight
        }
        class func resizeImageWithImage (sourceImage:UIImage, scaledToWidth: CGFloat) -> UIImage {
            let oldWidth = sourceImage.size.width
            let scaleFactor = scaledToWidth / oldWidth
            let newHeight = sourceImage.size.height * scaleFactor
            let newWidth = oldWidth * scaleFactor
            UIGraphicsBeginImageContext(CGSize(width:newWidth, height:newHeight))
            sourceImage.draw(in: CGRect(x:0, y:0, width:newWidth, height:newHeight))
            let newImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return newImage!
        }
        class func convertStringBeforeSending(text : String) -> String{
            let data: Data = text.data(using: .nonLossyASCII)!
            let strs: String = String(data: data as Data, encoding: .utf8)!
            return strs
        }
        class func convertStringAfterRecieving(text : String) -> String{
            let data: Data = text.data(using: .utf8)!
            let strs: String = String(data: data as Data, encoding: .nonLossyASCII)!
            return strs
        }
        class func daynameFromID(dayID : Int) -> String {
            switch dayID {
            case 1:
                return "Sunday"
            case 2:
                return "Monday"
            case 3:
                return "Tuesday"
            case 4:
                return "Wednessday"
            case 5:
                return "Thursday"
            case 6:
                return "Friday"
            case 7:
                return "Saturday"
            default:
                return ""
            }
        }
        
       class func getCurrentDate() -> String {
        let df = DateFormatter()
        df.dateFormat = "dd/MM/yyyy"
        let CurrentDate = df.string(from: NSDate() as Date)
        return CurrentDate
        }
        class func convertTimeStampToDate(timeStamp : Double , dt : String) -> String {
        
            let date = Date(timeIntervalSince1970: timeStamp)
            let dateFormatter = DateFormatter()
            dateFormatter.timeZone = NSTimeZone.local as TimeZone? //Set timezone that you want
            dateFormatter.locale = NSLocale.current
            dateFormatter.dateFormat = dt //Specify your format that you want
            var strDate: String? = dateFormatter.string(from: date)
            if strDate == nil {
                strDate = ""
            }
            return strDate!
}
        class func checkMaxLength(textField: UITextField!, maxLength: Int , range : NSRange) -> Bool {
            if (textField.text?.count)! >= maxLength && range.length == 0 {
                return false
            }else {
                return true
            }
        }
        class func compairTwoTimes(startTime: String , endTime: String) ->Bool {
            var startTimeArray = startTime.components(separatedBy: ":")
            let startHours: String = startTimeArray[0]
            let startMinutes: String = startTimeArray[1]
            var endTimeArray = endTime.components(separatedBy: ":")
            let endHours: String = endTimeArray[0]
            let endMinutes: String = endTimeArray[1]
            if Int(startHours)! < Int(endHours)! {
                return true
            }
            else if Int(startHours)! == Int(endHours)! {
                if Int(startMinutes)! == Int(endMinutes)!{
                    return false
                }else if Int(startMinutes)! < Int(endMinutes)!{
                    return true
                }
                else{
                    return false
                }
            }else{
                return false
            }
        }
        //MARK: - SetRGB -
        class func m_setRGB(red:CGFloat, green:CGFloat, blue:CGFloat) -> UIColor{
            return UIColor(red: red/255.0, green: green/255.0, blue: blue/255.0, alpha: 1.0)
        }
        //MARK: - Corner Radius/Border TO TEXT FIELD -
        class func setBorderOnTextField(textField: UITextField,with radius:CGFloat) -> Void {
            textField.layer.cornerRadius = radius
            textField.layer.borderWidth = 1.5
            textField.layer.borderColor = UIColor.init(red: 0.66, green: 0.66, blue: 0.66, alpha: 1.0).cgColor
        }
        //MARK: - Corner Radius/Border TO TEXT VIEW -
        class func setBorderOnTextView(textView: UITextView,with radius:CGFloat) -> Void {
            textView.layer.cornerRadius = radius
            textView.layer.borderWidth = 1.5
            textView.layer.borderColor = UIColor.init(red: 0.66, green: 0.66, blue: 0.66, alpha: 1.0).cgColor
        }
        //MARK: - PADDING TO TEXT FIELD -
        class func setLeftViewOnTextField(textField: UITextField) -> Void {
            let paddingView = UIView.init(frame: CGRect.init(x: 0.0, y: 0.0, width: 10.0, height: 20.0))
            textField.leftView = paddingView
            textField.leftViewMode = UITextField.ViewMode.always
        }
        class func setLeftImageViewOnTextField(textField: UITextField, WithImage imageName:UIImage) -> Void {
            let paddingView = UIView.init(frame: CGRect.init(x: 0.0, y: 0.0, width: 50.0, height: textField.frame.size.height))
            let paddingImage = UIImageView(frame: CGRect(x: 14, y: 14, width: textField.frame.size.height-28, height: textField.frame.size.height-28))
            paddingImage.image = imageName
            paddingImage.contentMode = .scaleAspectFit
            paddingView.addSubview(paddingImage)
            textField.leftView = paddingView
            textField.leftViewMode = UITextField.ViewMode.always
            
        }
        class func setRightImageViewOnTextField(textField: UITextField, WithImage imageName:UIImage) -> Void {
            let paddingView = UIView.init(frame: CGRect.init(x: 0.0, y: 0.0, width: 50.0, height: textField.frame.size.height))
            let paddingImage = UIImageView(frame: CGRect(x: 5, y: 5, width: textField.frame.size.height-10, height: textField.frame.size.height-10))
            paddingImage.image = imageName
            paddingImage.contentMode = .scaleAspectFit
            paddingView.addSubview(paddingImage)
            textField.rightView = paddingView
            textField.rightViewMode = UITextField.ViewMode.always
            
        }
        //MARK: - give shadow and corner radius to view -
        class func m_ShadowWithView(view:UIView, WithCornerRadius radius:CGFloat){
            //view.clipsToBounds = true
            view.layer.cornerRadius = radius
            view.layer.shadowOffset = CGSize(width: 0, height: 0)
            view.layer.shadowRadius = 3
            view.layer.shadowOpacity = 0.2
        }
        class func m_BorderWithcolor(view:UIView, WithColor color:UIColor){
            view.layer.borderWidth = 1.0
            view.layer.borderColor = color.cgColor;
            view.layer.masksToBounds = false
        }
        class func m_MakeCallToNumber(number:NSString){
            guard let number = URL(string: "telprompt://\(number)") else { return }
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(number)
            } else {
                UIApplication.shared.openURL(number)
            }
        }
        
        class  func shakeTextField(textField: UITextField, withText:String, currentText:String) -> Void {
            textField.text = ""
            textField.attributedPlaceholder = NSAttributedString(string: currentText,
                                                                 attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
            let isSecured = textField.isSecureTextEntry
            let animation = CABasicAnimation(keyPath: "position")
            animation.duration = 0.10
            animation.repeatCount = 2
            animation.autoreverses = true
            animation.fromValue = NSValue(cgPoint:CGPoint.init(x: textField.center.x - 10, y: textField.center.y) )
            animation.toValue = NSValue(cgPoint: CGPoint.init(x: textField.center.x + 10, y: textField.center.y) )
            textField.layer.add(animation, forKey: "position")
            if isSecured {
                textField.isSecureTextEntry = false
            }
            textField.attributedPlaceholder = NSAttributedString(string: withText,
                                                                 attributes: [NSAttributedString.Key.foregroundColor: UIColor.red])
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.0) {
                textField.attributedPlaceholder = NSAttributedString(string: currentText,
                                                                     attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
                //  textField.placeholder = placeholder
                if isSecured {
                    textField.isSecureTextEntry = true
                }
            }
            
        }
        
        class  func shakeTextView(textView: UITextView, withText:String, currentText:String) -> Void {
//            textView.text = NSAttributedString(string: currentText,
//                                                                 attributes: [NSAttributedStringKey.foregroundColor: UIColor.lightGray])
            let isSecured = textView.isSecureTextEntry
            let animation = CABasicAnimation(keyPath: "position")
            animation.duration = 0.10
            animation.repeatCount = 2
            animation.autoreverses = true
            animation.fromValue = NSValue(cgPoint:CGPoint.init(x: textView.center.x - 10, y: textView.center.y) )
            animation.toValue = NSValue(cgPoint: CGPoint.init(x: textView.center.x + 10, y: textView.center.y) )
            textView.layer.add(animation, forKey: "position")
            if isSecured {
                textView.isSecureTextEntry = false
            }
//            textView.attributedPlaceholder = NSAttributedString(string: withText,
//                                                                 attributes: [NSAttributedStringKey.foregroundColor: UIColor.red])
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.0) {
                textView.text = withText
//                    NSAttributedString(string: currentText,attributes: [NSAttributedStringKey.foregroundColor: UIColor.lightGray])
                //  textField.placeholder = placeholder
                if isSecured {
                    textView.isSecureTextEntry = true
                }
            }
            
        }
        class func toCheckAlphaOrNumeric(string: String) -> Bool {
            let aSet = NSCharacterSet(charactersIn:"0123456789").inverted
            let compSepByCharInSet = string.components(separatedBy: aSet)
            let numberFiltered = compSepByCharInSet.joined(separator: "")
            return string == numberFiltered
        }

       
        class func ShowSuccessAlert(viewControler : UIViewController , message : String) {
            _ = UIAlertController.showAlertInViewController(viewController: viewControler, withTitle: kAlertTitle, message: message, cancelButtonTitle: NSLocalizedString("ok", comment: ""), destructiveButtonTitle: nil, otherButtonTitles: nil) { (controller, action , buttonIndex) in
                
            }
            
        }
        class func calculateTimeAgo(startTimeStamp : Double ) -> String {
            let date = Date.init(timeIntervalSince1970: startTimeStamp / 1000)
            if date.isToday {
                return (date.format(with: "hh:mm a"))
            }else if date.isYesterday{
                return "Yesterday"
            }else {
                return date.format(with: "dd/MM/yy")
            }
        }
        
        class func calculateTimeAgoForChatBubble(startTimeStamp : Double ) -> String {
            let date = Date.init(timeIntervalSince1970: startTimeStamp / 1000)
            if date.isToday {
                return (date.format(with: "hh:mm a"))
            }else {
                return date.format(with: "dd-MM-yy hh:mm a")
            }
        }
        
    }


        
    
    
    
