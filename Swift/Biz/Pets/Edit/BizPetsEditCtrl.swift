//
//  BizPetsEditCtrl
//  Kanito
//
//  Created by Luciano Calderano on 13/12/16.
//  Copyright © 2016 Kanito. All rights reserved.
//

import UIKit

class BizPetsEditCtrl: MYViewController {
    class func Instance () -> BizPetsEditCtrl {
        let vc = load(storyboard: .BizPets) as! BizPetsEditCtrl
        return vc
    }
    var petClass: PetClass!
    
    enum EditRequestType: String {
        case add = "company/pet/add"
        case edit = "company/pet/edit"
        case delete = "company/pet/del"
    }
    
    @IBOutlet fileprivate var tableView: UITableView!
    
    private var inputClass = InputClass()
    private var selectedIndex: IndexPath?
    private var popup = PopupPicker.Instance()

    override func viewDidLoad() {
        super.viewDidLoad()
        popup.delegate = self

        setBackAsHome = true
        inputClass.config(tableView: tableView, view: view)
        
        if petClass!.idCustomerPet.isEmpty {
        }
        else {
            let headerView = BizPetsEditHeader.dequeue(tableView)
            tableView.tableHeaderView = headerView
            
            let footerView = tableView.dequeueReusableCell(withIdentifier: "BizPetsEditFooter")
            tableView.tableFooterView = footerView
        }
        loadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
    }
    
    override func headerViewDxTapped() {
        save()
    }
    
    func loadData() {
        var item: PetItems.EditField!
        
        item = PetItems.EditField(type: .name)
        item.title = Lng("petName")
        item.value = petClass.name
        dataArray.append(item)
        
        item = PetItems.EditField(type: .petType, editMode: true)
        item.title = Lng("petType")
        item.id = petClass.type.id
        item.value = petClass.type.name
        dataArray.append(item)
        
        item = PetItems.EditField(type: .breed, editMode: true)
        item.title = Lng("petBreed")
        item.id = petClass.breed.id
        item.value = petClass.breed.name
        dataArray.append(item)
        
        item = PetItems.EditField(type: .age, editMode: true)
        item.title = Lng("petAge")
        item.id = petClass.age.id
        item.value = petClass.age.name
        dataArray.append(item)
        
        item = PetItems.EditField(type: .size, editMode: true)
        item.title = Lng("petSize")
        item.id = petClass.size.id
        item.value = petClass.size.name
        dataArray.append(item)
        
        item = PetItems.EditField(type: .gender, editMode: true)
        item.title = Lng("petGender")
        item.id = petClass.gender.id
        item.value = petClass.gender.name
        dataArray.append(item)
    }

    private func save () {
        view.endEditing(true)
        if petClass!.idCustomerPet.isEmpty {
            createRequest(of: .add)
        }
        else {
            createRequest(of: .edit)
        }
    }
    
    @IBAction func deletePet () {
        alert(Lng("petDelete"),
                   message: Lng("areSure"),
                   cancelBlock: nil) { (UIAlertAction) in
                self.createRequest(of: .delete)
        }
    }
    
    private func createRequest (of type: EditRequestType) {
        let req = PetEditRequest(petCls: petClass!)
        req.start(type: type) { (success) in
            if success {
                self.postNotificationReloadData(type: .customerPets)
                _ = self.navigationController?.popToRootViewController(animated: true)
            }
        }
    }
    
    private func showPopup(_ popup: UIView) {
        var rect = view.bounds
        rect.origin.y = rect.size.height
        view.addSubview(popup)
        popup.frame = rect
        view.setNeedsLayout()
        UIView.animate(withDuration: 0.3, animations: {
            self.popup.frame = self.view.bounds
            self.view.setNeedsLayout()
        })
    }
    
    private func closePopup(_ popup: UIView) {
        view.setNeedsLayout()
        UIView.animate(withDuration: 0.3, animations: {
            var rect = popup.bounds
            rect.origin.y = -rect.size.height
            self.popup.frame = rect
            self.view.setNeedsLayout()
        }) { (true) in
            self.popup.removeFromSuperview()
        }
    }

     override func okPressedOnKeyboard() {
        view.endEditing(true)
    }
    
    //MARK: Server request
    
