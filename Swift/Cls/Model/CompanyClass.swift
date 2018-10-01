//
//  CompanyClass.swift
//  Kanito
//
//  Created by mac on 01/03/17.
//  Copyright © 2017 Kanito. All rights reserved.
//

import Foundation
import SDWebImage

class CompanyClass {
    struct Model {
        var id = ""
        var name = ""
//        var activities = ""
        var activities = [JsonDict]()
        var logo = UIImage.init(named: "ico.grey.customer")
    }
    static var shared = CompanyClass()
    var value = Model()
    
    fileprivate let keyJson     = "Value"
    fileprivate let keyAct      = "Activ"
    fileprivate let fileConfig  = UserDefaults.init(suiteName: "company.config")
    fileprivate var json        = JsonDict()
    fileprivate let logo = Config.url.kanito + "/application/assets/img/placeholder/placeHolder-business.jpeg"
    
    init() {
        self.config(dict: getProfile())
    }
    
    fileprivate func getProfile() -> JsonDict {
        let dict = self.fileConfig?.dictionaryRepresentation()
        guard dict != nil else {
            return [:]
        }
        return dict!
    }
    
    private func config (dict: JsonDict) {
        guard dict[keyJson] != nil else {
            return
        }
        
        self.json = dict.dictionary(keyJson)
        self.value.id = self.json.string("id_company")
        self.value.name = self.json.string("business_name")
        
        let logoUrl = self.json.string("companyThumb")
        var urlString = ""
        if logoUrl.isEmpty {
            urlString = self.logo
        }
        else {
            urlString = Config.url.companyLogo.replacingOccurrences(of: "#", with: logoUrl + "_s")
        }
        let url = URL.init(string: urlString)
        
        let sd = SDWebImageManager()
        sd.downloadImage(with: url, options: .lowPriority, progress: nil) {
            (image, error, type, response, url) in
            if error == nil {
                self.value.logo = image
            }
        }
        
//        let img = UIImageView()
//        
//        img.sd_setImage(with: url)
//        self.value.logo = img.image
//
//        self.getDataFromUrl(url: url!) { (data, response, error)  in
//            guard let data = data, error == nil else { return }
//            DispatchQueue.main.async() { () -> Void in
//                do {
//                    try data.write(to: logoFile!)
//                }
//                catch {
//                }
//                self.value.logo = UIImage(data: data)!
//            }
//        }
        
//        self.value.activities = ""
//        let act = self.fileConfig?.string(forKey: keyAct)
//        if act != nil && (act?.isEmpty)! {
//            self.value.activities = act!
//            return
//        }

        let act = self.fileConfig?.array(forKey: keyAct)
        if act != nil && (act?.count)! > 0 {
            self.value.activities = act! as! [JsonDict]
            return
        }

        let request = MYHttpRequest.get("company/get/activities")
        request.json = [
            "companyId" : self.value.id
        ]
//        self.value.activities = ""
        request.start(showWheel: false) { (success, response) in
            if success {
                self.value.activities = response.array("Value") as! [JsonDict]

//                for dict in response.array("Value") as! [JsonDict] {
//                    let act = Activities.shared.getActivity(id: dict.string("id_activity"))
//                    self.value.activities += act.name + " "
//                }
                self.fileConfig?.setValue(self.value.activities, forKey: self.keyAct)
            }
        }
    }
    
//   private func getDataFromUrl(url: URL, completion: @escaping (_ data: Data?, _  response: URLResponse?, _ error: Error?) -> Void) {
//        URLSession.shared.dataTask(with: url) {
//            (data, response, error) in
//            completion(data, response, error)
//            }.resume()
//    }
    
    func logout () {
        let fileManager = FileManager.default
        do {
            try fileManager.removeItem(atPath: NSTemporaryDirectory() + self.value.id)
        }
        catch {
        }
        self.value = Model()
        self.saveWith(dict: [:])
    }
    
    func saveWith (dict: JsonDict) {
        self.config(dict: dict)
        self.fileConfig?.setValue(self.json, forKey: keyJson)
    }
}
/*
 address = "Via Roma 1";
 "business_name" = TestKanito;
 "company_name" = "";
 cover = "";
 description = "";
 email = "";
 "id_city" = 1;
 "id_company" = 57;
 "id_country" = "";
 "id_user" = 132;
 "instant_pay" = 0;
 "is_deleted" = 0;
 "is_homeService" = 0;
 "is_mobileService" = 0;
 lat = "";
 lon = "";
 "old_city" = 0;
 "old_country" = 0;
 "old_user_company_id" = 0;
 "old_user_id" = 0;
 "pay_method" = 0;
 "pet_type" = D;
 "phone_number" = "";
 slogan = "";
 "tax_code" = "";
 thumb = "";
 "time_creation" = "2017-02-28 18:34:35";
 "time_delete" = "";
 "time_last_update" = "";
 "time_type" = "";
 "vanity_url" = testkanito;
 vat = "";
 video = "";
 "web_site" = "";
 "zip_code" = "";

 */
