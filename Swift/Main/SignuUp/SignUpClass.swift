//
//  SignUpClass.swift
//  Kanito
//
//  Created by Luciano Calderano on 05/02/17.
//  Copyright © 2017 Kanito. All rights reserved.
//

import Foundation

protocol SignUpClassDelegate: class {
    func exitSignUpClass (withResponse response: JsonDict, success: Bool)
}

class SignUpClass {
    weak var delegate: SignUpClassDelegate?
    init(delegate: SignUpClassDelegate) {
        self.delegate = delegate
        switch UserClass.shared.user.loginType {
        case .facebook :
            self.signInFacebook()
        case .google :
            self.signInGoogle()
        default:
            return
        }
    }
    
    func signInMail (password: String, passConf: String) {
        let request = MYHttpRequest.post("user/sign-in")
        request.json = [
            "ip":               WiFiAddress.get(),
            "firstName":        UserClass.shared.user.firstname,
            "lastName":         UserClass.shared.user.lastname,
            "email":            UserClass.shared.user.mail,
            "password":         password,
            "confirmPassword":  passConf,
            "typeUserVal":      UserClass.shared.user.type.rawValue
        ]
        self.startRequest(request: request)
    }
    
    private func signInFacebook () {
        let request = MYHttpRequest.post("user/sign-in-facebook")
        request.json = [
            "ip":               WiFiAddress.get(),
            "fbId":             UserClass.shared.user.id,
            "fbName":           UserClass.shared.user.name,
            "fbEmail":          UserClass.shared.user.mail,
            "typeUserVal":      UserClass.shared.user.type.rawValue
        ]
        self.startRequest(request: request)
    }
    
    private func signInGoogle () {
        let request = MYHttpRequest.post("user/sign-in-google")
        request.json = [
            "ip":               WiFiAddress.get(),
            "goId":             UserClass.shared.user.id,
            "goFirstName":      UserClass.shared.user.firstname,
            "goLastName":       UserClass.shared.user.lastname,
            "goEmail":          UserClass.shared.user.mail,
            "typeUserVal":      UserClass.shared.user.type.rawValue
        ]
        self.startRequest(request: request)
    }
    
    private func startRequest (request: MYHttpRequest) {
        request.start() { (success, response) in
            if success {
                self.delegate?.exitSignUpClass(withResponse: response, success: true)
            }
            else {
                self.delegate?.exitSignUpClass(withResponse: [:], success: false)
            }
        }
    }
}
