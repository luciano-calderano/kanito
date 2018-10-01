//
//  HomeMyKanitoCell.swift
//  Kanito
//
//  Created by Luciano Calderano on 18/01/17.
//  Copyright © 2017 Kanito. All rights reserved.
//

import Foundation

class HomeMyKanitoCell: UITableViewCell {
    class func dequeue (_ tableView: UITableView, _ indexPath: IndexPath) -> HomeMyKanitoCell {
        return tableView.dequeueReusableCell(withIdentifier: "HomeMyKanitoCell", for: indexPath) as! HomeMyKanitoCell
    }
    
    var cellData:Any {
        set {
            self.showData(newValue)
        }
        get {
            return ""
        }
    }
    @IBOutlet fileprivate var icona: UIImageView!
    @IBOutlet fileprivate var title: MYLabel!
    @IBOutlet fileprivate var badge: MYLabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        badge.layer.cornerRadius = 5
        badge.layer.masksToBounds = true
    }
    
    fileprivate func showData(_ data: Any) -> Void {
        let item = data as! MyKanitoMenu
        icona.image = item.icon
        title.text = item.title
        if item.badge == 0 {
            badge.isHidden = true
        }
        else {
            badge.isHidden = false
            badge.text = String(item.badge)
        }
    }
}
