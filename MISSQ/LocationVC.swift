//
//  LocationVC.swift
//  MISSQ
//
//  Created by Vikas Kumar on 04/04/22.
//

import UIKit
import Localize_Swift
import GooglePlaces
class LocationVC: UIViewController {
    @IBOutlet weak var tfAddress:UITextField!
    @IBOutlet weak var tfCity:UITextField!
    @IBOutlet weak var tfState:UITextField!
    @IBOutlet weak var tfPostalCode:UITextField!
    var bookingID: String = ""
    var userID: String = ""
    var lattitude: String = ""
    var longitude: String = ""
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    @IBAction func btnBackAction(sender: UIButton){
        self.navigationController?.popViewController(animated: true)
    }

    @IBAction func btnNextAction(sender: UIButton){
        if (tfAddress.text?.trimmingCharacters(in: .whitespaces).isEmpty)! {
            AlertToastManager.shared.addToast(self.view, message: "Please select address", position: .top)
        }else{
            self.apiSubmitData()
        }
    }
    
    func apiSubmitData()  {
        var parameter = Dictionary<String, String>()
        parameter["address"] = self.tfAddress.text ?? ""
        parameter["city"] = self.tfCity.text ?? ""
        parameter["state"] = self.tfState.text ?? ""
        parameter["postCode"] = self.tfPostalCode.text ?? ""
        parameter["latitude"] = self.lattitude
        parameter["longitude"] = self.longitude
        print(parameter)
        ServerManager.shared.showHud()
        ServerManager.shared.httpPost(request: API_BASE_URL + "booking/\(self.bookingID)/1",type: .put, params: parameter, successHandler: { (response) in
            print(response)
            ServerManager.shared.hidHud()
            AlertManager.shared.hideErrorView()
            
            if response["status"].intValue == 200 {
                let vc = AppDelegate.getViewController(identifire: "BookingDetail2VC") as! BookingDetail2VC
                vc.hidesBottomBarWhenPushed = true
                vc.bookingID = self.bookingID
                vc.userID = self.userID
                self.navigationController?.pushViewController(vc, animated: true)
            }else{
                AlertToastManager.shared.addToast(self.view, message: response["error_message"].stringValue, position: .top)
            }
        }){ (error) in
            ServerManager.shared.hidHud()
            AlertManager.shared.showErrorView(in: self.view,text:AppManager.getErrorMessage(error! as NSError),  onCompletion: {
                // self.GetStateFunction(countryIdd: countryIdd)
            })
        }
    }
}
extension LocationVC: UITextFieldDelegate{
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
            let autocompleteController = GMSAutocompleteViewController()
                autocompleteController.delegate = self
                present(autocompleteController, animated: true, completion: nil)
            return false
       
    }
}
extension LocationVC: GMSAutocompleteViewControllerDelegate {

  // Handle the user's selection.
  func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
      self.tfAddress.text = place.formattedAddress ?? ""
      self.lattitude = "\(place.coordinate.latitude )"
      self.longitude = "\(place.coordinate.longitude )"
      // Show AddressComponents
                  if place.addressComponents != nil {
                      
                      for addressComponent in (place.addressComponents)! {
                         for type in (addressComponent.types){
print("\(type): \(addressComponent.name)")
                             switch(type){
                                 case "locality":
                                 self.tfCity.text = addressComponent.name
                                 case "political":
                                 self.tfState.text = addressComponent.name
                                  case "postal_code":
                                 self.tfPostalCode.text = addressComponent.name
                             default:
                                 break
                             }
                         }
                     }
                  }
    dismiss(animated: true, completion: nil)
  }

  func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
    // TODO: handle the error.
    print("Error: ", error.localizedDescription)
  }

  // User canceled the operation.
  func wasCancelled(_ viewController: GMSAutocompleteViewController) {
    dismiss(animated: true, completion: nil)
  }

}
