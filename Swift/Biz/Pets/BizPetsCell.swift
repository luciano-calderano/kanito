//
//  BizPetsCell
//  Kanito
//
//  Created by Luciano Calderano on 26/10/16.
//  Copyright © 2016 Kanito. All rights reserved.
//

import UIKit

class BizPetsCell: UITableViewCell {
    class func dequeue (_ tableView: UITableView,
                        _ indexPath: IndexPath) -> BizPetsCell {
        let id = String (describing: self)
        return tableView.dequeueReusableCell(withIdentifier: id, for: indexPath)
            as! BizPetsCell
    }

    @IBOutlet fileprivate var petImage: UIImageView!
    @IBOutlet fileprivate var petNameLabel: MYLabel!
    @IBOutlet fileprivate var petDataLabel: MYLabel!

    @IBOutlet fileprivate var nameLabel: MYLabel!
    @IBOutlet fileprivate var iniziali: UIView!
    
    override func awakeFromNib() {
        let line = UIView()
        line.backgroundColor = UIColor.myGreyLight
        self.addSubview(line)
        self.costraintTo(view: line, atb: .bottom, f: 0)
        self.costraintTo(view: line, atb: .right, f: 0)
        self.costraintTo(view: line, atb: .left, f: 0)
        self.costraintTo(view: line, atb: .height, f: 5)

    }
    
    func data (_ petClass: PetClass) -> Void {
        petImage.image = petClass.image
        petNameLabel.text = petClass.name
        petDataLabel.text = petClass.breed.name + ", " +  petClass.age.name + ", " + petClass.size.name
        CustomerClass.getById(petClass.customer.idCustomer) { (customer) in
            petClass.customer = customer
            self.updateCustomer(petClass.customer)
        }
        self.updateCustomer(petClass.customer)
    }
    
    private func updateCustomer (_ customer: CustomerClass) {
        self.nameLabel.text = customer.name
        customer.setAvatar(into: self.iniziali)
        
    }
}
