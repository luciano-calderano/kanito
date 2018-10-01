//
//  RegTermCondCtrl.swift
//  Kanito
//
//  Created by Luciano Calderano on 22/12/16.
//  Copyright © 2016 Kanito. All rights reserved.
//

import Foundation

class SignUpTermCondCtrl: MYViewController {
    class func instanceFromSb (_ sb: UIStoryboard!) -> SignUpTermCondCtrl {
        return sb.instantiateViewController(withIdentifier: "SignUpTermCondCtrl") as! SignUpTermCondCtrl
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }    
}
