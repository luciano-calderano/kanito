//
//  HomeMyKanito.swift
//  Kanito
//
//  Created by Luciano Calderano on 18/01/17.
//  Copyright © 2017 Kanito. All rights reserved.
//

import Foundation

protocol DashboardViewDelegate {
    func dashboardView (sender: Any, action: DashboardAction, data: Any?)
}

class DashboardView : UIView, DashboardViewDelegate {
    class func Instance() -> DashboardView {
        let name = String (describing: self)
        return Bundle.main.loadNibNamed(name, owner: self, options: nil)?.first as! DashboardView
    }

    var delegate: DashboardViewDelegate?
    
    @IBOutlet var date: MYLabel!
    @IBOutlet var name: MYLabel!
    
    @IBOutlet var bookingStatView: DashBookingStatView?
    @IBOutlet var bookingListView: DashBookingListView?
    @IBOutlet var statNum: UIView!
    @IBOutlet var statVal: UIView!
    @IBOutlet var addCustomer: UIView!
    @IBOutlet var addBooking: UIView!

//MARK: -
    
    override func awakeFromNib() {
        super.awakeFromNib()
        addCustomer.addGestureRecognizer(UITapGestureRecognizer(target: self,
                                                                     action: #selector(addCustomerTapped)))
        addBooking.addGestureRecognizer(UITapGestureRecognizer(target: self,
                                                                    action: #selector(addBookingTapped)))
        date.text = Date().toString(withFormat: "EEEE dd MMM")
        name.text = name.text! + "\n" + UserClass.shared.user.firstname
        bookingListView?.delegate = self
        
        border(view: addCustomer)
        border(view: addBooking)
        border(view: statNum)
        border(view: statVal)
    }
    
    private func border (view: UIView) {
        view.layer.cornerRadius = 5
        view.layer.borderColor = UIColor.mySilver.cgColor
        view.layer.borderWidth = 1
    }
    
    @objc func addCustomerTapped () {
        dashboardView(sender: self, action: .addCustomer, data: nil)
    }
    
    @objc func addBookingTapped () {
        dashboardView(sender: self, action: .addBooking, data: nil)
    }
    
    //MARK: - Delegate
    
    func dashboardView(sender: Any, action: DashboardAction, data: Any?) {
        delegate?.dashboardView(sender: sender,
                                             action: action,
                                             data: data)
    }

}

//MARK: -

class DashBookingListView: UIView, UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout, DashboardViewDelegate {
    @IBOutlet var title: MYLabel!
    @IBOutlet var bookingsCollection: UICollectionView!
    @IBOutlet var viewHeightConstraint: NSLayoutConstraint!

    var delegate: DashboardViewDelegate?

    private var bookingList = [BookingClass]()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        DashBookingListCell.register(bookingsCollection)
    }
    
    func bookingList (bookingList list: [BookingClass]) {
        bookingList = list
        if bookingList.count > 0 {
            title.text = Lng("yourBooking")
            viewHeightConstraint.constant = 300
        }
        else {
            title.text = Lng("noBooking")
            viewHeightConstraint.constant = title.frame.size.height
        }
        bookingsCollection.reloadData()
    }

    // MARK: - collection view datasource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return bookingList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = DashBookingListCell.dequeue(collectionView, indexPath)
        cell.delegate = self
        cell.data(booking: bookingList[indexPath.row])
        return cell
    }
    
    // MARK: - collection view delegate
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView.isDragging || collectionView.isDecelerating || collectionView.isTracking {
            return
        }
        dashboardView(sender: self,
                                   action: .bookingSelected,
                                   data: bookingList[indexPath.row])
    }
    
    //MARK: - Delegate
    
    func dashboardView(sender: Any, action: DashboardAction, data: Any?) {
        delegate?.dashboardView(sender: sender,
                                             action: action,
                                             data: data)
    }
}

//MARK: -

class DashBookingStatView: UIView {
    struct StatData {
        var bookingValue:Double = 0
        var bookingTrend: Double = 0
        var incomeValue:Double = 0
        var incomeTrend: Double = 0
    }
    
    @IBOutlet private var bookingIcon: UIImageView!
    @IBOutlet private var bookingValue: MYLabel!
    @IBOutlet private var bookingTrend: MYLabel!
    
    @IBOutlet private var incomeIcon: UIImageView!
    @IBOutlet private var incomeValue: MYLabel!
    @IBOutlet private var incomeTrend: MYLabel!
    
    func data (value: StatData) {
        bookingValue.text =  String.init(format: "%.0f", value.bookingValue)
        bookingTrend.text =  String.init(format: "%+.2f%%", value.bookingTrend)
        incomeValue.text =  String.init(format: "%.0f", value.incomeValue)
        incomeTrend.text =  String.init(format: "%+.2f%%", value.incomeTrend)
        
        bookingIcon.isHighlighted = value.bookingTrend < 0
        incomeIcon.isHighlighted = value.incomeTrend < 0
    }
}
