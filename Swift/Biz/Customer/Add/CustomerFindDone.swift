//
//  CustomerList
//  Kanito
//
//  Created by Luciano Calderano on 13/12/16.
//  Copyright © 2016 Kanito. All rights reserved.
//

import UIKit

class CustomerFindDone : MYViewController {
    class func Instance(found: Bool) -> CustomerFindDone {
        let sbName = StoryboardType.CustomerFind.rawValue
        let vcName = found ? "CustomerAdded" : "CustomerNotFound"
        let sb = UIStoryboard.init(name: sbName, bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: vcName)
        return vc as! CustomerFindDone
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setBackAsHome = true
    }
}
