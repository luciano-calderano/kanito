//
//  UIMessageClass.swift
//  Kanito
//
//  Created by Luciano Calderano on 15/12/16.
//  Copyright © 2016 Kanito. All rights reserved.
//

import UIKit
import MessageUI

class UIMessageClass: UIViewController, MFMessageComposeViewControllerDelegate, MFMailComposeViewControllerDelegate {
    static var mainCtrl = UIApplication.shared.keyWindow?.rootViewController
    class func setMainViewController (_ mainViewCtrl: UIViewController) {
        UIMessageClass().setMainViewController(mainViewCtrl)
    }
    class func sendSMS (_ to: String) {
        UIMessageClass().sendSMS(to)
    }
    class func openCall (_ to: String) {
        UIMessageClass().openCall(to)
    }
    class func openVideoCall (_ to: String) {
        UIMessageClass().openVideoCall(to)
    }
    class func sendEmail (_ to: String) {
        UIMessageClass().sendEmail(to)
    }
    
    fileprivate func setMainViewController (_ mainViewCtrl: UIViewController) {
        UIMessageClass.mainCtrl = mainViewCtrl
    }
    fileprivate func sendSMS (_ to: String) {
        if (MFMessageComposeViewController.canSendText()) {
            let controller = MFMessageComposeViewController()
            controller.body = ""
            controller.recipients = [to]
            controller.messageComposeDelegate = self
            UIMessageClass.mainCtrl?.present(controller, animated: true, completion: nil)
        }
    }
    
    fileprivate func openCall (_ to: String) {
        openUrl("telprompt://" + to)
    }
    fileprivate func openVideoCall (_ to: String) {
        openUrl("facetime://" + to)
    }
    fileprivate func sendEmail (_ to: String) {
        if !MFMailComposeViewController.canSendMail() {
            UIMessageClass.mainCtrl?.alert("", message: "Mail services are not available", okBlock: nil)
            return
        }

        let controller = MFMailComposeViewController()
        controller.mailComposeDelegate = self
        
        controller.setSubject("")
        controller.setToRecipients([to])
        controller.setMessageBody("", isHTML: false)
        
        UIMessageClass.mainCtrl?.present(controller, animated: true, completion: nil)
    }
    
    // MARK: - Delegate
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        var response = ""
        switch result {
        case .cancelled:
            response = "Message cancelled"
        case .failed:
            response = "Message failed"
        case .sent:
            response = "Message sent"
        }
        print(response)
        UIMessageClass.mainCtrl?.alert(response, message: "", okBlock: nil)
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        var response = ""
        switch result {
        case .cancelled:
            response = "Message cancelled"
        case .failed:
            response = "Message failed"
        case .sent:
            response = "Message sent"
        default:
            response = "Message error: " + (error?.localizedDescription)!
        }
        print(response)
        UIMessageClass.mainCtrl?.alert(response, message: "", okBlock: nil)
    }
    
}
