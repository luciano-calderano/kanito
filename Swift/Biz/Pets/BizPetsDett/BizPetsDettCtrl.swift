//
//  BizPetsDettCtrl
//  Kanito
//
//  Created by Luciano Calderano on 13/12/16.
//  Copyright © 2016 Kanito. All rights reserved.
//

import UIKit

class BizPetsDettCtrl : MYViewController, UITableViewDelegate, UITableViewDataSource {
    class func Instance (petClass: PetClass) -> BizPetsDettCtrl {
        let vc = self.load(storyboard: .BizPets) as! BizPetsDettCtrl
        vc.petClass = petClass
        return vc
    }

    @IBOutlet fileprivate var tableView: UITableView!

    var petClass: PetClass!

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.backgroundColor = UIColor.white
        let headerView = BizPetsDettHeader.dequeue(tableView)
        headerView.data(self.petClass)
        self.tableView.tableHeaderView = headerView

        self.loadData()
    }
    
    override func headerViewDxTapped() {
        let ctrl = BizPetsEditCtrl.Instance()
        ctrl.petClass = self.petClass
        self.navigationController?.show(ctrl, sender: self)
    }
    
    func loadData() {
        let new: (String, String) -> (PetItems.EditField) = { (title, value) in
            let item = PetItems.EditField()
            item.title = Lng(title)
            item.value = value
            return item
        }

        dataArray.append(new ("owner",     self.petClass.customer.name))
        dataArray.append(new ("petBreed",  self.petClass.breed.name))
        dataArray.append(new ("petAge",    self.petClass.age.name))
        dataArray.append(new ("petSize",   self.petClass.size.name))
        dataArray.append(new ("petGender", self.petClass.gender.name))
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
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = BizPetsDettCell.dequeue(tableView: tableView, indexPath: indexPath)
        cell.data (dataArray[indexPath.row] as! PetItems.EditField)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
    
}
