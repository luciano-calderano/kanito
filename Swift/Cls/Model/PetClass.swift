//
//  PetClass.swift
//  Kanito
//
//  Created by Luciano Calderano on 03/02/17.
//  Copyright © 2017 Kanito. All rights reserved.
//

import Foundation
import SDWebImage

enum PetType: String {
    case all = "A"
    case dog = "D"
    case cat = "C"
}

class PetClass: NSObject {
    var idPet = ""
    var idBusiness = ""
    var idCustomerPet = ""
    
    var name    = ""
    var type    = Pet_SubClass.init(type: .petType)
    var breed   = Pet_SubClass.init(type: .breed)
    var age     = Pet_SubClass.init(type: .age)
    var size    = Pet_SubClass.init(type: .size)
    var gender  = Pet_SubClass.init(type: .gender)
    var image   = UIImage.init(named: "ico.grey.dog")
    
    var customer: CustomerClass!
    
    enum Pet_SubClassType: String {
        case petType
        case name
        case owner
        case breed
        case age
        case size
        case gender
        case none
    }
    
    class Pet_SubClass {
        var id = ""
        var name = ""
        var subClassType = Pet_SubClassType.none
        
        init(type: Pet_SubClassType) {
            self.subClassType = type
        }
    }
}


class Pets {
    static let shared = Pets()
    
    private let petConfig = UserDefaults.init(suiteName: "pets.config")
    private var petDict = [String: PetClass]()

    private func getFirst (type: PetClass.Pet_SubClassType) -> PetClass.Pet_SubClass {
        let item = PetItems.getKeys(type: type)
        let dict = PetCachedClass.shared.getList(type: type).first!
        let obj = PetClass.Pet_SubClass.init(type: type)
        obj.id = dict.string(item.id)
        obj.name = dict.string(item.name)
        return obj
    }
    
    func getNew () -> PetClass {
        let pet = PetClass()
        pet.gender = self.getFirst(type: .gender)
        pet.type = self.getFirst(type: .petType)
        pet.breed = self.getFirst(type: .breed)
        pet.age = self.getFirst(type: .age)
        pet.size = self.getFirst(type: .size)
        return pet
    }
    
    func getListForCustomer (idUser: String, completion: @escaping ([PetClass]) -> () = {
        (petArray) in }) {
        
        let request = MYHttpRequest.get("company/customer/pets")
        request.json = [
            "companyId" : CompanyClass.shared.value.id,
            "userId"    : idUser,
            "limit"     : 0,
            "offset"    : 100
        ]
        request.start() { (success, response) in
            if success {
                var array = [PetClass]()
                for dict in response.array("Value.itemList") as! [JsonDict] {
                    array.append(self.convert(with: dict))
                }
                completion (array)
            }
        }
    }
    
    func getList (pageNum: Int, maxItem: Int, search: String = "",
                  completion: @escaping ([PetClass]) -> () = {
        (petArray) in }) {
            let page = search.isEmpty ? "list" : "search-by-name"
            let request = MYHttpRequest.get("company/pet/" + page)
            request.json = [
                "companyId" : CompanyClass.shared.value.id,
                "limit"     : maxItem,
                "offset"    : pageNum
            ]
            
            if search.isEmpty == false {
                request.json["name"] = search
            }
            
            request.start() { (success, response) in
                if success {
                    var array = [PetClass]()
                    for dict in response.array("Value.itemList") as! [JsonDict] {
                        array.append(self.convert(with: dict))
                    }
                    completion (array)
                }
            }
    }
    
    func getPet (id: String, completion: @escaping (PetClass) -> () = {
        (pet) in }) {
        let pet = self.petDict[id]
        guard pet == nil else {
            completion (pet!)
            return
        }
        
        self.getFromComfig(id: id) { (pet) in
            guard pet.idCustomerPet == id else {
                self.getFromWeb(id: id, completion: { (pet) in
                    self.petDict[id] = pet
                    completion(pet)
                })
                return
            }
            self.petDict[id] = pet
            completion (pet)
        }
    }
    
    // MARK: private
    
