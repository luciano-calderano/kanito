//
//  BizPetsEditTextCell
//  Kanito
//
//  Created by Luciano Calderano on 26/10/16.
//  Copyright © 2016 Kanito. All rights reserved.
//

import UIKit

protocol BizPetsEditCellDelegate: class {
    func bizPetsEditCellBeginEditing(_ textField: UITextField, indexPath: IndexPath)
    func bizPetsEditCellEndEditing(_ textField: UITextField)
    func bizPetsEditCellTextChanged (text: String)
    func bizPetsEditCellUpdate (item: PetItems.EditField)
}

//MARK: Text edit item cell

class BizPetsEditCell: UITableViewCell {
    @IBOutlet fileprivate var titleLabel: MYLabel!
    
    weak var delegate: BizPetsEditCellDelegate?
    var indexPath: IndexPath!
    var cellItem = PetItems.EditField()
    
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
//        if item.id.isEmpty && item.array.count > 0 {
//            let v = item.array[0]
//            item.id = v.string(item.keys.id)
//            item.value = v.string(item.keys.name)
//            self.delegate?.bizPetsEditCellUpdate(item: item)
//        }
        self.cellItem = item
        self.titleLabel.text = item.title
    }
}

//MARK: Text field cell

class BizPetsEditTextCell: BizPetsEditCell, UITextFieldDelegate {
    class func dequeue (tableView: UITableView, indexPath: IndexPath) -> BizPetsEditTextCell {
        let id = String (describing: self)
        return tableView.dequeueReusableCell(withIdentifier: id, for: indexPath)
            as! BizPetsEditTextCell
    }

    @IBOutlet fileprivate var valueText: MYTextField!

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
    
    override func data (_ item: PetItems.EditField) -> Void {
        super.data(item)
        self.valueText.text = item.value
        self.valueText.isEnabled = item.value.isEmpty
    }
    
    ////////////////////////
    
    @objc func textChanged () {
        self.cellItem.value = self.valueText.text!
        self.delegate?.bizPetsEditCellTextChanged(text: self.valueText.text!)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.delegate?.bizPetsEditCellBeginEditing(textField, indexPath: self.indexPath)
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.delegate?.bizPetsEditCellEndEditing(textField)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

//MARK: Picker cell

class BizPetsPickerCell: BizPetsEditCell, UIPickerViewDelegate, UIPickerViewDataSource {
    class func dequeue (_ tableView: UITableView,
                        _ indexPath: IndexPath) -> BizPetsPickerCell {
        let id = String (describing: self)
        return tableView.dequeueReusableCell(withIdentifier: id, for: indexPath)
            as! BizPetsPickerCell
    }
    
    @IBOutlet fileprivate var valueLabel: MYLabel!
    @IBOutlet fileprivate var valuePicker: UIPickerView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.valuePicker.delegate = self
        self.valuePicker.dataSource = self
    }
    
    override func data (_ item: PetItems.EditField) -> Void {
        super.data(item)
        self.valueLabel.text = item.value
        self.valuePicker.selectRow(item.index, inComponent: 0, animated: true)
    }
    
    
    ////////////////////////
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.cellItem.array.count
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 32
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.cellItem.getItem(at: row).value
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.sendDelegateFor(row: row)
    }
    
    private func sendDelegateFor(row: Int) {
        let item = self.cellItem.getItem(at: row)
        self.cellItem.id = item.id
        self.cellItem.value = item.value
        
        self.valueLabel.text = self.cellItem.value
        self.delegate?.bizPetsEditCellUpdate(item: self.cellItem)
    }
}

//MARK: Header cell

class BizPetsEditHeader: UITableViewCell {
    class func dequeue (_ tableView: UITableView) -> BizPetsEditHeader {
        let id = String (describing: self)
        return tableView.dequeueReusableCell(withIdentifier: id) as! BizPetsEditHeader
    }    
    @IBOutlet fileprivate var petImage: UIImageView!
}

