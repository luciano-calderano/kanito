//
//  HeaderView
//  Kanito
//
//  Created by Luciano Calderano on 17/11/16.
//  Copyright © 2016 Kanito. All rights reserved.
//

import UIKit

public protocol HeaderViewDelegate: class {
    func headerViewSxTapped()
    func headerViewDxTapped()
}

class HeaderContainerView : UIView, HeaderViewDelegate {
    weak var delegate:HeaderViewDelegate?
    let header = HeaderView.Instance()
    
    @IBInspectable var title:String = ""
    @IBInspectable var sxImage: UIImage?
    @IBInspectable var dxTitle:String = ""
    @IBInspectable var dxImage: UIImage?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        self.initialize()
    }
    
    func initialize() {
        self.addSubview(header)
        header.delegate = self
        header.frame = self.bounds
        header.backgroundColor = self.backgroundColor
        header.titleLabel.text = self.title.tryLang()

        if self.sxImage == nil {
            header.sxButton.isHidden = true
        }
        else {
            header.sxButton.isHidden = false
            header.sxButton.setImage(self.sxImage, for: .normal)
        }

        header.dxButton.isHidden = false
        if self.dxTitle.isEmpty == false {
            let button = UIButton()
            button.titleLabel?.font = header.dxButton.titleLabel?.font
            button.setTitle(self.dxTitle.tryLang(), for: .normal)
            button.sizeToFit()
            header.dxButtonSize.constant = button.frame.size.width
            header.dxButton.setTitle(self.dxTitle.tryLang(), for: .normal)
        }
        else {
            if self.dxImage == nil {
                header.dxButton.isHidden = true
            }
            else {
                header.dxButton.setImage(self.dxImage, for: .normal)
            }
        }
    }
    
    func headerViewSxTapped() {
        self.delegate?.headerViewSxTapped()
    }
    
    func headerViewDxTapped () {
        self.delegate?.headerViewDxTapped()
    }
}


class HeaderView : UIView {
    class func Instance() -> HeaderView {
        let nib = UINib(nibName: "HeaderView", bundle: nil)
        let view = nib.instantiate(withOwner: self, options: nil).first as! HeaderView
        return view
    }

    @IBOutlet var titleLabel: MYLabel!
    @IBOutlet var sxButton: UIButton!
    @IBOutlet var dxButton: UIButton!
    @IBOutlet var dxButtonSize: NSLayoutConstraint!
    
    weak var delegate:HeaderViewDelegate?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    @IBAction func sxButtonTapped() {
        self.delegate?.headerViewSxTapped()
    }
    
    @IBAction func dxButtonTapped () {
        self.delegate?.headerViewDxTapped()
    }
}