    private func getFromComfig (id: String, completion: @escaping (PetClass) -> () = { (pet) in }) {
        let dict = self.petConfig?.dictionary(forKey: id)
        guard dict == nil else {
            completion (self.convert(with: dict!))
            return
        }
        completion(Pets.shared.getNew())
    }
    
    private func getFromWeb (id: String, completion: @escaping (PetClass) -> () = { (pet) in }) {
        let request = MYHttpRequest.get("company/pet/get")
        request.json = [
            "customerPetId" : id,
        ]
        request.start(showWheel: false, silentError: true) { (success, response) in
            if success {
                let pet = self.convert(with: response.dictionary("Value"))
                completion(pet)
            }
            else {
                let pet = PetClass()
                pet.idPet = id
                pet.name = "Unknown: id. \(id)"
                completion(pet)
            }
        }
    }
    
    private func convert (with dict: JsonDict) -> PetClass {
        let petClass = PetClass()
        petClass.idPet              = dict.string("id_pet")
        petClass.idBusiness         = dict.string("id_business")
        petClass.idCustomerPet      = dict.string("id_customer_pet")

        petClass.name               = dict.string("name")
        petClass.type.id            = dict.string("pet_type")
        petClass.type.name          = self.getValue(for: petClass.type.id, type: .petType)
        petClass.breed.id           = dict.string("id_breed")
        petClass.breed.name         = self.getValue(for: petClass.breed.id, type: .breed)
        petClass.age.id             = dict.string("id_age")
        petClass.age.name           = self.getValue(for: petClass.age.id, type: .age)
        petClass.size.id            = dict.string("id_size")
        petClass.size.name          = self.getValue(for: petClass.size.id, type: .size)
        petClass.gender.id          = dict.string("gender")
        petClass.gender.name        = self.getValue(for: petClass.gender.id, type: .gender)
        
        petClass.customer           = CustomerClass()
        petClass.customer.idUser    = dict.string("id_user")
        petClass.customer.idCustomer = dict.string("id_customer")
        
//        let sd = SDWebImageManager()
//        let url = URL.init(string: dict.string("thumb"))
//        sd.downloadImage(with: url, options: .lowPriority, progress: nil) {
//            (image, error, type, response, url) in
//            if error == nil {
//                petClass.image = image
//            }
//        }
        self.petConfig?.setValue(dict, forKey: petClass.idCustomerPet)
        return petClass
    }
    
    func getValue (for key:String, type: PetClass.Pet_SubClassType) -> String {
        return PetCachedClass.shared.getValue(for: key, type: type)
    }
}

/////////////////////////////

class PetItems {
    class func getKeys (type: PetClass.Pet_SubClassType) -> (id: String, name: String) {
        switch type {
        case .age:
            return ("id_age", "name")
        case .size:
            return ("id_size", "name")
        case .petType:
            return ("id", "name")
        case .breed:
            return ("id_breed", "breed_name")
        case .gender:
            return ("id", "name")
        default:
            return ("", "")
        }
    }
    
    var array = [EditField]()
    
    func getId (type: PetClass.Pet_SubClassType) -> String {
        let item = self.array[type.hashValue]
        return item.id
    }
    func getValue (type: PetClass.Pet_SubClassType) -> String {
        let item = self.array[type.hashValue]
        return item.value
    }
    func getItem (type: PetClass.Pet_SubClassType) -> PetItems.EditField {
        return self.array[type.hashValue]
    }
    func saveItem (type: PetClass.Pet_SubClassType, item: PetItems.EditField) {
        self.array[type.hashValue] = item
    }
    
    func updateItem (type: PetClass.Pet_SubClassType, id: String, value: String) {
        let item = self.array[type.hashValue]
        item.id = id
        item.value = value
        item.index = PetCachedClass.shared.getIndex(for: item.id, type: item.subClassType)
        self.array[type.hashValue] = item
    }
    
    //MARK: EditField
    
    class EditField {
        var id = ""
        var title = ""
        var value = ""
        var index = 0
        var subClassType = PetClass.Pet_SubClassType.none
        var array = [JsonDict]()
        var keys = (id: "", name: "")
        
