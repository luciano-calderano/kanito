//
//  HomeMyKanito.swift
//  Kanito
//
//  Created by Luciano Calderano on 18/01/17.
//  Copyright © 2017 Kanito. All rights reserved.
//

import Foundation

enum DashboardAction {
    case addCustomer
    case addBooking
    case bookingAccept
    case bookingReject
    case bookingSelected
}

class Dashboard: MYViewController {
    class func Instance () -> Dashboard {
        let vc = self.load(storyboard: .Customer) as! Dashboard
        return vc
    }
    
    let dashboardView = DashboardView.Instance()
    @IBOutlet private var scroll: UIScrollView!
    
    private var bookingCount2mBefore:Double = 0
    private var bookingCount1mBefore:Double = 0
    private var bookingCountFuture:Double = 0
    private let refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.scroll.addSubviewWithConstraints(self.dashboardView)
        self.dashboardView.delegate = self
        
        self.refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        self.refreshControl.addTarget(self, action: #selector(self.loadData), for: .valueChanged)
        self.refreshControl.backgroundColor = UIColor.myGreyLight
        self.scroll.addSubview(refreshControl)
        
        self.addNotificationReloadData()
        
        self.loadData()
        self.loadStat()
    }
    
    override func reloadData(_ notification: Notification) {
        let n = notification.object as! NotificationType
        if n == .booking {
            self.loadData()
        }
    }
    
    @objc func loadData() {
        self.refreshControl.endRefreshing()
        let cal = Calendar(identifier: .gregorian)
        let endDate = cal.date(byAdding: .day, value: 30, to: Date())
        
        BookingClass.getList(fromDay: Date(),
                             toDay: endDate!, offset: 10) { (dataArray, count) in
                                self.httpResponse(array: dataArray,
                                                  count: count)
        }
    }
    
    private func httpResponse (array: [BookingClass] , count: Int) {
        var contentSize = self.scroll.contentSize
        if array.count == 0 {
            contentSize.height = self.dashboardView.frame.size.height - (self.dashboardView.bookingListView?.frame.size.height)!
        }
        else {
            contentSize.height = self.dashboardView.frame.size.height
        }
        self.scroll.contentSize = contentSize
        self.bookingCountFuture = Double(count)
        self.updateStat()
        self.dashboardView.bookingListView?.bookingList(bookingList: array)
        BookingNext.shared.loadBookingPerDay()
    }
    
    
    //MARK: - Statistics
    
    private func loadStat() {
        let getDatePrevMonth: (Int) -> (ini: Date, end: Date) = { (monthDiff) in
            let cal = Calendar(identifier: .gregorian)
            let d = cal.date(byAdding: .month, value: monthDiff, to: Date())
            let ini = cal.date(from: cal.dateComponents([.year, .month], from: d!))!
            let end = cal.date(byAdding: DateComponents(month: 1, day: -1), to: ini)!
            return (ini, end)
        }
        
        self.updateStat()
        
        let d2 = getDatePrevMonth(-2)
        BookingClass.getList(fromDay: d2.ini,
                             toDay: d2.end, offset: 0) { (dataArray, count) in
                                self.bookingCount2mBefore = Double(count)
                                self.updateStat()
        }
        
        let d1 = getDatePrevMonth(-1)
        BookingClass.getList(fromDay: d1.ini,
                             toDay: d1.end, offset: 0) { (dataArray, count) in
                                self.bookingCount1mBefore = Double(count)
                                self.updateStat()
        }
    }
    
    private func updateStat () {
        var statData = DashBookingStatView.StatData()
        let trend = self.bookingCount2mBefore == 0 ? 0 : ((100 / self.bookingCount2mBefore) * self.bookingCount1mBefore) - 100
        
        statData.bookingValue = self.bookingCountFuture
        statData.bookingTrend = trend
        self.dashboardView.bookingStatView?.data(value: statData)
    }
}

//MARK: - DashboardViewDelegate

extension Dashboard: DashboardViewDelegate {
    func dashboardView(sender: Any, action: DashboardAction, data: Any?) {
        switch action {
        case .addCustomer:
            self.nextCtrl(CustomerFind.Instance())
        case .addBooking:
            let ctrl = BookingEdit.Instance()
            let cal = Calendar(identifier: .gregorian)
            let d = cal.startOfDay(for: Date())
            
            ctrl.values.startTime = cal.date(bySettingHour: 8, minute: 0, second: 0, of: d)!
            ctrl.values.endTime = cal.date(bySettingHour: 9, minute: 0, second: 0, of: d)!
            self.nextCtrl(ctrl)
        case .bookingAccept:
            break
        case .bookingReject:
            break
        case .bookingSelected:
            let ctrl = BookingDetail.Instance()
            ctrl.booking = data as? BookingClass
            self.navigationController?.show(ctrl, sender: self)
            break
        }
    }
}
