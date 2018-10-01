//
//  CustomerListCell
//  Kanito
//
//  Created by Luciano Calderano on 26/10/16.
//  Copyright © 2016 Kanito. All rights reserved.
//

import UIKit

public protocol SignUpDataCellDelegate: class {
    func returnTapped(itenNum: Int)
    func activeField (textField: UITextField)
}

class SignUpDataCell: UITableViewCell, UITextFieldDelegate {
    class func dequeue (_ tableView: UITableView, _ indexPath: IndexPath) -> SignUpDataCell {
        return tableView.dequeueReusableCell(withIdentifier: "SignUpDataCell", for: indexPath) as! SignUpDataCell
    }

    @IBOutlet fileprivate var title: MYLabel!
    @IBOutlet fileprivate var input: MYTextField!
    @IBOutlet fileprivate var showButton: UIButton!
    @IBOutlet fileprivate var buttonWidth: NSLayoutConstraint!

    var itemNum = 0
    var cellItem: SignUpDataClass?
    weak var delegate: SignUpDataCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.input.addTarget(self, action: #selector(textChanged), for: .editingChanged)
        self.input.delegate = self
        self.input.font = UIFont.size(17, type: .Bold)
    }
    
    func data(item: SignUpDataClass, row: Int, delegate: SignUpDataCellDelegate?) -> Void {
        self.itemNum = row
        self.delegate = delegate
        self.cellItem = item
        
        self.showButton.isHidden = item.type != .password
        self.buttonWidth.isActive = item.type == .password
        self.input.isSecureTextEntry = item.type == .password
        
        self.title?.text = item.title
        self.input.placeholder = item.placeholder
        self.input.text = item.value
        self.input.keyboardType = item.type == .email ? UIKeyboardType.emailAddress : UIKeyboardType.default
    }
    
    @IBAction func showPassTapped () {
        self.input.isSecureTextEntry = false
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        if selected {
            self.input.becomeFirstResponder()
        }
    }
    
    @objc func textChanged () {
        cellItem?.value = self.input.text!
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.delegate?.activeField(textField: textField)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.delegate?.returnTapped(itenNum: self.itemNum)
        return true
    }
}