        func getItem (at row: Int) -> (id: String, value: String) {
            let dict = self.array[row]
            return (dict.string(self.keys.id), dict.string(self.keys.name))
        }
        
        init() {
        }
        
        init(type: PetClass.Pet_SubClassType, editMode: Bool = false) {
            self.subClassType = type
            if editMode {
                self.keys = PetItems.getKeys(type: type)
                self.array = PetCachedClass.shared.getList(type: type)
            }
        }
    }
}

/////////////////////

class PetCachedClass {
    static let shared = PetCachedClass()
    let petsDefault = UserDefaults.init(suiteName: "pets.default")
    let keyDate = "cache.date"

    func checkCache (forceClear: Bool = false) {
        _ = PetsCache.init(clear: forceClear)
    }
    
    func getValue (for key:String, type: PetClass.Pet_SubClassType) -> String {
        let page = type.rawValue
        let dict = self.petsDefault?.dictionary(forKey: "key." + page)
        let data = dict?.dictionary(key)
        return data?.string("name") ?? "key: " + key + "?"
    }
    
    func getList (type: PetClass.Pet_SubClassType) -> [JsonDict] {
        let array = self.petsDefault?.array(forKey: type.rawValue) ?? [JsonDict]()
        return array as! [JsonDict]
    }
    
    func getIndex (for key:String, type: PetClass.Pet_SubClassType) -> Int {
        if key.isEmpty {
            return 0
        }
        let dict = self.petsDefault?.dictionary(forKey: "key." + type.rawValue)
        let data = dict?.dictionary(key)
        let index = data?.int("index")
        return index ?? 0
    }
    
    func getCacheDate () -> Date {
        var s = self.petsDefault?.value(forKey: keyDate) as? String
        if s == nil {
            s = Date.init(timeIntervalSince1970: 0).toString(withFormat:  Config.fmt.data)
        }
        return s!.toDate(withFormat: Config.fmt.data)!
    }
    func saveCacheDate () {
        self.petsDefault?.set(Date().toString(withFormat: Config.fmt.data), forKey: keyDate)
    }
    
    func saveList (type: PetClass.Pet_SubClassType, array: [JsonDict]) {
        let page = type.rawValue
        self.petsDefault?.set (array, forKey: page)
        
        let keyDict = PetItems.getKeys(type: type)
        var item = [String: JsonDict]()
        for i in 0...array.count - 1 {
            let dict = array[i]
            item[dict.string(keyDict.id)] =  [
                "index" : i,
                "name"  : dict.string(keyDict.name)
            ]
        }
        self.petsDefault?.set (item, forKey: "key." + page)
    }
    
    //MARK: Pets cache
    
    class PetsCache {
        init(clear: Bool = false) {
            if clear || checkLastDate(PetCachedClass.shared.getCacheDate()) == false {
                createList(type: .breed)
                createList(type: .age)
                createList(type: .size)
                createList(type: .petType)
                createList(type: .gender)
                PetCachedClass.shared.saveCacheDate()
            }
        }
        
        func checkLastDate(_ date: Date) -> Bool {
            let diff = Calendar.current.dateComponents([.day], from: date, to: Date()).day
            return diff! < 30
        }
        
        func createList (type: PetClass.Pet_SubClassType) {
            var page = ""
            switch type {
            case .petType:
                let array = [
                    ["id": "D", "name": Lng("dog")],
                    ["id": "C", "name": Lng("cat")],
                    //                ["id": "A", "name": Lng("all")]
                ]
                PetCachedClass.shared.saveList(type: type, array: array)
                return
            case .age:
                page = "tools/ages"
            case .breed:
                page = "tools/breeds"
            case .size:
                page = "tools/sizes"
            case .gender:
                let array = [
                    ["id": "M", "name": Lng("male")],
                    ["id": "F", "name": Lng("female")]
                ]
                PetCachedClass.shared.saveList(type: type, array: array)
                return
            default:
                return
            }
            let request =  MYHttpRequest.get(page)
            request.start(showWheel: false) { (success, response) in
                if success {
                    let array = response.array("Value") as! [JsonDict]
                    PetCachedClass.shared.saveList(type: type, array: array)
                }
            }
        }
    }
}

