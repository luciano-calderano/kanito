//
//  File.swift
//  Kanito
//
//  Created by Luciano Calderano on 27/01/17.
//  Copyright © 2017 Kanito. All rights reserved.
//

import Foundation

//@IBDesignable
class MYCheckView : UIView {
    @IBInspectable var disabledColor: UIColor = UIColor.clear {
        didSet {
            self.layer.borderColor = disabledColor.cgColor
            self.layer.borderWidth = 1
        }
    }
    
    var enabled = false
    var isEnabled: Bool {  get { return enabled }
        set {
            self.enabled = newValue
            self.layer.borderWidth = newValue ? 0 : 2
            self.imageView.isHidden = !newValue
            self.backgroundColor = newValue ? self.myBackColor : UIColor.clear
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.initialize()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initialize()
    }
    
    private let imageView = UIImageView()
    private var myBackColor = UIColor()
    
    fileprivate func initialize () {
        self.myBackColor = self.backgroundColor!
        self.layer.masksToBounds = true
        self.layer.cornerRadius = self.frame.size.width / 2
        
        self.addSubview(self.imageView)
        let w = self.frame.size.width * 0.4
        let h = self.frame.size.height * 0.4
        let x = (self.bounds.size.width - w) / 2
        let y = (self.bounds.size.height - w) / 2
        
        self.imageView.frame = CGRect.init(x: x, y: y, width: w, height: h)
        self.imageView.image = UIImage.init(named: "ico.white.check")// ?//.resize(16)
    }
}

@IBDesignable class MYIconView : UIView {
    var imageView = UIImageView()
    
    @IBInspectable var image: UIImage? {
        didSet {
            self.imageView.image = image
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.initialize()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initialize()
    }
    
    fileprivate func initialize () {
        self.layer.masksToBounds = true
        self.layer.cornerRadius = self.frame.size.width / 2
        
        self.addSubview(self.imageView)
        let w = self.frame.size.width * 0.5
        let h = self.frame.size.height * 0.5
        let x = (self.bounds.size.width - w) / 2
        let y = (self.bounds.size.height - w) / 2
        
        self.imageView.frame = CGRect.init(x: x, y: y, width: w, height: h)
    }
}
