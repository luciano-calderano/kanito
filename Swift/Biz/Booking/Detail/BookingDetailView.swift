//
//  BizDashReseView
//  Kanito
//
//  Created by Luciano Calderano on 15/01/17.
//  Copyright © 2017 Kanito. All rights reserved.
//

import Foundation

class BookingDetailView : MYViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    class func Instance() -> BookingDetailView {
        let vc = self.load(storyboard: .BookingDetail) as! BookingDetailView
        return vc
    }

    @IBOutlet private var titleLabel: MYLabel!
    @IBOutlet private var typeLabel: MYLabel!
    @IBOutlet private var dateLabel: MYLabel!
    @IBOutlet private var statusLabel: MYLabel!

    @IBOutlet private var employesLabel: MYLabel!
    @IBOutlet private var totalLabel: MYLabel!
    
    @IBOutlet private var calendarButton: MYButton!
    @IBOutlet private var addPetButton: MYButton!
    @IBOutlet private var actionButton: MYButton!
    
    @IBOutlet fileprivate var collection: UICollectionView!

    var booking: BookingClass!
    var delegate: BookingDetailDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.updateButton(btn: self.calendarButton)
        self.updateButton(btn: self.addPetButton)
        self.updateButton(btn: self.actionButton)
        
        self.titleLabel.text = self.booking.activity.name
        self.typeLabel.text = self.booking.activityGroup.name
        self.dateLabel.text = self.booking.time.ini.text + " - " + self.booking.time.end.text
        self.statusLabel.text = self.booking.isPending == 1 ? Lng("isPending") : Lng("confirmed")
    }

    private func updateButton (btn: MYButton) {
        btn.setImage(btn.image(for: .normal)?.resize(24), for: .normal)
        btn.imageEdgeInsets = UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 20)
    }
    
    func data (value: Any) {
    }
    
    @IBAction func calendarTapped () {
    }
    @IBAction func addPetTapped () {
    }
    @IBAction func rejectTapped () {
    }

    // MARK: collection view datasource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.booking.petList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = BookingDetailCell.dequeue(collectionView, indexPath)
        let pet = self.booking.petList[indexPath.row]
        cell.data(value: pet)
        return cell
    }
    
    // MARK: collection view delegate
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView.isDragging || collectionView.isDecelerating || collectionView.isTracking {
            return
        }
//        self.delegate?.tappedBookingDetailCell(booking: self.booking)
    }

}


