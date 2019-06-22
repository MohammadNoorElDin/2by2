//
//  DateExt.swift
//  2By2
//
//  Created by rocky on 11/27/18.
//  Copyright © 2018 personal. All rights reserved.
//

import Foundation

extension Date
{
    func toString( dateFormat format  : String ) -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
    
}
