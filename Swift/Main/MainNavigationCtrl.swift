//
//  MainNavigationCtrl.swift
//  Kanito
//
//  Created by Luciano Calderano on 26/01/17.
//  Copyright © 2017 Kanito. All rights reserved.
//

import Foundation

class MainNavigationCtrl: UINavigationController, ChooseMarketDelegate {
    private let keyMarket = "MarketPlace"
    private var clearMarket = false
    
    override func awakeFromNib() {
        LanguageClass.shared.selectLanguage()        
        start()
        //        checkFirstLoad()
    }
    
    private func checkFirstLoad () {
        let market = UserDefaults.standard.string(forKey: keyMarket)
        if market != nil {
            start()
        } else {
            chooseMarketPlace()
        }
    }
    
    func chooseMarketPlace () {
        let ctrl = ChooseMarket.Instance()
        ctrl.delegate = self
        show(ctrl, sender: self)
    }
    
    func selectedMarket(code: String) {
        UserDefaults.standard.set(code, forKey: keyMarket)
        start()
    }
    
    func start () {
        var sbType: StoryboardType?
        switch UserClass.shared.user.type {
            //        case .pvt:
        //            sbType = .PvtHome
        case .biz, .pro :
            sbType = .BizHome
        default:
            sbType = .Home
        }
        //        let sb = UIStoryboard.init(name: "BookingSelectPet", bundle: nil)
        let sb = UIStoryboard.init(name: (sbType?.rawValue)!, bundle: nil)
        let ctrl = sb.instantiateInitialViewController()
        show(ctrl!, sender: self)
    }
    
}
