//
//  Goods.swift
//  mypay
//
//  Created by Hessam on 12/13/16.
//  Copyright © 2016 Hessam. All rights reserved.
//

import Foundation
class Goods{
    let goodsid: Int
    let name: String
    let price: Int
    let description: String
    init(goodsid: Int,name: String,price: Int,description: String) {
        self.goodsid = goodsid
        self.name = name
        self.price = price
        self.description = description
    }
}
