//
//  PetContainerView.swift
//  Kanito
//
//  Created by mac on 24/02/17.
//  Copyright © 2017 Kanito. All rights reserved.
//

import Foundation

class PetContainerView: UIView {
    private var defaultIcon = UIImage.init(named: "ico.grey.dog")

    func showPets (petList: [PetClass], maxIcons:Int = 1) {
        for sub in self.subviews {
            sub.removeFromSuperview()
        }
        if petList.count == 0 {
            return
        }
        self.backgroundColor = UIColor.clear

        let pet = petList[0]
        
        var rect = CGRect.init(x: 0, y: 0,
                               width: 25,
                               height: self.frame.size.height)
        let petImage = UIImageView.init(frame: rect)
        petImage.image = pet.image
        self.addSubview(petImage)
        
        if petList.count == 1 {
            let label = MYLabel()
            label.frame = CGRect.init(x: 30, y: 0,
                                      width: frame.size.width - 35,
                                      height: frame.size.height)
            label.font = UIFont.size(12, type: .Bold)
            label.textColor = UIColor.myGreyDark
            label.text = ""
            label.text = pet.name
            self.addSubview(label)
            return
        }
        
        for i in 1...(min(petList.count, maxIcons) - 1) {
            let pet = petList[i]
            rect.origin.x += rect.size.width + 10
            let img = UIImageView.init(frame: rect)
            img.image = pet.image
            self.addSubview(img)
        }
        
        if (petList.count > maxIcons) {
            rect.origin.x += rect.size.width + 10
            
            let label = UILabel.init(frame: rect)
            label.layer.cornerRadius = rect.size.width / 2
            label.layer.borderWidth = 1
            label.layer.borderColor = UIColor.myGreyMedium.cgColor
            label.font = UIFont.size(12, type: .Bold)
            label.textColor = UIColor.myGreyMedium
            label.text = "+\(petList.count - maxIcons)"
            label.textAlignment = .center
            self.addSubview(label)
        }
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
