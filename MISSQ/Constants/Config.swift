//
//  Config.swift
//
//  Created by SFS04 on 7/6/17.
//  Copyright © 2017 SFS04. All rights reserved.
//

import Foundation
import UIKit
struct SignUpData{
    var profilePicture = UIImage()
    var profilePictureStr = String()
    var name = String()
    var email = String()
    var birthday = String()
    var userAge = String()
    var phone = String()
    var password = String()
    var gender = String()
    var heigt = String()
    var lookingFor = String()
    var interest = String()
    var education  = String()
    var squats = String()
    var bench = String()
    var deadlift = String()
    var powerClean = String()
    var bio = String()
    var loginType: String?
    var socialType: String?
    var socialID: String?
}
enum NibConstants:String {
    case homeImageCell = "HomeImageCell"
    case homeVideoCell = "HomeVideoCell"
    case profileUpperCell = "ProfileUpperCell"
    
}
struct StripeKeys {
    static let SECRET_KEY = "sk_test_51Ke0QhFTwkTjEW92qOZRw3U2iU02E9hJvcuwu53d8wnLvb3PpB9DtBaFtlBD7TGoz50JcUWbU24lbLgRT2FyBZnz00LIwp8ylG"
    static let PUBLISH_KEY = "pk_test_51Ke0QhFTwkTjEW92UVKsMLdqxFjZB9tvPUOaZPZGPDcFG2DizQQPfWFdB0mJj9uqKPrsHB9CVAsyjahaUl659Wpd00IE6nJUe4"
}

struct fontName {
    static let normal : String = "Gordita-Regular"
    static let light : String = "Gordita-Light"
    static let medium : String = "Gordita-Medium"
}
struct Constants {
    struct ApplePay {
        static let MERCHANT_IDENTIFIER: String = "REPLACE_ME"
        static let COUNTRY_CODE: String = "US"
        static let CURRENCY_CODE: String = "USD"
    }

    struct Square {
        static let SQUARE_LOCATION_ID: String = "<# REPLACE_ME #>"
        static let APPLICATION_ID: String  = "sandbox-sq0idb-nllUHLfpANX_XRfWx2ENxw"
        static let CHARGE_SERVER_HOST: String = "REPLACE_ME"
        static let CHARGE_URL: String = "\(CHARGE_SERVER_HOST)/chargeForCookie"
    }
    struct UserDefaults {
        static let kAppLaunch                      : String = "kAppLaunch"
        static let kDeviceToken                    : String = "kDeviceToken"
        static let kUserData                       : String = "kLoginUserData"
        static let kSelectedLanguage               : String = "kSelectedLanguage"
        static let kUserImage                      : String = "kUserImage"
        static let kUserName                       : String = "kUserName"
        static let kUserEmail                      : String = "kUserEmail"
        static let kIsLogin                        : String = "isLogin"
        static let kAuthToken                      : String = "kAuthToken"
        static let kUserID                         : String = "UserID"
        static let kCurrentUser                    : String = "kCurrentUser"
        static let kLastMessage                    : String = "lastMessage"
        static let defaultCard                     : String = "defaultCard"
    }
}
struct API {
       static var stripeBaseURL : String = "https://api.stripe.com/"

}
struct GAPIConstant {
    //MARK:- stripe apis
    static func createStripeCustomer() -> String {
        return API.stripeBaseURL + "v1/customers"
    }
    static func createPaymentMethod() -> String {
           return API.stripeBaseURL + "v1/payment_methods"
       }
    static func createStripeCard(customerId:String) -> String{
        return API.stripeBaseURL + "v1/customers/\(customerId)/sources"
    }

    static func getAllCards(customerId:String) -> String{
        return API.stripeBaseURL + "v1/customers/\(customerId)/sources"
    }
    
    static func deleteCard(customerId:String, cardId:String) -> String{
        return API.stripeBaseURL + "v1/customers/\(customerId)/sources/\(cardId)"
    }

    static func getCustomerInfo(customerId:String) -> String{
        return API.stripeBaseURL + "v1/customers/\(customerId)"
    }

    static func updateCustomerInfo(customerId:String) -> String{
        return API.stripeBaseURL + "v1/customers/\(customerId)"
    }
    static func apiChargeAccount() -> String{
        return API.stripeBaseURL + "v1/charges"
    }
    
    
    //MARK: - Header
    let kHeaderAPIKey       : String = "API-Key"
    let kHeaderAPIKeyValue  : String = ""
    let kHeaderToken        : String = "TOKEN"
}

public struct Notification_Key{
    static let GetPlayingTrackStatus = "get_playing_track"
    static let appRemoteConnected = "appRemoteConnected"
     static let appRemoteDisConnected = "appRemoteDisConnected"
}
public struct Spotify_key{
    static let clientID = "e41a51f7362949c2a0b3e6cb8b935e0e"//"b5bb18dd321e4a44804275fa836d1751"//
    static let clientSecretID = "9d6092b6b1f84e72ba86aaf0395495eb" //"1421bc7135e2403181ed0bac70baa843"//
    static let redirectURI = "climattude://" //"MoodMusic://"
    static let getCurrentProfileOfUser = "https://api.spotify.com/v1/me"
    static let getCurrentUserTopTracks = "https://api.spotify.com/v1/me/top/tracks"
    static let getCurrentUserTpArtists = "https://api.spotify.com/v1/me/top/artists"
    static let getCurrentUserTracks = "https://api.spotify.com/v1/tracks"
    static let getCurrentUserPlaylist = "https://api.spotify.com/v1/me/playlists"
    static let getCurrentUserArtist = "https://api.spotify.com/v1/artists"
    
}
let kAccessTokenKey = "access-token-key"
 let redirectUri = URL(string:"climattude://")!
 let clientIdentifier = "e41a51f7362949c2a0b3e6cb8b935e0e"
 let name = "Now Playing View"
