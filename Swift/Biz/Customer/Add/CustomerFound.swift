//
//  CustomerList
//  Kanito
//
//  Created by Luciano Calderano on 13/12/16.
//  Copyright © 2016 Kanito. All rights reserved.
//

import UIKit

class CustomerFound : MYViewController {
    class func Instance(_ customer: CustomerClass) -> CustomerFound {
        let vc = self.load(storyboard: .CustomerFind) as! CustomerFound
        vc.customer = customer
        return vc
    }
    var customer: CustomerClass!
    
    @IBOutlet var nameText: MYLabel!
    @IBOutlet var iniziali: MYLabel!
    @IBOutlet var petNameText: MYLabel!
    @IBOutlet var phoneText: MYLabel!
    @IBOutlet var emailText: MYLabel!
    @IBOutlet var container: UIView!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.customer.setAvatar(into: self.iniziali)

        self.setBackAsHome = true
        self.container.layer.borderWidth = 1
        self.container.layer.borderColor = UIColor.mySilver.cgColor
        self.container.layer.cornerRadius = 5

        self.nameText.text = self.customer.name
        self.phoneText.text = self.customer.phone
        self.emailText.text = self.customer.email
    }

    @IBAction func addCustTapped () {
        let request = MYHttpRequest.post("company/customer/import")
        request.json = [
            "companyId" : CompanyClass.shared.value.id,
            "userId"    : self.customer.idUser
        ]
        request.start() { (success, response) in
            if success {
                self.postNotificationReloadData(type: .customers)
                let ctrl = CustomerFindDone.Instance(found: true)
                self.navigationController?.show(ctrl, sender: self)
            }
        }
    }
    
    @IBAction func addManuTapped () {
        let ctrl = BizCustEditCtrl.Instance(CustomerClass())
        self.navigationController?.show(ctrl, sender: self)
    }
}
