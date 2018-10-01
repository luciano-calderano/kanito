//
//  CustomerListCell
//  Kanito
//
//  Created by Luciano Calderano on 26/10/16.
//  Copyright © 2016 Kanito. All rights reserved.
//

import UIKit

class SignUpBizOptCell: UITableViewCell {
    class func dequeue (_ tableView: UITableView, _ indexPath: IndexPath) -> SignUpBizOptCell {
        return tableView.dequeueReusableCell(withIdentifier: "SignUpBizOptCell", for: indexPath) as! SignUpBizOptCell
    }

    @IBOutlet fileprivate var title: MYLabel!
    @IBOutlet fileprivate var check: MYCheckView!
    
    func data (value: Any) {
        let act = value as! KActivity.Act
        self.title?.text = act.name
    }
    
    func isSelected (_ sel: Bool) {
        self.check.isEnabled = sel
    }
}
