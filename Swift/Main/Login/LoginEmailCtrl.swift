//
//  LoginEmailCtr
//  Kanito
//
//  Created by Luciano Calderano on 16/01/17.
//  Copyright © 2017 Kanito. All rights reserved.
//

import Foundation

class LoginEmailCtr: MYViewController {
    class func Instance () -> LoginEmailCtr {
        let sb = UIStoryboard.init(name: StoryboardType.Login.rawValue, bundle: nil)
        return sb.instantiateViewController(withIdentifier: "LoginEmailCtr") as! LoginEmailCtr
    }

    @IBOutlet var mailText: MYTextField!
    @IBOutlet var passWordText: MYTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mailText.delegate = self
        mailText.keyboardType = UIKeyboardType.emailAddress
        passWordText.delegate = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }
    
    @IBAction func showPassword () {
        passWordText.isSecureTextEntry = false
    }
    
    
    @IBAction func passRecoveryTapped () {
        let ctrl = LoginRecoveryCtrl.Instance()
        navigationController?.show(ctrl, sender: self)
    }

    private func loginMail () {
        view.endEditing(true)

        let request = MYHttpRequest.get("user/log-in")
        request.json = [
            "email":            mailText.text!,
            "password":         passWordText.text!
        ]

        request.start() { (success, response) in
            if success {
                self.httpResponse(response)
            }
        }
    }
    
    fileprivate func httpResponse(_ response: JsonDict) {
        if response.string("Value.user_type") == UserType.pvt.rawValue {
            alert("Private user not supported", message: "", okBlock: nil)
            return
        }
        CompanyClass.shared.value.id = ""
        userLogged(userDict: response)
    }
    
    @IBAction func loginTapped () {
        if validateEmail(mailText.text!) == false {
            mailText.becomeFirstResponder()
            return
        }
        UserClass.shared.user.mail = mailText.text!
        if (passWordText.text?.isEmpty)! {
            passWordText.becomeFirstResponder()
        }
        loginMail()
    }
    
    fileprivate func validateEmail(_ candidate: String) -> Bool {
        let valid = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}"
        return NSPredicate(format: "SELF MATCHES %@", valid).evaluate(with: candidate)
    }
}
extension LoginEmailCtr: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == passWordText {
            view.endEditing(true)
        }
        if textField == mailText {
            passWordText.becomeFirstResponder()
        }
        return true
    }
}

