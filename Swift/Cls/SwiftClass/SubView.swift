//
//  SubView.swift
//  Kanito
//
//  Created by mac on 03/04/17.
//  Copyright © 2017 Kanito. All rights reserved.
//

import Foundation

class SubView {
    var container: UIView!
    var subView: UIView!
    var edge: UIEdgeInsets = UIEdgeInsets.zero {
        didSet {
            self.t = edge.top
            self.l = edge.left
            self.b = edge.bottom
            self.r = edge.right
        }
    }
    var t:CGFloat = 0 { didSet { self.costraint (.top,      f: t) } }
    var l:CGFloat = 0 { didSet { self.costraint (.left,     f: l) } }
    var b:CGFloat = 0 { didSet { self.costraint (.bottom,   f: b) } }
    var r:CGFloat = 0 { didSet { self.costraint (.right,    f: r) } }
    var h:CGFloat = 0 { didSet { self.costraint (.height,   f: h) } }
    var w:CGFloat = 0 { didSet { self.costraint (.width,    f: w) } }
    var centerX = false { didSet { self.costraint (.centerX,f: 0) } }
    var centerY = false { didSet { self.costraint (.centerY,f: 0) } }
    
    init(container: UIView, subview: UIView, fillContainer: Bool = false) {
        self.container = container
        self.subView = subview
        container.addSubview(subview)
//        container.translatesAutoresizingMaskIntoConstraints = false
        subview.translatesAutoresizingMaskIntoConstraints = false
        if fillContainer {
            self.edge = .zero
        }
    }
    
    func costraint (_ atb: NSLayoutConstraint.Attribute, f: CGFloat) {
        self.subView.translatesAutoresizingMaskIntoConstraints = false
        let dest = (atb == .height || atb == .width) ? nil : self.container
        self.container.addConstraint (NSLayoutConstraint(item: self.subView,
                                                         attribute:   atb,
                                                         relatedBy:   .equal,
                                                         toItem:      dest,
                                                         attribute:   atb,
                                                         multiplier:  1,
                                                         constant:    f))
        self.container.layoutIfNeeded()
    }
}

