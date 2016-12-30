//
//  MyServer.swift
//  mypay
//
//  Created by Hessam on 12/30/16.
//  Copyright © 2016 Hessam. All rights reserved.
//

import Foundation

struct MyServer {
    //Server Specification
    static let serverName: String = "hessam.local"
    static let serverPort: String = "8080"
    static let urlString: String = "http://\(MyServer.serverName):\(MyServer.serverPort)/"
    //Http Methods go here
    struct Method {
        static let signInMethod: String = "\(MyServer.urlString)signin"
        static let smsVerificationMethod: String = "\(MyServer.urlString)smsverification"
        static let completeVerificationMethod: String = "\(MyServer.urlString)completesignup"
        static let getStoreMethod: String = "\(MyServer.urlString)getstore"
    }
}
