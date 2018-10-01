//
//  CustomerList
//  Kanito
//
//  Created by Luciano Calderano on 13/12/16.
//  Copyright © 2016 Kanito. All rights reserved.
//

import UIKit

class CustomerFind : MYViewController, UITextFieldDelegate {
    class func Instance() -> CustomerFind {
        let vc = self.load(storyboard: .CustomerFind) as! CustomerFind
        return vc
    }

    @IBOutlet var emailText: MYTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setBackAsHome = true
        self.emailText.keyboardType = .emailAddress
        self.emailText.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
    @IBAction func findTapped () {
        if (self.emailText.text?.isEmpty)! {
            return
        }
        let request = MYHttpRequest.get("user/get-by-email")
        request.json = [
            "email"     : self.emailText.text ?? "",
        ]
        request.start() { (success, response) in
            if success {
                let customer = CustomerClass.init(byEmailResponse: response)
                let ctrl = CustomerFound.Instance(customer)
                self.navigationController?.show(ctrl, sender: self)
            }
        }
    }
    
    @IBAction func noMailTapped () {
        let ctrl = BizCustEditCtrl.Instance(CustomerClass())
        self.navigationController?.show(ctrl, sender: self)
    }
}
