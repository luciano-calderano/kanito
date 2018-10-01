//
//  BizDashReseView
//  Kanito
//
//  Created by Luciano Calderano on 15/01/17.
//  Copyright © 2017 Kanito. All rights reserved.
//

import Foundation

protocol BookingSubviewDelegate: class {
    func delegateBookingSubview (addBookingAtHour: Int)
}

class BookingSubview : UIView {
    weak var delegate: BookingSubviewDelegate?
}

class BookingTimeSubview : BookingSubview {
    class func Instance() -> BookingTimeSubview {
        let id = String (describing: self)
        return Bundle.main.loadNibNamed(id, owner: self, options: nil)?.first as! BookingTimeSubview
    }

    @IBOutlet private var title: MYLabel!
    
    var hour: Int {
        set {
            self.title.text = String.init(format: "%02d", newValue) + ":00"
            self.tag = newValue
        }
        get { return self.tag }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = UIColor.clear
        self.title.text = String.init(format: "%02d", self.tag)
    }
    
    @IBAction func plusTapped () {
        self.delegate?.delegateBookingSubview(addBookingAtHour: self.tag)
    }
}

///////////////////////////////////////////

class BookingViewBase : BookingSubview {
    var maxIcons = 1

    @IBOutlet private var title: MYLabel!
    @IBOutlet private var subtitle: MYLabel!
    @IBOutlet private var timeFromTo: MYLabel!
    @IBOutlet private var status: MYLabel!
    @IBOutlet private var typeImage: UIImageView!
    @IBOutlet private var backView: UIView!
    @IBOutlet private var lineView: UIView!
    @IBOutlet private var petsContainer: PetContainerView!
    
    private var booking: BookingClass!
    private var colorConf = UIColor.hexColor("0D8489")
    private var colorPend = UIColor.hexColor("f29100")
    
    var delegateBooking: ViewBookingDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = UIColor.white
        self.updateColor()
        self.petsContainer.layer.masksToBounds = true
        self.addGestureRecognizer(UITapGestureRecognizer.init(target: self,
                                                              action: #selector(viewTapped)))

    }
    
    private func updateColor (confirmed: Bool = true) {
        let color = confirmed ? self.colorConf : self.colorPend
        self.backView.backgroundColor = color
        self.lineView.backgroundColor = color
        self.title.textColor = color
        self.subtitle.textColor = color
        self.timeFromTo.textColor = color
        self.status.textColor = color
        self.status.text = confirmed ? Lng("confirmed") : Lng("inPending")
        self.typeImage.isHighlighted = confirmed
        
    }
    
    private func showTitle(booking: BookingClass) {
        var s = ""
        if (self.frame.size.height > 40) {
            s = self.booking.petName
        }
        if (self.frame.size.height > 60) {
            s += "\n(" + self.booking.customerName + ")"
        }
        if (self.frame.size.height > 80) {
            s += "\n" + self.booking.time.ini.text + " - " + self.booking.time.end.text
        }
        self.subtitle.text = s
    }
    
    func show (booking: BookingClass) {
        self.booking = booking

//        Pets.shared.getPet(id: booking.idCustomerPet) { (pet) in
//            CustomerClass.getById(pet.customer.idCustomer, completion: {
//                (customer) in
//                booking.customerName = customer.name
                self.showTitle(booking: booking)
//            })
//        }

        let isSmall = (self.frame.size.height < 85)
        self.typeImage.isHidden = isSmall
        self.status.isHidden = isSmall
        self.timeFromTo.isHidden = true

        self.showTitle(booking: booking)

        self.updateColor(confirmed: self.booking.isPending == 0)
        self.title.text = self.booking.activity.name
        
//        self.petsContainer.showPets(imagesUrl: self.booking.petList,
//                                    petName: self.booking.petName,
//                                    maxIcons: self.maxIcons)
     }
    
    @objc func viewTapped() -> Void {
        self.delegateBooking?.delegateBookingSubview(bookings: [self.booking])
    }
}

class BookingViewMini : BookingViewBase {
    class func Instance() -> BookingViewMini {
        return self.InstanceView() as! BookingViewMini
    }
}
class BookingViewSmall : BookingViewBase {
    class func Instance() -> BookingViewSmall {
        return self.InstanceView() as! BookingViewSmall
    }
}
class BookingViewBig : BookingViewBase {
    class func Instance() -> BookingViewBig {
        return self.InstanceView() as! BookingViewBig
    }
}


