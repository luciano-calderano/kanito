//
//  MYHttp.swift
//  Lc
//
//  Created by Luciano Calderano on 07/11/16.
//  Copyright © 2016 Kanito. All rights reserved.
//

import UIKit
import Alamofire

class MYHttpRequest {    
    class func get (_ page: String) -> MYHttpRequest {
        let req = MYHttpRequest (Config.Http.url, page, .get)
        return req
    }
    
    class func post (_ page: String) -> MYHttpRequest {
        let req = MYHttpRequest (Config.Http.url, page, .post)
        return req
    }
    
    var json = JsonDict() {
        didSet {
            http.parameters = json
            http.parameters["token"] = http.token
        }
    }
    
    private struct dataHttp {
        var type: HTTPMethod!
        var page = ""
        var url = ""
        let token = Config.Http.token
        var myWheel: MYWheel?
        var parameters = JsonDict()
    }
    private var http = dataHttp()
    private let jsonResponse =  UserDefaults.init(suiteName: "Response.json")

    init(_ baseUrl: String, _ page: String, _ type: HTTPMethod) {
        http.page = page
        http.url = baseUrl + page
        http.type = type
    }
    
    // MARK: - Start
    
    func start (showWheel: Bool = true,
                silentError: Bool = false,
                completion: @escaping (Bool, JsonDict) -> () = {
        (success, response) in }) {
        startWheel(true, show: showWheel)
        self.printJson(self.json)
        let af = Alamofire.request(http.url, method: http.type, parameters: http.parameters)
        af.responseString { response in
     // af.responseJSON { (response) in
            if let dict = self.elabora(response, showWheel, silentError) {
                completion (true, dict)
            } else {
                completion (false, [:])
            }
        }
    }
    
    // MARK: - private
    
    private func elabora (_ response: DataResponse<String>, //<Any>
                          _ showWheel: Bool,
                          _ silentError: Bool) -> JsonDict? {
        startWheel(false, show: showWheel)
        if let error = response.error {
            showError(title: "Error !", message: error.localizedDescription)
            return nil
        }
        if response.result.isSuccess == false {
            showError(title: "Error !", message: "Wrong response")
            return nil
        }
        
        let dict = self.removeNullFromJsonString(response.result.value!)
        // let dict = response.value as! JsonDict
        if response.response?.statusCode != 200 {
            let msg = dict.string("msg")
            if msg.isEmpty == false  && silentError == false {
                showError(title: "", message: msg)
            }
            return nil
        }
        
        printJson(dict)
        do {
            try saveJson(dict)
        } catch {
            print("Json: è stata sollevata un'eccezione \(error) ")
        }
        return dict
    }
    
    private func removeNullFromJsonString (_ text: String) -> JsonDict {
        if text.isEmpty {
            return [:]
        }
        
        let jsonString = text.replacingOccurrences(of: ":null", with: ":\"\"")
        if let data = jsonString.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as! JsonDict
            } catch {
                print(error.localizedDescription)
            }
        }
        return [:]
    }
    
    private func saveJson (_ dict: JsonDict) throws {
        self.jsonResponse?.setValue(dict, forKey: http.page)
    }
    
    private func showError (title: String, message: String) {
        let alert = UIAlertController(title: title as String, message: message  as String, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        if let topVC = UIApplication.shared.windows[0].rootViewController {
            topVC.present(alert, animated: true, completion: nil)
        }
    }
    
    fileprivate func printJson (_ json: JsonDict) {
        if Config.Http.printJson {
            print("\n[ \(http.url) ]\n\(json)\n------------")
        }
    }
    
    fileprivate func startWheel(_ start: Bool, show: Bool = true, inView: UIView = UIApplication.shared.keyWindow!) {
        guard show else {
            return
        }
        if start {
            http.myWheel = MYWheel()
            http.myWheel?.start(inView)
        }
        else {
            http.myWheel?.stop()
            http.myWheel = nil
        }
    }
}

