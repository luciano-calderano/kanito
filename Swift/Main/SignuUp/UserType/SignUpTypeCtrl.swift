//
//  ViewController.swift
//  LGLinearFlowViewSwift
//
//  Created by Luka Gabric on 16/08/15.
//  Copyright © 2015 Luka Gabric. All rights reserved.
//

import UIKit

//class UserTypeMenu {
//    var type = UserType.None
//    var title = ""
//    var descr = ""
//    var icona: UIImage!
//    var color = UIColor.myOrange
//    
//    init(type: UserType, title: String, descr: String, iconName: String) {
//        self.type = type
//        self.title = title.tryLang()
//        self.descr = descr.tryLang()
//        self.icona = UIImage.init(named: iconName)!
//    }
//}

class SignUpTypeCtrl: MYViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewFlowLayout,  UIScrollViewDelegate {
    class func instanceFromSb (_ sb: UIStoryboard!) -> SignUpTypeCtrl {
        return sb.instantiateViewController(withIdentifier: "SignUpTypeCtrl") as! SignUpTypeCtrl
    }

    // MARK: Vars
    
    @IBOutlet fileprivate var collectionView: UICollectionView!
    
    fileprivate var animationsCount = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.dataArray = [
            UserTypeMenu.init(type: .pvt, title: "#signupTypePvt",
                              descr: "#signupTypePvtDesc", iconName: "customer"),
            UserTypeMenu.init(type: .pro, title: "#signupTypePro",
                              descr: "#signupTypeProDesc", iconName: "signUpPro"),
            UserTypeMenu.init(type: .biz, title: "#signupTypeBiz",
                              descr: "#signupTypeBizDesc", iconName: "signUpBiz"),
        ]
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.collectionView.isHidden = false
        self.navigationController?.navigationBar.isHidden = true
    }

    // MARK: Actions
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.dataArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = SignUpTypeCell.dequeue(collectionView, indexPath: indexPath)
        let item = self.dataArray[indexPath.row] as! UserTypeMenu
        cell.data(value: item)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView.isDragging || collectionView.isDecelerating || collectionView.isTracking {
            return
        }
        
        let item = self.dataArray[indexPath.row] as! UserTypeMenu
        UserClass.shared.user.type = item.type

        self.collectionView.isHidden = true
        
        switch item.type {
        case .pvt:
            let ctrl = SignUpDone.instanceFromSb(self.storyboard)
            self.navigationController?.show(ctrl, sender: self)
        default:
            let ctrl = SignUpBizData.instanceFromSb(self.storyboard)
            self.navigationController?.show(ctrl, sender: self)
        }
    }
    
    
    func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        if self.collectionView == nil {
            return proposedContentOffset
        }
        
        let collectionViewSize = self.collectionView!.bounds.size
        let proposedRect = CGRect(x: proposedContentOffset.x, y: 0, width: collectionViewSize.width, height: collectionViewSize.height)
        
        let layoutAttributes = self.layoutAttributesForElements(in: proposedRect)
        
        if layoutAttributes == nil {
            return proposedContentOffset
        }
        
        var candidateAttributes: UICollectionViewLayoutAttributes?
        let proposedContentOffsetCenterX = proposedContentOffset.x + collectionViewSize.width / 2
        
        for attributes: UICollectionViewLayoutAttributes in layoutAttributes! {
            if attributes.representedElementCategory != .cell {
                continue
            }
            
            if candidateAttributes == nil {
                candidateAttributes = attributes
                continue
            }
            
            if fabs(attributes.center.x - proposedContentOffsetCenterX) < fabs(candidateAttributes!.center.x - proposedContentOffsetCenterX) {
                candidateAttributes = attributes
            }
        }
        
        if candidateAttributes == nil {
            return proposedContentOffset
        }
        
        var newOffsetX = candidateAttributes!.center.x - self.collectionView!.bounds.size.width / 2
        
        let offset = newOffsetX - self.collectionView!.contentOffset.x
        
        if (velocity.x < 0 && offset > 0) || (velocity.x > 0 && offset < 0) {
//            let pageWidth = self.collectionView.itemSize.width + self.minimumLineSpacing
            let pageWidth:CGFloat = 10
            newOffsetX += velocity.x > 0 ? pageWidth : -pageWidth
        }
        
        return CGPoint(x: newOffsetX, y: proposedContentOffset.y)
    }

    
     func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
//        if !self.scaleItems || self.collectionView == nil {
//            return super.layoutAttributesForElements(in: rect)
//        }
//        
        let superAttributes = super.layoutAttributesForElements(in: rect)
//
//        if superAttributes == nil {
//            return nil
//        }
//        
//        let contentOffset = self.collectionView!.contentOffset
//        let size = self.collectionView!.bounds.size
//        
//        let visibleRect = CGRect(x: contentOffset.x, y: contentOffset.y, width: size.width, height: size.height)
//        let visibleCenterX = visibleRect.midX
//        
//        var newAttributesArray = Array<UICollectionViewLayoutAttributes>()
//        
        for (_, attributes) in superAttributes!.enumerated() {
            let newAttributes = attributes.copy() as! UICollectionViewLayoutAttributes
            newAttributesArray.append(newAttributes)
            let distanceFromCenter = visibleCenterX - newAttributes.center.x
            let absDistanceFromCenter = min(abs(distanceFromCenter), self.scalingOffset)
            let scale = absDistanceFromCenter * (self.minimumScaleFactor - 1) / self.scalingOffset + 1
            newAttributes.transform3D = CATransform3DScale(CATransform3DIdentity, scale, scale, 1)
        }
        
        return newAttributesArray;
    }

    
    
//    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
////        self.pageControl.currentPage = Int(self.contentOffset / self.pageWidth)
//    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
//        let pageWidth:CGFloat = 210;
//    
//        let currentOffset = scrollView.contentOffset.x;
//        var targetOffset = targetContentOffset->x;
//        var newTargetOffset = 0
//        
//        if (targetOffset > currentOffset) {
//            newTargetOffset = ceilf(currentOffset / pageWidth) * pageWidth
//        }
//        else {
//            newTargetOffset = floorf(currentOffset / pageWidth) * pageWidth
//        }
//        
//        if (newTargetOffset < 0) {
//            newTargetOffset = 0
//        }
//        else if (newTargetOffset > scrollView.contentSize.width) {
//            newTargetOffset = scrollView.contentSize.width
//        }
//        
//        targetContentOffset->x = currentOffset
//        scrollView.setContentOffset(CGPoint.init(x: 10, y: 0), animated: true)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
//        scrollView.setContentOffset(CGPoint.init(x: 10, y: 0), animated: true)
//        let index = scrollView.contentOffset.x / self.collectionView.items .itemSize.width
//        let fracPart = index.truncatingRemainder(dividingBy: 1)
//        let item = Int(fracPart >= 0.5 ? ceil(index) : floor(index))
//        
//        let indexPath = IndexPath(item: item, section: 0)
//        collectionView.scrollToItem(at: indexPath, at: .left, animated: true)
    }}
