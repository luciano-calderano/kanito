//
//  BookingEdit.swift
//  Kanito
//
//  Created by Luciano Calderano on 16/02/17.
//  Copyright © 2017 Kanito. All rights reserved.
//

import Foundation

class BookingEdit: MYViewController, PopupTimeDelegate, PopupDateDelegate, PopupDelegate, BookingEditViewDelegate, BookingSelectPetDelegate {
    class func Instance () -> BookingEdit {
        let vc = self.load(storyboard: .Booking) as! BookingEdit
        return vc
    }
    var isShownFromDetail = false
    var booking: BookingClass? {
        didSet {
            let b = booking!
            self.values.id = b.id
            self.values.activity = b.activity
            self.values.startTime = b.time.ini.date
            self.values.endTime = b.time.end.date
            self.values.title = b.title
            self.values.isPending = b.isPending
            self.values.note = b.note
            Pets.shared.getPet(id: b.idCustomerPet) { (pet) in
                self.values.pet.id = b.idCustomerPet
                self.values.pet.name = b.petName
            }
            CustomerClass.getById(b.idCustomer) { (customer) in
                self.values.pet.idCustomer = b.idCustomer
                self.values.pet.nameCustomer = b.customerName
            }
        }
    }
    
    var values = BookingData.Values()
    var input = InputClass()
    
    @IBOutlet private var scroll: UIScrollView!
    
    private let subView = BookingEditView.Instance()
    private var pet: PetClass!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.scroll.addSubview(subView)
        self.scroll.contentSize = self.subView.frame.size
        self.subView.delegate = self
        
        self.subView.updateWith(value: self.values)
        self.input.config(scroll: self.scroll, view: self.subView)
        