    class PetEditRequest {
        var petClass: PetClass!
        init (petCls: PetClass) {
            petClass = petCls
        }

        func start (type: EditRequestType, completion: @escaping (Bool) -> Void) {
            let pet = petClass!
            let request = MYHttpRequest.post(type.rawValue)
            switch type {
            case .add:
                request.json = [
                    "companyId"     : CompanyClass.shared.value.id,
                    "userId"        : pet.customer.idUser,
                    "petType"       : pet.type.id,
                    "petName"       : pet.name,
                    "breedId"       : pet.breed.id,
                    "sizeId"        : pet.size.id,
                    "ageId"         : pet.age.id,
                    "gender"        : pet.gender.id,
                ]
            case .edit:
                request.json = [
                    "customerPetId" : pet.idCustomerPet,
                    "petType"       : pet.type.id,
                    "breedId"       : pet.breed.id,
                    "sizeId"        : pet.size.id,
                    "ageId"         : pet.age.id,
                    "gender"        : pet.gender.id,
                ]
            case .delete:
                request.json = [
                    "customerPetId" : pet.idCustomerPet
                ]
            }

            request.start() { (success, response) in
                completion (success)
            }
        }
    }
}

// MARK:- UITableViewDelegate

extension BizPetsEditCtrl : UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let petEditItems = dataArray[indexPath.row] as! PetItems.EditField
        let cell:BizPetsEditCell!
        if petEditItems.subClassType == .name {
            cell = BizPetsEditTextCell.dequeue(tableView: tableView, indexPath: indexPath)
        }
        else {
            cell = BizPetsPickerCell.dequeue(tableView, indexPath)
            cell.isSelected = (indexPath.row == selectedIndex?.row)
        }
        cell.delegate = self
        cell.indexPath = indexPath
        cell.data (petEditItems)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndex = indexPath
        let petEditItems = dataArray[indexPath.row] as! PetItems.EditField
        if petEditItems.subClassType == .name {
            return
        }
        view.endEditing(true)
        popup.petItems = petEditItems
        showPopup(popup)
    }
}

//MARK:- BizPetsEditCellDelegate

extension BizPetsEditCtrl: BizPetsEditCellDelegate {
    func bizPetsEditCellUpdate(item: PetItems.EditField) {
        switch item.subClassType {
        case .breed:
            petClass?.breed.id = item.id
            petClass?.breed.name = item.value
        case .age:
            petClass?.age.id = item.id
            petClass?.age.name = item.value
        case .size:
            petClass?.size.id = item.id
            petClass?.size.name = item.value
        case .gender:
            petClass?.gender.id = item.id
            petClass?.gender.name = item.value
        case .petType:
            petClass?.type.id = item.id
            petClass?.type.name = item.value
        default:
            break
        }
    }
    
    func bizPetsEditCellBeginEditing(_ textField: UITextField, indexPath: IndexPath) {
        redesignKeyboard(textField: textField)
        inputClass.inputTextField(textField)
        if (selectedIndex != nil) {
            selectedIndex = nil
            tableView.reloadData()
        }
        let cell = tableView.cellForRow(at: indexPath)
        cell?.setSelected(true, animated: true)
    }
    
    func bizPetsEditCellEndEditing(_ textField: UITextField) {
        textField.resignFirstResponder()
    }
    
    func bizPetsEditCellTextChanged (text: String) {
        petClass?.name = text
    }
}

extension BizPetsEditCtrl: PopupPickerDelegate {
    func popupPickerSelected(popup: PopupPicker, item: PetItems.EditField) {
        guard let pet = petClass else { return }
        
        switch item.subClassType {
        case .breed:
            pet.breed.id = item.id
            pet.breed.name = item.value
        case .age:
            pet.age.id = item.id
            pet.age.name = item.value
        case .size:
            pet.size.id = item.id
            pet.size.name = item.value
        case .gender:
            pet.gender.id = item.id
            pet.gender.name = item.value
        case .petType:
            pet.type.id = item.id
            pet.type.name = item.value
        default:
            break
        }
        closePopup(popup)
        tableView.reloadData()
        
    }
    func popupPickerCancelled (popup: PopupPicker) {
        closePopup(popup)
    }
}
