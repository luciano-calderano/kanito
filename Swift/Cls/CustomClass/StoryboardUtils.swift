//
//  StoryboardUtils.swift
//  Kanito
//
//  Created by mac on 17/03/17.
//  Copyright © 2017 Kanito. All rights reserved.
//

import Foundation

enum StoryboardType: String {
    case Home
    case Login
    case SignUp
    case BizHome
    case PvtHome
    
    case BizDash
    case Customer
    case CustomerFind
    case BizPets
    case Booking
    case BookingDetail
    
    case Popup
}

//func loadCtrl (sb: StoryboardType, vc: Any) -> UIViewController {
//    let vcName = String (describing: vc)
//    let sb = UIStoryboard.init(name: sb.rawValue, bundle: nil)
//    let vc = sb.instantiateViewController(withIdentifier: vcName)
//    return vc
//}
//
//
//func loadCtrl (sb: StoryboardType, vc: Any) -> UIViewController {
//    return loadCtrl(sbName: sb.rawValue, vc: vc)
//}
//
//func loadCtrl (sbName: String, vc: Any) -> UIViewController {
//    let vcName = String (describing: vc)
//    return loadCtrl(sbName: sbName, vcName: vcName)
//}
//
//func loadCtrl (sb: StoryboardType, vcName: String) -> UIViewController {
//    return loadCtrl(sbName: sb.rawValue, vcName: vcName)
//}
//
//func loadCtrl (sbName: String, vcName: String) -> UIViewController {
//    let sb = UIStoryboard.init(name: sbName, bundle: nil)
//    let vc = sb.instantiateViewController(withIdentifier: vcName)
//    return vc
//}
