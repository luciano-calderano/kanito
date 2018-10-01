//
//  SignUpBizOptCtrl
//  Kanito
//
//  Created by Luciano Calderano on 13/12/16.
//  Copyright © 2016 Kanito. All rights reserved.
//

import UIKit

protocol SignUpBizOptCtrlDelegate : class {
    func returnValues (type: Int, desc: String, index: [Int])
}


class SignUpBizOptCtrl : MYViewController, UITableViewDelegate, UITableViewDataSource {
    class func instanceFromSb (_ sb: UIStoryboard!) -> SignUpBizOptCtrl {
        return sb.instantiateViewController(withIdentifier: "SignUpBizOptCtrl") as! SignUpBizOptCtrl
    }

    weak var delegate: SignUpBizOptCtrlDelegate?
    var type = 0
    
    @IBOutlet fileprivate var tableView: UITableView!
    @IBOutlet fileprivate var maxLabel: MYLabel!
    
    private var selectedArray = [Int]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.maxLabel.alpha = 0
        self.maxLabel.layer.cornerRadius = self.maxLabel.frame.size.height / 2
        self.maxLabel.layer.masksToBounds = true
        self.loadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    
    func loadData() {
        for (_, value) in KActivity.shared.activities {
            dataArray.append(value)
        }
//        let a = dataArray.sorted(by: $0.name > $1.name)
//        dataArray = Activities.shared.activityList
        self.tableView.reloadData()
    }
    
    // MARK: table view
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = SignUpBizOptCell.dequeue(tableView, indexPath)
        cell.data(value: dataArray[indexPath.row])
        cell.isSelected(self.selectedArray.index(of: indexPath.row) != nil)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if let index = self.selectedArray.index(of: indexPath.row) {
            self.selectedArray.remove(at: index)
        }
        else {
            if selectedArray.count == 3 {
                self.showMax()
            }
            else {
                self.selectedArray.append(indexPath.row)
            }
        }
        self.tableView.reloadRows(at: [indexPath], with: .fade)
    }
    
    func showMax () {
        self.maxLabel.alpha = 1
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            UIView.animate(withDuration: 0.5) {
                self.maxLabel.alpha = 0
            }
        }
    }
    
    @IBAction func confirmTapped () {
        var desc = ""
        var indexArray = [Int]()
        for i in self.selectedArray {
            let act = dataArray[i] as! KActivity.Act
            if desc.isEmpty == false {
                desc += " - "
            }
            desc += act.name
            indexArray.append (Int(act.id)!)
        }
        
        self.delegate?.returnValues(type: self.type, desc: desc, index: indexArray)
        _ = self.navigationController?.popViewController(animated: true)
    }
}
