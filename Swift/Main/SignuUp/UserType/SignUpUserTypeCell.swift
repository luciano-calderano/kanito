//
//  SignUpUserTypeCell
//  Kanito
//
//  Created by Luciano Calderano on 16/12/16.
//  Copyright © 2016 Kanito. All rights reserved.
//
//

import UIKit

class SignUpUserTypeCell: UICollectionViewCell {
    class func dequeue (_ collectionView: UICollectionView, _ indexPath: IndexPath) -> SignUpUserTypeCell {
        return collectionView.dequeueReusableCell(withReuseIdentifier: "SignUpUserTypeCell",
                                                  for: indexPath) as! SignUpUserTypeCell
    }

    @IBOutlet private var title: MYLabel!
    @IBOutlet private var descr: MYLabel!
    @IBOutlet private var image: UIImageView!
    @IBOutlet private var check: MYCheckView!
    @IBOutlet private var comingSoon: UIView!

    override func awakeFromNib() {
        self.layer.borderColor = UIColor.myOrange.cgColor
        self.layer.borderWidth = 1
        self.image.layer.cornerRadius = self.image.frame.size.height / 2
        self.image.layer.borderColor = UIColor.white.cgColor
        self.image.layer.borderWidth = 1
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    func data (value: Any) {
        let item = value as! UserTypeMenu
        self.comingSoon.isHidden = item.type != .pvt
        self.title.text = item.title
        self.descr.text = item.descr
        self.image.image = item.icona
        self.check.isEnabled = self.isSelected
        
        let borderColor = item.type.rawValue == UserType.pvt.rawValue ? UIColor.myGreyMedium : UIColor.myOrange
        self.layer.borderColor = borderColor.cgColor
    }
}
