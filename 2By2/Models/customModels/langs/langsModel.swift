//
//  langsModel.swift
//  2By2
//
//  Created by mac on 11/1/18.
//  Copyright © 2018 personal. All rights reserved.
//

import Foundation

class langsModel {
    
    var name: String
    var id: Int
    var selected: Bool = false 
    
    init(lang: String, id: Int) {
        self.name = lang
        self.id = id
    }
}
