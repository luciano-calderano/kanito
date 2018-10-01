//
//  SignUpType
//  Kanito
//
//  Created by Luciano Calderano on 16/12/16.
//  Copyright © 2016 Kanito. All rights reserved.
//

import UIKit
import FacebookLogin
import FacebookCore

class SignUpType: MYViewController, GIDSignInUIDelegate, GIDSignInDelegate, SignUpClassDelegate {
    class func instanceFromSb (_ sb: UIStoryboard!) -> SignUpType {
        return sb.instantiateViewController(withIdentifier: "SignUpType") as! SignUpType
    }
    @IBOutlet var googleContainer: UIView!
    @IBOutlet var fbButton: MYButton!
    @IBOutlet var googleButton: MYButton!
    
    private var wheel: MYWheel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.updateButtons()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    
    private func updateButtons () {
        self.fbButton.setImage(self.fbButton.image(for: .normal)?.resize(25), for: .normal)
        self.googleButton.setImage(self.googleButton.image(for: .normal)?.resize(25), for: .normal)
    }
    
    @IBAction func btnSignUp () {
        let ctrl = SignUpData.instanceFromSb(self.storyboard)
        self.navigationController?.show(ctrl, sender: self)
    }
    
    // MARK: -  fb login
    
    @IBAction func btnFbLogin () {
        
        let loginManager = LoginManager()
        let permission:[ReadPermission] = [ .publicProfile, .userFriends, .email ]
            loginManager.logIn(readPermissions: permission,
                               viewController: self) { loginResult in
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
    
    // MARK: -  fb request

    private func fbRequest () {
        self.wheel = MYWheel.init(true)
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

        self.signup()
    }
    
    // MARK: -  google login
    
    @IBAction func googlePlusButtonTouchUpInside(sender: AnyObject) {
        self.wheel = MYWheel.init(true)

        var configureError: NSError?
        GGLContext.sharedInstance().configureWithError(&configureError)
        guard configureError == nil else {
            self.wheel?.stop()
            self.alert("Error", message: (configureError?.localizedDescription)!, okBlock: nil)
            return
        }

        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().signOut()
        GIDSignIn.sharedInstance().signIn()
    }
    
    // MARK: -  google delegate
    
    func sign(inWillDispatch signIn: GIDSignIn!, error: Error!) {
        self.wheel?.stop()
    }
    
    func sign(_ signIn: GIDSignIn!, present viewController: UIViewController!) {
        self.present(viewController, animated: true, completion: nil)
    }
    
    func sign(_ signIn: GIDSignIn!, dismiss viewController: UIViewController!) {
        self.dismiss(animated: false, completion: nil)
    }
    
    public func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        guard user != nil else {
            return
        }
        
        UserClass.shared.user.id = user.userID
        UserClass.shared.user.mail = user.profile.email
        UserClass.shared.user.name = user.profile.name
        UserClass.shared.user.firstname = user.profile.givenName
        UserClass.shared.user.lastname = user.profile.familyName
        UserClass.shared.user.loginType = .google
        
        self.signup()
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        UserClass.shared.logout()
    }

/////////////////
    
    private func signup () {
        _ = SignUpClass(delegate: self)
    }
    
    func exitSignUpClass(withResponse response: JsonDict, success: Bool) {
        if success {
            UserClass.shared.saveUser()

            switch UserClass.shared.user.type {
            case .biz, .pro:
                self.gotoStoryboard(named: "SignUpBiz")
            default:
                self.gotoStoryboard(named: "SignUpDone")
            }

        }
    }
}

