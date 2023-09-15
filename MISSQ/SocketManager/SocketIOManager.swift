import Foundation
import SocketIO
import SwiftyJSON

class SocketIOManager: NSObject {
    var manager : SocketManager
    var socket : SocketIOClient
    var isEstablishConnection : Bool = false
    fileprivate let API_SERVER_URL = "http://18.223.22.179/"
    var PortNumber = "80"
    class var shared: SocketIOManager{
        struct  Singlton{
            static let instance = SocketIOManager()
        }
        return Singlton.instance
    }
    
    override init(){
        manager = SocketManager(socketURL: URL(string: "\(API_SERVER_URL):\(PortNumber)")!, config: [.log(true), .compress])
        socket = manager.defaultSocket
       // socket.connect()
    }
    
    
    func establishConnection(completionHandler: @escaping (_ isConnected: Bool) -> Void) {
        if !Reachability.isConnectedToNetwork(){
            completionHandler(false)
        }else{
            if socket.status != .connected {
                isEstablishConnection = false
                socket.connect()
            }else{
                SocketIOManager.shared.joinChatRoom()
                completionHandler(true)
                return
            }
            if !isEstablishConnection {
               
                SocketIOManager.shared.socket.on(clientEvent: .connect) { (data, Ack) in
                    self.isEstablishConnection = true
                    SocketIOManager.shared.joinChatRoom()
                    completionHandler(true)
                }
                
//                SocketIOManager.shared.socket.once(clientEvent: .connect) { (data, Ack) in
//                    self.isEstablishConnection = true
//                    SocketIOManager.shared.joinChatRoom()
//                    completionHandler(true)
//                }
            }
        }
    }
    
