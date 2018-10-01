//
//  CustomerList
//  Kanito
//
//  Created by Luciano Calderano on 13/12/16.
//  Copyright © 2016 Kanito. All rights reserved.
//

import UIKit
import MessageUI

class CustomerDetail : MYViewController, CustomerDetailHeaderDelegate {
    class func Instance(customer: CustomerClass) -> CustomerDetail {
        let vc = load(storyboard: .Customer) as! CustomerDetail
        vc.customer = customer
        return vc
    }
    
    class EditField {
        var title = ""
        var value = ""
        var kbType = UIKeyboardType.default
    }
    
    enum ButtonSelection: Int {
        case Dett = 0
        case Pets = 1
    }
    
    @IBOutlet fileprivate var tableView: UITableView!

    var customer: CustomerClass!
    private var customerInfo: CustomerInfo!
    private var customerPets: CustomerPets!
    
    private var selectedButton = ButtonSelection.Dett
    private var headerView: CustomerDetailHeader!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.addNotificationReloadData()
        
        self.loadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }

    override func headerViewDxTapped () {
        let ctrl = BizCustEditCtrl.Instance(self.customer)
        self.navigationController?.show(ctrl, sender: self)
    }
    
    override func reloadData(_ notification: Notification) {
        let n = notification.object as! NotificationType
        if n == NotificationType.customerPets {
            self.customerPets.loadPets(idUser: self.customer.idUser)
            self.petsTapped()
        }
    }
    
    private func loadData() {
        self.customerInfo = CustomerInfo.init(customer: self.customer)
        self.customerInfo.customerDetail = self
        self.customerPets = CustomerPets.init(idUser: self.customer.idUser)
        self.customerPets.customerDetail = self

        self.infoTapped()

        self.headerView = CustomerDetailHeader.dequeue(tableView)
        headerView.data(self.customer)
        headerView.delegate = self
        self.tableView.tableHeaderView = headerView
    }
    
    // MARK: - // Buttons
    
    @IBAction func addPet () {
        let ctrl = BizPetsEditCtrl.Instance()
        ctrl.petClass = Pets.shared.getNew()
        ctrl.petClass.customer = self.customer
        self.navigationController?.show(ctrl, sender: self)
    }
    
    // MARK: - Delegate Header buttons tapped
    
    func infoTapped() {
//        self.updateButton.isHidden = false
        self.selectedButton = .Dett
        self.tableView.delegate = self.customerInfo
        self.tableView.dataSource = self.customerInfo
        self.tableView.reloadData()
        self.tableView.tableFooterView = nil
    }
    
    func petsTapped() {
//        self.updateButton.isHidden = true
        self.selectedButton = .Pets
        self.tableView.delegate = self.customerPets
        self.tableView.dataSource = self.customerPets
        self.tableView.reloadData()
        
        let footerView = self.tableView.dequeueReusableCell(withIdentifier: "CustomerDetailAddPetCell")
        let subview = footerView?.viewWithTag(99)
        subview?.layer.borderColor = UIColor.mySilver.cgColor
        subview?.layer.borderWidth = 1
        subview?.layer.cornerRadius = 5
        self.tableView.tableFooterView = footerView
    }
    
    //MARK: - Table view tapped

    func emailTapped(email: String) {
        UIMessageClass.mainCtrl = self
        UIMessageClass.sendEmail(email)
    }
    
    func phoneTapped(phone: String) {
        UIMessageClass.mainCtrl = self
        UIMessageClass.openCall(phone)
    }
    
    func petSelected (pet: PetClass) {
        pet.customer = self.customer
        let ctrl = BizPetsDettCtrl.Instance(petClass: pet)
        self.show(ctrl, sender: self)
    }

    //MARK: - CustomerInfoClass
    
    class CustomerInfo : NSObject, UITableViewDelegate, UITableViewDataSource {
        var customerDetail: CustomerDetail!
        private var dataArray = [EditField]()
        init(customer: CustomerClass) {
            let new: (String, String) -> (CustomerDetail.EditField) = { (title, value) in
                let item = CustomerDetail.EditField()
                item.title = Lng(title)
                item.value = value
                return item
            }
            dataArray.append(new("code",     customer.code))
            dataArray.append(new("phone",    customer.phone))
            dataArray.append(new("email",    customer.email))
            dataArray.append(new("vetName",  customer.vetName))
            dataArray.append(new("vetPhone", customer.vetPhone))
        }

        func numberOfSections(in tableView: UITableView) -> Int {
            return 1
        }
        
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return dataArray.count
        }
        
        func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return 70
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = CustomerDetailInfoCell.dequeue(tableView, indexPath)
            cell.data (dataArray[indexPath.row])
            return cell
        }
        
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            let field = dataArray[indexPath.row]
            switch indexPath.row {
            case 1:
                customerDetail.phoneTapped(phone: field.value)
            case 2:
                customerDetail.emailTapped(email: field.value)
            case 4:
                customerDetail.phoneTapped(phone: field.value)
            default:
                break
            }
        }
    }
    
    class CustomerPets: NSObject, UITableViewDelegate, UITableViewDataSource {
        var customerDetail: CustomerDetail!
        var dataArray = [PetClass]()
        init(idUser: String) {
            super.init()
            self.loadPets(idUser: idUser)
        }
        
        func loadPets (idUser: String) {
            Pets.shared.getListForCustomer(idUser: idUser) {
                (petArray) in
                self.dataArray = petArray
            }
        }

        func numberOfSections(in tableView: UITableView) -> Int {
            return 1
        }
        
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return dataArray.count
        }
        
        func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return 150
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = CustomerDetailPetsCell.dequeue(tableView, indexPath)
            cell.data (dataArray[indexPath.row])
            return cell
        }
        
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            tableView.deselectRow(at: indexPath, animated: true)
            self.customerDetail.petSelected(pet: dataArray[indexPath.row])
        }
    }
}


