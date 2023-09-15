//
//  AppDelegate.swift
//  MISSQ
//
//  Created by Vikas Kumar on 01/04/22.
//


/*
 apple
 
 Email:  info@appsmachina.com
 Pass:  L0cksley
 
 
 Nileshshelar@gmail.com
 FBSMyoga@1199

 
 
 rajitrana1994@gmail.com
 123456

 contact.rajatrana@gmail.com
 123456
 */

import UIKit
import Localize_Swift
import IQKeyboardManagerSwift
import GooglePlaces
import GoogleMaps
import AppTrackingTransparency
import FBSDKLoginKit
import GoogleSignIn
import Firebase
import Stripe
import CoreLocation
@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var bookingID: String = ""
    var serviceName: String = ""
    var serviceImage: String = ""
    var price: String = ""
    var notificationCode: String = ""
    public var userlocation : CLLocation!
    var locationManager : CLLocationManager!
    var latitute : String = ""
    var longitude : String = ""
    var address : String = ""
    var amount: Int = 0
    var sender_id: String = ""

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        IQKeyboardManager.shared.enable = true
        GMSServices.provideAPIKey("AIzaSyByn2AA0EcUDwcvbaqhsGQZOfycO9zFbis")
        GMSPlacesClient.provideAPIKey(kGooglePlaceApiKey)
        STPAPIClient.shared.publishableKey = StripeKeys.PUBLISH_KEY
        STPPaymentConfiguration.shared.publishableKey = StripeKeys.PUBLISH_KEY
        ApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)
        self.setUpPush()
        self.setUplocation()
        return true
    }
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        return (GIDSignIn.sharedInstance.handle(url))
       }
       func application(_ application: UIApplication, handleOpen url: URL) -> Bool {
           return true
       }
       func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool{
       
           return  ApplicationDelegate.shared.application(app, open: url, options: options)
       }
    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

    // MARK: UISceneSession Lifecycle
    class var sharedDelegate:AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }
    //MARK: Custom Methods
    class func getViewController(identifire: String) -> AnyObject {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if #available(iOS 13.0, *) {
            let controller:AnyObject = storyboard.instantiateViewController(identifier: identifire)as AnyObject
            (controller as? UIViewController)?.modalPresentationStyle = .overFullScreen
            return controller
        } else {
            let controller:AnyObject = storyboard.instantiateViewController(withIdentifier: identifire)as AnyObject
            return controller
        }
    }
}

extension AppDelegate {
    func instantiateVC(with identifier: String) -> UIViewController {
        return AppDelegate.getViewController(identifire: identifier) as! UIViewController
    }
    
