//
//  SignUpUserTel.swift
//  Kanito
//
//  Created by Luciano Calderano on 01/02/17.
//  Copyright © 2017 Kanito. All rights reserved.
//

import Foundation

class SignUpUserTel: MYViewController, UITextFieldDelegate {
    class func instanceFromSb (_ sb: UIStoryboard!) -> SignUpUserTel {
        return sb.instantiateViewController(withIdentifier: "SignUpUserTel") as! SignUpUserTel
    }
    
    @IBOutlet var flag: UIImageView!
    @IBOutlet var prefix: MYLabel!
    @IBOutlet var phone: MYTextField!
    @IBOutlet var continueButton: MYButton!
    @IBOutlet fileprivate var titleView: UIView!
    @IBOutlet fileprivate var topConstraint: NSLayoutConstraint!
    
    private var topOriginal:CGFloat = 0
    private var prefixSelected = 0
    
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

        self.phone.delegate = self
        dataArray.append(Prefix.init(flagName: "flag.ita", prefix: "+39"))
        dataArray.append(Prefix.init(flagName: "flag.usa", prefix: "+1"))
        self.showPrefix()
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
    override func headerViewDxTapped() {
        let ctrl = SignUpDone.instanceFromSb(self.storyboard)
        self.navigationController?.show(ctrl, sender: self)
    }

    @IBAction func prefixTapped () {
        prefixSelected += 1
        prefixSelected %= dataArray.count
        self.showPrefix()
    }
    
    private func showPrefix () {
        let prefix = dataArray[prefixSelected] as! Prefix
        self.flag.image = prefix.flag
        self.prefix.text = prefix.prefix
    }

    @IBAction func continueTapped () {
        if self.prefix.text?.isEmpty == true {
            self.prefix.becomeFirstResponder()
            return
        }
        
        let request = MYHttpRequest.post("send-sms-code")
        request.json = [
            "userId"      : UserClass.shared.user.id,
            "phoneNumber" : self.prefix.text! + self.phone.text!,
        ]
        
        request.start() { (success, response) in
            if success {
                let ctrl = SignUpUserTelCode.instanceFromSb(self.storyboard)
                ctrl.phoneNumber = self.prefix.text! + " " + self.phone.text!
                self.navigationController?.show(ctrl, sender: self)
            }
        }
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {
        if UIDevice.current.userInterfaceIdiom != UIUserInterfaceIdiom.phone {
            return
        }
        
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        let chiudi = UIBarButtonItem.init(title: "\u{2716}", style: .plain, target: self, action: #selector(closeKeyboard))
        let space = UIBarButtonItem.init(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        let ok = UIBarButtonItem.init(title: "\u{2714}", style: .plain, target: self, action: #selector (closeKeyboard))
        toolBar.setItems([chiudi, space, ok], animated: false)
        toolBar.sizeToFit()
        
        textField.inputAccessoryView = toolBar
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
    @objc func closeKeyboard() {
        self.view.endEditing(true)
    }
}
