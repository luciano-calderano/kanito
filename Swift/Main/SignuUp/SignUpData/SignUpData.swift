//
//  SignUpUserCtrl
//  Kanito
//
//  Created by Luciano Calderano on 16/01/17.
//  Copyright © 2017 Kanito. All rights reserved.
//

import Foundation

enum SignUpDataRowType {
    case firstName
    case lastName
    case email
    case password
    case passConf
}

enum SignUpDataType {
    case value
    case email
    case password
}

class SignUpDataClass {
    var type = SignUpDataType.value
    var title = ""
    var value = ""
    var placeholder = ""
}

class SignUpData: MYViewController, UITableViewDelegate, UITableViewDataSource, SignUpDataCellDelegate, SignUpClassDelegate {
    class func instanceFromSb (_ sb: UIStoryboard!) -> SignUpData {
        return sb.instantiateViewController(withIdentifier: "SignUpData") as! SignUpData
    }

    @IBOutlet private var termAndCond: MYLabel!
    @IBOutlet private var loginTypeBtn: MYButton!
    @IBOutlet private var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.keyboardWillShow(notification:)),
                                               name:UIResponder.keyboardWillShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.keyboardWillHide(notification:)),
                                               name:UIResponder.keyboardWillHideNotification,
                                               object: nil)

        
        dataArray.append(self.addData(type: .value, title: "#firstName", placeholder: "#firstNameDescr"))
        dataArray.append(self.addData(type: .value, title: "#lastName", placeholder: "#lastNameDescr"))
        dataArray.append(self.addData(type: .email, title: "#email", placeholder: "#signupUserMail"))
        dataArray.append(self.addData(type: .password, title: "#password", placeholder: "#signupPassword"))
        dataArray.append(self.addData(type: .password, title: "#passConf", placeholder: "#signupPassConf"))
        
        let footerView = self.tableView.dequeueReusableCell(withIdentifier: "SignUpDataFooter")
        self.tableView.tableFooterView = footerView

    }
    
    private func addData (type: SignUpDataType, title: String, placeholder: String) -> SignUpDataClass {
        let data = SignUpDataClass()
        data.type = type
        data.title = title.tryLang()
        data.value = ""
        data.placeholder = placeholder.tryLang()
        return data
    }
    
    // MARK: table view
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
//    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
//        return 50
//    }
//    
//    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
//        return tableView.dequeueReusableCell(withIdentifier: "SignUpDataFooter")
//    }
//    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = dataArray[indexPath.row] as! SignUpDataClass
        let cell = SignUpDataCell.dequeue(tableView, indexPath)
        cell.data(item: item, row: indexPath.row, delegate: self)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK: SignUpDataCellDelegate

    func returnTapped (itenNum: Int) {
        if itenNum < dataArray.count - 1 {
            self.tableView.selectRow(at: NSIndexPath.init(row: itenNum + 1, section: 0) as IndexPath,
                                     animated: false,
                                     scrollPosition: .none)
        }
        else {
            self.view.endEditing(true)
        }
    }
    
    func activeField(textField: UITextField) {
        self.activeField = textField
        super.redesignKeyboard(textField: textField)
    }

    //MARK: button tapped
    
    @IBAction func passForgotTapped () {
        self.navigationBack()
    }

    @IBAction func loginOrSignupPressed () {
    }

    @IBAction func termCond () {
        openUrl(Config.url.kanito + "/terms.html")
    }
    @IBAction func privacy () {
        openUrl(Config.url.kanito + "/privacy.html")
    }
    
    @IBAction func singUpTapped () {
        guard self.checkData() else {
            return
        }
        let pass = dataArray[SignUpDataRowType.password.hashValue] as! SignUpDataClass
        let conf = dataArray[SignUpDataRowType.passConf.hashValue] as! SignUpDataClass

        let signUpClass = SignUpClass(delegate: self)
        signUpClass.signInMail(password: pass.value, passConf: conf.value)
    }
    
    func exitSignUpClass(withResponse response: JsonDict, success: Bool) {
        if success {
            UserClass.shared.user.id = response.string("Value")
//            UserClass.shared.saveUserWith(dict: response)
            self.gotoUserType()
        }
    }
    
    private func gotoUserType () {
        switch UserClass.shared.user.type {
        case .biz, .pro :
            self.gotoStoryboard(named: "SignUpBiz")

        default:
            self.gotoStoryboard(named: "SignUpDone")
        }
    }

    fileprivate func checkData () -> Bool {
        var item = SignUpDataClass()
        var row = 0
        
        row = SignUpDataRowType.firstName.hashValue
        item = dataArray[row] as! SignUpDataClass
        if item.value.isEmpty {
            self.selectRow (row)
            return false
        }
        UserClass.shared.user.firstname = item.value

        row = SignUpDataRowType.lastName.hashValue
        item = dataArray[row] as! SignUpDataClass
        if item.value.isEmpty {
            self.selectRow (row)
            return false
        }
        UserClass.shared.user.lastname = item.value

        row = SignUpDataRowType.email.hashValue
        item = dataArray[row] as! SignUpDataClass
        if self.validateEmail (item.value) == false {
            self.selectRow (row)
            return false
        }
        UserClass.shared.user.mail = item.value
        
        row = SignUpDataRowType.password.hashValue
        item = dataArray[row] as! SignUpDataClass
        if item.value.isEmpty {
            self.selectRow (row)
            return false
        }
        let password = item.value
        
        row = SignUpDataRowType.passConf.hashValue
        item = dataArray[row] as! SignUpDataClass
        if password != item.value {
            self.selectRow (row)
            return false
        }
        
        UserClass.shared.user.loginType = .email
        UserClass.shared.user.name = UserClass.shared.user.firstname + " " + UserClass.shared.user.lastname
        self.view.endEditing(true)
        return true
    }
    
    private func selectRow (_ row: Int) {
        self.tableView.selectRow(at: IndexPath.init(row: row, section: 0),
                                 animated: false,
                                 scrollPosition: .none)

    }
    
    fileprivate func validateEmail(_ candidate: String) -> Bool {
        let valid = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}"
        return NSPredicate(format: "SELF MATCHES %@", valid).evaluate(with: candidate)
    }
    

    var kbSize = CGSize.init(width: 0, height: 0)
    var activeField: UITextField?
    
    @objc func keyboardWillShow (notification: NSNotification) {
        let sizeValue = notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as! NSValue
        
        kbSize = sizeValue.cgRectValue.size
        let maxBottom = self.view.frame.size.height - kbSize.height
        let tblBottom = self.tableView.frame.size.height + self.tableView.frame.origin.y
        
        
        let contentInsets = UIEdgeInsets.init(top: 0.0, left: 0.0, bottom: tblBottom - maxBottom, right: 0.0)
        self.tableView.contentInset = contentInsets;
        self.tableView.scrollIndicatorInsets = contentInsets;
    }
    
    @objc func keyboardWillHide (notification: NSNotification) {
        self.tableView.contentInset = .zero
        self.tableView.scrollIndicatorInsets = self.tableView.contentInset
    }
}