    func SetTabbarController(type : Int = 0,selectedIndex:Int? = 0) -> UITabBarController {
            UINavigationBar.appearance().barTintColor = UIColor.AppColor()
            UINavigationBar.appearance().shadowImage = UIImage()
            UINavigationBar.appearance().tintColor = UIColor.AppColor()
          //  UINavigationBar.appearance().isTranslucent = false
      //  AppManager.getLoggedInUser()
        let imgInsets = UIEdgeInsets(top: 5, left: 0, bottom: -5, right: 0)
        let titleInsets = UIOffset(horizontal: 0, vertical: 9)
        var notofictionVC = UIViewController()
        notofictionVC = self.instantiateVC(with: "CustomerHomeVC") as! CustomerHomeVC
        notofictionVC.tabBarItem.selectedImage = #imageLiteral(resourceName: "home1").withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
        notofictionVC.tabBarItem.image = #imageLiteral(resourceName: "home").withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
      //  notofictionVC.tabBarItem.title = "Home"
        notofictionVC.tabBarItem.imageInsets = imgInsets
        notofictionVC.tabBarItem.titlePositionAdjustment = titleInsets
        let notofictionNavigation  = UINavigationController(rootViewController: notofictionVC)
        
        var healthVC = UIViewController()
        healthVC = self.instantiateVC(with: "CustomerBookingVC") as! CustomerBookingVC
        healthVC.tabBarItem.selectedImage = #imageLiteral(resourceName: "booking1").withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
        healthVC.tabBarItem.image = #imageLiteral(resourceName: "booking").withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
//        healthVC.tabBarItem.title = "Health Analytics"
        healthVC.tabBarItem.imageInsets = imgInsets
        healthVC.tabBarItem.titlePositionAdjustment = titleInsets
        let healthVCNavigation  = UINavigationController(rootViewController: healthVC)
        
       
        
        var chatVC = UIViewController()
        chatVC = self.instantiateVC(with: "CustomerChatVC") as! CustomerChatVC
        chatVC.tabBarItem.selectedImage = #imageLiteral(resourceName: "chat1").withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
        chatVC.tabBarItem.image = #imageLiteral(resourceName: "chat").withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
//        chatVC.tabBarItem.title = "Chat"
        chatVC.tabBarItem.imageInsets = imgInsets
        chatVC.tabBarItem.titlePositionAdjustment = titleInsets
        let chatVCVCNavigation  = UINavigationController(rootViewController: chatVC)
        
        
        var vsVC = UIViewController()
        vsVC = self.instantiateVC(with: "CustomerReviewVC") as! CustomerReviewVC
        vsVC.tabBarItem.selectedImage = #imageLiteral(resourceName: "like1").withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
        vsVC.tabBarItem.image = #imageLiteral(resourceName: "like").withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
//        vsVC.tabBarItem.title = "Account"
        vsVC.tabBarItem.imageInsets = imgInsets
        vsVC.tabBarItem.titlePositionAdjustment = titleInsets
        let vsVCNavigation  = UINavigationController(rootViewController: vsVC)
        
        
        
        notofictionNavigation.interactivePopGestureRecognizer?.isEnabled = false
        vsVCNavigation.interactivePopGestureRecognizer?.isEnabled = false
        
        notofictionNavigation.interactivePopGestureRecognizer?.delegate = nil
        vsVCNavigation.interactivePopGestureRecognizer?.delegate = nil
        
        let tabBarController = UITabBarController()
        tabBarController.viewControllers = [notofictionNavigation, healthVCNavigation,chatVCVCNavigation,vsVCNavigation]
        tabBarController.selectedIndex = selectedIndex ?? 0
        tabBarController.tabBar.shadowImage = UIImage()
        tabBarController.tabBar.backgroundImage = UIImage()
        tabBarController.tabBar.isTranslucent = false
        tabBarController.tabBar.backgroundColor = UIColor.AppOrangeColor()
//         tabBarController.tabBar.layer.shadowOffset = CGSize(width: 0, height: -5)
//         tabBarController.tabBar.layer.shadowRadius = 5
//         tabBarController.tabBar.layer.shadowColor = UIColor.black.cgColor
//         tabBarController.tabBar.layer.shadowOpacity = 0.1
        tabBarController.tabBar.barTintColor = UIColor.white
        tabBarController.tabBar.unselectedItemTintColor = UIColor.white
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.black], for: .normal)
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.AppOrangeColor()], for: .selected)
        if #available(iOS 15.0, *) {
            notofictionVC.tabBarItem.imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: -5, right: 0)
            healthVC.tabBarItem.imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: -5, right: 0)
            chatVC.tabBarItem.imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: -5, right: 0)
            vsVC.tabBarItem.imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: -5, right: 0)
           let appearance = UITabBarAppearance()
           appearance.configureWithOpaqueBackground()
           appearance.backgroundColor = UIColor.AppOrangeColor()
            
            let tabBarItemAppearance = UITabBarItemAppearance()
            tabBarItemAppearance.normal.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
            tabBarItemAppearance.selected.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.AppColor()]
            tabBarItemAppearance.normal.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: 9)
            tabBarItemAppearance.selected.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: 9)
            appearance.stackedLayoutAppearance = tabBarItemAppearance
            tabBarController.tabBar.standardAppearance = appearance
            tabBarController.tabBar.scrollEdgeAppearance = tabBarController.tabBar.standardAppearance
        }
        return tabBarController
     
    }
    func SetEmployeeTabbarController(type : Int = 0,selectedIndex:Int? = 0) -> UITabBarController {
            UINavigationBar.appearance().barTintColor = UIColor.AppColor()
            UINavigationBar.appearance().shadowImage = UIImage()
            UINavigationBar.appearance().tintColor = UIColor.AppColor()
          //  UINavigationBar.appearance().isTranslucent = false
      //  AppManager.getLoggedInUser()
        let imgInsets = UIEdgeInsets(top: 5, left: 0, bottom: -5, right: 0)
        let titleInsets = UIOffset(horizontal: 0, vertical: 9)
        var notofictionVC = UIViewController()
        notofictionVC = self.instantiateVC(with: "EHOmeVC") as! EHOmeVC
        notofictionVC.tabBarItem.selectedImage = #imageLiteral(resourceName: "Ehome1").withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
        notofictionVC.tabBarItem.image = #imageLiteral(resourceName: "Ehome").withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
     //   notofictionVC.tabBarItem.title = "Home"
        notofictionVC.tabBarItem.imageInsets = imgInsets
        notofictionVC.tabBarItem.titlePositionAdjustment = titleInsets
        let notofictionNavigation  = UINavigationController(rootViewController: notofictionVC)
        
        var healthVC = UIViewController()
        healthVC = self.instantiateVC(with: "EBookingVC") as! EBookingVC
        healthVC.tabBarItem.selectedImage = #imageLiteral(resourceName: "Ebookings1").withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
        healthVC.tabBarItem.image = #imageLiteral(resourceName: "Ebookings").withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
      //  healthVC.tabBarItem.title = "Booking"
        healthVC.tabBarItem.imageInsets = imgInsets
        healthVC.tabBarItem.titlePositionAdjustment = titleInsets
        let healthVCNavigation  = UINavigationController(rootViewController: healthVC)
        
       
        
        var chatVC = UIViewController()
        chatVC = self.instantiateVC(with: "EWalletVC") as! EWalletVC
        chatVC.tabBarItem.selectedImage = #imageLiteral(resourceName: "wallet1").withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
        chatVC.tabBarItem.image = #imageLiteral(resourceName: "wallet").withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
    //    chatVC.tabBarItem.title = "Wallet"
        chatVC.tabBarItem.imageInsets = imgInsets
        chatVC.tabBarItem.titlePositionAdjustment = titleInsets
        let chatVCVCNavigation  = UINavigationController(rootViewController: chatVC)
        
        
        var vsVC = UIViewController()
        vsVC = self.instantiateVC(with: "EProfileVC") as! EProfileVC
        vsVC.tabBarItem.selectedImage = #imageLiteral(resourceName: "Eprofile1").withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
        vsVC.tabBarItem.image = #imageLiteral(resourceName: "Eprofile").withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
     //   vsVC.tabBarItem.title = "Profile"
        vsVC.tabBarItem.imageInsets = imgInsets
        vsVC.tabBarItem.titlePositionAdjustment = titleInsets
        let vsVCNavigation  = UINavigationController(rootViewController: vsVC)
        
        var settingVC = UIViewController()
        settingVC = self.instantiateVC(with: "SettingVC") as! SettingVC
        settingVC.tabBarItem.selectedImage = #imageLiteral(resourceName: "Esettings1").withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
        settingVC.tabBarItem.image = #imageLiteral(resourceName: "Esettings").withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
       // settingVC.tabBarItem.title = "Setting"
        settingVC.tabBarItem.imageInsets = imgInsets
        settingVC.tabBarItem.titlePositionAdjustment = titleInsets
        let settingVCNavigation  = UINavigationController(rootViewController: settingVC)
        
        
        
        notofictionNavigation.interactivePopGestureRecognizer?.isEnabled = false
        vsVCNavigation.interactivePopGestureRecognizer?.isEnabled = false
        
        notofictionNavigation.interactivePopGestureRecognizer?.delegate = nil
        vsVCNavigation.interactivePopGestureRecognizer?.delegate = nil
        
        let tabBarController = UITabBarController()
        tabBarController.viewControllers = [notofictionNavigation, healthVCNavigation,chatVCVCNavigation,vsVCNavigation,settingVCNavigation]
        tabBarController.selectedIndex = selectedIndex ?? 0
        tabBarController.tabBar.shadowImage = UIImage()
        tabBarController.tabBar.backgroundImage = UIImage()
        tabBarController.tabBar.isTranslucent = false
        tabBarController.tabBar.backgroundColor = UIColor.AppOrangeColor()
//         tabBarController.tabBar.layer.shadowOffset = CGSize(width: 0, height: -5)
//         tabBarController.tabBar.layer.shadowRadius = 5
//         tabBarController.tabBar.layer.shadowColor = UIColor.black.cgColor
//         tabBarController.tabBar.layer.shadowOpacity = 0.1
        tabBarController.tabBar.barTintColor = UIColor.white
        tabBarController.tabBar.unselectedItemTintColor = UIColor.white
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.black], for: .normal)
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.AppOrangeColor()], for: .selected)
        if #available(iOS 15.0, *) {
            notofictionVC.tabBarItem.imageInsets = UIEdgeInsets(top: 10, left: 0, bottom: -10, right: 0)
            healthVC.tabBarItem.imageInsets = UIEdgeInsets(top: 10, left: 0, bottom: -10, right: 0)
            chatVC.tabBarItem.imageInsets = UIEdgeInsets(top: 10, left: 0, bottom: -10, right: 0)
            vsVC.tabBarItem.imageInsets = UIEdgeInsets(top: 10, left: 0, bottom: -10, right: 0)
            settingVC.tabBarItem.imageInsets = UIEdgeInsets(top: 10, left: 0, bottom: -10, right: 0)
           let appearance = UITabBarAppearance()
           appearance.configureWithOpaqueBackground()
           appearance.backgroundColor = UIColor.AppOrangeColor()
            
            let tabBarItemAppearance = UITabBarItemAppearance()
            tabBarItemAppearance.normal.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
            tabBarItemAppearance.selected.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.AppColor()]
            tabBarItemAppearance.normal.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: 9)
            tabBarItemAppearance.selected.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: 9)
            appearance.stackedLayoutAppearance = tabBarItemAppearance
            tabBarController.tabBar.standardAppearance = appearance
            tabBarController.tabBar.scrollEdgeAppearance = tabBarController.tabBar.standardAppearance
        }
        return tabBarController
     
    }
}
extension AppDelegate : MessagingDelegate,UNUserNotificationCenterDelegate{
    func setUpPush()  {
        FirebaseApp.configure()
        //MARK:- Register for Notification
        UNUserNotificationCenter.current().delegate = self
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) {
            (granted, error) in
            guard granted else { return }
            DispatchQueue.main.async {
                UIApplication.shared.registerForRemoteNotifications()
            }
        }
        Messaging.messaging().delegate = self
        let token = Messaging.messaging().fcmToken
        print("FCM token: \(token ?? "")")
        
    }
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        print("The device token \(fcmToken ?? "")")
        //Save the token to local storage and post to app server to generate Push Notification...
        UserDefaults.standard.set(fcmToken, forKey: "DeviceToken")
        // self.PostTokenToserver()
    }
    
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,  willPresent notification: UNNotification, withCompletionHandler   completionHandler: @escaping (_ options:   UNNotificationPresentationOptions) -> Void) {
        let userInformation = notification.request.content.userInfo
        
        let body = userInformation["data"] as? String
        let dic = self.convertDictioanry(str: body!)
        
        let notificationcode = "\(dic["notificationCode"] ?? "")"
        
        if notificationcode == "3" || notificationcode == "1" || notificationcode == "2" || notificationcode == "24" {
            completionHandler([])
            self.GetDateFromPush(userInfo: userInformation)
        } else if notificationcode == "8"  {
            
            
            if let tabBarController  = rootController1 as? UITabBarController , let navController = tabBarController.selectedViewController as? UINavigationController ,  let visibleViewController = navController.visibleViewController {
                let story = UIStoryboard.init(name: "Main", bundle: nil)
                if visibleViewController.isKind(of: MessageDetailVC.self) {
                    let vw = visibleViewController as! MessageDetailVC
                    if (dic["bookingId"] as? String ?? "") == vw.bookingID {
                        completionHandler([])
                        vw.GetAllMessage()
                    } else {
                        completionHandler([.alert, .badge, .sound])
                    }
                    
                    
                } else {
                    completionHandler([.alert, .badge, .sound])
                }
            }
           
        } else {
            if #available(iOS 14.0, *) {
                completionHandler([.banner, .list, .sound])
            } else {
                completionHandler([.alert, .badge, .sound])
            }
        }
        
    }
   
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        self.GetDateFromPush(userInfo: userInfo)
        
    }
    func GetDateFromPush(userInfo : [AnyHashable : Any], isTerminated : Bool = false)  {
        
        let seconds = 2.0
        DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
            let body = userInfo["data"] as? String
            let dic = self.convertDictioanry(str: body!)
            
            let data = dic["serviceDetails"] as? [String:Any]
            let name = "\(data?["name"] ?? "")"
            let image = "\(data?["image"] ?? "")"
            let serviceID = "\(data?["id"] ?? "")"
            let servicePrice = "\(data?["price"] ?? "")"
            let notificationcode = "\(dic["notificationCode"] ?? "")"
            let bookingId = "\(dic["id"] ?? "")"
            let am =  dic["amount"] as? Int ?? 0
            let sender_ids = dic["sender_id"] as? Int ?? 0
            if AppManager.isLogin() {
                
                self.notificationCode = notificationcode
                self.serviceName = name
                self.serviceImage = image
                self.price = servicePrice
                if notificationcode == "8" {
                    self.bookingID = dic["bookingId"] as? String ?? ""
                } else {
                    self.bookingID = bookingId
                }
                
                self.amount = am
                self.sender_id = "\(sender_ids)"
                NotificationCenter.default.post(name: Notification.Name("NotificationIdentifier"), object: nil)
            }
        }
    }
    
    //CONVERT STRING INTO DICTIOANRY
    func convertDictioanry(str:String) -> [String:Any]{
        var dictonary:[String:Any] = [:]
        if let data = str.data(using: String.Encoding.utf8) {
            do {
                dictonary = (try JSONSerialization.jsonObject(with: data, options: []) as? [String:AnyObject])!
            } catch let error as NSError {
                print(error)
            }
        }
        return dictonary
    }
    
}
extension AppDelegate:CLLocationManagerDelegate{
    func setUplocation() {
        locationManager = CLLocationManager()
        locationManager?.delegate = self
      //  locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            switch CLLocationManager.authorizationStatus() {
            case .notDetermined, .restricted, .denied:
                print("No access")
            case .authorizedAlways, .authorizedWhenInUse:
                locationManager.delegate = self
                locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
                locationManager.startUpdatingLocation()
            }
        } else {
           
        }
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        self.latitute = "\(locValue.latitude)"
        self.longitude = "\(locValue.longitude)"
         self.locationManager.stopUpdatingLocation()
        let loc: CLLocation = CLLocation(latitude:locValue.latitude, longitude: locValue.longitude)
        
        CLGeocoder().reverseGeocodeLocation(loc, preferredLocale: nil) { (clPlacemark: [CLPlacemark]?, error: Error?) in
            guard let pm = clPlacemark?.first else {
                print("No placemark from Apple: \(String(describing: error))")
                return
            }
            self.address = pm.postalCode ?? ""
            var addressString : String = ""
                                if pm.subLocality != nil {
                                    addressString = addressString + pm.subLocality! + ", "
                                }
                                if pm.thoroughfare != nil {
                                    addressString = addressString + pm.thoroughfare! + ", "
                                }
                                if pm.locality != nil {
                                    addressString = addressString + pm.locality! + ", "
                                }
                                if pm.country != nil {
                                    addressString = addressString + pm.country! + ", "
                                }
                                if pm.postalCode != nil {
                                    addressString = addressString + pm.postalCode! + " "
                                }
            self.address = addressString
            NotificationCenter.default.post(name: Notification.Name("locationUpdate"), object: nil)
           
        }
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined:
            
            // If status has not yet been determied, ask for authorization
            manager.requestAlwaysAuthorization()
            break
        case .authorizedWhenInUse:
            // If authorized when in use
            manager.startUpdatingLocation()
            break
        case .authorizedAlways:
            // If always authorized
            manager.startUpdatingLocation()
            break
        case .restricted:
         //   self.OPenLOcationAlert()
            // If restricted by e.g. parental controls. User can't enable Location Services
            break
        case .denied:
         //   self.OPenLOcationAlert()
            // If user denied your app access to Location Services, but can grant access from Settings.app
            break
        default:
            break
        }
    }
    
    func OPenLOcationAlert()  {
        let alert = UIAlertController(title: "Allow Location Access", message: "MISSQ needs access to your location. Turn on Location Services in your device settings.", preferredStyle: UIAlertController.Style.alert)
        
        // Button to Open Settings
        alert.addAction(UIAlertAction(title: "Settings", style: UIAlertAction.Style.default, handler: { action in
            guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                return
            }
            if UIApplication.shared.canOpenURL(settingsUrl) {
                UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                    print("Settings opened: \(success)")
                })
            }
        }))
        
      //  self.window?.rootViewController?.present(alert, animated: true, completion: nil)
    }
}


