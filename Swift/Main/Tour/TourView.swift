//
//  Tour01View.swift
//  Kanito
//
//  Created by Luciano Calderano on 15/01/17.
//  Copyright © 2017 Kanito. All rights reserved.
//

import Foundation

class TourView : UIView {
    class func Instance(page: Int) -> TourView {
        let vc = Bundle.main.loadNibNamed("TourView", owner: self, options: nil)?.first as! TourView
        vc.page(num: page)
        return vc
    }
    
    @IBOutlet private var title: UILabel!
    @IBOutlet private var image: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.clipsToBounds = true
        image.layer.cornerRadius = 5
        image.layer.borderWidth = 3
        image.layer.borderColor = UIColor.myGreyMedium.cgColor
    }
    
    func page (num: Int) {
        var s = ""
        var img: UIImage!
        switch num {
        case 1:
            img = UIImage.init(named: "tour01")
            s = Lng("tour01")
        case 2:
            img = UIImage.init(named: "tour02")
            s = Lng("tour02")
        case 3:
            img = UIImage.init(named: "tour03")
            s = Lng("tour03")
        default:
            break
        }
        title.text! = s
        image.image = img
    }
}
