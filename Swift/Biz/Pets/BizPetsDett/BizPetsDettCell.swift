//
//  BizPetsDettCell
//  Kanito
//
//  Created by Luciano Calderano on 26/10/16.
//  Copyright © 2016 Kanito. All rights reserved.
//

import UIKit

class BizPetsDettCell: UITableViewCell, UITextFieldDelegate {
    class func dequeue (tableView: UITableView, indexPath: IndexPath) -> BizPetsDettCell {
        let id = String (describing: self)
        return tableView.dequeueReusableCell(withIdentifier: id, for: indexPath)
            as! BizPetsDettCell
    }

    @IBOutlet fileprivate var titleLabel: MYLabel!
    @IBOutlet fileprivate var valueLabel: MYLabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let line = UIView()
        line.backgroundColor = UIColor.mySilver
        self.addSubview(line)
        self.costraintTo(view: line, atb: .bottom, f: 0)
        self.costraintTo(view: line, atb: .right, f: -8)
        self.costraintTo(view: line, atb: .left, f: 8)
        self.costraintTo(view: line, atb: .height, f: 1)

    }

    func data (_ item: PetItems.EditField) -> Void {
        self.titleLabel.text = item.title
        self.valueLabel.text = item.value
    }
}

// MARK: Header cell

class BizPetsDettHeader: UITableViewCell {
    class func dequeue (_ tableView: UITableView)
        -> BizPetsDettHeader {
        let id = "BizPetsDettHeader"
        return tableView.dequeueReusableCell(withIdentifier: id)
            as! BizPetsDettHeader
    }
    
    @IBOutlet fileprivate var mainImage: UIImageView!
    @IBOutlet fileprivate var typeImage: UIImageView!
    @IBOutlet fileprivate var nameLabel: MYLabel!
    @IBOutlet fileprivate var infoLabel: MYLabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.typeImage.alpha = 0.8
    }
    
    func data (_ petClass: PetClass) -> Void {
        self.nameLabel.text = petClass.name
        self.infoLabel.text = petClass.breed.name + " • " + petClass.age.name + " • " + petClass.size.name
        self.mainImage.image = UIImage.init(named: "ico.grey.dog")
        let iconName = petClass.type.id == "D" ? "badge-dog" : "badge-dog"
        self.typeImage.image = UIImage.init(named: iconName)
    }
}
