//
//  DashBookingListCell.swift
//  Kanito
//
//  Created by mac on 07/04/17.
//  Copyright © 2017 Kanito. All rights reserved.
//

import Foundation

//MARK: -

class DashBookingListCell: UICollectionViewCell {
    class func register (_ collectionView: UICollectionView) {
        let name = String (describing: self)
        collectionView.register(UINib(nibName: name, bundle: nil),
                                forCellWithReuseIdentifier: name)
    }
    
    class func dequeue (_ collectionView: UICollectionView,
                        _ indexPath: IndexPath) -> DashBookingListCell {
        let name = String (describing: self)
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: name, for: indexPath)
        return cell as! DashBookingListCell
    }
    
    @IBOutlet private var title: MYLabel!
    @IBOutlet private var jobType: MYLabel!
    @IBOutlet private var dateTime: MYLabel!
    @IBOutlet private var date: MYLabel!
    @IBOutlet private var info: MYLabel!
    @IBOutlet private var price: MYLabel!
    @IBOutlet private var status: MYLabel!
    @IBOutlet private var statusIcon: UIImageView!
    
    @IBOutlet private var petContainerView: PetContainerView!
    
    @IBOutlet private var buttonAcc: MYButton!
    @IBOutlet private var buttonRej: MYButton!
    @IBOutlet private var sxButtonConstraints: NSLayoutConstraint!
    
    var delegate: DashboardViewDelegate?
    private var booking: BookingClass!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.borderColor = UIColor.myGreyMedium.cgColor
        self.layer.borderWidth = 1
        self.layer.cornerRadius = 5
        self.layer.masksToBounds = true
        
        self.date.layer.borderColor = UIColor.myGreyMedium.cgColor
        self.date.layer.borderWidth = 1
        self.date.layer.cornerRadius = 3
        
        self.buttonAcc.imageEdgeInsets = UIEdgeInsets.init(top: 10, left: 10, bottom: 10, right: 20)
        self.buttonRej.imageEdgeInsets = UIEdgeInsets.init(top: 10, left: 10, bottom: 10, right: 20)
    }
    
    func data (booking: BookingClass) {
        self.booking = booking
        
        self.title.text = booking.activity.name.capitalized
        self.jobType.text = booking.activityGroup.name
        var d = booking.time.ini.date.toString(withFormat: "dd/MM")
        let today = Date().toString(withFormat: "dd/MM")
        if d == today {
            d = Lng("today")
        }
        self.date.text =  d
        self.dateTime.text = booking.time.ini.text + " - " + booking.time.end.text
        self.info.text! = booking.customerName
        self.price.text = ""
        
        Pets.shared.getPet(id: booking.idCustomerPet) { (pet) in
            self.petContainerView.showPets(petList: booking.petList)
        }
        
        if booking.isPending == 1 {
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
        self.delegate?.dashboardView(sender: self,
                                             action: .bookingReject,
                                             data: self.booking)
    }
}
