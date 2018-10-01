//
//  LoginCtrl.swift
//  Kanito
//
//  Created by Luciano Calderano on 16/12/16.
//  Copyright © 2016 Kanito. All rights reserved.
//

import UIKit

class LoginRecoveryCtrl: MYViewController {
    class func Instance () -> LoginRecoveryCtrl {
        let sb = UIStoryboard.init(name: StoryboardType.Login.rawValue, bundle: nil)
        return sb.instantiateViewController(withIdentifier: "LoginRecoveryCtrl") as! LoginRecoveryCtrl
    }

    @IBOutlet var txtMail: MYTextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        txtMail.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }
    
    @IBAction func btnSend () {
        txtMail.text = txtMail.text?.trimmingCharacters(in: .whitespaces)
        if (txtMail.text?.isEmpty)! {
            txtMail.becomeFirstResponder()
            return
        }
        view.endEditing(true)
        
        let request = MYHttpRequest.post("user/forgot-password")
        request.json = [
            "email":  txtMail.text!
        ]
        request.start() { (success, response) in
            if success {
                self.httpResponse(response)
            }
        }
    }
    
    fileprivate func httpResponse(_ resultDict: JsonDict) {
        alert(resultDict.string("msg"), message: "") { (UIAlertAction) in
            self.gotoInitialStoryboard()
        }
    }
}

extension LoginRecoveryCtrl: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return true
    }
}
