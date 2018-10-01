//
//  UserClass.swift
//  Kanito
//
//  Created by Luciano Calderano on 02/11/16.
//  Copyright © 2016 Kanito. All rights reserved.
//

import Foundation

enum UserType: String {
    case None = "!"
    case pvt = "C"
    case pro = "P"
    case biz = "B"
}

enum LoginType: String {
    case None = "!"
    case email = "E"
    case facebook = "F"
    case google = "G"
}

class UserClass {
    class UserModel {
        var id = ""
        var mail = ""
        var name = ""
        var firstname = ""
        var lastname = ""
        var type = UserType.None
        var loginType = LoginType.None
    }
    static var shared = UserClass()
    var user = UserModel()
    var json = JsonDict()
    
    fileprivate let userKeyJson         = "Value"
    
    fileprivate let userKeyId           = "id_user"
    fileprivate let userKeyMail         = "email"
    fileprivate let userKeyName         = "username"
    fileprivate let userKeyFirstName    = "first_name"
    fileprivate let userKeyLastName     = "last_name"
    fileprivate let userKeyType         = "user_type"
    
    fileprivate let userConfig = UserDefaults.init(suiteName: "user.config")
    
    init() {
        self.config(dict: getUserProfile())
    }

    fileprivate func getUserProfile() -> JsonDict {
        let dict = self.userConfig?.dictionaryRepresentation()
        guard dict != nil else {
            return [:]
        }
        return dict!
    }

    private func config (dict: JsonDict) {
        guard dict[userKeyJson] != nil else {
            self.user.type = UserType.None
            return
        }
        
        self.json =             dict.dictionary(userKeyJson)
        self.user.id =          self.json.string(userKeyId)
        
        self.user.type =        UserType(rawValue: self.json.string(userKeyType))!
        self.user.name =        self.json.string(userKeyName)
        self.user.firstname =   self.json.string(userKeyFirstName)
        self.user.lastname =    self.json.string(userKeyLastName)
        self.user.mail =        self.json.string(userKeyMail)
    }

    func saveUser () { // ???
        var userDict = JsonDict()
        userDict[userKeyId] =           self.user.id
        userDict[userKeyName] =         self.user.name
        userDict[userKeyFirstName] =    self.user.firstname
        userDict[userKeyLastName] =     self.user.lastname
        userDict[userKeyMail] =         self.user.mail
        userDict[userKeyType] =         self.user.type.rawValue
        userDict[userKeyJson] =         self.json
        self.saveUserWith(dict: userDict)
    }
    
    func saveUserWith (dict: JsonDict) {
        self.config(dict: dict)
        
        self.userConfig?.setValue(self.json, forKey: userKeyJson)
    }
        
    func logout() {
        self.user = UserModel()
        CompanyClass.shared.logout()
        self.userConfig?.removeObject(forKey: userKeyJson)
    }
}
