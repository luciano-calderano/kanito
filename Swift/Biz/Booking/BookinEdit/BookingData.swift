//
//  BookingData
//  Kanito
//
//  Created by mac on 24/03/17.
//  Copyright © 2017 Kanito. All rights reserved.
//

import Foundation

struct BookingData {
    enum Enum: String {
        case title
        case date
        case pet
        
        case activity

        case startTime
        case endTime
        //    case employee
        //    case total
        case isPending
        case note
        case none
        case delete
    }
    
    struct Values {
        var id = ""
        var title = ""

        var pet = (id:String(), name:String(), idCustomer:String(), nameCustomer:String())
        var activity = Object()
        var startTime = Date()
        var endTime = Date()
        var isPending = 0
        var note = ""
    }
    
}
