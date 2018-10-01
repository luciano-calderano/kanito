//
//  BizDashReseCollCell.swift
//  Kanito
//
//  Created by Luciano Calderano on 19/01/17.
//  Copyright © 2017 Kanito. All rights reserved.
//

import Foundation

class BookingDetailCell: UICollectionViewCell {
    class func dequeue (_ collectionView: UICollectionView, _ indexPath: IndexPath) -> BookingDetailCell {
        return collectionView.dequeueReusableCell(withReuseIdentifier: "BookingDetailCell",
                                                  for: indexPath) as! BookingDetailCell
    }

    @IBOutlet private var nameLabel: MYLabel!
    @IBOutlet private var breedLabel: MYLabel!
    @IBOutlet private var genderAndSizeLabel: MYLabel!
    @IBOutlet private var ageLabel: MYLabel!
    @IBOutlet private var ownerLabel: MYLabel!
    @IBOutlet private var iniziali: MYLabel!

    private var petClass: PetClass!

    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.borderColor = UIColor.myGreyMedium.cgColor
        self.layer.borderWidth = 1
        self.layer.cornerRadius = 5
        
        self.iniziali.layer.cornerRadius = self.iniziali.frame.size.width / 2
        self.iniziali.layer.masksToBounds = true


    }

    private func updatePetData () {
        Pets.shared.getPet(id: self.petClass.idCustomerPet) { (pet) in
            self.breedLabel.text = pet.breed.name
            self.genderAndSizeLabel.text = pet.gender.name + ", " + pet.size.name
            self.ageLabel.text = pet.age.name
        }
    }
    
    func data (value: PetClass) {
        self.petClass = value
        
        self.nameLabel.text = self.petClass.name
        self.breedLabel.text = self.petClass.breed.name
        self.genderAndSizeLabel.text = self.petClass.gender.name + ", " + self.petClass.size.name
        self.ageLabel.text = self.petClass.age.name
        CustomerClass.getById(self.petClass.customer.idCustomer) { (customer) in
            self.ownerLabel.text = customer.name
            customer.setAvatar(into: self.iniziali)
        }
        self.updatePetData()
    }
}
