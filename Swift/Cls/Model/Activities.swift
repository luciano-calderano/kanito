//
//  Activities.swift
//  Kanito
//
//  Created by mac on 26/03/17.
//  Copyright © 2017 Kanito. All rights reserved.
//

import Foundation

class KActivity {
    static let shared = KActivity()
    
    private let fileConfig  = UserDefaults.init(suiteName: "activity.config")
    private let keyAct = "Act"
    private let keyGrp = "Grp"
    private let keyDate = "Date"

    var activities = [String: Act]()
    var groups = [Grp]()

    class Act {
        var id = ""
        var name = ""
        var order = 0
        var grpId = ""
        
        class func create(array: [JsonDict]) -> [String: Act] {
            var acts = [String: Act]()
            for dict in array {
                let act = Act()
                act.id = dict.string("id_activity_type")
                act.name = dict.string("name")
                act.order = dict.int("order")
                act.grpId = dict.string("id_activity_group")
                acts[act.id] = act
            }
            return acts
        }
    }

    class Grp {
        var id = ""
        var name = ""
        var order = 0
        
        class func create(array: [JsonDict]) -> [Grp] {
            var groups = [Grp]()
            for dict in array {
                let grp = Grp()
                grp.id = dict.string("id_activity_group")
                grp.name = dict.string("name")
                grp.order = dict.int("order")
                groups.append(grp)
            }
            return groups
        }
    }
    
    func load(forceClear: Bool = false) {
        if forceClear || self.mustReload() {
            loadGropus()
        }
    }
    
    func getObjectWithKey (_ key: String) -> Object {
        let act = self.activities[key]
        var obj = Object()
        obj.id = key
        obj.name = (act == nil) ? "Activity(\(key))" : (act?.name)!
        
        var objGrp = Object()
        objGrp.id = act?.grpId ?? "0"
        objGrp.name = "Group (\(objGrp.id))"
        
        for grp in self.groups {
            if grp.id == objGrp.id {
                objGrp.name = grp.name
                break
            }
        }
        obj.data = objGrp
        return obj
    }

    private func mustReload () -> Bool {
        func daysBetweenDates(_ startDate: Date, and endDate: Date) -> Int {
            let calendar = Calendar.current
            let components = (calendar as NSCalendar).components([.day], from: startDate, to: endDate, options: [])
            return components.day!
        }

        let plistGrp = fileConfig?.value(forKey: self.keyGrp) as? [JsonDict]
        if plistGrp == nil {
            return true
        }
        self.groups = Grp.create(array: plistGrp!)

        let plistAct = fileConfig?.value(forKey: self.keyAct) as? [JsonDict]
        if plistAct == nil {
            return true
        }
        self.activities = Act.create(array: plistAct!)

        let lastDate = fileConfig?.value(forKey: self.keyDate) as? String
        if lastDate == nil {
            return true
        }
        
        let date = lastDate!
        if date.isEmpty {
            return true
        }
        
        if let d = date.toDate(withFormat: Config.fmt.data), daysBetweenDates(d, and: Date()) > 30 {
            return true
        }
        return false
    }
    
    private func loadGropus () {
        let request = MYHttpRequest.get("tools/groups")
        request.start(showWheel: false) { (success, response) in
            if success {
                let array = response.array("Value") as! [JsonDict]
                self.fileConfig?.setValue(array, forKey: self.keyGrp)
                self.groups = Grp.create(array: array)
                self.loadActivities()
            }
        }
        let date = Date().toString(withFormat: Config.fmt.data)
        self.fileConfig?.setValue(date, forKey: self.keyDate)
    }
    
    private func loadActivities () {
        self.activities.removeAll()
        var actPlist = [JsonDict]()

        for grp in self.groups {
            let request = MYHttpRequest.get("tools/activities-by-group")
            request.json = [
                "groupId" : grp.id
            ]
            request.start(showWheel: false) { (success, response) in
                if success {
                    let array = response.array("Value")  as! [JsonDict]
                    for dict in array {
                        actPlist.append(dict)
                    }
                    for (key, value) in Act.create(array: array)  {
                        self.activities[key] = value
                    }
                    self.fileConfig?.setValue(actPlist, forKey: self.keyAct)
                }
            }
        }
    }
}
