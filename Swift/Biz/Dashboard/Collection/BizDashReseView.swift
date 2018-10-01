//
//  BizDashReseView
//  Kanito
//
//  Created by Luciano Calderano on 15/01/17.
//  Copyright © 2017 Kanito. All rights reserved.
//

import Foundation

protocol BizDashReseViewDelegate: class {
    func bizDashReseCollectionCellButtonTapped (data: JsonDict)
}

class BizDashReseView : UIView {
    
    class func Instance() -> BizDashReseView {
        return Bundle.main.loadNibNamed("BizDashReseView", owner: self, options: nil)?.first as! BizDashReseView
    }
    static let size = CGSize.init(width: 210, height: 340)
    weak var delegate: BizDashReseViewDelegate?
    
    @IBOutlet private var title: MYLabel!
    @IBOutlet private var jobType: MYLabel!
    @IBOutlet private var dateTime: MYLabel!
    @IBOutlet private var info: MYLabel!
    @IBOutlet private var price: MYLabel!
    @IBOutlet private var status: MYLabel!
    @IBOutlet private var statusIcon: UIImageView!
    
    @IBOutlet private var petContainer: UIView!
    @IBOutlet private var petImg: UIImageView!
    @IBOutlet private var petName: MYLabel!

    @IBOutlet private var buttonAcc: MYButton!
    @IBOutlet private var buttonRej: MYButton!
    @IBOutlet private var sxButtonConstraints: NSLayoutConstraint!

    private var dict: JsonDict!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.borderColor = UIColor.myGreyMedium.cgColor
        self.layer.borderWidth = 1
        self.buttonAcc.imageEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 20)
        self.buttonRej.imageEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 20)
    }
    
    func data (value: Any) {
        self.dict = value as! JsonDict

        self.title.text = self.dict.string("title")
        self.jobType.text = self.dict.string("job")
        self.dateTime.text = self.dict.string("date")
        self.info.text = self.dict.string("info")
        self.price.text = self.dict.string("price")
        
        self.petFill(petArray: self.dict.array("pets") as! [JsonDict])
        
        if dict.int("stat") == 0 {
            self.status.text = Lng("inPending")
            self.statusIcon.isHighlighted = false
            self.sxButtonConstraints.constant = 0
            self.status.textColor = UIColor.myOrange
            self.buttonAcc.isHidden = false
        }
        else {
            self.status.text = Lng("confirmed")
            self.statusIcon.isHighlighted = true
            self.sxButtonConstraints.constant = -self.buttonAcc.bounds.size.width
            self.status.textColor = UIColor.green
            self.buttonAcc.isHidden = true
        }
    }
    
    @IBAction func buttonTapped () {
        self.delegate?.bizDashReseCollectionCellButtonTapped(data: self.dict)
    }
    
    private func petFill (petArray: [JsonDict]) {
        self.petName.text = ""
        if petArray.count == 0 {
            self.petImg.image = nil
            return
        }
        
        let dict = petArray[0]
        self.petImg.image = UIImage.init(named: dict.string("foto"))
        if petArray.count == 1{
            self.petName.text = dict.string("nome")
            return
        }
        let counter = min(petArray.count, 3) - 1
        var rect = self.petImg.frame
        for i in 1...counter {
            let dict = petArray[i]
            rect.origin.x += rect.size.width + 10
            let img = UIImageView.init(frame: rect)
            img.image = UIImage.init(named: dict.string("foto"))
            self.petContainer.addSubview(img)
        }
        if (petArray.count > 3) {
            rect.origin.x += rect.size.width + 10

            let label = UILabel.init(frame: rect)
            label.layer.cornerRadius = rect.size.width / 2
            label.layer.borderWidth = 1
            label.layer.borderColor = UIColor.myGreyMedium.cgColor
            label.font = UIFont.size(12, type: .Bold)
            label.textColor = UIColor.myGreyMedium
            label.text = "+" + String (petArray.count - 3)
            label.textAlignment = .center
            self.petContainer.addSubview(label)
        }
    }
}


