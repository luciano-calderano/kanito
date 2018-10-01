//
//  CustomerList
//  Kanito
//
//  Created by Luciano Calderano on 13/12/16.
//  Copyright © 2016 Kanito. All rights reserved.
//

import UIKit
import MessageUI

protocol BookingSelectPetDelegate {
    func BookingSelectPetDelegate (_ me:BookingSelectPet, selected: [String])
}

class BookingSelectPet : MYViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    class func Instance() -> BookingSelectPet {
        let vc = self.load(storyboardName: "BookingSelectPet") as! BookingSelectPet
        return vc
    }
    var delegate: BookingSelectPetDelegate?
    
    @IBOutlet fileprivate var tableView: UITableView!
    @IBOutlet fileprivate var searchText: UITextField!
    @IBOutlet fileprivate var okButton: MYButton!

    private let multiselect = false
    private var pageNum = 0
    private let maxItem = 50
    private var refreshControl: UIRefreshControl!
    private var selectedSection: Int = -1
    private var customerPetsDict: [String: Any]?
    private var customerPetsArray = [PetClass]()
    private var customerPetsSet = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action:#selector(self.refresh), for: .valueChanged)
        self.tableView.addSubview(refreshControl)

        self.loadData()
        self.myButtonTitle()
    }
    
    @objc func refresh () {
        self.pageNum = 0
        dataArray.removeAll()
        self.loadData()
    }
    
    private func loadData() {
        refreshControl.endRefreshing()
        CustomerClass.getList(pageNum: self.pageNum,
                              maxItem: self.maxItem,
                              search: self.searchText.text!) { (result) in
                                self.httpResponse(result)

        }
    }
    
    private func httpResponse(_ customers: [CustomerClass]) {
        let array = dataArray as! [CustomerClass] + customers
        dataArray = array
        self.tableView.reloadData()
        if customers.count == 0 {
            self.alert("", message: Lng("noCustSel"), okBlock: nil)
        }
        else {
            self.pageNum += 1
        }
    }

    @IBAction func selectedTapped () {
        self.delegate?.BookingSelectPetDelegate(self, selected: self.customerPetsSet)
        self.navigationBack()
    }
    
    @IBAction func searchTapped () {
        self.view.endEditing(true)
        self.refresh()
    }
    
    // MARK: table view
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 1
    }
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == self.selectedSection ? self.customerPetsArray.count : 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return indexPath.section == self.selectedSection ? 80 : 0
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BookingSelectPetCustCell") as! BookingSelectPetCustCell
        cell.data (dataArray[section] as! CustomerClass, section: section)
        cell.contentView.tag = section
        let tap = UITapGestureRecognizer.init(target: self, action: #selector (cellTapped(_:)))
        cell.contentView.addGestureRecognizer(tap)

        if (section == dataArray.count - 1) {
            if (dataArray.count == self.pageNum * self.maxItem) {
                self.loadData()
            }
        }
        return cell.contentView
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footer = UIView()
        footer.backgroundColor = UIColor.mySilver
        return footer
    }
    
    @objc func cellTapped (_ sender: UITapGestureRecognizer) {
        if self.selectedSection < 0 {
        }
        else {
            self.tableView.reloadSections(IndexSet(integer: self.selectedSection), with: .fade)
        }
        self.selectedSection = (sender.view?.tag)!
        let customer = dataArray[self.selectedSection] as! CustomerClass
        let pets = self.customerPetsDict?[customer.idCustomer]
        if pets == nil {
            Pets.shared.getListForCustomer(idUser: customer.idUser, completion: { (petList) in
                self.customerPetsArray = petList
                self.tableView.reloadData()
            })
        }
        else {
            self.customerPetsArray = pets as! [PetClass]
            self.tableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = BookingSelectPetPetsCell.dequeue(tableView: tableView, indexPath: indexPath)
        let pet = self.customerPetsArray[indexPath.row]
        cell.data (pet, selected: self.customerPetsSet.contains(pet.idCustomerPet))
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let pet = self.customerPetsArray[indexPath.row]

        if self.multiselect {
            if let i = self.customerPetsSet.index(of: pet.idCustomerPet) {
                self.customerPetsSet.remove(at: i)
            }
            else {
                self.customerPetsSet.append(pet.idCustomerPet)
            }
            self.tableView.reloadRows(at: [indexPath], with: .fade)
        }
        else {
            self.customerPetsSet.removeAll()
            self.customerPetsSet.append(pet.idCustomerPet)
            self.tableView.reloadSections(IndexSet(integer: indexPath.section), with: .fade)
        }
        self.myButtonTitle()
    }
    
    // MARK: cell delegate
    
    private func myButtonTitle () {
        var s = ""
        switch self.customerPetsSet.count {
        case 0:
//            s = "Select one or more pets"
            s = "Select one pet"
        case 1:
            s = Lng("confirm")
//            s = "One pet selected"
        default:
            s = "\(self.customerPetsSet.count) pets selected"
        }
        self.okButton.setTitle(s, for: .normal)
    }
    
    // MARK: search
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        self.refresh()
        return true
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.redesignKeyboard(textField: textField)
    }
    
    @IBAction func textChanged (textField: UITextField) {
    }
}
