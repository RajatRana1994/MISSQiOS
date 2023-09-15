//
//  GetStartedVC.swift
//  MISSQ
//
//  Created by Vikas Kumar on 01/04/22.
//

import UIKit
import Localize_Swift
import GoogleSignIn
import FBSDKLoginKit
import AuthenticationServices
import LocalAuthentication
import Localize_Swift
class GetStartedVC: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    @IBAction func btnGetStart(sender: UIButton){
        let vc = AppDelegate.getViewController(identifire: "ChooseTypeVC") as! ChooseTypeVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func SocialLoginApi(socialID: String, token: String, socialType: String, email:String,userType: String, name:String)  {
        
        var deviceToken:String = ""
        if let deviceTokenVal = UserDefaults.standard.object(forKey: "DeviceToken") as? String{
            deviceToken = deviceTokenVal
        }
        var parameter = Dictionary<String, String>()
        parameter["socialId"] = socialID
        parameter["socialToken"] = token
        parameter["socialType"] = socialType
        parameter["userType"] = userType
        parameter["email"] = email
        parameter["name"] = name
        print(parameter)
        ServerManager.shared.showHud()
        ServerManager.shared.httpPost(request: API_BASE_URL + "user/soical-login", params: parameter, successHandler: { (response) in
            print(response)
            ServerManager.shared.hidHud()
            AlertManager.shared.hideErrorView()
            if response["status"].intValue == 200 {
                let data = response["data"]
                UserDefaults.SFSDefault(setValue: data["authorizationKey"].stringValue, forKey: kAuthToken)
                UserDefaults.SFSDefault(setValue: data["id"].stringValue , forKey: kUserID)
                UserDefaults.standard.set(true, forKey: kIsLogin)
                let currentUser = User.init(userData: data)
                AppManager.saveLoggedInUser(currentUser: currentUser)
                AppManager.getLoggedInUser()
                if currentUser.loginType == "1"{
                    let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
                    windowScene?.windows.first?.rootViewController = AppDelegate.sharedDelegate.SetEmployeeTabbarController()
                }else{
                    let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
                    windowScene?.windows.first?.rootViewController = AppDelegate.sharedDelegate.SetTabbarController()
                }
                
            }else{
                let vc = AppDelegate.getViewController(identifire: "GetStartedVC") as! GetStartedVC
                let nav = UINavigationController.init(rootViewController: vc)
                let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
                windowScene?.windows.first?.rootViewController = nav
                
            }
        }){ (error) in
            ServerManager.shared.hidHud()
            AlertManager.shared.showErrorView(in: self.view,text:AppManager.getErrorMessage(error! as NSError),  onCompletion: {
                self.SocialLoginApi(socialID: socialID, token: token, socialType: socialType, email: email, userType: userType, name: name)
            })
        }
    }
    //MARK:Google login btn action
    @IBAction func btnGoogleAction(semde:UIButton){
        let signInConfig = GIDConfiguration.init(clientID: "535411702392-85m2g8ket416e70h8bsiphcnafu9c3ic.apps.googleusercontent.com")
        GIDSignIn.sharedInstance.signIn(with: signInConfig, presenting: self) { user, error in
            guard error == nil else { return }
            let userId = user?.userID                  // For client-side use only!
            let idToken = user?.authentication.idToken // Safe to send to the server
            let givenName = user?.profile?.givenName
            let familyName = user?.profile?.familyName
            let email = user?.profile?.email
            let image = user?.profile?.imageURL(withDimension: 400)
            
            signUpDetail.loginType = "social"
            signUpDetail.name = "\(givenName ?? "") \(familyName ?? "")"
            signUpDetail.email = email ?? ""
            signUpDetail.socialID = userId
            signUpDetail.socialType = "2"
            signUpDetail.profilePictureStr = image?.absoluteString ?? ""
            let vc = AppDelegate.getViewController(identifire: "ChooseSocialUserTypeVC") as! ChooseSocialUserTypeVC
            vc.modalPresentationStyle = .overFullScreen
            vc.choseTypeCompilation = { (isCustomer) in
                if isCustomer{
                    self.SocialLoginApi(socialID: userId ?? "", token: idToken ?? "", socialType: "4", email: email ?? "",userType: "0", name: "\(givenName ?? "") \(familyName ?? "")")
                }else{
                    self.SocialLoginApi(socialID: userId ?? "", token: idToken ?? "", socialType: "4", email: email ?? "",userType: "1", name: "\(givenName ?? "") \(familyName ?? "")")
                }
            }
            self.present(vc, animated: true, completion: nil)
            
        }
    }
    //MARK:Facebook login btn action
    @IBAction func btnFacebookAction(semde:UIButton){
        self.FacebookLoginAction()
    }
    
    
}
extension GetStartedVC{
    //MARK:Facebook button action
    func FacebookLoginAction(){
        // Login with facebookl
        let fbLoginManager : LoginManager = LoginManager()
        fbLoginManager.logIn(permissions: ["email"], from: self) { (result, error) in
            if (error == nil){
                let fbloginresult : LoginManagerLoginResult = result!
                if fbloginresult.grantedPermissions != nil {
                    if(fbloginresult.grantedPermissions.contains("email")){
                        self.getFBUserData()
                        fbLoginManager.logOut()
                    }
                }
            }
        }
    }
    //MARK: - Get FBUser Data -
    func getFBUserData(){
        if((AccessToken.current) != nil){
            
            GraphRequest(graphPath: "me", parameters: ["fields": "id, name, first_name, last_name, picture.type(large), email ,location"]).start { (connection, result, error) -> Void in
                if (error == nil){
                    let dict_FBData = result as! [String : AnyObject]
                    print(result!)
                    
                    let  firstName = dict_FBData["first_name"]! as! String
                    let lastName = dict_FBData["last_name"]! as! String
                    let id = dict_FBData["id"]! as! String
                    let picture = dict_FBData["picture"]! as! [String:AnyObject]
                    let dataImg = picture["data"]! as! [String:AnyObject]
                    let image = dataImg["url"]! as! String
                    var email:String = ""
                    if dict_FBData.keys.contains("email"){
                        email = dict_FBData["email"] as!String
                    }
                    signUpDetail.loginType = "social"
                    signUpDetail.name = "\(firstName) \(lastName)"
                    signUpDetail.email = email
                    signUpDetail.socialID = id
                    signUpDetail.socialType = "1"
                    signUpDetail.profilePictureStr = image
                    let vc = AppDelegate.getViewController(identifire: "ChooseSocialUserTypeVC") as! ChooseSocialUserTypeVC
                    vc.modalPresentationStyle = .overFullScreen
                    vc.choseTypeCompilation = { (isCustomer) in
                        if isCustomer{
                            self.SocialLoginApi(socialID: id, token: id, socialType: "1", email: email,userType: "0", name: "\(firstName) \(lastName)")
                        }else{
                            self.SocialLoginApi(socialID: id, token: id, socialType: "1", email: email,userType: "1", name: "\(firstName) \(lastName)")
                        }
                    }
                    self.present(vc, animated: true, completion: nil)
                }
            }
        }
    }
}

