//
//  BodyGenerator.swift
//  mypay
//
//  Created by Hessam on 12/6/16.
//  Copyright © 2016 Hessam. All rights reserved.
//

import Foundation

class BodyMaker {
    //Mark: Properties
    var body: String!
    
    //MARK: Methods
    func getBody() -> String? {
        return body;
    }
    func appednKeyValue(key: String,value: String){
        if body != nil
        {
            let str = "&\(key)=\(value)"
            body.append(str)
        }
        else{
            body = "\(key)=\(value)"
        }
    }
}
