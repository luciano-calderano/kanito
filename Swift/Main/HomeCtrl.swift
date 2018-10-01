//
//  MainCtrl
//  Kanito
//
//  Created by Luciano Calderano on 20/12/16.
//  Copyright © 2016 Kanito. All rights reserved.
//

import UIKit

class HomeCtrl: MYViewController {
    
    @IBOutlet fileprivate var footLoginView: UIView!
    @IBOutlet fileprivate var scrollView: UIScrollView!
    @IBOutlet fileprivate var pageControl: UIPageControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.viewControllers = [ self ]
        
        scrollView.delegate = self
        pageControl.currentPage = 0
        
        dataArray = [
            TourView.Instance(page: 1),
            TourView.Instance(page: 2),
            TourView.Instance(page: 3)
        ]
        
        for view in dataArray as! [UIView] {
            scrollView.addSubview(view)
        }
        pageControl.numberOfPages = dataArray.count + 1
<<<<<<< HEAD
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
=======
>>>>>>> 27c997a30628d22b0ed0092449db4269d26446e3
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
<<<<<<< HEAD
=======
        UIApplication.shared.statusBarStyle = .lightContent
>>>>>>> 27c997a30628d22b0ed0092449db4269d26446e3
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let screenWidth = UIScreen.main.bounds.size.width
        let screenHeight = UIScreen.main.bounds.size.height
        var x = screenWidth
        scrollView.contentInset.top = 0
        
        for view in dataArray as! [UIView] {
            view.frame = CGRect.init(x: x, y: 0, width: screenWidth, height: screenHeight)
            x += screenWidth
        }
        scrollView.contentSize = CGSize.init(width:x, height: view.frame.size.height)
    }
    
    //MARK: Button tapped
    
    @IBAction func loginTapped () {
        gotoStoryboard(type: .Login)
    }
    @IBAction func signinTapped () {
        gotoStoryboard(type: .SignUp)
    }
    @IBAction func anonTapped () {
        gotoStoryboard(type: .BizHome)
        //        gotoStoryboard(.PvtHome)
    }
}

//MARK:- Scroll delegate

extension HomeCtrl: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView){
        let pageWidth = scrollView.frame.width
        let currentPage = floor((scrollView.contentOffset.x-pageWidth/2)/pageWidth)+1
        pageControl.currentPage = Int(currentPage);
    }
    
}
