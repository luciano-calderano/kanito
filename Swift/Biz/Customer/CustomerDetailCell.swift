//
//  CustomerDetailInfoCell
//  Kanito
//
//  Created by Luciano Calderano on 26/10/16.
//  Copyright © 2016 Kanito. All rights reserved.
//

import UIKit

class CustomerDetailInfoCell: UITableViewCell {
    class func dequeue (_ tableView: UITableView,
                        _ indexPath: IndexPath) -> CustomerDetailInfoCell {
        let id = String (describing: self)
        return tableView.dequeueReusableCell(withIdentifier: id, for: indexPath)
            as! CustomerDetailInfoCell
    }

    @IBOutlet fileprivate var titleLabel: MYLabel!
    @IBOutlet fileprivate var valueLabel: MYLabel!
    
    func data (_ data: CustomerDetail.EditField) -> Void {
        self.titleLabel.text = data.title
        self.valueLabel.text = data.value
    }
}

class CustomerDetailPetsCell: UITableViewCell, UITextFieldDelegate {
    class func dequeue (_ tableView: UITableView,
                        _ indexPath: IndexPath) -> CustomerDetailPetsCell {
        let id = String (describing: self)
        return tableView.dequeueReusableCell(withIdentifier: id, for: indexPath)
            as! CustomerDetailPetsCell
    }
    
    @IBOutlet fileprivate var petImage: UIImageView!
    @IBOutlet fileprivate var nameLabel: MYLabel!
    @IBOutlet fileprivate var breed_size_Label: MYLabel!
    @IBOutlet fileprivate var age_gender_Label: MYLabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func data (_ pet: PetClass) -> Void {
        //        self.petImage.image = data.string("")
        self.nameLabel.text = pet.name
        self.breed_size_Label.text = pet.breed.name + ", " + pet.size.name
        self.age_gender_Label.text = pet.age.name + ", " + pet.gender.name
    }
    
}
