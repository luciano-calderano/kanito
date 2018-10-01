//
//  BizCustDettCell
//  Kanito
//
//  Created by Luciano Calderano on 26/10/16.
//  Copyright © 2016 Kanito. All rights reserved.
//

import UIKit

class BizCustDettCell: UITableViewCell, UITextFieldDelegate {
    class func dequeue (_ tableView: UITableView, indexPath: IndexPath) -> BizCustDettCell {
        return tableView.dequeueReusableCell(withIdentifier: "BizCustDettCell", for: indexPath) as! BizCustDettCell
    }

    weak var delegate: MYInputClassDelegate?
    
    @IBOutlet fileprivate var titleLabel: MYLabel!
    @IBOutlet fileprivate var valueText: MYTextField!
    
    var indexPath: IndexPath!
    private var cellItem: BizCustDettClass?

    override func awakeFromNib() {
        super.awakeFromNib()
        self.valueText.addTarget(self, action: #selector(textChanged), for: .editingChanged)
        self.valueText.delegate = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        if selected {
            valueText.becomeFirstResponder()
        }
    }
    
    func data (_ data: BizCustDettClass) -> Void {
        cellItem = data
        self.titleLabel.text = data.title
        self.valueText.text = data.value
    }
    
    ////////////////////////
    
    func textChanged () {
        cellItem?.value = self.valueText.text!
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.delegate?.activeField(textField: textField)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.delegate?.returnTappedAt (indexPath: self.indexPath)
        return true
    }
}
