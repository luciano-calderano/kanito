//
//  CustomerListCell
//  Kanito
//
//  Created by Luciano Calderano on 26/10/16.
//  Copyright © 2016 Kanito. All rights reserved.
//

import UIKit

protocol CustomerDetailHeaderDelegate: class {
    func infoTapped ()
    func petsTapped ()
}

class CustomerDetailHeader: UITableViewCell {
    class func dequeue (_ tableView: UITableView) -> CustomerDetailHeader {
        let id = String (describing: self)
        return tableView.dequeueReusableCell(withIdentifier: id)
            as! CustomerDetailHeader
    }

    weak var delegate: CustomerDetailHeaderDelegate?

    @IBOutlet fileprivate var iniziali: UIView!
    @IBOutlet fileprivate var nameLabel: MYLabel!
    @IBOutlet fileprivate var badge01: UIButton!
    @IBOutlet fileprivate var badge02: UIButton!
    @IBOutlet fileprivate var badge03: UIButton!
    @IBOutlet fileprivate var hiddenLabel: MYLabel!
    @IBOutlet fileprivate var buttonView: UIView!

    @IBOutlet fileprivate var infoBtn: UIButton!
    @IBOutlet var petsBtn: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        self.hiddenLabel.isHidden = true
        self.buttonView.layer.borderWidth = 1
        self.buttonView.layer.borderColor = UIColor.myGreyLight.cgColor
        self.buttonView.layer.cornerRadius = 3
        
        self.infoBtn.setImage(self.infoBtn.image(for: .normal)?.resize(20), for: .normal)
        self.infoBtn.setImage(self.infoBtn.image(for: .selected)?.resize(20), for: .selected)
        self.petsBtn.setImage(self.petsBtn.image(for: .normal)?.resize(20), for: .normal)
        self.petsBtn.setImage(self.petsBtn.image(for: .selected)?.resize(20), for: .selected)
        
        infoBtn.imageEdgeInsets = UIEdgeInsets.init(top: 10, left: 0, bottom: 10, right: 20)
        petsBtn.imageEdgeInsets = UIEdgeInsets.init(top: 10, left: 0, bottom: 10, right: 20)
        
        self.infoBtn.isSelected = true
        self.petsBtn.isSelected = false
    }

    func data (_ customer: CustomerClass) -> Void {
        customer.setAvatar(into: self.iniziali)
        self.nameLabel.text = customer.name
        self.hiddenLabel.text = "  " + customer.status + "  "
    }
    
    @IBAction func badge02Tapped () {
        hiddenLabel.isHidden = false
        let dispatchTime = DispatchTime.now() + .seconds(2)
        DispatchQueue.main.asyncAfter(deadline: dispatchTime) {
            UIView.animate(withDuration: 0.2, animations: {
                self.hiddenLabel.isHidden = true
            })
        }
    }

    @IBAction func infoTapped () {
        self.infoBtn.isSelected = true
        self.petsBtn.isSelected = false
        self.delegate?.infoTapped()
    }
    @IBAction func petsTapped () {
        self.infoBtn.isSelected = false
        self.petsBtn.isSelected = true
        self.delegate?.petsTapped()
    }
}
