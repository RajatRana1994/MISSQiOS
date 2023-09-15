// Developed by Mykola Darkngs Golyash
// 2020
// http://golyash.com

import UIKit

public class DECardNumberTextField: UITextField {
   
   private var shouldFormatNumber = true
   
   private weak var hiddenDelegate: UITextFieldDelegate?
   
   public var cardNumberFormatter = DECardNumberFormatter()
   
   override public var delegate: UITextFieldDelegate? {
      didSet {
         if delegate?.isKind(of: DECardNumberTextField.self) == false {
            hiddenDelegate = delegate
            delegate = self
         }
      }
   }
   @IBInspectable var leftImage: UIImage? {
       didSet {
           updateView()
       }
   }
   
   @IBInspectable var leftPadding: CGFloat = 0 {
       didSet {
           updateView()
       }
   }
   
   @IBInspectable var rightImage: UIImage? {
       didSet {
           updateView()
       }
   }
   
   @IBInspectable var rightPadding: CGFloat = 0 {
       didSet {
           updateView()
       }
   }
   
   private var _isRightViewVisible: Bool = true
   var isRightViewVisible: Bool {
       get {
           return _isRightViewVisible
       }
       set {
           _isRightViewVisible = newValue
           updateView()
       }
   }
   
   func updateView() {
       setLeftImage()
       setRightImage()
       
       // Placeholder text color
       attributedPlaceholder = NSAttributedString(string: placeholder != nil ?  placeholder! : "", attributes:[NSAttributedString.Key.foregroundColor: tintColor])
   }
   
   func setLeftImage() {
       
       leftViewMode = UITextField.ViewMode.always
       var view: UIView
       
       if let image = leftImage {
           let imageView = UIImageView(frame: CGRect(x: leftPadding, y: 0, width: 20, height: 20))
           imageView.image = image
           // Note: In order for your image to use the tint color, you have to select the image in the Assets.xcassets and change the "Render As" property to "Template Image".
           imageView.tintColor = tintColor
           
           var width = imageView.frame.width + leftPadding
           
           if borderStyle == UITextField.BorderStyle.none || borderStyle == UITextField.BorderStyle.line {
               width += 5
           }
           
           view = UIView(frame: CGRect(x: 0, y: 0, width: width, height: 20))
           view.addSubview(imageView)
       } else {
           view = UIView(frame: CGRect(x: 0, y: 0, width: leftPadding, height: 20))
       }
       
       leftView = view
       
   }
   
   func setRightImage() {
       if self.rightPadding > 0{
       rightViewMode = UITextField.ViewMode.always
       
       var view: UIView
       
       if let image = rightImage, isRightViewVisible {
           let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 14, height: 14))
           imageView.image = image
           // Note: In order for your image to use the tint color, you have to select the image in the Assets.xcassets and change the "Render As" property to "Template Image".
           imageView.tintColor = tintColor
           
           var width = imageView.frame.width + rightPadding
           
           if borderStyle == UITextField.BorderStyle.none || borderStyle == UITextField.BorderStyle.line {
               width += 5
           }
           imageView.contentMode = .scaleAspectFit
           view = UIView(frame: CGRect(x: 0, y: 0, width: width, height: 25))
           view.addSubview(imageView)
           
       } else {
           view = UIView(frame: CGRect(x:0, y: 0, width: rightPadding, height: 20))
       }
       
       rightView = view
       }
   }
   
   
   
   @IBInspectable public var bottomBorder: CGFloat = 0 {
       didSet {
           borderStyle = .none
           layer.backgroundColor = UIColor.white.cgColor
           layer.masksToBounds = false
           //layer.shadowColor = UIColor.gray.cgColor
           layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
           layer.shadowOpacity = 1.0
           layer.shadowRadius = 0.0
       }
   }
   @IBInspectable public var backGroundBottomBorder: CGFloat = 0 {
       didSet {
           borderStyle = .none
           layer.backgroundColor = UIColor.white.cgColor
           layer.masksToBounds = false
           //layer.shadowColor = UIColor.gray.cgColor
           layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
           layer.shadowOpacity = 1.0
           layer.shadowRadius = 0.0
       }
   }
   @IBInspectable public var bottomBorderColor : UIColor = UIColor.clear {
       didSet {
           layer.shadowColor = bottomBorderColor.cgColor
           layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
           layer.shadowOpacity = 1.0
           layer.shadowRadius = 0.0
       }
   }
   
   /// Sets the placeholder color
   @IBInspectable var placeHolderColor: UIColor? {
       get {
           return self.placeHolderColor
       }
       set {
           self.attributedPlaceholder = NSAttributedString(string:self.placeholder != nil ? self.placeholder! : "", attributes:[NSAttributedString.Key.foregroundColor: newValue!])
       }
   }
    
   // MARK: -
   
   @objc private func textFieldEditingChanged(_ textField: UITextField) {
      if shouldFormatNumber {
         let formattedText = cardNumberFormatter.number(from: textField.text ?? "")
         if !formattedText.isEmpty {
            textField.text = formattedText
         }
      } else if textField.text?.isEmpty == true {
         shouldFormatNumber = true
      }
   }
   
   // MARK: -
   
   public func setup() {
      if delegate == nil {
         delegate = self
      }
      addTarget(self, action: #selector(textFieldEditingChanged(_:)), for: .editingChanged)
   }
}

extension DECardNumberTextField: UITextFieldDelegate {
   
   public func textFieldDidBeginEditing(_ textField: UITextField) {
      shouldFormatNumber = false
      
      guard let text = textField.text else {
         return
      }
      
      if text.isNumberOrEmpty() {
         shouldFormatNumber = true
      }
   }
   
   public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
      guard string.isNumberOrEmpty() else {
         shouldFormatNumber = false
         return false
      }
      
      shouldFormatNumber = true
      
      return true
   }
   
   public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
      return hiddenDelegate?.textFieldShouldReturn?(textField) ?? false
   }
}

private extension String {
   
   func isNumber() -> Bool {
      if Int(self) == nil {
         return false
      }
      
      return true
   }
   
   func isNumberOrEmpty() -> Bool {
      if isEmpty {
         return true
      }
      
      return isNumber()
   }
}
