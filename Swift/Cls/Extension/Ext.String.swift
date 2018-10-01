//
//  JsonDictExtension.swift
//  Lc
//
//  Created by Luciano Calderano on 26/10/16.
//  Copyright © 2016 Kanito. All rights reserved.
//

import Foundation

extension String {
    func tryLang() -> String {
        var s = self as String
        if (s.count > 0) {
            if s[s.startIndex..<s.index(s.startIndex, offsetBy: 1)] == "#" {
                s = String(s[s.index(s.startIndex, offsetBy: 1)..<s.endIndex])
                s = Lng(s)
            }
        }
        
        let newLine = "\n"
        return s.replacingOccurrences(of: "\\n", with: newLine)
    }
}
