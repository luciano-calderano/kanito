//
//
//  BookingWeek
//

import UIKit
import FSCalendar

protocol ViewBookingDelegate: class {
    func delegateBookingSubview (bookings: [BookingClass])
}

class BookingWeek: MYViewController, FSCalendarDataSource, FSCalendarDelegate, FSCalendarDelegateAppearance, ViewBookingDelegate, BookingSubviewDelegate {
    class func Instance () -> BookingWeek {
        let vc = self.load(storyboard: .Booking) as! BookingWeek
        return vc
    }
    
    struct Params {
        let hIni = 7
        let hEnd = 22
        let topY = 20
        let lineOffset = 10
        let left = 80
        let high = 125
    }
    
    var selectedDate = Date()

    @IBOutlet weak var calendar: FSCalendar!
    @IBOutlet weak var calendarHeightConstraint: NSLayoutConstraint!
    @IBOutlet var scroll: UIScrollView!
    
    private let wheel = MYWheel.init(true)
    private let param = Params()
    private var viewBooking = ViewBooking()
    
    private let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = Config.fmt.data
        return formatter
    }()
    
    private let gregorian: NSCalendar! = NSCalendar(calendarIdentifier:NSCalendar.Identifier.gregorian)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.scroll.backgroundColor = UIColor.white
        self.drawHours()
        self.calendarSetting()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.loadData()
        self.wheel.stop()
    }

    override func headerViewDxTapped() {
        self.addBooking(at: self.param.hIni)
    }
    
    private func addBooking (at hour: Int) {
        let ctrl = BookingEdit.Instance()
        let cal = Calendar(identifier: .gregorian)
        let d = cal.startOfDay(for: self.calendar.selectedDate!)
        
        ctrl.values.startTime = cal.date(bySettingHour: hour, minute: 0, second: 0, of: d)!
        ctrl.values.endTime = cal.date(bySettingHour: hour + 1, minute: 0, second: 0, of: d)!
        
        self.nextCtrl(ctrl)
    }

    private func loadData () {
        self.viewBooking.removeFromSuperview()
        self.viewBooking = ViewBooking()
        self.viewBooking.delegate = self
        
        var edge = UIEdgeInsets.zero
        edge.top = CGFloat(self.param.topY + self.param.lineOffset)
        edge.left = CGFloat(self.param.left)

        let sub = SubView(container: self.scroll, subview: self.viewBooking)
        sub.edge = edge
        sub.h = CGFloat((1 + self.param.hEnd - self.param.hIni) * self.param.high)
        sub.w = UIScreen.main.bounds.size.width - CGFloat(self.param.left)
        self.viewBooking.backgroundColor = UIColor.clear

        dataArray.removeAll()
        BookingClass.getList(forDay: self.selectedDate) { (response, count) in
            self.dataArray = response
            self.viewBooking.showData(array: self.dataArray as! [BookingClass])
        }
    }
    
    private func drawHours () {
        for hour in self.param.hIni...self.param.hEnd {
            let y = (hour - self.param.hIni) * self.param.high
            let view = BookingTimeSubview.Instance()

            let sub = SubView(container: self.scroll, subview: view)
            sub.t = CGFloat(y + self.param.topY)
            sub.l = 0
            sub.h = CGFloat(self.param.high)
            sub.w = CGFloat(self.param.left)

            view.hour = hour
            view.delegate = self
        }
    }
    
    /**** Calendar ****/
    
    private func calendarSetting () {
        self.calendar.scope = .week
        self.calendar.scrollDirection = .horizontal
        self.calendar.pagingEnabled = true
        self.calendar.firstWeekday = 2
        self.calendar.appearance.caseOptions = []
        self.calendar.select(self.selectedDate)
    }
    
    func minimumDate(for calendar: FSCalendar) -> Date {
        return Calendar.current.date(byAdding: .year, value: -1, to: Date())!
    }
    
    func maximumDate(for calendar: FSCalendar) -> Date {
        return Calendar.current.date(byAdding: .year, value: 2, to: Date())!
    }
    
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        return BookingNext.shared.getBookingWithDate(date)
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, eventDefaultColorsFor date: Date) -> [UIColor]? {
        return [UIColor.myBizGreen]
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        NSLog("calendar did select date \(self.formatter.string(from: date))")
        if monthPosition == .previous || monthPosition == .next {
            calendar.setCurrentPage(date, animated: true)
        }
        self.selectedDate = date
        self.loadData()
    }
    
    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
        calendarHeightConstraint.constant = bounds.height
        view.layoutIfNeeded()
    }
    
    // MARK: Delegate subview
    
    func delegateBookingSubview (addBookingAtHour: Int) {
        self.addBooking(at: addBookingAtHour)
    }
    
    func delegateBookingSubview(bookings: [BookingClass]) {
        dataArray = bookings
        if bookings.count == 1 {
            self.openBookingDetail(booking: bookings.first!)
        }
        else {
            self.openBookingMultiple()
        }
    }
    
    private func openBookingDetail (booking: BookingClass) {
        let ctrl = BookingDetail.Instance()
        ctrl.booking = booking
        self.navigationController?.show(ctrl, sender: self)
    }
    
    private func openBookingMultiple () {
        let ctrl = BookingMultiple.Instance()
        ctrl.dataArray = dataArray
        self.navigationController?.show(ctrl, sender: self)
    }
    
    /*************************************************/
    
    class ViewBooking: UIView {
        let params = Params()
        
//        private var bookingArray = [BookingClass]()
        weak var delegate: ViewBookingDelegate?
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        override init (frame : CGRect) {
            super.init(frame : frame)
            self.backgroundColor = UIColor.clear
            self.isUserInteractionEnabled = true
        }
        
        private func drawHourLines () {
            let newLine: (Int, Int, UIColor) -> () = { (hour, minute, backColor) in
                let m = (hour - self.params.hIni) * 60 + minute
                let y = CGFloat((m * self.params.high) / 60)
                
                let sub = SubView(container: self, subview: UIView())
                sub.t = y
                sub.l = 0
                sub.r = 0
                sub.h = 1
                sub.subView.backgroundColor = backColor
            }
            
            for hour in self.params.hIni...self.params.hEnd + 1 {
                newLine(hour, 0, .myGreyMedium)
            }
            
            let date = Date()
            let calendar = NSCalendar.current
            let hour = calendar.component(.hour, from: date)
            let minute = calendar.component(.minute, from: date)
            newLine(hour, minute, .myBizGreen)
        }
        
        func showData(array: [BookingClass]) {
            self.drawHourLines()
            var bookingArray = array
            bookingArray = self.showBigBookingView(bookingArray)
            bookingArray = self.showLeft(bookingArray)
            self.showMultiple(bookingArray)
        }
        
        //MARK: Create array

        let hasConflict: (BookingClass, [BookingClass]) -> (Bool) = { (booking, array) in
            let ini = booking.time.ini.minutes + 1
            let end = booking.time.end.minutes - 1
            for bookTmp in array {
                if booking.id == bookTmp.id {
                    continue
                }

                let iniTmp = bookTmp.time.ini.minutes
                let endTmp = bookTmp.time.end.minutes
                if iniTmp...endTmp ~= ini || iniTmp...endTmp ~= end {
                    return true
                }
                if ini...end ~= iniTmp || ini...end ~= endTmp {
                    return true
                }
            }
            return false
        }
        
        private func showBigBookingView (_ bookingArray: [BookingClass]) -> [BookingClass] {
            var arrNo = [BookingClass] ()
            for booking in bookingArray {
                if hasConflict(booking, bookingArray) {
                    arrNo.append(booking)
                }
                else {
                    self.showBooking(booking: booking, viewType: .full)
                }
            }
            return arrNo
        }
    
        private func showLeft (_ bookingArray: [BookingClass]) -> [BookingClass] {
            var arrOk = [BookingClass] ()
            var arrNo = [BookingClass] ()
            for booking in bookingArray {
                if hasConflict(booking, arrOk) {
                    arrNo.append(booking)
                }
                else {
                    arrOk.append(booking)
                }
            }
            for booking in arrOk {
                self.showBooking(booking: booking, viewType: .left)
            }
            return arrNo
        }
        
        private func showMultiple (_ bookingArray: [BookingClass]) {
            var bookings = [BookingClass]()
            for booking in bookingArray {
                if bookings.count > 0 {
                    let bookTmp = bookings.first!
                    if booking.time.ini.minutes < bookTmp.time.end.minutes {
                        bookings.append(booking)
                            continue
                        }
                    self.drawRight(bookings)
                    
                    bookings.removeAll()
                }
                bookings.append(booking)
            }
            self.drawRight(bookings)
        }
        
        private func drawRight (_ bookings: [BookingClass]) {
            if bookings.count == 0 {
                return
            }
            if bookings.count == 1 {
                self.showBooking(booking: bookings.first!, viewType: .right)
            }
            else {
                self.drawMultipleView(bookings: bookings)
            }
        }
        
        private func drawMultipleView (bookings: [BookingClass]) {
            let view = MultiView.init()
            let booking = bookings.first!
            for b in bookings {
                if b.time.end.minutes > booking.time.end.minutes {
                    booking.time.end.minutes = b.time.end.minutes
                }
            }
            
            let pos = self.getPos(booking: booking)
            let sub = SubView(container: self, subview: view)
            sub.t = pos.y
            sub.r = -5
            sub.l = self.frame.size.width / 2
            sub.h = pos.h
            
            view.drawPlus()
            view.bookings = bookings
            view.delegate = self.delegate
        }
        
        //MARK: Utils
        
        private func showBooking (booking: BookingClass, viewType: BookingClass.ViewType) {
            var item: BookingViewBase!
            let pos = self.getPos(booking: booking)
            var left:CGFloat = 0
            var right:CGFloat = 5
            
            if (viewType == BookingClass.ViewType.full) {
                item = BookingViewBig.Instance()
                item.maxIcons = 3
            }
            else {
                if viewType == BookingClass.ViewType.right {
                    left = self.frame.size.width / 2
                }
                else {
                    right += self.frame.size.width / 2
                }
                item = Int(pos.h) > 50 ?
                    BookingViewSmall.Instance() : BookingViewMini.Instance()
            }
            
            let sub = SubView(container: self, subview: item)
            sub.t = pos.y
            sub.r = -right
            sub.l = left
            sub.h = pos.h
            
            item.show(booking: booking)
            item.delegateBooking = self.delegate
        }
        
        private func getPos(booking: BookingClass) -> (y: CGFloat, h: CGFloat) {
            let offset = 60 * self.params.hIni
            let y = ((booking.time.ini.minutes - offset) * self.params.high) / 60
            let h = ((booking.time.end.minutes - offset) * self.params.high) / 60 - y
            return (y: CGFloat(y), h: CGFloat(h))
        }
        

        //MARK: MultiView class
        
        class MultiView: UIView {
            var bookings = [BookingClass]()
            var delegate: ViewBookingDelegate?
            override init (frame : CGRect) {
                super.init(frame : frame)
            }
            convenience init () {
                self.init(frame:CGRect.zero)
            }
            required init(coder aDecoder: NSCoder) {
                super.init(coder: aDecoder)!
            }
            
            func drawPlus() {
                let plus = UIImageView.init(image: UIImage.init(named: "ico.white.plus"))
                let sub = SubView(container: self, subview: plus)
                sub.h = 24
                sub.w = 24
                sub.centerX = true
                sub.centerY = true
                self.backgroundColor = UIColor.hexColor("0D8489")

                let tap = UITapGestureRecognizer.init(target: self,
                                                      action: #selector(viewTapped))
                self.addGestureRecognizer(tap)
            }
            
            @objc func viewTapped () {
                self.delegate?.delegateBookingSubview(bookings: self.bookings)
            }
        }

    }
}
