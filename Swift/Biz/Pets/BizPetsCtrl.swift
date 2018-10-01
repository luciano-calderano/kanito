//
//  BizPetsCtrl
//  Kanito
//
//  Created by Luciano Calderano on 13/12/16.
//  Copyright © 2016 Kanito. All rights reserved.
//

import UIKit

class BizPetsCtrl : MYViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    @IBOutlet fileprivate var tableView: UITableView!
    @IBOutlet fileprivate var searchText: UITextField!
//    private var fullArray = [PetClass]()

    fileprivate var refreshControl = UIRefreshControl()
    private var pageNum = 0
    private let maxItem = 30

    override func viewDidLoad() {
        super.viewDidLoad()
        self.addNotificationReloadData()
        
        self.refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        self.refreshControl.addTarget(self, action: #selector(self.refresh), for: .valueChanged)
        self.refreshControl.backgroundColor = UIColor.myGreyLight
        self.tableView.addSubview(self.refreshControl)
        
        let headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: self.tableView.frame.size.width, height: 5))
        headerView.backgroundColor = UIColor.myGreyLight
        self.tableView.tableHeaderView = headerView

        self.loadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }
    
    override func headerViewDxTapped() {
        let ctrl = BizPetsEditCtrl.Instance()
        ctrl.petClass = Pets.shared.getNew()
        self.navigationController?.show(ctrl, sender: self)
    }
    
    override func reloadData(_ notification: Notification) {
        let n = notification.object as! NotificationType
        if n == .customerPets {
            self.refresh()
        }
    }
    
    @objc func refresh () {
        self.pageNum = 0
        dataArray.removeAll()
        self.loadData()
    }
    
    func loadData() {
        refreshControl.endRefreshing()
        Pets.shared.getList(pageNum: self.pageNum,
                            maxItem: self.maxItem,
                            search: self.searchText.text!) {
            (petArray) in
            self.pageNum += 1
            let array = self.dataArray as! [PetClass] + petArray
            self.dataArray = array
            self.tableView.reloadData()
        }
    }
    
    // MARK: search
    
    @IBAction func searchTapped () {
        self.view.endEditing(true)
        self.refresh()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.redesignKeyboard(textField: textField)
    }
    
    @IBAction func textChanged (textField: UITextField) {
//        if (textField.text?.isEmpty)! {
//            dataArray = self.fullArray
//        }
//        else {
//            let predicate = NSPredicate.init(format: "self.name contains[cd] %@",
//                                             textField.text!)
//            dataArray = self.fullArray.filter { predicate.evaluate(with: $0) }
//        }
//        self.tableView.reloadData()
    }

    
    // MARK: table view
    
    func maxItemOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
    
    func tableView(_ tableView:UITableView, willDisplay cell:UITableViewCell, forRowAt indexPath:IndexPath) {
        if (indexPath.row == dataArray.count - 1) {
            if (dataArray.count == self.pageNum * self.maxItem) {
                self.loadData()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = BizPetsCell.dequeue(tableView, indexPath)
        cell.data (dataArray[indexPath.row] as! PetClass)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let ctrl = BizPetsDettCtrl.Instance(petClass: dataArray[indexPath.row] as! PetClass)
        self.navigationController?.show(ctrl, sender: self)
    }
}
