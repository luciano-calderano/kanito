//
//  custClass.swift
//  Kanito
//
//  Created by Luciano Calderano on 02/11/16.
//  Copyright © 2016 Kanito. All rights reserved.
//

import Foundation

class CustomerClass: NSObject {
    private var firstName = ""
    private var lastName = ""

    var idUser = ""
    var idCustomer = ""
    var name = ""
    
    var phone = ""
    var email = ""
    var code = ""
    var vetName = ""
    var vetPhone = ""
    var status = "Status ?"
    var pets = [PetClass]()
    
    let userConfig = UserDefaults.init(suiteName: "customers.config")

    class func getById (_ id: String, completion: @escaping (CustomerClass) -> () = { (customer) in }) {
        let customer = CustomerClass()
        if id.isEmpty {
            completion (customer)
            return
        }
        
        let dict = customer.userConfig?.dictionary(forKey: id)
        if dict == nil || (dict?.string("id_user").isEmpty)! {
            let request = MYHttpRequest.get("company/customer/get")
            
            request.json = [
                "customerId" : id,
            ]
            request.start(showWheel: false, silentError: true) { (success, response) in
                if success {
                    customer.convert(with: response.dictionary("Value"))
                }
                completion(customer)
            }
            return
        }
        customer.convert(with: dict!)
        completion(customer)
    }

    class func getList (pageNum: Int, maxItem: Int, search: String = "",
                        completion: @escaping ([CustomerClass]) -> () = { (array) in }
                        ) {
        let page = (search.isEmpty) ? "list" : "search-by-name"
        let request = MYHttpRequest.get("company/customer/" + page)
        request.json = [
            "companyId" : CompanyClass.shared.value.id,
            "limit"     : maxItem,
            "offset"    : pageNum
        ]
        
        if search.isEmpty == false {
            request.json["name"] = search
        }
        
        request.start() { (success, response) in
            if success {
                var array = [CustomerClass] ()
                for dict in response.array("Value.itemList") {
                    array.append(CustomerClass.init(with: dict as! JsonDict))
                }
                completion (array)
            }
        }
    }
    
    override init() {
    }
    
    init(with dict: JsonDict) {
        super.init()
        self.convert(with: dict)
    }

    init(byEmailResponse response: JsonDict) {
        let dict = response.dictionary("Value")
        self.idUser = dict.string("id_user")
        self.idCustomer = dict.string("id_customer")
        
        self.firstName = dict.string("first_name")
        self.lastName = dict.string("last_name")
        self.name = self.firstName + " " + self.lastName
        
        self.email = dict.string("email")
        self.phone = dict.string("phone_number")
        if self.phone.isEmpty {
            self.phone = dict.string("cell_number")
        }
    }
    
    func setAvatar (into view: UIView) {
        view.backgroundColor = UIColor.clear
        let avatar = UILabel.init(frame: view.bounds)
        avatar.backgroundColor = UIColor.myGreyMedium
        avatar.textColor = UIColor.white
        avatar.textAlignment = .center
        avatar.font = UIFont.size(avatar.frame.size.width * 0.4)
        avatar.text = self.firstName.left(lenght: 1) + self.lastName.left(lenght: 1)
//        avatar.minimumScaleFactor = 0.3
        avatar.layer.cornerRadius = avatar.frame.size.width / 2
        avatar.layer.masksToBounds = true

        view.addSubview(avatar)
    }
    
    //MARK: - private
    
    private func convert (with dict: JsonDict) {
        self.idUser = dict.string("id_user")
        self.idCustomer = dict.string("id_customer")
        
        self.firstName = dict.string("customer_first_name")
        self.lastName = dict.string("customer_last_name")
        self.name = self.firstName + " " + self.lastName
        self.email = dict.string("customer_email")
        
        self.phone = dict.string("customer_phone_number")
        if self.phone.isEmpty {
            self.phone = dict.string("customer_cell_number")
        }
        
        self.code = dict.string("customer_code")
        self.vetName = dict.string("customer_vet_name")
        self.vetPhone = dict.string("customer_vet_phone")
        
        self.userConfig?.setValue(dict, forKey: self.idCustomer)
    }
}
