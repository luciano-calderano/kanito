//
//  RegTermCondCtrl.swift
//  Kanito
//
//  Created by Luciano Calderano on 22/12/16.
//  Copyright © 2016 Kanito. All rights reserved.
//

import Foundation

class SignUpDone: MYViewController {
    class func instanceFromSb (_ sb: UIStoryboard!) -> SignUpDone {
        return sb.instantiateViewController(withIdentifier: "SignUpDone") as! SignUpDone
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }

    @IBAction func myKanitoPressd () {
        CompanyClass.shared.value.id = ""
        let request = MYHttpRequest.get("user/get")
        request.json = [
            "userId" : UserClass.shared.user.id
        ]
        request.start() { (success, response) in
            if success {
                self.userLogged(userDict: response)
            }
        }
    }
}
