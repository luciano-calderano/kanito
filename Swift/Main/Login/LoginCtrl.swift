//
//  LoginCtrl.swift
//  Kanito
//
//  Created by Luciano Calderano on 16/12/16.
//  Copyright © 2016 Kanito. All rights reserved.
//

import UIKit
import FacebookLogin
import FacebookCore

class LoginCtrl: MYViewController {
    @IBOutlet var googleContainer: UIView!
    @IBOutlet var fbButton: MYButton!
    @IBOutlet var googleButton: MYButton!
    @IBOutlet var versLabel: MYLabel!
    
    private var wheel: MYWheel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        versLabel.text = ""
        if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
            versLabel.text = version
        }
        updateButtons()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
<<<<<<< HEAD
=======
        UIApplication.shared.statusBarStyle = .default
>>>>>>> 27c997a30628d22b0ed0092449db4269d26446e3
    }
    
    private func updateButtons () {
        fbButton.setImage(fbButton.image(for: .normal)?.resize(25), for: .normal)
        googleButton.setImage(googleButton.image(for: .normal)?.resize(25), for: .normal)
    }
    
    // MARK: -  IBAction
    
    @IBAction func btnLogin () {
        let ctrl = LoginEmailCtr.Instance()
        navigationController?.show(ctrl, sender: self)
    }
    
    @IBAction func btnFbLogin () {
        fbLogin()
    }
    
    @IBAction func googleTapped () {
        googleLogin()
    }
}

// MARK: - Login

extension LoginCtrl {
    private func gotoLogin () {
        switch UserClass.shared.user.loginType {
        case .facebook:
            loginFacebook()
        case .google:
            loginGoogle()
        default:
            return
        }
    }
    
    private func loginFacebook () {
        let request = MYHttpRequest.get("user/log-in-facebook")
        request.json = [
            "fbId": UserClass.shared.user.id,
        ]
        startRequest(request: request)
    }
    
    private func loginGoogle () {
        let request = MYHttpRequest.get("user/log-in-google")
        request.json = [
            "goId": UserClass.shared.user.id,
        ]
        startRequest(request: request)
    }
    
    private func startRequest (request: MYHttpRequest) {
        request.start() { (success, response) in
            if success {
                self.userLogged(userDict: response)
            }
        }
    }
}

// MARK: -  Facebook login

extension LoginCtrl {
    private func fbLogin () {
        let loginManager = LoginManager()
        loginManager.loginBehavior = .systemAccount
        let permission:[ReadPermission] = [ .publicProfile, .userFriends, .email ]
        loginManager.logIn(readPermissions: permission,
                           viewController: self) {
                            (loginResult) in
                            switch loginResult {
                            case .failed(let error):
                                self.alert("Error", message: error.localizedDescription, okBlock: nil)
                            case .cancelled:
                                self.alert("Canceled", message: "", okBlock: nil)
                            case .success: // (let grantedPermissions, let declinedPermissions, let accessToken):
                                self.fbRequest()
                            }
        }
    }
    
    private func fbRequest () {
        wheel = MYWheel.init(true)
        let request = GraphRequest(graphPath: "me",
                                   parameters: ["fields":"id,email,name,first_name,last_name,gender"],
                                   accessToken: AccessToken.current,
                                   httpMethod: .GET,
                                   apiVersion: FacebookCore.GraphAPIVersion.defaultVersion)
        request.start { (response, result) in
            self.wheel?.stop()
            switch result {
            case .success(let value):
                self.fbData(dict: value.dictionaryValue! as JsonDict)
            case .failed(let error):
                self.alert("Error", message: error.localizedDescription, okBlock: nil)
            }
        }
    }
    
    private func fbData (dict: JsonDict) {
        UserClass.shared.user.id = dict.string("id")
        UserClass.shared.user.mail = dict.string("email")
        UserClass.shared.user.name = dict.string("name")
        UserClass.shared.user.firstname = dict.string("first_name")
        UserClass.shared.user.lastname = dict.string("last_name")
        UserClass.shared.user.loginType = .facebook
        
        gotoLogin()
    }
    
}

// MARK:-  google login

extension LoginCtrl {
    private func googleLogin () {
        wheel = MYWheel.init(true)
        var configureError: NSError?
        GGLContext.sharedInstance().configureWithError(&configureError)
        guard configureError == nil else {
            wheel?.stop()
            alert("Error", message: (configureError?.localizedDescription)!, okBlock: nil)
            return
        }
        
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().signOut()
        GIDSignIn.sharedInstance().signIn()
    }
}

// MARK:-  google delegate

extension LoginCtrl: GIDSignInUIDelegate, GIDSignInDelegate {
    public func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        guard let user = user else { return }
        
        UserClass.shared.user.id = user.userID
        UserClass.shared.user.mail = user.profile.email
        UserClass.shared.user.name = user.profile.name
        UserClass.shared.user.firstname = user.profile.givenName
        UserClass.shared.user.lastname = user.profile.familyName
        UserClass.shared.user.loginType = .google
        
        gotoLogin()
    }

    func sign(inWillDispatch signIn: GIDSignIn!, error: Error!) {
        wheel?.stop()
    }
    
    func sign(_ signIn: GIDSignIn!, present viewController: UIViewController!) {
        present(viewController, animated: true, completion: nil)
    }
    
    func sign(_ signIn: GIDSignIn!, dismiss viewController: UIViewController!) {
        dismiss(animated: false, completion: nil)
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        UserClass.shared.logout()
    }
}
