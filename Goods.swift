//
//  Goods.swift
//  mypay
//
//  Created by Hessam on 12/13/16.
//  Copyright © 2016 Hessam. All rights reserved.
//

import Foundation
class Goods{
    var name: String? = nil
    var price: Int? = nil
    var description: String? = nil
    init(name: String,price: Int,description: String) {
        self.name = name
        self.price = price
        self.description = description
    }
}
