//
//  CustomerList
//  Kanito
//
//  Created by Luciano Calderano on 13/12/16.
//  Copyright © 2016 Kanito. All rights reserved.
//

import UIKit

class CustomerList : MYViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, CustomerListCellDelegate {
    
    class func Instance() -> CustomerList {
        let vc = self.load(storyboard: .Customer) as! CustomerList
        return vc
    }

    @IBOutlet fileprivate var tableView: UITableView!
    @IBOutlet fileprivate var searchText: UITextField!
    
//    private var fullArray = [CustomerClass]()
    private var pageNum = 0
    private let maxItem = 30
    
    private let refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        self.refreshControl.addTarget(self, action: #selector(self.refresh), for: .valueChanged)
        self.refreshControl.backgroundColor = UIColor.myGreyLight
        self.tableView.addSubview(self.refreshControl)

        let swipeSx = UISwipeGestureRecognizer.init(target: self, action: #selector(self.swipe))
        swipeSx.direction = .left
        self.tableView.addGestureRecognizer(swipeSx)
        
        let swipeDx = UISwipeGestureRecognizer.init(target: self, action: #selector(self.swipe))
        swipeDx.direction = .right
        self.tableView.addGestureRecognizer(swipeDx)

        self.loadData()
        self.addNotificationReloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }

    // MARK: - Add Customer & Pet
    
    override func headerViewDxTapped() {
        self.nextCtrl(CustomerFind.Instance())
    }
    
    override func reloadData(_ notification: Notification) {
        let n = notification.object as! NotificationType
        if n == .customers {
            self.refresh()
        }
    }
    
    @objc func refresh () {
        self.pageNum = 0
        dataArray.removeAll()
        self.loadData()
    }
    
    private func loadData() {
        self.refreshControl.endRefreshing()
        CustomerClass.getList(pageNum: self.pageNum,
                              maxItem: self.maxItem,
                              search: self.searchText.text!) { (result) in
                                self.httpResponse(result)

        }
    }
    
    private func httpResponse(_ customers: [CustomerClass]) {
        let array = dataArray as! [CustomerClass] + customers
        dataArray = array

        self.tableView.reloadData()
        if customers.count == 0 {
            self.alert("", message: Lng("noCust"), okBlock: nil)
        }
        else {
            self.pageNum += 1
        }
    }
    
    @IBAction func searchTapped () {
        self.view.endEditing(true)
        self.refresh()
    }
    
    // MARK: - table view
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    func tableView(_ tableView:UITableView, willDisplay cell:UITableViewCell, forRowAt indexPath:IndexPath) {
        if (indexPath.row == dataArray.count - 1) {
            if (dataArray.count == self.pageNum * self.maxItem) {
                self.loadData()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = CustomerListCell.dequeue(tableView: tableView, indexPath: indexPath)
        cell.delegate = self
        cell.data (dataArray[indexPath.row] as! CustomerClass)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let cust = dataArray[indexPath.row] as! CustomerClass
        let ctrl = CustomerDetail.Instance(customer: cust)
        self.navigationController?.show(ctrl, sender: self)
    }
    
    // MARK: - search
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        self.refresh()
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
//            let predicate = NSPredicate.init(format: "self.name contains[cd] %@", textField.text!)
//            dataArray = self.fullArray.filter { predicate.evaluate(with: $0) }
//        }
//        self.tableView.reloadData()
    }
    
    // MARK: - Cell delegate

    func emailTapped(email: String) {
        UIMessageClass.mainCtrl = self
        UIMessageClass.sendEmail(email)
    }
    
    func phoneTapped(phone: String) {
        UIMessageClass.mainCtrl = self
        UIMessageClass.openCall(phone)
    }
    
    // MARK: - swipe
    
    @objc func swipe (_ sender: UISwipeGestureRecognizer) {
        let p = sender.location(in: self.tableView)
        let currentIdx = self.tableView.indexPathForRow(at: p)

        let cell = self.tableView.cellForRow(at: currentIdx!) as! CustomerListCell
        if cell.mainView.frame.origin.x != 0 {
            return
        }
        
        var rect = cell.mainView.frame
        let x = sender.direction == .left ? -rect.size.width : rect.size.width
        rect.origin.x = x / 2

        UIView.animate(withDuration: 0.2, animations: {
            cell.mainView.frame = rect
        }, completion: { finished in
            self.timerToCloseCell(cell)
        })
    }
    
    private func timerToCloseCell (_ cell: CustomerListCell) {
        let dispatchTime = DispatchTime.now() + .seconds(2)
        DispatchQueue.main.asyncAfter(deadline: dispatchTime) {
            UIView.animate(withDuration: 0.2, animations: {
                var rect = cell.mainView.frame
                rect.origin.x = 0
                cell.mainView.frame = rect
            })
        }
    }
}
