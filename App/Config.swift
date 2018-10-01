//
//  Config.swift
//
//  Created by Luciano Calderano on 07/11/16.
//  Copyright © 2016 Kanito. All rights reserved.
//
// svn: http://94.23.198.166/svn/ios.kanito.it/ - user: kanitoIos01 - pass: K@n1t0Io6
//
// utente: k@kanito.it / kanito
//
// Fb - AppId: 446371238733467 / 7618612761ceb18b2d7c5ba6157f194c
// Apple - business@kanito.it / Bu$1ne$s01!

import UIKit

typealias JsonDict = Dictionary<String, Any>

struct Config {
    struct url {
        static let kanito = "https://www.kanito.it"
        static let companyLogo = Config.url.kanito + "/application/user_data/img/#.jpg"
    }
    struct fmt {
        static let ora     = "HH:mm"
        static let dataDB  = "yyyy-MM-dd HH:mm:ss"
        static let data    = "dd/MM/yyyy"
        static let dataOra = "dd/MM/yyyy HH:mm"
    }
    struct Http {
        static let url = "http://api.kanito.it/"
        static let token = "olihGYTYV57856-=gg"
        static let printJson = false
    }
<<<<<<< HEAD
=======

>>>>>>> 27c997a30628d22b0ed0092449db4269d26446e3
}

func openUrl(_ url: String) {
    UIApplication.shared.open(URL(string: url)!, options: [:], completionHandler: nil)
}



