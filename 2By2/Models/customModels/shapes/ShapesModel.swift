//
//  ShapesModel.swift
//  trainee
//
//  Created by rocky on 11/28/18.
//  Copyright © 2018 personal. All rights reserved.
//

import Foundation

class ShapesModel  {

    var Image: String?
    var Name: String
    var Id: Int
    
    init(Id: Int, Image: String?, Name: String) {
        self.Image = Image
        self.Name = Name
        self.Id = Id
    }
}
