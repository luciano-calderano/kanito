//
//  CustomerPetsCell
//  Kanito
//
//  Created by Luciano Calderano on 26/10/16.
//  Copyright © 2016 Kanito. All rights reserved.
//

import UIKit

class BookingSelectPetPetsCell: UITableViewCell {
    class func dequeue (tableView: UITableView, indexPath: IndexPath) -> BookingSelectPetPetsCell {
        let id = String (describing: self)
        return tableView.dequeueReusableCell(withIdentifier: id, for: indexPath)
            as! BookingSelectPetPetsCell
    }

    @IBOutlet fileprivate var petPicContainer: UIView!
    @IBOutlet fileprivate var petPic: UIImageView!
    @IBOutlet fileprivate var nameLabel: MYLabel!
    @IBOutlet fileprivate var info1Label: MYLabel!
    @IBOutlet fileprivate var info2Label: MYLabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        self.petPic.layer.cornerRadius = self.petPic.frame.size.width / 2
        self.petPic.layer.masksToBounds = true
        self.petPicContainer.layer.cornerRadius = self.petPicContainer.frame.size.width / 2
        self.petPicContainer.layer.masksToBounds = true
        self.petPicContainer.layer.borderColor = UIColor.myBizGreen.cgColor
        
        let line = UIView()
        let view = self.contentView
        line.backgroundColor = UIColor.mySilver
        view.addSubview(line)
        view.costraintTo(view: line, atb: .top, f: 0)
        view.costraintTo(view: line, atb: .right, f: 0)
        view.costraintTo(view: line, atb: .left, f: self.nameLabel.frame.origin.x)
        view.costraintTo(view: line, atb: .height, f: 1)
    }

    func data (_ pet: PetClass, selected: Bool) -> Void {
        self.nameLabel.text = pet.name
        self.info1Label.text = pet.breed.name
        self.info2Label.text = pet.age.name
        self.petPic.image = pet.image
        self.petPicContainer.layer.borderWidth = selected ? 2 : 0
    }
}
