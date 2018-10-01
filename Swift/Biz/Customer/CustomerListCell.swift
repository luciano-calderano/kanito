//
//  CustomerListCell
//  Kanito
//
//  Created by Luciano Calderano on 26/10/16.
//  Copyright © 2016 Kanito. All rights reserved.
//

import UIKit

protocol CustomerListCellDelegate: class {
    func emailTapped(email: String)
    func phoneTapped(phone: String)
}

class CustomerListCell: UITableViewCell {
    class func dequeue (tableView: UITableView, indexPath: IndexPath) -> CustomerListCell {
        let id = String (describing: self)
        return tableView.dequeueReusableCell(withIdentifier: id, for: indexPath)
            as! CustomerListCell
    }

    weak var delegate: CustomerListCellDelegate?
    
    @IBOutlet var mainView: UIView!
    @IBOutlet var phoneButton: UIButton!
    @IBOutlet var emailButton: UIButton!
    
    @IBOutlet fileprivate var avatarContainer: UIView!

    @IBOutlet fileprivate var nameLabel: MYLabel!
    @IBOutlet fileprivate var emailLabel: MYLabel!
    @IBOutlet fileprivate var phoneLabel: MYLabel!
    
    @IBOutlet fileprivate var status01Label: MYLabel!
    @IBOutlet fileprivate var status02Label: MYLabel!
    
    @IBOutlet fileprivate var status01Image: UIImageView!
    @IBOutlet fileprivate var status02Image: UIImageView!
    @IBOutlet fileprivate var status03Image: UIImageView!
    
    @IBOutlet fileprivate var petContainerView: PetContainerView!

    private var email = ""
    private var phone = ""
    
    override func awakeFromNib() {
        super.awakeFromNib()
        status01Label.layer.borderWidth = 2
        status01Label.layer.borderColor = UIColor.myOrange.cgColor
        status01Label.layer.cornerRadius = 3
        
        status02Label.layer.borderWidth = 2
        status02Label.layer.borderColor = UIColor.myOrange.cgColor
        status02Label.layer.cornerRadius = 3
    }

    func data (_ customer: CustomerClass) -> Void {
        customer.setAvatar(into: self.avatarContainer)
        self.nameLabel.text = customer.name
        self.emailLabel.text = customer.email
        self.phoneLabel.text = customer.phone
        self.status01Label.text = "  " + customer.status + "  "
        self.status02Label.isHidden = true
        if customer.pets.count == 0 {
            Pets.shared.getListForCustomer(idUser: customer.idUser) {
                (petArray) in
                customer.pets = petArray
                self.showPets(pets: customer.pets)
            }
        }
        self.showPets(pets: customer.pets)
    }

    private func showPets (pets: [PetClass]) {
        self.petContainerView.showPets(petList: pets, maxIcons: 3)
    }
    
    @IBAction func emailTapped () {
        self.delegate?.emailTapped(email: self.email)
    }
    
    @IBAction func phoneTapped () {
        self.delegate?.phoneTapped(phone: self.phone)
    }
}
