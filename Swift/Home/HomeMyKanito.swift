//
//  HomeMyKanito.swift
//  Kanito
//
//  Created by Luciano Calderano on 18/01/17.
//  Copyright © 2017 Kanito. All rights reserved.
//

import Foundation

enum MyKanitoMenuType {
    case typeSeparator
    case typeItem
}

class MyKanitoMenu {
    var type = MyKanitoMenuType.typeSeparator
    var icon = UIImage()
    var title = ""
    var badge = 0
}

class HomeMyKanitoCtrl : MYViewController, UITableViewDelegate, UITableViewDataSource {
    class func instanceFromSb (_ sb: UIStoryboard!) -> HomeMyKanitoCtrl {
        return sb.instantiateViewController(withIdentifier: "HomeMyKanitoCtrl") as! HomeMyKanitoCtrl
    }
    
    @IBOutlet fileprivate var tableView: UITableView!
    private var selectedArray = [Int]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    
    private func loadData() {
        dataArray.append(menuItem(type: .typeItem, iconName: "ico.grey.dog", title: "Titolo 1"))
        dataArray.append(menuItem(type: .typeItem, iconName: "ico.grey.dog", title: "Titolo 2"))
        dataArray.append(menuItem(type: .typeItem, iconName: "ico.grey.dog", title: "Titolo 3"))
        dataArray.append(menuItem(type: .typeItem, iconName: "ico.grey.dog", title: "Titolo 4"))
        dataArray.append(menuItem(type: .typeItem, iconName: "ico.grey.dog", title: "Titolo 5"))
        
        let item = dataArray[1] as! MyKanitoMenu
        item.badge = 2
        dataArray[1] = item
        
        self.tableView.reloadData()
    }
    
    private func menuItem (type: MyKanitoMenuType, iconName: String, title: String) -> MyKanitoMenu {
        let item = MyKanitoMenu()
        item.type = type
        if iconName.isEmpty == false {
            item.icon = UIImage.init(named: iconName)!
        }
        item.title = title
        return item
    }
    
    // MARK: table view
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 45
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = HomeMyKanitoCell.dequeue(tableView, indexPath)
        cell.cellData = dataArray[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }    
}
