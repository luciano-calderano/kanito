//
//  BookingEditView
//  Kanito
//
//  Created by Luciano Calderano on 16/02/17.
//  Copyright © 2017 Kanito. All rights reserved.
//

import Foundation

protocol BookingEditSubViewDelegate {
    func viewTapped (type: BookingData.Enum)
}

class BookingEditContainer: UIView, BookingEditSubViewDelegate {
    @IBInspectable var title:String = "" {
        didSet {
            self.subView.title.text = title.tryLang()
        }
    }
    var id = ""

    var delegate: BookingEditSubViewDelegate?
    var type:BookingData.Enum = BookingData.Enum.none
    var value:String = "" {
        didSet {
            self.subView.subtitle.text = value
            
            if value.isEmpty {
                self.subView.subtitle.textColor = UIColor.myGreyMedium
                self.subView.subtitle.text = Lng("booking." + self.type.rawValue)
            }
            else {
                self.subView.subtitle.textColor = UIColor.black
                self.subView.subtitle.text = value
            }
        }
    }
    let subView = BookingEditSubView.Instance()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.addSubviewWithConstraints(self.subView)
        self.subView.delegate = self
    }
    
    func viewTapped (type: BookingData.Enum) {
        self.delegate?.viewTapped(type: self.type)
    }
}

/**********************************/

class BookingEditSubView: UIView {
    class func Instance() -> BookingEditSubView {
        let id = String (describing: self)
        return Bundle.main.loadNibNamed(id, owner: self, options: nil)?.first as! BookingEditSubView
    }

    @IBOutlet var title: MYLabel!
    @IBOutlet var subtitle: MYLabel!

    var delegate: BookingEditSubViewDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.addGestureRecognizer(UITapGestureRecognizer.init(target: self,
                                                              action: #selector (viewTapped)))
        
        let line = UIView()
        line.backgroundColor = UIColor.myGreyLight
        self.addSubview(line)
        self.costraintTo(view: line, atb: .bottom, f: 0)
        self.costraintTo(view: line, atb: .right, f: -20)
        self.costraintTo(view: line, atb: .left, f: 20)
        self.costraintTo(view: line, atb: .height, f: 1)
    }
    
    @objc func viewTapped () {
        self.delegate?.viewTapped(type: BookingData.Enum.none)
    }
}

/**********************************/

protocol BookingEditViewDelegate {
    func viewTapped (type: BookingData.Enum)
    func bookingEditViewDelegate(view: BookingEditView, title: String)
    func bookingEditViewDelegate(view: BookingEditView, rect: CGRect)
}

class BookingEditView: UIView, BookingEditSubViewDelegate, UITextFieldDelegate, UITextViewDelegate {
    class func Instance() -> BookingEditView {
        let id = String (describing: self)
        return Bundle.main.loadNibNamed(id, owner: self, options: nil)?.first as! BookingEditView
    }

    var delegate: BookingEditViewDelegate?
    var isPending: Int { get { return self.pendingSwitch.isOn ? 1 : 0 } }

    @IBOutlet var deleteButton: MYButton!

    @IBOutlet private var title: UITextField!
    @IBOutlet private var titleView: UIView!

    @IBOutlet private var petView: BookingEditContainer!
    @IBOutlet private var dateView: BookingEditContainer!
    @IBOutlet private var activityView: BookingEditContainer!
    @IBOutlet private var timeView: BookingEditContainer!
    @IBOutlet private var timeStart: MYLabel!
    @IBOutlet private var timeEnd: MYLabel!
    
    @IBOutlet private var pendingSwitch: UISwitch!
    @IBOutlet private var note: UITextView!

    override func awakeFromNib() {
        super.awakeFromNib()
        self.title.delegate = self

        self.setSubview(self.petView,       type: .pet)
        self.setSubview(self.dateView,      type: .date)
        self.setSubview(self.activityView,  type: .activity)

        self.timeView.addGestureRecognizer(UITapGestureRecognizer.init(target: self,
                                                                   action: #selector(timeViewTapped)))

        self.note.layer.borderColor = UIColor.myGreyMedium.cgColor
        self.note.layer.borderWidth = 1
        self.note.delegate = self
        self.backgroundColor = UIColor.white
        self.addBottomLine(to: self.timeView)
        self.addBottomLine(to: self.titleView)

    }
    private func addBottomLine (to view: UIView) {
        let line = UIView()
        line.backgroundColor = UIColor.myGreyLight
        view.addSubview(line)
        view.costraintTo(view: line, atb: .bottom, f: 0)
        view.costraintTo(view: line, atb: .right, f: -20)
        view.costraintTo(view: line, atb: .left, f: 20)
        view.costraintTo(view: line, atb: .height, f: 1)
    }
    
    private func setSubview (_ container: BookingEditContainer,
                             type: BookingData.Enum) {
        container.type = type
        container.delegate = self
    }

    @objc func timeViewTapped () {
        self.viewTapped(type: .startTime)
    }
    func viewTapped (type: BookingData.Enum) {
        self.delegate?.viewTapped(type: type)
    }
    
    func updateWith (value newValue: BookingData.Values) {
        if newValue.id.isEmpty {
            self.deleteButton.isHidden = true
        }
        self.title.text = newValue.title
        self.dateView.value = newValue.startTime.toString(withFormat: Config.fmt.data)
        
        self.timeStart.text = newValue.startTime.toString(withFormat: Config.fmt.ora)
        self.timeEnd.text = newValue.endTime.toString(withFormat: Config.fmt.ora)

        self.activityView.id = newValue.activity.id
        self.activityView.value = newValue.activity.name
        self.petView.id = newValue.pet.id
        self.petView.value = newValue.pet.name

        self.pendingSwitch.setOn(newValue.isPending == 1, animated: true)
        self.note.text = newValue.note
    }

    @IBAction func deleteBooking () {
        self.viewTapped(type: .delete)
    }

    @IBAction func titleChanged () {
        self.delegate?.bookingEditViewDelegate(view: self, title: self.title.text!)
    }

    //MARK: textField Delegate

    func textFieldDidBeginEditing(_ textField: UITextField) {
        let p = textField.convert(CGPoint(x: 0, y: 0), to: self)
        let rect = CGRect.init(origin: p, size: textField.frame.size)
        self.delegate?.bookingEditViewDelegate(view: self, rect: rect)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        let p = textView.convert(CGPoint(x: 0, y: 0), to: self)
        let rect = CGRect.init(origin: p, size: textView.frame.size)
        self.delegate?.bookingEditViewDelegate(view: self, rect: rect)
        return
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n") {
            textView.resignFirstResponder()
            return false
        }
        return true
    }

}
