//
//  BizCustEditCell
//  Kanito
//
//  Created by Luciano Calderano on 26/10/16.
//  Copyright © 2016 Kanito. All rights reserved.
//

import UIKit

protocol BizCustEditCellDelegate: class {
    func textFieldDidBeginEditing(_ textField: UITextField, indexPath: IndexPath)
    func textFieldShouldReturn(_ textField: UITextField)
}

class BizCustEditCell: UITableViewCell, UITextFieldDelegate {
    class func dequeue (_ tableView: UITableView,
                        _ indexPath: IndexPath) -> BizCustEditCell {
        let id = String (describing: self)
        let cell = tableView.dequeueReusableCell(withIdentifier: id, for: indexPath)
            as! BizCustEditCell
        cell.indexPath = indexPath
        return cell
    }
    weak var delegate: BizCustEditCellDelegate?
    var indexPath: IndexPath!

    @IBOutlet fileprivate var titleLabel: MYLabel!
    @IBOutlet fileprivate var valueText: MYTextField!
    
    private var cellItem: CustomerDetail.EditField!

    override func awakeFromNib() {
        super.awakeFromNib()
        self.valueText.addTarget(self, action: #selector(textChanged), for: .editingChanged)
        self.valueText.delegate = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        if selected {
            valueText.becomeFirstResponder()
        }
    }
    
    func data (_ data: CustomerDetail.EditField) -> Void {
        self.cellItem = data
        self.titleLabel.text = data.title
        self.valueText.text = data.value
        self.valueText.keyboardType = data.kbType
    }
    
    ////////////////////////
    
    @objc func textChanged () {
        self.cellItem?.value = self.valueText.text!
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.delegate?.textFieldDidBeginEditing(textField, indexPath: self.indexPath)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.delegate?.textFieldShouldReturn(textField)
        return true
    }
}

// MARK: Header cell

class BizCustEditHeader: UITableViewCell {
    class func dequeue (_ tableView: UITableView) -> BizCustEditHeader {
        return tableView.dequeueReusableCell(withIdentifier: "BizCustEditHeader") as! BizCustEditHeader
    }
    
    @IBOutlet fileprivate var iniziali: MYLabel!
    @IBOutlet fileprivate var name: MYLabel!
    
    func data (_ customer: CustomerClass) -> Void {
        customer.setAvatar(into: self.iniziali)
        self.name.text = customer.name
    }
}

