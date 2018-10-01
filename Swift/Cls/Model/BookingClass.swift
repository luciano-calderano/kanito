//
//  BookingClass.swift
//  Kanito
//
//  Created by mac on 16/03/17.
//  Copyright © 2017 Kanito. All rights reserved.
//

import Foundation
import LcLib

class BookingNext {
    static var shared = BookingNext()
    private var dict = [String: Int]()
    private let keyFmt = "yyMMdd"

    func clear () {
        self.dict.removeAll()
    }
    
    func getBookingWithDate (_ date: Date) -> Int {
        let d = date.toString(withFormat: keyFmt)
        return self.dict[d] ?? 0
    }
    
    func loadBookingPerDay() {
        let d = Date()
        let day = 60 * 60 * 24
        for i in 0...60 {
            let date = d.addingTimeInterval(TimeInterval(i * day))
            self.loadBookingWithDate(date)
        }
    }

    func loadBookingWithDate(_ date: Date) {
        BookingClass.getList(fromDay: date,
                             toDay: date,
                             offset: 1,
                             showWheel: false) {
                                (dataArray, count) in
                                if dataArray.count > 0 {
                                    let booking = dataArray.first
                                    self.saveBookingCount(date: booking?.time.ini.date,
                                                          count: count)
                                }
        }
    }
    
    func saveBookingCount (date: Date?, count: Int) {
        let key = date?.toString(withFormat: self.keyFmt) ?? "-"
        self.dict.removeValue(forKey: key)
        var i: Int!
        if count > 20 {
            i = 3
        } else if count > 10 {
            i = 2
        } else if count > 0 {
            i = 1
        }
        else {
            return
        }
        self.dict[key] = i
    }
}

class BookingClass {
    enum ViewType {
        case full
        case left
        case right
    }
    
    struct Time {
        var text = ""
        var minutes = 0
        var date: Date!
    }

    var id = ""
    var idCustomer = ""
    var idCustomerPet = ""

    var title = ""
    var time = (ini: Time(), end: Time())
    var customerName = ""
    var petName = ""

    var petList = [PetClass]()

    var status = ""
    var note = ""
    var activityGroup = Object()
    var activity = Object()
    var service = Object()
    var cooperator = Object()
    var isPending = 0

    init(with dict: JsonDict) {
        self.id = dict.string("id_calendar")
        
        self.idCustomer = dict.string("id_customer")
        self.idCustomerPet = dict.string("id_customer_pet")

        CustomerClass.getById(self.idCustomer) { (customer) in
            self.customerName = customer.name
            Pets.shared.getPet(id: self.idCustomerPet) { (pet) in
                pet.image = UIImage.init(named: "ico.green.dog")
                pet.customer = customer
                self.petList.append(pet)
                self.petName = pet.name
            }
        }
        
        self.title = dict.string("calendar_title")
        self.time.ini = self.convertTime(dict.string("time_start"))
        self.time.end = self.convertTime(dict.string("time_end"))
        self.note = dict.string("calendar_note")
        
        self.activity = KActivity.shared.getObjectWithKey(dict.string("id_activity"))
        self.activityGroup = self.activity.data as! Object
//        self.activity = Activities.shared.getActivity(id: dict.string("id_activity"))
//        self.activityGroup = Activities.shared.getActivityGroup(activityId: self.activity.id)
        
        self.service.id = dict.string("id_service")
        self.service.name = "Srv." +  dict.string("id_service")
        self.cooperator.id = dict.string("id_cooperator")
        self.cooperator.name = "Coop." +  dict.string("id_cooperator")

        self.isPending = dict.int("is_pending")
        
        if self.time.ini.date > self.time.end.date {
            let d = self.time.ini.date.addingTimeInterval(60 * 60)
            let s = d.toString(withFormat: Config.fmt.dataDB)
            self.time.end = self.convertTime(s)
        }
    }
    
    private func getPets (id: String) -> [PetClass] {
        let pet = Pets.shared.getNew()
        pet.image = UIImage.init(named: "ico.green.dog")
        pet.idCustomerPet = self.idCustomerPet
        pet.name = self.petName
        pet.customer = CustomerClass()
        pet.customer.idCustomer = self.idCustomer
        pet.customer.name = self.customerName
        return [ pet ]
    }
    
    private func convertTime (_ time:String) -> Time {
        var t = Time()
        t.date = time.toDate(withFormat: Config.fmt.dataDB)
        t.text = t.date.toString(withFormat: Config.fmt.ora)
        let h = Int(t.date.toString(withFormat: "HH"))!
        let m = Int(t.date.toString(withFormat: "mm"))!
        t.minutes = h * 60 + m
        return t
    }

    static func getList (forDay day: Date,
                         completion: @escaping ([BookingClass], Int) -> ()) {
        BookingClass.getList(fromDay: day, toDay: day) { (dataArray, count) in
            BookingNext.shared.saveBookingCount(date: day, count: count)
            return completion (dataArray, count)
        }
    }
    
    static func getList (fromDay dayStart: Date,
                         toDay dayEnd: Date,
                         offset: Int = 100,
                         showWheel: Bool = true,
                         completion: @escaping ([BookingClass], Int) -> ()) {
        
        let start = Calendar.current.startOfDay(for: dayStart)
        
        let endTmp = Calendar.current.startOfDay(for: dayEnd)
        var components = DateComponents()
        components.day = 1
        components.second = -1
        let end = Calendar.current.date(byAdding: components, to: endTmp)!
        
        let request = MYHttpRequest.get("booking/list")
        request.json = [
            "companyId"     : CompanyClass.shared.value.id,
            //                "customerId"    : self.customer.idCustomer,
            //                "customerPetId" : self.values.pet.id,
            //                "employeeId"    : 0, //
            "start"         : start.toString(withFormat: Config.fmt.dataDB),
            "end"           : end.toString(withFormat: Config.fmt.dataDB),
            "limit"         : 0,
            "offset"        : offset,
        ]
        
        request.start(showWheel: showWheel) { (success, response) in
            if success {
                var dataArray = [BookingClass]()
                for dict in response.array("Value.itemList") as! [JsonDict] {
                    dataArray.append(BookingClass.init(with: dict))
                }
                completion(dataArray, response.int("Value.itemCount"))
            }
        }
    }
}

