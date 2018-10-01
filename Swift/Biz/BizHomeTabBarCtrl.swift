//
//  BizHomeTabBarCtrl
//  Kanito
//
//  Created by Luciano Calderano on 18/01/17.
//  Copyright © 2017 Kanito. All rights reserved.
//

import Foundation

class BizHomeTabBarCtrl : UITabBarController {
    var reload = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.viewControllers = [ self ]
        UITabBar.appearance().tintColor = UIColor.myBizGreen
        
        for ctrl in self.viewControllers! {
            ctrl.tabBarItem.title = ctrl.tabBarItem.title?.tryLang()
        }
//        BookingNext.shared.loadBookingPerDay()
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    
}
