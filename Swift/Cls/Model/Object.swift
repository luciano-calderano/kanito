//
//  Object.swift
//  Kanito
//
//  Created by mac on 27/03/17.
//  Copyright © 2017 Kanito. All rights reserved.
//

import Foundation

struct Object {
    var id = ""
    var name = ""
    var active = true
    var data: Any?
    
    init() {
    }
    
    init(id: String, name: String) {
        self.id = id
        self.name = name
    }
}
