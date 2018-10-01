//
//  DatePicker.swift
//  Kanito
//
//  Created by Luciano Calderano on 17/02/17.
//  Copyright © 2017 Kanito. All rights reserved.
//

import Foundation

protocol PopupDateDelegate: class {
    func popupDateConfirmed (popup: PopupDate, date: Date)
    func popupDateCancelled (popup: PopupDate)
}

class PopupDate: UIView {
    class func Instance() -> PopupDate {
        let id = String (describing: self)
        return Bundle.main.loadNibNamed(id, owner: self, options: nil)?.first as! PopupDate
    }
    
    @IBOutlet private var datePicker: UIDatePicker!
    var delegate: PopupDateDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        self.confPicker(picker: self.datePicker)
    }
    
    func update (date: Date) {
        self.datePicker.date = date
    }
    
    private func confPicker (picker: UIDatePicker) {
        picker.backgroundColor = UIColor.myGreyLight
        picker.datePickerMode = .date
    }
    
    @IBAction func confirmTapped() {
        self.delegate?.popupDateConfirmed(popup: self,
                                          date: self.datePicker.date)
    }
    @IBAction func cancelTapped() {
        self.delegate?.popupDateCancelled(popup: self)
    }
}
