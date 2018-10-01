//
//  BizCustEditCtrl
//  Kanito
//
//  Created by Luciano Calderano on 13/12/16.
//  Copyright © 2016 Kanito. All rights reserved.
//

import UIKit

class BizCustEditCtrl : MYViewController, UITableViewDelegate, UITableViewDataSource, BizCustEditCellDelegate {
    class func Instance(_ customer: CustomerClass) -> BizCustEditCtrl {
        let vc = self.load(storyboard: .Customer) as! BizCustEditCtrl
        vc.customer = customer
        return vc
    }
    
    enum ItemAdd {
        case fN
        case lN
//        case co
        case ph
        case em
//        case vN
//        case vP
        case last
    }
    enum ItemEdit {
        case co
        case ph
//        case em
        case vN
        case vP
        case last
    }

    @IBOutlet fileprivate var tableView: UITableView!

    private var inputClass = InputClass()
    private var activeRow = 0
    
    var customer: CustomerClass!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setBackAsHome = true
        self.inputClass.config(tableView: self.tableView, view: self.view)
        self.loadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func headerViewDxTapped() {
        self.save()
    }

    private func loadData() {
        var item: CustomerDetail.EditField!
        if self.customer.idCustomer.isEmpty {
            self.header?.header.titleLabel.text = Lng ("addCustomer")
            for _ in 0...ItemAdd.last.hashValue - 1 {
                dataArray.append(CustomerDetail.EditField())
            }
<<<<<<< HEAD
            item = dataArray[ItemAdd.fN.hashValue] as? CustomerDetail.EditField
            item.title = Lng("firstName")
            dataArray[ItemAdd.fN.hashValue] = item
            
            item = dataArray[ItemAdd.lN.hashValue] as? CustomerDetail.EditField
=======
            item = dataArray[ItemAdd.fN.hashValue] as! CustomerDetail.EditField
            item.title = Lng("firstName")
            dataArray[ItemAdd.fN.hashValue] = item
            
            item = dataArray[ItemAdd.lN.hashValue] as! CustomerDetail.EditField
>>>>>>> 27c997a30628d22b0ed0092449db4269d26446e3
            item.title = Lng("lastName")
            dataArray[ItemAdd.lN.hashValue] = item
            
//            item = dataArray[ItemAdd.co.hashValue] as! CustomerDetail.EditField
//            item.title = Lng("code")
//            dataArray[ItemAdd.co.hashValue] = item
            
<<<<<<< HEAD
            item = dataArray[ItemAdd.ph.hashValue] as? CustomerDetail.EditField
=======
            item = dataArray[ItemAdd.ph.hashValue] as! CustomerDetail.EditField
>>>>>>> 27c997a30628d22b0ed0092449db4269d26446e3
            item.title = Lng("phone")
            item.kbType = .phonePad
            dataArray[ItemAdd.ph.hashValue] = item
            
<<<<<<< HEAD
            item = dataArray[ItemAdd.em.hashValue] as? CustomerDetail.EditField
=======
            item = dataArray[ItemAdd.em.hashValue] as! CustomerDetail.EditField
>>>>>>> 27c997a30628d22b0ed0092449db4269d26446e3
            item.title = Lng("email")
            item.kbType = .emailAddress
            dataArray[ItemAdd.em.hashValue] = item
            
//            item = dataArray[ItemAdd.vN.hashValue] as! CustomerDetail.EditField
//            item.title = Lng("vetName")
//            dataArray[ItemAdd.vN.hashValue] = item
//            
//            item = dataArray[ItemAdd.vP.hashValue] as! CustomerDetail.EditField
//            item.title = Lng("vetPhone")
//            item.kbType = .phonePad
//            dataArray[ItemAdd.vP.hashValue] = item
        }
        else {
            self.header?.header.titleLabel.text = Lng ("editCustomer")
            let headerView = BizCustEditHeader.dequeue(tableView)
            headerView.data(self.customer)
            self.tableView.tableHeaderView = headerView
            
            let footerView = self.tableView.dequeueReusableCell(withIdentifier: "BizCustEditFooter")
            self.tableView.tableFooterView = footerView
            
            for _ in 0...ItemEdit.last.hashValue - 1 {
                dataArray.append(CustomerDetail.EditField())
            }
            
<<<<<<< HEAD
            item = dataArray[ItemEdit.co.hashValue] as? CustomerDetail.EditField
=======
            item = dataArray[ItemEdit.co.hashValue] as! CustomerDetail.EditField
>>>>>>> 27c997a30628d22b0ed0092449db4269d26446e3
            item.title = Lng("code")
            item.value = self.customer.code
            dataArray[ItemEdit.co.hashValue] = item
            
<<<<<<< HEAD
            item = dataArray[ItemEdit.ph.hashValue] as? CustomerDetail.EditField
=======
            item = dataArray[ItemEdit.ph.hashValue] as! CustomerDetail.EditField
>>>>>>> 27c997a30628d22b0ed0092449db4269d26446e3
            item.title = Lng("phone")
            item.kbType = .phonePad
            dataArray[ItemEdit.ph.hashValue] = item
            
            //            item = dataArray[ItemEdit.em.hashValue] as! CustomerDetail.EditField
            //            item.title = Lng("email")
            //            item.kbType = .emailAddress
            //            dataArray[ItemEdit.em.hashValue] = item
            
<<<<<<< HEAD
            item = dataArray[ItemEdit.vN.hashValue] as? CustomerDetail.EditField
=======
            item = dataArray[ItemEdit.vN.hashValue] as! CustomerDetail.EditField
>>>>>>> 27c997a30628d22b0ed0092449db4269d26446e3
            item.title = Lng("vetName")
            item.value = self.customer.vetName
            dataArray[ItemEdit.vN.hashValue] = item
            
<<<<<<< HEAD
            item = dataArray[ItemEdit.vP.hashValue] as? CustomerDetail.EditField
=======
            item = dataArray[ItemEdit.vP.hashValue] as! CustomerDetail.EditField
>>>>>>> 27c997a30628d22b0ed0092449db4269d26446e3
            item.title = Lng("vetPhone")
            item.value = self.customer.vetPhone
            item.kbType = .phonePad
            dataArray[ItemEdit.vP.hashValue] = item
        }
    }

