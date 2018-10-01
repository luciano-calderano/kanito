//
//  DatePicker.swift
//  Kanito
//
//  Created by Luciano Calderano on 17/02/17.
//  Copyright © 2017 Kanito. All rights reserved.
//

import Foundation

protocol PopupTimeDelegate: class {
//    func popupTimeDelegate (popup: PopupTime, data: [Date])
    func popupTimeConfirmed (popup: PopupTime, startTime: Date, endTime: Date)
    func popupTimeCancelled (popup: PopupTime)
}

class PopupTime: UIView {
    class func Instance() -> PopupTime {
        let id = String (describing: self)
        return Bundle.main.loadNibNamed(id, owner: self, options: nil)?.first as! PopupTime
    }
    
    @IBOutlet private var datePickerIni: UIDatePicker!
    @IBOutlet private var datePickerEnd: UIDatePicker!
    var delegate: PopupTimeDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        self.confPicker(picker: self.datePickerIni)
        self.confPicker(picker: self.datePickerEnd)
    }
    
    func update (dateIni: Date, dateEnd: Date) {
        self.datePickerIni.date = dateIni
        self.datePickerEnd.date = dateEnd
    }
    
    private func confPicker (picker: UIDatePicker) {
        picker.backgroundColor = UIColor.myGreyLight
        picker.datePickerMode = .time
        picker.minuteInterval = 5
    }
    
    @IBAction func confirmTapped() {
        guard self.datePickerEnd.date > self.datePickerIni.date else {
            return
        }
        self.delegate?.popupTimeConfirmed(popup: self,
                                          startTime: self.datePickerIni.date,
                                          endTime: self.datePickerEnd.date)
    }
    @IBAction func cancelTapped() {
        self.delegate?.popupTimeCancelled(popup: self)
    }
}
