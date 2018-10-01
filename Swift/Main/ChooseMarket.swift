//
//  ChoosMarket.swift
//  Kanito
//
//  Created by Luciano Calderano on 01/02/17.
//  Copyright © 2017 Kanito. All rights reserved.
//

import Foundation
class Market {
    var flag: UIImage?
    var name = ""
    var info = ""
    var code = ""
    
    init(flagName: String, code: String , name: String, info: String) {
        self.flag = UIImage.init(named: flagName)
        self.name = name
        self.info = info
        self.code = code
    }
}

protocol ChooseMarketDelegate {
    func selectedMarket(code: String)
}

class ChooseMarket: UIViewController {
    class func Instance () -> ChooseMarket {
        let id = String (describing: self)
        let sb = UIStoryboard.init(name: "Main", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: id)
            as! ChooseMarket
        return vc
    }
    
    @IBOutlet fileprivate var tableView: UITableView!
    private var dataArray = [Market]()
    var delegate: ChooseMarketDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadData()
    }
    
    func loadData() {
        dataArray.append(Market(flagName: "flag.ita", code: "it", name: "Italy",
                                info: "nnn Pet services attivi"))
        dataArray.append(Market(flagName: "flag.usa", code: "us", name: "United States",
                                info: "nnn Pet services attivi"))
    }
}

extension ChooseMarket: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataArray.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = UIView()
        header.backgroundColor = UIColor.clear
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = ChooseMarketCell.dequeue(tableView, indexPath)
        cell.data (dataArray[indexPath.section])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
    
    @IBAction func buttonTapped () {
        let indexPath = self.tableView.indexPathForSelectedRow
        if indexPath == nil {
            return
        }
        let market = dataArray[(indexPath?.section)!]
        self.delegate?.selectedMarket(code: market.code)
    }
}

// MARK: ChooseMarketCell

class ChooseMarketCell: UITableViewCell {
    class func dequeue (_ tableView: UITableView,
                        _ indexPath: IndexPath) -> ChooseMarketCell {
        let id = String (describing: self)
        return tableView.dequeueReusableCell(withIdentifier: id,
                                             for: indexPath) as! ChooseMarketCell
    }
    
    @IBOutlet fileprivate var flag: UIImageView!
    @IBOutlet fileprivate var name: MYLabel!
    @IBOutlet fileprivate var info: MYLabel!
    @IBOutlet fileprivate var check: MYCheckView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.flag.layer.cornerRadius = 3
        self.flag.layer.masksToBounds = true
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        self.check.isEnabled = selected
        self.backgroundColor = UIColor.white
    }
    
    func data (_ market: Market) -> Void {
        self.flag.image = market.flag
        self.name.text = market.name
        self.info.text = market.info
    }
}
