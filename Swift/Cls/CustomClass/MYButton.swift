//
//  MYButton.swift
//  Kanito
//
//  Created by Luciano Calderano on 03/11/16.
//  Copyright © 2016 Kanito. All rights reserved.
//

import UIKit

class MYButton: UIButton {
    @IBInspectable var borderColor: UIColor = UIColor.clear  {
        didSet {
            self.layer.borderWidth = 1
            self.layer.borderColor = borderColor.cgColor
        }
    }

    @IBInspectable var cornerRadius:CGFloat = 3 {
        didSet {
            self.layer.cornerRadius = cornerRadius
        }
    }

//    @IBInspectable var borderMargins = false
//    {
//        get { return self.layer.borderWidth > 0 }
//        set { self.layer.borderWidth = newValue ? 2 : 0; self.layer.borderColor = UIColor.myOrange.cgColor }
//    }
    var title: String {
        get { return self.titleLabel!.text! }
        set { self.setTitle(newValue.tryLang(), for: UIControl.State()) }
    }
    
    required internal init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.initialize()
    }
    
    fileprivate func initialize () {
        self.layer.masksToBounds = false
        
        self.showsTouchWhenHighlighted = true
        if self.backgroundColor == nil {
            self.backgroundColor = UIColor.myOrange
        }
        if self.titleColor(for: .normal) == nil {
            self.setTitleColor(UIColor.white, for: UIControl.State.normal)
        }
        self.titleLabel?.font = UIFont.mySize((self.titleLabel?.font.pointSize)!)
        self.title = self.currentTitle ?? ""
        
//        self.borderMargins = false
//        self.layer.cornerRadius = cornerRadius
    }
}
