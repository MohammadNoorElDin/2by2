//
//  SpecializationModel.swift
//  2By2
//
//  Created by mac on 11/1/18.
//  Copyright © 2018 personal. All rights reserved.
//

import Foundation

class SpecializationModel {
    
    var id : Int
    var name : String
    var selected: Bool = false
    
    init(id: Int, name: String) {
        self.id = id
        self.name = name
    }
}
