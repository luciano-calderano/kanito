
import Foundation

class PopupTableView: PopupViewController {
    class func Instance () -> PopupTableView {
        let vc = load(storyboard: .Popup) as! PopupTableView
        return vc
    }
    
    @IBOutlet private var tableView: UITableView!
    var multipleSelection = false
    private var selectedArray = [IndexPath]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.clear
        view.isOpaque = false
    }
    
    override func sendValueTodelegate() {
        var data = [Object]()
        for indexpath in selectedArray {
            data.append(dataArray[indexpath.row] as! Object)
        }
        delegate?.popupDelegate(data: data)
    }
}

// MARK:- table view

extension PopupTableView: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = PopupTableViewCell.dequeue(tableView, indexPath)
        let obj = dataArray[indexPath.row] as! Object
        
        cell.object(value: obj)
        cell.isSelected(selectedArray.contains(indexPath))
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if multipleSelection == false {
            delegate?.popupDelegate(data: [dataArray[indexPath.row]])
            navigationBack()
            return
            //            if selectedArray.count > 0 {
            //                let idx = selectedArray.first
            //                selectedArray.removeAll()
            //                tableView.reloadRows(at: [idx!], with: .fade)
            //            }
            //            selectedArray.append(indexPath)
        }
        else {
            if let index = selectedArray.index(of: indexPath) {
                selectedArray.remove(at: index)
            } else {
                selectedArray.append(indexPath)
            }
        }
        tableView.reloadRows(at: [indexPath], with: .fade)
    }
}

class PopupTableViewCell: UITableViewCell {
    class func dequeue (_ tableView: UITableView, _ indexPath: IndexPath) -> PopupTableViewCell {
        return tableView.dequeueReusableCell(withIdentifier: "PopupTableViewCell", for: indexPath)
            as! PopupTableViewCell
    }
    
    @IBOutlet fileprivate var title: MYLabel!
    @IBOutlet fileprivate var check: MYCheckView!
    
    func object (value: Object) {
        title?.text = value.name
    }
    
    func isSelected (_ sel: Bool) {
        check.isEnabled = sel
    }
}
