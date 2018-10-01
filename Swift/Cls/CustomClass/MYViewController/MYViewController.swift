//
//  MyViewController.swift
//  Enci
//
//  Created by Luciano Calderano on 26/10/16.
//  Copyright © 2016 Kanito. All rights reserved.
//

enum NotificationType {
    case customers
    case customerPets
    case pets
    case booking
}

import UIKit

class MYViewController: UIViewController, HeaderViewDelegate {
    @IBOutlet var header: HeaderContainerView?
    
    var dataArray = [Any]()
    var setBackAsHome = false
    var connectionStatus = UIView()
    let notificationName = Notification.Name("NotificationReloadData")

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.header?.delegate = self
        self.tabBarController?.navigationItem.hidesBackButton = true
        self.navigationItem.setHidesBackButton(true, animated: false)

        self.connectionStatus.layer.cornerRadius = 5

        self.view.addSubview(self.connectionStatus)
        self.view.costraintTo(view: self.connectionStatus, atb: .top, f: 5)
        self.view.costraintTo(view: self.connectionStatus, atb: .right, f: -50)
        self.view.costraintTo(view: self.connectionStatus, atb: .height, f: 10)
        self.view.costraintTo(view: self.connectionStatus, atb: .width, f: 10)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.showConnection()
    }

    private func showConnection () {
        let color = Reachability.isConnectedToNetwork() ? UIColor.green : UIColor.red
        self.connectionStatus.backgroundColor = color
    }
    
    func headerViewSxTapped() {
        if self.setBackAsHome == false {
            self.navigationBack()
        }
        else {
            self.navigationHome()
        }
    }
    
    @IBAction func backPressed () {
        self.navigationBack()
    }
    @IBAction func homePressed () {
        self.navigationHome()
    }

    func navigationBack () {
        _ = self.navigationController?.popViewController(animated: true)
    }

    func navigationHome () {
        _ = self.navigationController?.popToRootViewController(animated: true)
    }
    
    func headerViewDxTapped () {
        assertionFailure("MYViewController: headerViewDxTapped-override")
    }

    //MARK : Notification reola data
    
    func addNotificationReloadData () {
        NotificationCenter.default.addObserver(self, selector: #selector(self.reloadData(_:)),
                                               name: notificationName, object: nil)
    }
    
    @objc func reloadData (_ notification: Notification) {
        print ("Override !")
    }
    
    func postNotificationReloadData (type: NotificationType) {
        NotificationCenter.default.post(name: notificationName, object: type)
    }

    func nextCtrl (_ ctrl: UIViewController) {
        self.navigationController?.show(ctrl, sender: self)
    }

    func userLogged (userDict: JsonDict) {
        UserClass.shared.saveUserWith(dict: userDict)

        if CompanyClass.shared.value.id.isEmpty {
            let request = MYHttpRequest.get("company/get/by-owner")
            request.json = [
                "userId" : UserClass.shared.user.id,
            ]
            request.start(showWheel: false) { (success, response) in
                if success {
                    CompanyClass.shared.saveWith(dict: response)
                    self.gotoInitialStoryboard()
                }
            }
        }
    }
    
    func gotoInitialStoryboard () {
        let navi = self.navigationController as! MainNavigationCtrl
        navi.start()
    }

    func gotoStoryboard (type sb: StoryboardType, ctrlName: String = "") {
        self.gotoStoryboard(named: sb.rawValue, ctrlName: ctrlName)
    }
    
    func gotoStoryboard (named name: String, ctrlName: String = "") {
        let sb = UIStoryboard.init(name: name, bundle: nil)
        let ctrl = ctrlName.isEmpty ? sb.instantiateInitialViewController() : sb.instantiateViewController(withIdentifier: ctrlName)
        self.navigationController?.show(ctrl!, sender: self)
    }

    func gotoViewController (named name: String) {
        let ctrl = self.storyboard?.instantiateViewController(withIdentifier: name)
        self.navigationController?.show(ctrl!, sender: self)
    }
    
    func redesignKeyboard (textView: UITextView, okButton: Bool = true) {
//        if UIDevice.current.userInterfaceIdiom != UIUserInterfaceIdiom.phone {
//            return
//        }
//        textView.inputAccessoryView = self.redesign(okButton: okButton)
    }
    
    func redesignKeyboard (textField: UITextField, okButton: Bool = true) {
        if UIDevice.current.userInterfaceIdiom != UIUserInterfaceIdiom.phone {
            return
        }
        if textField.keyboardType == .phonePad {
            textField.inputAccessoryView = self.redesign(okButton: okButton)
        }
    }
    private func redesign (okButton: Bool) -> UIToolbar {
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        let chiudi = UIBarButtonItem.init(title: "\u{2716}", style: .plain, target: self, action: #selector(cancelPressedOnKeyboard))
        let space = UIBarButtonItem.init(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        if okButton == true {
            let ok = UIBarButtonItem.init(title: "\u{2714}", style: .plain, target: self, action: #selector (okPressedOnKeyboard))
            toolBar.setItems([chiudi, space, ok], animated: false)
        }
        else {
            toolBar.setItems([chiudi, space], animated: false)
        }
        toolBar.sizeToFit()
        return toolBar
    }
    
    
    @objc func cancelPressedOnKeyboard() {
        self.view.endEditing(true)
    }
    @objc func okPressedOnKeyboard() {
        self.view.endEditing(true)
    }    
}


import SystemConfiguration

public class Reachability {
    
    class func isConnectedToNetwork() -> Bool {
        
        var zeroAddress = sockaddr_in(sin_len: 0, sin_family: 0, sin_port: 0, sin_addr: in_addr(s_addr: 0), sin_zero: (0, 0, 0, 0, 0, 0, 0, 0))
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        
        var flags: SCNetworkReachabilityFlags = SCNetworkReachabilityFlags(rawValue: 0)
        if SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) == false {
            return false
        }
        
        /* Only Working for WIFI
         let isReachable = flags == .reachable
         let needsConnection = flags == .connectionRequired
         
         return isReachable && !needsConnection
         */
        
        // Working for Cellular and WIFI
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        let ret = (isReachable && !needsConnection)
        
        return ret
        
    }
}
