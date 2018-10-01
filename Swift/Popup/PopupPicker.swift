//
//  DatePicker.swift
//  Kanito
//
//  Created by Luciano Calderano on 17/02/17.
//  Copyright © 2017 Kanito. All rights reserved.
//

import Foundation

protocol PopupPickerDelegate {
    func popupPickerSelected (popup: PopupPicker, item: PetItems.EditField)
    func popupPickerCancelled (popup: PopupPicker)
}

class PopupPicker: UIView {
    class func Instance() -> PopupPicker {
        let id = String (describing: self)
        return Bundle.main.loadNibNamed(id, owner: self, options: nil)?.first as! PopupPicker
    }
    
    @IBOutlet private var myPicker: UIPickerView!
    @IBOutlet private var title: MYLabel!
    
    var petItems = PetItems.EditField() {
        didSet {
            update()
        }
    }
    
    var delegate: PopupPickerDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        confPicker(picker: myPicker)
    }
    
    private func update () {
        title.text = petItems.title
        myPicker.reloadAllComponents()
        if petItems.array.count == 0 {
            return
        }
        petItems.index = PetCachedClass.shared.getIndex(for: petItems.id,
                                                        type: petItems.subClassType)
        myPicker.selectRow(petItems.index, inComponent: 0, animated: true)
    }
    
    private func confPicker (picker: UIPickerView) {
        picker.backgroundColor = .myGreyLight
    }
    
    @IBAction func confirmTapped() {
        let row = myPicker.selectedRow(inComponent: 0)
        let item = petItems.getItem(at: row)
        petItems.id = item.id
        petItems.value = item.value
        delegate?.popupPickerSelected(popup: self, item: petItems)
    }
    @IBAction func cancelTapped() {
        delegate?.popupPickerCancelled(popup: self)
    }
}

extension PopupPicker: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return petItems.array.count
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 32
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return petItems.getItem(at: row).value
    }
}
