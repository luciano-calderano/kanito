//
//  MYWheel.swift
//  Lc
//
//  Created by Luciano Calderano on 10/11/16.
//  Copyright © 2016 it.kanitoKanito. All rights reserved.
//

import UIKit

class MYWheel: UIView {
    static var backWheelImage:UIImage?
    private let activityIndicatorView = UIActivityIndicatorView()
    
    init (_ autoStart: Bool = false) {
        super.init(frame: UIScreen.main.bounds)
        initialize()
        if autoStart {
            start()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func initialize () {
        backgroundColor = UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 0.1)
        let container = UIView()
        container.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        container.center = center
        container.backgroundColor = UIColor.darkGray
        container.alpha = 0.9
        container.clipsToBounds = true
        container.layer.cornerRadius = 10
        
        activityIndicatorView.frame = CGRect(x: 0.0, y: 0.0, width: 40.0, height: 40.0)
<<<<<<< HEAD
        activityIndicatorView.style = UIActivityIndicatorView.Style.whiteLarge
=======
        activityIndicatorView.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.whiteLarge
>>>>>>> 27c997a30628d22b0ed0092449db4269d26446e3
        activityIndicatorView.center = CGPoint(x: container.frame.size.width / 2, y: container.frame.size.height / 2)
        
        container.addSubview(activityIndicatorView)
        
        addSubview(container)
    }
    
    func stop () {
        activityIndicatorView.stopAnimating()
        isHidden = true
        removeFromSuperview()
    }
    
    func start(_ uiView: UIView = UIApplication.shared.keyWindow!) -> Void {
        frame = uiView.bounds
        center = uiView.center
        uiView.addSubview(self)
        if let backImage = MYWheel.backWheelImage {
            let imageBack = UIImageView()
            imageBack.image = backImage
<<<<<<< HEAD
            imageBack.contentMode = UIView.ContentMode.scaleAspectFit
            imageBack.alpha = 0.1
            addSubview(imageBack)
            imageBack.frame = bounds
            imageBack.sendSubviewToBack(self)
=======
            imageBack.contentMode = UIViewContentMode.scaleAspectFit
            imageBack.alpha = 0.1
            addSubview(imageBack)
            imageBack.frame = bounds
            imageBack.sendSubview(toBack: self)
>>>>>>> 27c997a30628d22b0ed0092449db4269d26446e3
        }
        activityIndicatorView.startAnimating()
    }
}