    private func save () {
        
        let page = self.customer.idCustomer.isEmpty == false ? "edit" : "add"
        let request = MYHttpRequest.post("company/customer/" + page)
        if self.customer.idCustomer.isEmpty {
            let firstName = dataArray[ItemAdd.fN.hashValue] as! CustomerDetail.EditField
            let lastName = dataArray[ItemAdd.lN.hashValue] as! CustomerDetail.EditField
            let phone = dataArray[ItemAdd.ph.hashValue] as! CustomerDetail.EditField
            let email = dataArray[ItemAdd.em.hashValue] as! CustomerDetail.EditField
            request.json = [
                "companyId"     : CompanyClass.shared.value.id,
                "firstName"     : firstName.value,
                "lastName"      : lastName.value,
                "email"         : email.value,
                "phone"         : phone.value,
            ]
        }
        else {
            let code = dataArray[ItemEdit.co.hashValue] as! CustomerDetail.EditField
            let phone = dataArray[ItemEdit.ph.hashValue] as! CustomerDetail.EditField
            let vetName = dataArray[ItemEdit.vN.hashValue] as! CustomerDetail.EditField
            let vetPhone = dataArray[ItemEdit.vP.hashValue] as! CustomerDetail.EditField
            request.json = [
                "customerId"    : self.customer.idCustomer,
                "code"          : code.value,
                "phone"         : phone.value,
                "vetName"       : vetName.value,
                "vetPhone"      : vetPhone.value,
            ]
        }
        request.start() { (success, response) in
            if success {
                self.httpResponse(response)
            }
        }
    }
    
    fileprivate func httpResponse(_ resultDict: JsonDict) {
        self.postNotificationReloadData(type: .customers)
        if self.customer.idCustomer.isEmpty == false {
            self.navigationHome()
        }
        else {
            self.gotoStoryboard(type: .CustomerFind, ctrlName: "CustomerAdded")
        }
    }

    @IBAction func deleteCustomer () {
        self.alert(Lng("deleteCust"),
                   message: "",
                   cancelBlock: nil) { (UIAlertAction) in
                    self.sendDeleteCustomer()
        }
    }
    
    private func sendDeleteCustomer () {
        let request = MYHttpRequest.post("company/customer/delete")
        request.json = [
            "customerId"    : self.customer.idCustomer
        ]
        request.start() { (success, response) in
            if success {
                self.postNotificationReloadData(type: .customers)
                self.postNotificationReloadData(type: .pets)
                self.navigationHome()
            }
        }
    }
    
    // MARK: table view
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = BizCustEditCell.dequeue(tableView, indexPath)
        cell.delegate = self
        cell.data (dataArray[indexPath.row] as! CustomerDetail.EditField)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
    }
    
    // Cell delegate
    
    func textFieldDidBeginEditing(_ textField: UITextField, indexPath: IndexPath) {
        self.activeRow = indexPath.row
        self.redesignKeyboard(textField: textField)
        self.inputClass.inputTextField(textField)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) {
        self.gotoNextRow()
    }
    
    override func okPressedOnKeyboard() {
        self.gotoNextRow()
    }
    
    private func gotoNextRow () {
        self.activeRow += 1
        if self.activeRow < dataArray.count {
            self.tableView.selectRow(at: IndexPath(row: self.activeRow, section: 0),
                                     animated: true, scrollPosition: .none)
        }
        else {
            self.view.endEditing(true)
        }
    }
}