var valumeValue = "0.0"
let kAccuWeatherAPI_KEY =  "NFF1bEJf0QFvk5boWz5PaAGTD6ZB7Xwt"//"W4xRgs3pAa5JxxjPSoY7k8gLAtmD5fSH"//"wKemc8XvuRrh9oJh5MGAkf7wIkMAgMmT"//
//http://api.1uppro.com/api/
// "http://3.20.218.227:9200/api/"
let kAlertTitle  = "MSQ"
var signUpDetail = SignUpData()
let API_SERVER_URL  = "https://app.msqassociates.com/apis/v1/"//"http://35.182.146.148:4000/apis/v1/"
let API_BASE_URL  =  API_SERVER_URL
let SupportMailId = "Admin@gmail.com"

let arrDuartion = ["15 Mins","30 Mins","45 Mins","1 Hour","1 Hour 15 Mins","1 Hour 30 Mins","1 Hour 45 Mins","2 Hours"]
let API_LOGIN = API_BASE_URL + "user/login"
let API_SIGN_UP = API_BASE_URL + "user/signup"
let API_OTP = API_BASE_URL + "user/verify"
let API_UPDATE_PROFILE = API_BASE_URL + "driver/update"
let API_FORGOT_PASSWORD = API_BASE_URL + "forgot-password"
let API_CHANGE_PASSWORD = API_BASE_URL + "change-password"
let API_SocialLOGIN = API_BASE_URL + "social-login"
let API_ADD_PRECRIPTION = API_BASE_URL + "prescription"
let API_TRANSFER_REQUEST_PRECRIPTION = API_BASE_URL + "transfer-request"
let API_REFILL_REQUEST_PRECRIPTION = API_BASE_URL + "refile-request"
let GoogleMapsAPIServerKey = "AIzaSyDy_3sGI-cV_5NFumNOI1gGh9MsDH2eeVE"

//MARK: CONSTANT VARIABLES
let kDegreeSign = "°"
var CurrencyName                      = "P"
let DbSongId                      = "songID"
let DbMoodId                      = "moodID"
let DbLocId                      = "locID"
let DbStreamingId                      = "ID"
let kMoodCheck = "mood"
let kMiniPlayerCheck = "mini_player"
let kSkippedWalkThrough = "isLogin"
let kMusicSource = "MusicSource"
let kMoodAddSource = "moodSourceMusic"
let kTemperature = "temperature"
let kMoods = "mood"
let kLanguage = "language"
let kDeviceType = "ios"
let kBusinessName = "Business_Name"
let kUserEmail = "user_email"
let kUserMobile = "user_Mobile"
let kUserPassword = "user_Password"
let kChooseRegistrationType = "Registration_type"
let kStoreAddress = "store_address"
let kQRCodeID = "store_address"
let kStoreLat = "store_lat"
let kStoreLon = "store_lon"
let kDeviceToken = "DeviceToken"
let kUserID = "userID"
let kIsLogin = "isUserLogin"
let kIsNotify = "isUserNotify"
let kIsTouchID = "isTouchID"
let kSpotifyPurchased = "spotifyIAP"
let kauthToken = "authentication_token"
let kDontShowAgain = "notShowAgain"
let kUserName = "UserName"
let kCurrentUser = "currnetUser"
let kBankStatus = "bankstatus"



let kpropertyType = "propertyType"
let kCartItems = "cartItems"
let kNotificationStatus = "notification_status"

let kUserData = "user_data"
let kIsCustomer = "is_customer"
let kZipCode = "ZipCode"
let kDryCleanerID = "defaultDryCleaner"
let kIsFavourites = "isFavourites"
let kAuthToken = "authentication_token"


var loggedInUser: User!

let kGooglePlaceApiKey = "AIzaSyCb1TyOPFa37Gl1H-3zH49DH4S9dUV1ld0"
let kUsernameValidation = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLKMNOPQRSTUVWXYZ "
let kZipCodeValidation = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLKMNOPQRSTUVWXYZ0123456789"
let kEmailAcceptableCharacter = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789_.@-"


let kPasswordMaxLength = 20
let kUserNameMaxLength = 40
let kAgeMaxLength = 3
let kZipCodeMaxLenght = 10
let kCityMaxLength = 30
let kSubjectMaxLength = 80
let kAddressNoteMaxLength = 80

var strCityName: String!
var strZipCode: String!
var isFindParternScreen: Bool = false
var isFavouritesRefersh: Bool = false

enum SearchControllerType : Int {
    case SC_Add = 0
    case SC_Search =  1
    case SC_None
}


