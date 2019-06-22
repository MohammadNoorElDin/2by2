//
//  LocationsModel.swift
//  2By2
//
//  Created by mac on 11/1/18.
//  Copyright © 2018 personal. All rights reserved.
//

import Foundation

class LocationsModel {
    
    var id: Int
    var name: String
    //    var latitude: String
    //    var longitude: String
    var selected: Bool = false
    
    init(id: Int, name: String) {
        self.id = id
        self.name = name 
    }
}
