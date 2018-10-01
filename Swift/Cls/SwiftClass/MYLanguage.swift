//
//  LanguageClass.swift
//  Lc
//
//  Created by Luciano Calderano on 09/11/16.
//  Copyright © 2016 Kanito. All rights reserved.
//

import Foundation

func Lng(_ key: String) -> String {
    return LanguageClass.shared.getValue(fromKey: key)
}

class LanguageClass {
    static var shared = LanguageClass()

    private let languages = [
        "en" : 0,
        "it" : 1
    ]
    private var dict = [String: String]()
    private var langSelected = 99
    
    func getValue (fromKey key: String) -> String {
        return self.dict[key] ?? "[ #" + key + "? ]"
    }
    
    @objc func selectLanguage() {
        let langIdFromSettings = UserDefaults.standard.string(forKey: "settings.langId") ?? ""
        if self.langSelected == self.languages[langIdFromSettings] ?? -1 {
            return
        }
        
        self.langSelected = self.languages[langIdFromSettings] ?? -1
        if self.langSelected < 0 {
            var strIso = Locale.current.identifier
            if (strIso.count < 2) {
                strIso = Bundle.main.preferredLocalizations.first!
            }
            else if (strIso.count > 2) {
                strIso = strIso.left(lenght: 2)
            }
            self.langSelected = self.languages[strIso] ?? 0
        }
        self.dict = self.loadLanguage(atIndex: self.langSelected)
    }
    
    private func loadLanguage(atIndex idx: Int) -> Dictionary<String, String> {
        let filePath = Bundle.main.path(forResource: "Lang", ofType: "txt")
        let str = try? String(contentsOfFile: filePath!, encoding: String.Encoding.utf8) as String
        let array = (str?.components(separatedBy: "\n"))! as [String]
        var dic = [String: String]()
        
        for s in array {
            let riga = s.components(separatedBy: "=")
            guard riga.count == 2 else {
                continue
            }
            let valuesArray = riga[1].components(separatedBy: "|") as [String]
            guard valuesArray.count == self.languages.count else {
                continue
            }
            dic[riga[0]] = valuesArray[idx]
        }
        return dic
    }
}


//@objc class ClsLang : NSObject { // Kanito old
//    static var langId: String {
//        get {
//            return ClsLang.getKey("id")
//        }
//    }
//    static var langCode: String {
//        get {
//            return ClsLang.getKey("code")
//        }
//    }
//    @objc class func key (_ key: String) -> String {
//        return Lng(key)
//    }
//    @objc class func getKey (_ key: String) -> String {
//        let key = "Language"
//        let dict = UserDefaults.standard.value(forKey: key) as? JsonDict
//        if dict == nil {
//            return ""
//        }
//        return dict!.string(key)
//    }
//
//    @objc class func saveLanguageList (_ array: [JsonDict]) {
//        LanguageClass.shared.selectLanguage()
//        let key = "Language"
//        UserDefaults.standard.set(array, forKey: "LanguagesArray")
//        for dict in array {
//            let langDict = dict.dictionary(key)
//            if langDict.string("iso") == LanguageConfig.currentLanguage.rawValue {
//                UserDefaults.standard.set(langDict, forKey: key)
//                break
//            }
//        }
//    }
//}
