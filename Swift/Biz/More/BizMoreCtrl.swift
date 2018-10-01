//
//  BizMoreCtrl
//  Kanito
//
//  Created by Luciano Calderano on 13/12/16.
//  Copyright © 2016 Kanito. All rights reserved.
//

import UIKit

struct BizMoreClass {
    var type = 0
    var title = ""
    var subTitle = ""
    var colorBack = UIColor.white
    var icon: UIImage?
    var height:CGFloat = 0
    var selector: Selector?
}

class BizMoreCtrl : MYViewController, UITableViewDelegate, UITableViewDataSource {
    class func instanceFromSb (_ sb: UIStoryboard!) -> BizMoreCtrl {
        return sb.instantiateViewController(withIdentifier: "BizMoreCtrl") as! BizMoreCtrl
    }
    
    @IBOutlet fileprivate var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadData()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
    //    override func viewWillDisappear(_ animated: Bool) {
    //        super.viewWillDisappear(animated)
    //        UIApplication.shared.statusBarStyle = .lightContent
    //    }
    
    func loadData() {
        var item: BizMoreClass!
        
        var s = ""
        for dict in CompanyClass.shared.value.activities {
            let id = dict.string("id_activity")
            let act = KActivity.shared.activities[id]!
            //            let act = Activities.shared.getActivity(id: dict.string("id_activity"))
            s += act.name + " "
        }
        
        item = BizMoreClass()
        item.type = 1
        item.title = CompanyClass.shared.value.name
        item.subTitle = s
        item.icon = CompanyClass.shared.value.logo
        item.height = 150
        item.selector = #selector(customer)
        dataArray.append(item)
<<<<<<< HEAD
        
        item = BizMoreClass()
        item.height = 30
        dataArray.append(item)
        
        //        item = BizMoreClass()
        //        item.type = 2
        //        item.title = Lng("settings")
        //        item.icon = UIImage.init(named: "ico.grey.customer")
        //        item.colorBack = UIColor.hexColor("9b9b9b")
        //        item.height = 50
        //        item.selector = #selector(impostazioni)
        //        dataArray.append(item)
        
=======

        item = BizMoreClass()
        item.height = 30
        dataArray.append(item)

//        item = BizMoreClass()
//        item.type = 2
//        item.title = Lng("settings")
//        item.icon = UIImage.init(named: "ico.grey.customer")
//        item.colorBack = UIColor.hexColor("9b9b9b")
//        item.height = 50
//        item.selector = #selector(impostazioni)
//        dataArray.append(item)

>>>>>>> 27c997a30628d22b0ed0092449db4269d26446e3
        item = BizMoreClass()
        item.type = 2
        item.title = Lng("support")
        item.icon = UIImage.init(named: "ico.white.clienti") //"ico.grey.customer")
        item.colorBack = UIColor.hexColor("ff5f73")
        item.height = 50
        item.selector = #selector(support)
        dataArray.append(item)
<<<<<<< HEAD
        
        item = BizMoreClass()
        item.height = 20
        dataArray.append(item)
        
=======

        item = BizMoreClass()
        item.height = 20
        dataArray.append(item)

>>>>>>> 27c997a30628d22b0ed0092449db4269d26446e3
        item = BizMoreClass()
        item.type = 2
        item.title = Lng("gotoMarketPlace")
        item.icon = UIImage.init(named: "ico.white.k")
        item.colorBack = UIColor.hexColor("f6a623")
        item.height = 50
        item.selector = #selector(marketPlace)
        dataArray.append(item)
    }
    
    // MARK: table view
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let item = dataArray[indexPath.row] as! BizMoreClass
        return item.height
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = dataArray[indexPath.row] as! BizMoreClass
        let cellId = { () -> String in
            switch item.type {
            case 1:  return "BizMore01"
            case 2:  return "BizMore02"
            default: return "BizMore00"
            }
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId(), for: indexPath)
        
        if (item.icon != nil) {
            let iconSize = min(item.height - 10, 60)
            cell.imageView?.image = item.icon?.resize(iconSize)
            
            if item.type == 2 {
                let itemSize = CGSize.init(width: iconSize, height: iconSize)
                UIGraphicsBeginImageContextWithOptions(itemSize, false, UIScreen.main.scale)
                let imageRect = CGRect.init(x: 10, y: 10, width: itemSize.width - 20, height: itemSize.height - 20)
                cell.imageView?.image?.draw(in: imageRect)
                cell.imageView?.image = UIGraphicsGetImageFromCurrentImageContext()
                UIGraphicsEndImageContext()
            }
        }
        
        cell.imageView?.backgroundColor = item.colorBack
        cell.imageView?.layer.cornerRadius = 4
        cell.textLabel?.text = item.title
        cell.detailTextLabel?.text = item.subTitle
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
<<<<<<< HEAD
        
=======

>>>>>>> 27c997a30628d22b0ed0092449db4269d26446e3
        let item = dataArray[indexPath.row] as! BizMoreClass
        if item.selector  != nil {
            self.perform (item.selector)
        }
    }
    
    @objc func customer () {
        openUrl(Config.url.kanito + "/my-kanito/business.html")
    }
    func impostazioni () {
        
    }
    @objc func support () {
        openUrl(Config.url.kanito + "ontact-us.html")
    }
    @objc func marketPlace () {
        openUrl(Config.url.kanito)
    }
    
    @IBAction func logout () {
        self.alert (Lng("logout"),  message: Lng("areSure"),
                    cancelBlock: { (UIAlertAction) in
                        return
        },
                    okBlock: { (UIAlertAction) in
                        UserClass.shared.logout()
                        self.gotoStoryboard(type: .Home)
        })
    }
}
