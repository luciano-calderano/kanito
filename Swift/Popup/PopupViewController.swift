//
//  DatePicker.swift
//  Kanito
//
//  Created by Luciano Calderano on 17/02/17.
//  Copyright © 2017 Kanito. All rights reserved.
//

import Foundation

protocol PopupDelegate: class {
    func popupDelegate (data: Any)
}

class PopupViewController: MYViewController {
    weak var delegate: PopupDelegate?

    override func viewDidLoad() {
        self.modalPresentationStyle = .overCurrentContext
        view.backgroundColor = UIColor.clear
        view.isOpaque = true
    }
    
    func sendValueTodelegate () {
        print ("Error")
    }
    
    @IBAction func confirmTapped () {
        self.navigationBack()
        self.sendValueTodelegate()
    }
    @IBAction func cancelTapped () {
        self.navigationBack()
    }
}
