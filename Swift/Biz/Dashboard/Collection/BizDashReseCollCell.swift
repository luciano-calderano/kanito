//
//  BizDashReseCollCell.swift
//  Kanito
//
//  Created by Luciano Calderano on 19/01/17.
//  Copyright © 2017 Kanito. All rights reserved.
//

protocol BizDashReseCollCellDelegate: class {
    func bizDashReseCollectionCellButtonTapped (data: JsonDict)
}

import Foundation

class BizDashReseCollCell: UICollectionViewCell, BizDashReseViewDelegate {
    class func dequeue (_ collectionView: UICollectionView, indexPath: IndexPath) -> BizDashReseCollCell {
        return collectionView.dequeueReusableCell(withReuseIdentifier: "BizDashReseCollCell",
                                                  for: indexPath) as! BizDashReseCollCell
    }
    weak var delegate: BizDashReseCollCellDelegate?

    private var subView: BizDashReseView!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.subView = BizDashReseView.Instance()
        self.contentView.addSubview(subView)
        self.subView.frame = self.bounds
        self.subView.delegate = self
    }
    
    func data (value: Any) {
        self.subView.data(value: value)
    }
    
    func bizDashReseCollectionCellButtonTapped(data: JsonDict) {
        self.delegate?.bizDashReseCollectionCellButtonTapped(data: data)
    }
}
