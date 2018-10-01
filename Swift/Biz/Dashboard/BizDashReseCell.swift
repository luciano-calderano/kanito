//
//  BizDashReseCell
//  Kanito
//
//  Created by Luciano Calderano on 18/01/17.
//  Copyright © 2017 Kanito. All rights reserved.
//

import Foundation

protocol BizDashReseCellDelegate: class {
    func bizDashReseCollectionCellButtonTapped (data: JsonDict)
    func bizDashReseCollectionCellSelected (data: JsonDict)
}


class BizDashReseCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout, BizDashReseCollCellDelegate {
    class func dequeue (_ tableView: UITableView, indexPath: IndexPath) -> BizDashReseCell {
        return tableView.dequeueReusableCell(withIdentifier: "BizDashReseCell", for: indexPath) as! BizDashReseCell
    }
    
    weak var delegate: BizDashReseCellDelegate?

    @IBOutlet fileprivate var collection: UICollectionView!
    private var reservationArray = [JsonDict]()
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func data (value: Any) {
        self.reservationArray = value as! [JsonDict]
        self.collection.reloadData()
    }
    
    // MARK: collection view layout
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return BizDashReseView.size
    }
    
    // MARK: collection view datasource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.reservationArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = BizDashReseCollCell.dequeue(collectionView, indexPath: indexPath)
        cell.delegate = self
        cell.data(value: self.reservationArray[indexPath.row])
        return cell
    }
    
    // MARK: collection view delegate
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView.isDragging || collectionView.isDecelerating || collectionView.isTracking {
            return
        }
        self.delegate?.bizDashReseCollectionCellSelected(data: self.reservationArray[indexPath.row])
    }
    
    func bizDashReseCollectionCellButtonTapped(data: JsonDict) {
        self.delegate?.bizDashReseCollectionCellButtonTapped(data: data)
    }

}
