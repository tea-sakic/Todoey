//
//  Item.swift
//  Todoey
//
//  Created by Tea Sakic on 30/06/2018.
//  Copyright © 2018 Tea Sakic. All rights reserved.
//

import Foundation

class Item: Codable {
    let titleOfItem : String
    var isItDone : Bool
    
    init(title : String, done : Bool ) {
        titleOfItem = title
        isItDone = done
    }
    
}
