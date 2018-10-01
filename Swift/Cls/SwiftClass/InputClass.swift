//
//  InputClass.swift
//  Kanito
//
//  Created by Luciano Calderano on 06/02/17.
//  Copyright © 2017 Kanito. All rights reserved.
//

import Foundation

class InputClass: NSObject {
    private var kbHeight:CGFloat = 0
    private var topOffset:CGFloat = 0
    private var scroll: UIScrollView!
    private var tableView: UITableView!
    private var view: UIView!
    private var type = 0
    
    func config(scroll: UIScrollView, view: UIView) {
        self.scroll = scroll
        self.view = view
        self.type = 1
        self.addKeybNotification()
    }

    func config(tableView: UITableView, view: UIView) {
        self.tableView = tableView
        self.view = view
        self.type = 2
        self.addKeybNotification()
    }
    
    private func addKeybNotification () {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.keyboardWillShow(notification:)),
                                               name:UIResponder.keyboardWillShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.keyboardWillHide(notification:)),
                                               name:UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func keyboardWillShow (notification: NSNotification) {
        let sizeValue = notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as! NSValue
        self.kbHeight = sizeValue.cgRectValue.size.height
        self.refresh()
    }
    @objc func keyboardWillHide (notification: NSNotification) {
        self.reset()
    }
    
    func inputTextField ( _ textField: UITextField) {
        let absolutePoint = textField.convert(CGPoint(x: 0, y: 0), to: self.view)
        self.topOffset = absolutePoint.y + textField.frame.size.height + 5
        self.refresh()
    }
    func inputTextView ( _ inputView: UIView, onView: UIView) {
        let absolutePoint = inputView.convert(CGPoint(x: 0, y: 0), to: onView)
        self.topOffset = absolutePoint.y + inputView.frame.size.height + 5
        self.refresh()
    }
    
    func refresh () {
        let visibleFrameHeight = self.view.frame.size.height - self.kbHeight
        
//        var rect = self.view.frame
//        rect.size.height = visibleFrameHeight
//        self.tableView.scrollRectToVisible(rect, animated: true)
    
        UIView.animate(withDuration: 0.2) {
            if self.type == 1 {
                let y = self.topOffset - visibleFrameHeight
                self.scroll.contentOffset = CGPoint.init(x: 0, y: y > 0 ? y : 0)
            }
            if self.type == 2 {
                let tblBottom = self.tableView.frame.size.height + self.tableView.frame.origin.y
                
                self.tableView.contentInset = UIEdgeInsets.init(top: 0.0, left: 0.0, bottom: tblBottom - visibleFrameHeight, right: 0.0)
                self.tableView.scrollIndicatorInsets = self.tableView.contentInset

            }
        }
    }
    
    func reset () {
        UIView.animate(withDuration: 0.2) {
            if self.type == 1 {
                self.scroll.contentOffset = CGPoint.init(x: 0, y: 0)
            }
            if self.type == 2 {
                self.tableView.contentInset = UIEdgeInsets.init(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
                self.tableView.scrollIndicatorInsets = self.tableView.contentInset
            }
        }
    }
}
