//
//  SignUpUserCtrl
//  Kanito
//
//  Created by Luciano Calderano on 16/01/17.
//  Copyright © 2017 Kanito. All rights reserved.
//

import Foundation

class SignUpUserCtrl: MYViewController {
    class func instanceFromSb (_ sb: UIStoryboard!) -> SignUpUserCtrl {
        return sb.instantiateViewController(withIdentifier: "SignUpUserCtrl") as! SignUpUserCtrl
    }

    @IBOutlet private var inputScrollView: MYInputScrollView!

    private var subView: SignUpView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.subView = SignUpView.addInputViewToInputScrollView(self.inputScrollView) as! SignUpView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true        
    }
    
    //MARK: SignUpPvtViewDelegate
    
    func showTermCond () {
        let ctrl = SignUpTermCondCtrl.instanceFromSb(self.storyboard)
        self.navigationController?.show(ctrl, sender: self)
    }
    
    @IBAction func singUpTapped () {
        let check = subView.checkData()
        guard check.valid else {
            return
        }
        UserClass.shared.mail = check.mail
        UserClass.shared.pass = check.pass
        
        let ctrl = SignUpUserTypeCtrl.instanceFromSb(self.storyboard)
        self.navigationController?.show(ctrl, sender: self)
    }
}