    func closeConnection() {
        socket.disconnect()
    }
/*
    func receiveChannelMessage(completionHandler: @escaping (_ isSucessSent : Bool,_ obj:ChannelAllMessageDatum) -> Void) {
        socket.on("receiveMessageMultiple") { (responseArray, socketAck) -> Void in
            print(responseArray)
            if responseArray.count > 0 {
                let json =  JSON.init(responseArray[0])
                print(responseArray)
                if json["success"].intValue == 200  {
                    let dict = json["data"]
                    let idArr = json["id"].arrayValue
                    var messageID : Int = 0
                    for ids in idArr{
                        if ids["channel_id"].intValue == AppManager.shareInstance.channelID{
                            messageID = ids["message_id"].intValue
                            break
                        }
                    }
                    let date = AppManager.convertDateFromTimestamp(startTimeStamp: Double(Date().currentTimeMillis()))
                    let msg = ChannelAllMessageDatum.init(id: messageID, channelID: dict["channel_id"].intValue, senderID: dict["sender_id"].intValue, message: dict["message"].stringValue, type: "", flagCount: 0, parentID: 0, created: date, updated: "", status: 0, firstname: dict["firstname"].stringValue, lastname: dict["lastname"].stringValue, image: "", userRoleID: dict["role_id"].intValue, companyID: dict["company_id"].intValue, instituteID: dict["institute_id"].intValue, role: dict["role"].stringValue, userTypeID: dict["usertype"].intValue, rating: 0, noOfRatings: 0, totalRating: 0, flag: 0, isFavourite: 0, haveReply: 0, totalFavourite: 0, totalReplies: 0, organisationName: dict["organization_name"].stringValue)
                    completionHandler(true,msg)
                }
            }
        }
    }
    func GetSentChannelMessage(completionHandler: @escaping (_ isSucessSent : Bool,_ obj:ChannelAllMessageDatum) -> Void) {
        socket.on("sendMessageMultiple") { (responseArray, socketAck) -> Void in
            print(responseArray)
            if responseArray.count > 0 {
                let json =  JSON.init(responseArray[0])
                print(responseArray)
                if json["success"].intValue == 200  {
                    let dict = json["data"]
                    let idArr = json["id"].arrayValue
                    var messageID : Int = 0
                    for ids in idArr{
                        if ids["channel_id"].intValue == AppManager.shareInstance.channelID{
                            messageID = ids["message_id"].intValue
                            break
                        }
                    }
                    let date = AppManager.convertDateFromTimestamp(startTimeStamp: Double(Date().currentTimeMillis()))
                    let msg = ChannelAllMessageDatum.init(id: messageID, channelID: dict["channel_id"].intValue, senderID: userModel?.id, message: dict["message"].stringValue, type: "", flagCount: 0, parentID: 0, created: date, updated: "", status: 0, firstname: dict["firstname"].stringValue, lastname: dict["lastname"].stringValue, image: userModel?.image ?? "", userRoleID: dict["role_id"].intValue, companyID: dict["company_id"].intValue, instituteID: dict["institute_id"].intValue, role: userModel?.role ?? "", userTypeID: dict["usertype"].intValue, rating: 0, noOfRatings: 0, totalRating: 0, flag: 0, isFavourite: 0, haveReply: 0, totalFavourite: 0, totalReplies: 0, organisationName: userModel?.instituteName ?? "")
                    completionHandler(true,msg)
                }
            }
        }
    }
    /*
    func GetSentMessage(completionHandler: @escaping (_ messageId: Int) -> Void) {
        socket.on("send_message") { (responseArray, socketAck) -> Void in
            print(responseArray)
            if responseArray.count > 0 {
                let json =  JSON.init(responseArray[0])
                print(responseArray)
                    if json["success"].intValue == 200  {
                        let obj = json["data"]["parent_id"].intValue
                        
                        completionHandler(obj)
                    }
                
            }
        }
    }
 */
    func GetSentMessageForReply(completionHandler: @escaping (_ messageId: Int, _ message:ChannelAllMessageDatum ) -> Void) {
        socket.on("send_message") { (responseArray, socketAck) -> Void in
            print(responseArray)
            if responseArray.count > 0 {
                let json =  JSON.init(responseArray[0])
                print(responseArray)
                if json["success"].intValue == 200  {
                    
                    let dict = json["data"]
                    let obj = dict["parent_id"].intValue
                    let date = AppManager.convertDateFromTimestamp(startTimeStamp: Double(Date().currentTimeMillis()))
                    let msg = ChannelAllMessageDatum.init(id: obj, channelID: 0, senderID: userModel?.id, message: dict["message"].stringValue, type: "", flagCount: 0, parentID: dict["parent_id"].intValue, created: date, updated: "", status: 0, firstname: dict["firstname"].stringValue, lastname: dict["lastname"].stringValue, image: "", userRoleID: 0, companyID: 0, instituteID: 0, role: "", userTypeID: 0, rating: 0, noOfRatings: 0, totalRating: 0, flag: 0, isFavourite: 0, haveReply: 0, totalFavourite: 0, totalReplies: 0, organisationName: "")
                    completionHandler(obj, msg)
                }
                
            }
        }
    }
    /*
    func GetReceiveMsg(completionHandler: @escaping (_ messageId: Int) -> Void) {
        socket.on("receiveMessage") { (responseArray, socketAck) -> Void in
            print(responseArray)
            if responseArray.count > 0 {
                let json =  JSON.init(responseArray[0])
                print(responseArray)
                let messageId = json["id"].intValue
                completionHandler(messageId)
               
            }
        }
    }
 */
    func GetReceiveMsgForReply(completionHandler: @escaping (_ messageId: Int,_ message:ChannelAllMessageDatum) -> Void) {
        socket.on("receiveMessage") { (responseArray, socketAck) -> Void in
            print(responseArray)
            if responseArray.count > 0 {
                let json =  JSON.init(responseArray[0])
                print(responseArray)
               
                let date = AppManager.convertDateFromTimestamp(startTimeStamp: Double(Date().currentTimeMillis()))
                let dict = json["data"]
                 let messageId = dict["parent_id"].intValue
                let msg = ChannelAllMessageDatum.init(id: messageId, channelID: 0, senderID: dict["sender_id"].intValue, message: dict["message"].stringValue, type: "", flagCount: 0, parentID: dict["parent_id"].intValue, created: date, updated: "", status: 0, firstname: dict["firstname"].stringValue, lastname: dict["lastname"].stringValue, image: "", userRoleID: 0, companyID: 0, instituteID: 0, role: "", userTypeID: 0, rating: 0, noOfRatings: 0, totalRating: 0, flag: 0, isFavourite: 0, haveReply: 0, totalFavourite: 0, totalReplies: 0, organisationName: "")
                completionHandler(messageId, msg)
                
            }
        }
    }
    func GetPrivateMessage(completionHandler: @escaping (_ messageInfo: SCGetPrivateMessage, _ msgId:Int) -> Void) {
        socket.on("receivePrivateMessage") { (responseArray, socketAck) -> Void in
            print(responseArray)
            if responseArray.count > 0 {
                let json =  JSON.init(responseArray[0])
                print(responseArray)
                if json["success"].intValue == 200  {
                    let obj = json["data"]
                    let msgId = json["id"].intValue
                    let objMessage = SCGetPrivateMessage.init(obj: obj)
                    let date = AppManager.convertDateFromTimestamp(startTimeStamp: Double(Date().currentTimeMillis()))
                    objMessage.created = date
                    completionHandler(objMessage, msgId)
                }
            }
        }
    }
    func GetSentPrivateMessage(completionHandler: @escaping (_ messageInfo: SCGetPrivateMessage,_ msgId:Int) -> Void) {
        socket.on("send_private_message") { (responseArray, socketAck) -> Void in
            print(responseArray)
            if responseArray.count > 0 {
                let json =  JSON.init(responseArray[0])
                print(responseArray)
                if json["success"].intValue == 200  {
                    let obj = json["data"]
                    let msgId = json["id"].intValue
                    let objMessage = SCGetPrivateMessage.init(obj: obj)
                    let date = AppManager.convertDateFromTimestamp(startTimeStamp: Double(Date().currentTimeMillis()))
                    objMessage.created = date
                    completionHandler(objMessage,msgId)
                }
            }
        }
    }

    func sendRequest(key : String , parameter: [String : Any]) {
        if self.socket.status == .connected {
            SocketIOManager.shared.socket.emit(key, parameter)
        }else{
            self.establishConnection { (success) in
                if success  {
                     SocketIOManager.shared.socket.emit(key, parameter)
                }
            }
        }
    }

 */
    func joinChatRoom(){
        if AppManager.isLogin() {
            SocketIOManager.shared.socket.emit("join", ["user_id": AppManager.getUserID()])
        }
        
    }
 

}
