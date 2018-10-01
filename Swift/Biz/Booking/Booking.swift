//
//  ViewController.swift
//  SwiftExample
//
//  Created by Wenchao Ding on 9/3/15.
//  Copyright (c) 2015 wenchao. All rights reserved.
//

import UIKit
import FSCalendar

class Booking: MYViewController, FSCalendarDataSource, FSCalendarDelegate, FSCalendarDelegateAppearance {

    @IBOutlet weak var calendar: FSCalendar!
    
    private let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        return formatter
    }()
    override func viewDidLoad() {
        super.viewDidLoad()

        self.calendar.scrollDirection = .vertical
        self.calendar.pagingEnabled = false
        self.calendar.firstWeekday = 2
//        self.calendar.appearance.caseOptions = [
//            .weekdayUsesUpperCase,
//            .headerUsesUpperCase]
        var components = DateComponents()
        components.month = 1
        let next = Calendar.current.date(byAdding: components, to: Date())!
        self.calendar.setCurrentPage(next, animated: true)
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
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        if monthPosition == .previous || monthPosition == .next {
            calendar.setCurrentPage(date, animated: true)
        }
        
        let ctrl = BookingWeek.Instance()
        ctrl.selectedDate = date
        self.navigationController?.show(ctrl, sender: self)
    }
    
    //
    // MARK: FSCalendarAppearance delegate
    //

    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, eventDefaultColorsFor date: Date) -> [UIColor]? {
        return [UIColor.myBizGreen,
                UIColor.myBlueLight,
                UIColor.myBlueLight]
    }
}
