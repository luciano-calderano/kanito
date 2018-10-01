//
//  SignUpUserTel.swift
//  Kanito
//
//  Created by Luciano Calderano on 01/02/17.
//  Copyright © 2017 Kanito. All rights reserved.
//

import Foundation

class SignUpUserTelCode: MYViewController, UITextFieldDelegate {
    class func instanceFromSb (_ sb: UIStoryboard!) -> SignUpUserTelCode {
        return sb.instantiateViewController(withIdentifier: "SignUpUserTelCode") as! SignUpUserTelCode
    }
    
    var phoneNumber = ""
    
    @IBOutlet private var phone: MYLabel!
    @IBOutlet private var code: MYTextField!
    @IBOutlet private var continueButton: MYButton!
    @IBOutlet fileprivate var titleView: UIView!
    @IBOutlet fileprivate var topConstraint: NSLayoutConstraint!

    private var topOriginal:CGFloat = 0

    class Prefix {
        var flag: UIImage?
        var prefix = ""
        init(flagName: String, prefix: String) {
            self.flag = UIImage.init(named: flagName)
            self.prefix = prefix
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.topOriginal = self.topConstraint.constant
        self.titleView.layer.borderColor = UIColor.myGreyMedium.cgColor
        self.titleView.layer.borderWidth = 1
        self.header?.header.dxButton.setTitleColor(UIColor.myGreyMedium, for: .normal)

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.keyboardWillShow(notification:)),
                                               name:UIResponder.keyboardWillShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.keyboardWillHide(notification:)),
                                               name:UIResponder.keyboardWillHideNotification,
                                               object: nil)

        self.code.delegate = self
        self.phone.text = self.phoneNumber
    }
    
    override func headerViewDxTapped() {
        let ctrl = SignUpDone.instanceFromSb(self.storyboard)
        self.navigationController?.show(ctrl, sender: self)
    }
    
    @IBAction func continueTapped () {
        let request = MYHttpRequest.post("verify-code")
        request.json = [
            "userId"     : UserClass.shared.user.id,
            "verifyCode" : self.code.text!
        ]
        
        request.start() { (success, response) in
            if success {
                let ctrl = SignUpDone.instanceFromSb(self.storyboard)
                self.navigationController?.show(ctrl, sender: self)
            }
        }
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.redesignKeyboard(textField: textField)
    }
    
    @objc func keyboardWillShow (notification: NSNotification) {
        self.continueButton.isHidden = true
        let rect = self.header!.frame
        self.topConstraint.constant = rect.origin.y + rect.size.height
    }
    @objc func keyboardWillHide (notification: NSNotification) {
        self.continueButton.isHidden = false
        self.topConstraint.constant = self.topOriginal
    }
    
    override func okPressedOnKeyboard() {
        super.okPressedOnKeyboard()
    }
}
