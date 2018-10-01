//
//  SignUpBizOptCtrl
//  Kanito
//
//  Created by Luciano Calderano on 13/12/16.
//  Copyright © 2016 Kanito. All rights reserved.
//

import UIKit

protocol CitiesListDelegate : class {
    func exitCitiesList (id: Int, name: String)
}


class CitiesList : MYViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate{
    class func instanceFromSb (_ sb: UIStoryboard!) -> CitiesList {
        return sb.instantiateViewController(withIdentifier: "CitiesList") as! CitiesList
    }

    weak var delegate: CitiesListDelegate?
    
    private var fullArray = [JsonDict]()
    @IBOutlet fileprivate var tableView: UITableView!
    @IBOutlet fileprivate var searchText: UITextField!
    
    private var isCity = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.searchText.delegate = self
        self.loadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    
    func loadData(countryCode: String = "") {
        let page = isCity ? "tools/cities" : "tools/countries"
        let request = MYHttpRequest.get(page)
        if countryCode.isEmpty == false {
            request.json = [
                "countryCode" : countryCode
            ]
        }
        
        request.start() { (success, response) in
            if success {
                self.httpResponse(response)
            }
        }
    }
    
    fileprivate func httpResponse(_ resultDict: JsonDict) {
        self.fullArray.removeAll()
        self.searchText.text = ""
        
        self.fullArray = resultDict.array("Value") as! [JsonDict]
        if isCity == false {
            for code in ["IT", "US"] {
                let namePredicate = NSPredicate(format: "code = %@",  code);
                let filteredArray = self.fullArray.filter { namePredicate.evaluate(with: $0) }
                if filteredArray.count > 0 {
                    let value = filteredArray[0] as JsonDict
                    self.fullArray.insert(value, at: 0)
                }
            }
        }
        
        dataArray = self.fullArray
        self.tableView.reloadData()
    }
    
    // MARK: table view
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CitiesListCell", for: indexPath)
        let dict = dataArray[indexPath.row] as! JsonDict
        cell.textLabel?.text = dict.string("name")
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let dict = dataArray[indexPath.row] as! JsonDict

        if (isCity) {
            self.delegate?.exitCitiesList(id: dict.int("id_city"), name: dict.string("name"))
            _ = self.navigationController?.popViewController(animated: true)
        }
        else {
            self.isCity = true
            self.loadData(countryCode: dict.string("code"))
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.redesignKeyboard(textField: textField)
    }
    
    @IBAction func textChanged (textField: UITextField) {
        if (textField.text?.isEmpty)! {
            dataArray = self.fullArray
        }
        else {
            let predicate = NSPredicate.init(format: "%K contains[cd] %@", "name", textField.text!)
            dataArray = self.fullArray.filter { predicate.evaluate(with: $0) }
        }
        self.tableView.reloadData()
    }
}
