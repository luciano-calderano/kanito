//
//  SignUpUserTypeCtrl
//  Kanito
//
//  Created by Luciano Calderano on 16/12/16.
//  Copyright © 2016 Kanito. All rights reserved.
//

import UIKit

class UserTypeMenu {
    var type = UserType.None
    var title = ""
    var descr = ""
    var icona: UIImage!
    var color = UIColor.myOrange
    
    init(type: UserType, title: String, descr: String, iconName: String) {
        self.type = type
        self.title = title.tryLang()
        self.descr = descr.tryLang()
        self.icona = UIImage.init(named: iconName)!
    }
}

class SignUpUserTypeCtrl: MYViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    class func instanceFromSb (_ sb: UIStoryboard!) -> SignUpUserTypeCtrl {
        return sb.instantiateViewController(withIdentifier: "SignUpUserTypeCtrl") as! SignUpUserTypeCtrl
    }

    // MARK: Vars
    
    fileprivate var collectionViewLayout: SignUpUserTypeLayout!
    
    @IBOutlet fileprivate var collectionView: UICollectionView!
    @IBOutlet fileprivate var titleView: UIView!
    
    fileprivate var animationsCount = 0
    private var selectedIndexPath: IndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.titleView.layer.borderColor = UIColor.myGreyMedium.cgColor
        self.titleView.layer.borderWidth = 1
        
        dataArray = [
            UserTypeMenu.init(type: .pvt, title: "#signupTypePvt",
                              descr: "#signupTypePvtDesc", iconName: "signUpPvt"),
            UserTypeMenu.init(type: .pro, title: "#signupTypePro",
                              descr: "#signupTypeProDesc", iconName: "signUpBiz"),
            UserTypeMenu.init(type: .biz, title: "#signupTypeBiz",
                              descr: "#signupTypeBizDesc", iconName: "signUpPro"),
        ]
        self.configureCollectionView()
        self.selectedIndexPath =  IndexPath.init(row: 1, section: 0)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.collectionView.scrollToItem(at: self.selectedIndexPath!,
                                         at: .right,
                                         animated: true)
    }
    fileprivate var pageWidth: CGFloat {
        return self.collectionViewLayout.itemSize.width + self.collectionViewLayout.minimumLineSpacing
    }
    
    fileprivate var contentOffset: CGFloat {
        return self.collectionView.contentOffset.x + self.collectionView.contentInset.left
    }

    // MARK: Configuration
    
    fileprivate func configureCollectionView() {
        let size = CGSize(width: 250, height: min (340, self.collectionView.frame.size.height))
        self.collectionViewLayout = SignUpUserTypeLayout.configureLayout(self.collectionView,
                                                                         itemSize: size,
                                                                         minimumLineSpacing: 20)
        self.collectionViewLayout.minimumScaleFactor = 1
    }
    
    // MARK: Actions
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = SignUpUserTypeCell.dequeue(collectionView, indexPath)
        let item = dataArray[indexPath.row] as! UserTypeMenu
        cell.isSelected = (indexPath.row == selectedIndexPath?.row)
        cell.data(value: item)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView.isDragging || collectionView.isDecelerating || collectionView.isTracking {
            return
        }
        let item = dataArray[indexPath.row] as! UserTypeMenu
        if item.type == UserType.pvt {
            let alert = UIAlertController(title: "",
                                          message: Lng("signUpPvtMsg"),
                                          preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
            alert.addAction(UIAlertAction(title: "Go to website", style: .default, handler: { (web) in
                openUrl(Config.url.kanito)
            }))
            present(alert, animated: true, completion: nil)
            return
        }
        let temp = selectedIndexPath
        selectedIndexPath = indexPath
        if temp != nil {
            self.collectionView.reloadItems(at: [temp!])
        }
        self.collectionView.reloadItems(at: [indexPath])
        
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
//        self.pageControl.currentPage = Int(self.contentOffset / self.pageWidth)
    }
    
    @IBAction func continueTapped () {
        if self.selectedIndexPath == nil {
            return
        }

        let item = dataArray[(selectedIndexPath?.row)!] as! UserTypeMenu
        UserClass.shared.user.type = item.type

        let ctrl = SignUpType.instanceFromSb(self.storyboard)
        self.navigationController?.show(ctrl, sender: self)
    }
}
