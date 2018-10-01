//
//  CustomerCell
//  Kanito
//
//  Created by Luciano Calderano on 26/10/16.
//  Copyright © 2016 Kanito. All rights reserved.
//

import UIKit

class BookingSelectPetCustCell: UITableViewCell {
    class func dequeue (tableView: UITableView, indexPath: IndexPath) -> BookingSelectPetCustCell {
        let id = String (describing: self)
        return tableView.dequeueReusableCell(withIdentifier: id, for: indexPath)
            as! BookingSelectPetCustCell
    }

    @IBOutlet fileprivate var avatarContainer: UIView!
    @IBOutlet fileprivate var nameLabel: MYLabel!
    @IBOutlet fileprivate var infoLabel: MYLabel!

    private var section = 0
    
//    override func awakeFromNib() {
//        super.awakeFromNib()
//        let line = UIView()
//        let view = self.contentView
//        line.backgroundColor = UIColor.mySilver
//        view.addSubview(line)
//        view.costraintTo(view: line, atb: .top, f: 0)
//        view.costraintTo(view: line, atb: .right, f: 0)
//        view.costraintTo(view: line, atb: .left, f: 0)
//        view.costraintTo(view: line, atb: .height, f: 1)
//    }
//    
    func data (_ customer: CustomerClass, section: Int) -> Void {
        self.section = section
        customer.setAvatar(into: self.avatarContainer)
        self.nameLabel.text = customer.name
        self.infoLabel.text = customer.phone
    }
}