        self.addKeybNotification()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        var rect = self.subView.frame
        rect.size.width = self.scroll.frame.size.width
        rect.size.height = self.scroll.contentSize.height
        self.subView.frame = rect
        self.scroll.contentSize = self.subView.frame.size
    }
    
    override func headerViewDxTapped() {
        self.sendAddBooking()
    }
    
    /*** Delegate subview ***/
    
    private var selectedType = BookingData.Enum.none
    func viewTapped(type: BookingData.Enum) {
        self.selectedType = type
        switch type {
        case .pet:
            let ctrl = BookingSelectPet.Instance()
            ctrl.delegate = self
            self.navigationController?.show(ctrl, sender: self)
            return
        case .activity:
            let ctrl = PopupTableView.Instance()
            ctrl.delegate = self
            var array = [Object]()
            for dict in CompanyClass.shared.value.activities {
                
                let id = dict.string("id_activity")
                let act = KActivity.shared.activities[id]!

                var obj = Object()
                obj.id = act.id
                obj.name = act.name
//                let obj = Activities.shared.getActivity(id: id)
                array.append(obj)
            }
            ctrl.dataArray = array.sorted(by: { $0.name < $1.name })
            
            self.navigationController?.show(ctrl, sender: self)
            return
        case .date:
            let popup = PopupDate.Instance()
            popup.update(date: self.values.startTime)
            popup.delegate = self
            self.showPopup(popup)
            return
        case .startTime:
            let popup = PopupTime.Instance()
            popup.update(dateIni: self.values.startTime, dateEnd: self.values.endTime)
            popup.delegate = self
            self.showPopup(popup)
            return
        case .delete:
            self.deleteBooking()
            return
        default:
            return
        }
    }

    //MARK: - show/hide popup
    
    private func showPopup(_ popup: UIView) {
        var rect = self.view.bounds
        rect.origin.y = rect.size.height
        self.view.addSubview(popup)
        popup.frame = rect
        self.view.setNeedsLayout()
        UIView.animate(withDuration: 0.3, animations: {
            popup.frame = self.view.bounds
            self.view.setNeedsLayout()
        })
    }
    
    private func closePopup(_ popup: UIView) {
        self.view.setNeedsLayout()
        UIView.animate(withDuration: 0.3, animations: {
            var rect = popup.bounds
            rect.origin.y = -rect.size.height
            popup.frame = rect
            self.view.setNeedsLayout()
        }) { (true) in
            popup.removeFromSuperview()
        }
    }
    
    //MARK: - Delegate popup title
    
    private var editRect = CGRect.zero
    func bookingEditViewDelegate(view: BookingEditView, rect: CGRect) {
        self.editRect = rect
        self.updateOffset()
    }
    func bookingEditViewDelegate(view: BookingEditView, title: String) {
        self.values.title = title
    }
    
    //MARK: - Delegate popup Pet selected
    
    func BookingSelectPetDelegate(_ me: BookingSelectPet, selected: [String]) {
        if selected.count > 0 {
            self.values.pet.id = selected.first!
            Pets.shared.getPet(id: self.values.pet.id, completion: {
                (pet) in
                self.values.pet.name = pet.name
                self.subView.updateWith(value: self.values)
            })
        }
    }

    //MARK: - Delegate popup Date / time
    
    func popupTimeConfirmed(popup: PopupTime, startTime: Date, endTime: Date) {
        self.values.startTime = startTime
        self.values.endTime = endTime
        self.subView.updateWith(value: self.values)
        self.closePopup(popup)
    }
    
    func popupTimeCancelled(popup: PopupTime) {
        self.closePopup(popup)
    }
    
    func popupDateConfirmed(popup: PopupDate, date: Date) {
        let old = self.values.startTime.timeIntervalSince1970
        let new = date.timeIntervalSince1970 - old
        self.values.startTime = self.values.startTime.addingTimeInterval(new)
        self.values.endTime = self.values.endTime.addingTimeInterval(new)
        self.subView.updateWith(value: self.values)
        self.closePopup(popup)
    }
    
    func popupDateCancelled(popup: PopupDate) {
        self.closePopup(popup)
    }
    
    //MARK: - Delegate popup Table View
    
    func popupDelegate(data: Any) {
        switch self.selectedType {
        case .activity:
            let array = data as! [Object]
            if array.count == 0 {
                return
            }
            let obj = array.first!
            self.selectedType = .activity
            self.values.activity.id = obj.id
            self.values.activity.name = obj.name
        default:
            assertionFailure("BookingEdit: popupDelegate(default) \(self.selectedType)")
        }

        self.subView.updateWith(value: self.values)
    }

    //MARK: - Api booking
    
    private func deleteBooking () {
        self.alert(Lng("deleteBooking") + ", id:" + self.values.id, message: Lng("areSure")) { (UIAlertAction) in
            let request = MYHttpRequest.post("booking/delete")
            request.json = [
                "bookingId"     : self.values.id
            ]
            request.start() { (success, response) in
                if success {
                    BookingNext.shared.loadBookingWithDate((self.booking?.time.ini.date)!)
                    self.postNotificationReloadData(type: .booking)
                    self.goBack()
                }
            }

        }
        print(self.values.id)
    }
    
    private func sendAddBooking () {
        self.values.isPending = self.subView.isPending
        
        let page = self.values.id.isEmpty ? "booking/add" : "booking/edit"
        
        let request = MYHttpRequest.post(page)
        request.json = [
            "companyId"     : CompanyClass.shared.value.id,
            "activityId"    : self.values.activity.id,
            "customerId"    : self.values.pet.idCustomer,
            "customerPetId" : self.values.pet.id,
            "title"         : self.values.title,
            "note"          : self.values.note,
            "askFrom"       : "C",
            "start"         : self.values.startTime.toString(withFormat: Config.fmt.dataDB),
            "end"           : self.values.endTime.toString(withFormat: Config.fmt.dataDB),
            "isPending"     : self.values.isPending,
            "employeeId"    : 0, //
            "serviceId"     : 0, //
            "prize"         : "",
        ]
        if self.values.id.isEmpty == false {
            request.json["bookingId"] = self.values.id
        }
        
        request.start() { (success, response) in
            if success {
                if ((self.booking?.time.ini) != nil) && self.booking?.time.ini.date != self.values.startTime {
                    BookingNext.shared.loadBookingWithDate((self.booking?.time.ini.date)!)
                }
                BookingNext.shared.loadBookingWithDate(self.values.startTime)

                self.postNotificationReloadData(type: .booking)
                self.goBack()
            }
        }
    }
    
    private func goBack () {
        let vc = (self.navigationController?.viewControllers.first as! UITabBarController).selectedViewController
        if vc is Dashboard {
            _ = self.navigationController?.popToRootViewController(animated: true)
        }
        else {
            let ctrl = self.navigationController?.viewControllers[1]
            _ = self.navigationController?.popToViewController(ctrl!, animated: true)
        }
    }
    
    //MARK: - Keyboard actions
    
    private func addKeybNotification () {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.keyboardWillShow(notification:)),
                                               name:UIResponder.keyboardWillShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.keyboardWillHide(notification:)),
                                               name:UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    @objc func keyboardWillShow (notification: NSNotification) {
        let sizeValue = notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as! NSValue
        let h = sizeValue.cgRectValue.size.height
        self.scroll.contentInset = UIEdgeInsets.init(top: 0, left: 0, bottom: h, right: 0)
        self.updateOffset()
    }

    @objc func keyboardWillHide (notification: NSNotification) {
        self.scroll.contentInset = UIEdgeInsets.zero
    }
    
    private func updateOffset () {
        var offset = self.scroll.contentOffset
        offset.y += self.scroll.contentInset.bottom
        let a = self.view.frame.size.height - offset.y
        let b = self.editRect.origin.y + self.editRect.size.height + self.scroll.frame.origin.y
        if a < b {
            self.scroll.contentOffset = offset
        }
    }
}