@available(iOS 13.0, *)
extension GetStartedVC {
    private func setupLoginProviderView() {
        // Set button style based on device theme
        //        let isDarkTheme = view.traitCollection.userInterfaceStyle == .dark
        //        let style: ASAuthorizationAppleIDButton.Style = isDarkTheme ? .white : .white
        //
        //        // Create and Setup Apple ID Authorization Button
        //        let authorizationButton = ASAuthorizationAppleIDButton(type: .default, style: style)
        //        authorizationButton.addTarget(self, action: #selector(handleLogInWithAppleIDButtonPress), for: .touchUpInside)
        //
        //        // Add Height Constraint
        //        let heightConstraint = authorizationButton.heightAnchor.constraint(equalToConstant: 44)
        //        authorizationButton.addConstraint(heightConstraint)
        //
        //        //Add Apple ID authorization button into the stack view
        //        loginProviderStackView.addArrangedSubview(authorizationButton)
    }
    
    private func performExistingAccountSetupFlows() {
        // Prepare requests for both Apple ID and password providers.
        let requests = [ASAuthorizationAppleIDProvider().createRequest(), ASAuthorizationPasswordProvider().createRequest()]
        
        // Create an authorization controller with the given requests.
        let authorizationController = ASAuthorizationController(authorizationRequests: requests)
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
    
    @IBAction private func handleLogInWithAppleIDButtonPress() {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
}

@available(iOS 13.0, *)
extension GetStartedVC : ASAuthorizationControllerDelegate {
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
        // self.present(alert, animated: true, completion: nil)
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            
            // Create an account in your system.
            // For the purpose of this demo app, store the these details in the keychain.
            if KeychainItem.currentUserIdentifier == nil{
                KeychainItem.currentUserIdentifier = ""
            }
            if KeychainItem.currentUserIdentifier == ""{
                KeychainItem.currentUserIdentifier = appleIDCredential.user
                KeychainItem.currentUserFirstName = appleIDCredential.fullName?.givenName
                KeychainItem.currentUserLastName = appleIDCredential.fullName?.familyName
                KeychainItem.currentUserEmail = appleIDCredential.email
            }
            
            print("User Id - \(appleIDCredential.user)")
            print("User Name - \(appleIDCredential.fullName?.description ?? "N/A")")
            print("User Email - \(appleIDCredential.email ?? "N/A")")
            print("Real User Status - \(appleIDCredential.realUserStatus.rawValue)")
            
            if let identityTokenData = appleIDCredential.identityToken,
               let identityTokenString = String(data: identityTokenData, encoding: .utf8) {
                print("Identity Token \(identityTokenString)")
            }
            var email =  (KeychainItem.currentUserEmail ?? "") as String
            signUpDetail.loginType = "social"
            signUpDetail.name = "\(KeychainItem.currentUserFirstName ?? "") \(KeychainItem.currentUserLastName ?? "")"
            signUpDetail.email = email
            signUpDetail.socialID = KeychainItem.currentUserIdentifier
            signUpDetail.socialType = "3"
            let vc = AppDelegate.getViewController(identifire: "ChooseSocialUserTypeVC") as! ChooseSocialUserTypeVC
            vc.modalPresentationStyle = .overFullScreen
            vc.choseTypeCompilation = { (isCustomer) in
                if isCustomer{
                    self.SocialLoginApi(socialID: KeychainItem.currentUserIdentifier ?? "", token: KeychainItem.currentUserIdentifier ?? "", socialType: "5", email: email,userType: "0", name: "\(KeychainItem.currentUserFirstName ?? "") \(KeychainItem.currentUserLastName ?? "")")
                }else{
                    self.SocialLoginApi(socialID: KeychainItem.currentUserIdentifier ?? "", token: KeychainItem.currentUserIdentifier ?? "", socialType: "5", email: email,userType: "1", name: "\(KeychainItem.currentUserFirstName ?? "") \(KeychainItem.currentUserLastName ?? "")")
                }
            }
            self.present(vc, animated: true, completion: nil)
            
            
            
        } else if let passwordCredential = authorization.credential as? ASPasswordCredential {
            // Sign in using an existing iCloud Keychain credential.
            let username = passwordCredential.user
            let password = passwordCredential.password
            
            // For the purpose of this demo app, show the password credential as an alert.
            DispatchQueue.main.async {
                let message = "The app has received your selected credential from the keychain. \n\n Username: \(username)\n Password: \(password)"
                let alertController = UIAlertController(title: "Keychain Credential Received",
                                                        message: message,
                                                        preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
                self.present(alertController, animated: true, completion: nil)
            }
        }
    }
}

@available(iOS 13.0, *)
extension GetStartedVC : ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
}
