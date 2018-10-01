//
//  SignUpBizData
//  Kanito
//
//  Created by Luciano Calderano on 22/12/16.
//  Copyright © 2016 Kanito. All rights reserved.
//

import Foundation

class SignUpBizData: MYViewController, SignUpBizOptCtrlDelegate, UITextFieldDelegate, CitiesListDelegate {
    class func instanceFromSb (_ sb: UIStoryboard!) -> SignUpBizData {
        return sb.instantiateViewController(withIdentifier: "SignUpBizData") as! SignUpBizData
    }

    private var noType = ""
    private var typeIndex = [Int]()
    private var cityId = 0
    
    let inputClass = InputClass()
    
    @IBOutlet private var nameView: UIView!
    @IBOutlet private var typeView: UIView!
    @IBOutlet private var cityView: UIView!
    @IBOutlet private var scroll: UIScrollView!
    
    @IBOutlet private var nameText: MYTextField!
    @IBOutlet private var typeLabel: MYLabel!
    @IBOutlet private var addrText: MYTextField!
    @IBOutlet private var cityLabel: MYLabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.scroll.layer.borderColor = UIColor.hexColor("F9F9F9").cgColor
        self.scroll.layer.borderWidth = 1
        self.noType = (self.typeLabel.text?.tryLang())!
        
        self.nameText.delegate = self
        self.addrText.delegate = self
        
        typeView.isUserInteractionEnabled = true
        typeView.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(descViewTapped)))

        cityView.isUserInteractionEnabled = true
        cityView.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(cityViewTapped)))

        self.inputClass.config(scroll: self.scroll, view: self.view)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    
    @objc func descViewTapped () {
        self.view.endEditing(true)
        let ctrl = SignUpBizOptCtrl.instanceFromSb(self.storyboard)
        ctrl.delegate = self
        ctrl.type = 1
        self.navigationController?.show(ctrl, sender: self)
    }

    func returnValues (type: Int, desc: String, index: [Int]) {
        switch type {
        case 1:
            self.typeLabel.text =  desc.isEmpty ? self.noType : desc
            self.typeIndex = index
        default:
            break
        }
    }

    @objc func cityViewTapped () {
        self.view.endEditing(true)
        let ctrl = CitiesList.instanceFromSb(self.storyboard)
        ctrl.delegate = self
        self.navigationController?.show(ctrl, sender: self)
    }
    
    func exitCitiesList(id: Int, name: String) {
        self.cityLabel.text = name
        self.cityId = id
    }
    
    @IBAction func confirmTapped () {
        if (self.nameText.text?.isEmpty)! {
            self.nameText.becomeFirstResponder()
            return
        }
        if (self.addrText.text?.isEmpty)! {
            self.addrText.becomeFirstResponder()
            return
        }
        if self.typeIndex.count == 0 {
            self.descViewTapped()
            return
        }
        if self.cityId == 0 {
            self.cityViewTapped()
            return
        }

        
        let request = MYHttpRequest.post("user/sign-in/company-add")
        request.json = [
            "userId":           UserClass.shared.user.id,
            "companyName":      self.nameText.text!,
            "activityType":     self.typeIndex,
            "cityId":           self.cityId,
            "address":          self.addrText.text!
        ]

        request.start() { (success, response) in
            if success {
//                UserClass.shared.user.idBiz = response.string("Value")
                self.gotoStoryboard(named: "SignUpDone")
            }
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.redesignKeyboard(textField: textField, okButton: false)
        self.inputClass.inputTextField(textField)
    }

    override func cancelPressedOnKeyboard() {
        super.cancelPressedOnKeyboard()
        self.scroll.contentOffset = .zero
        self.view.endEditing(true)
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
