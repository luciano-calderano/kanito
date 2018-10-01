//
//  CollectionViewCell.swift
//  LGLinearFlowView
//
//  Created by Luka Gabric on 16/08/15.
//  Copyright © 2015 Luka Gabric. All rights reserved.
//

import UIKit

class SignUpTypeCell: UICollectionViewCell {
    class func dequeue (_ collectionView: UICollectionView, indexPath: IndexPath) -> SignUpTypeCell {
        return collectionView.dequeueReusableCell(withReuseIdentifier: "SignUpTypeCell",
                                                  for: indexPath) as! SignUpTypeCell
    }

    @IBOutlet private var title: MYLabel!
    @IBOutlet private var descr: MYLabel!
    @IBOutlet private var image: UIImageView!
    
    override func awakeFromNib() {
        self.layer.borderColor = UIColor.myOrange.cgColor
        self.layer.borderWidth = 1
    }
    
    func data (value: Any) {
        let item = value as! UserTypeMenu
        self.title.text = item.title
        self.descr.text = item.descr
        self.image.image = item.icona
    }
}
