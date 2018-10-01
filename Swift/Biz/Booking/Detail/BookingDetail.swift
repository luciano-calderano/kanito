//
//  HomeMyKanito.swift
//  Kanito
//
//  Created by Luciano Calderano on 18/01/17.
//  Copyright © 2017 Kanito. All rights reserved.
//

import Foundation

protocol BookingDetailDelegate {
    func tappedBookingDetailCell (booking: BookingClass)
}

class BookingDetail : MYViewController, BookingDetailDelegate {
    class func Instance () -> BookingDetail {
        let vc = self.load(storyboard: .BookingDetail) as! BookingDetail
        return vc
    }
    
    @IBOutlet fileprivate var scroll: UIScrollView!
    private var detailSubview = BookingDetailView()
    var booking: BookingClass!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.detailSubview = BookingDetailView.Instance()
        self.detailSubview.booking = self.booking
        self.detailSubview.delegate = self
        
        self.scroll.addSubviewWithConstraints(self.detailSubview.view)
        self.loadData()
    }

    override func headerViewDxTapped() {
        let ctrl = BookingEdit.Instance()
        ctrl.booking = self.booking
        self.navigationController?.show(ctrl, sender: self)
    }
    
    private func loadData() {
    }
    
    func tappedBookingDetailCell(booking: BookingClass) {
//        let ctrl = BookingEdit.Instance()
//        ctrl.booking = booking
//        self.navigationController?.show(ctrl, sender: self)
    }
}
