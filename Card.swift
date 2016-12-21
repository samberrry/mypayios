//
//  Card.swift
//  mypay
//
//  Created by Hessam on 12/12/16.
//  Copyright © 2016 Hessam. All rights reserved.
//

import Foundation

class Card: NSObject,NSCoding{
    //MARK: Properties
    var cardNumber: Int
    var cardName: String
    var expirationDate: String
    var cvv2: Int
    var customerID: Int
    var bankName: String
    
    struct Propertykey {
        static let cardNumberKey = "cardNumber"
        static let cardNameKey = "cardHolderName"
        static let expirationDateKey = "expirationDate"
        static let cvv2Key = "cvv2"
        static let customerIDKey = "customerID"
        static let bankNameKey = "bankName"
    }
    
    //Initialization
    init(num: Int,crdName: String,exprdate: String,cvv2: Int,cusID: Int,
         bankName: String) {
        self.cardNumber = num
        self.cardName = crdName
        self.expirationDate = exprdate
        self.cvv2 = cvv2
        self.customerID = cusID
        self.bankName = bankName
    }
    //MARK: Archiving Paths
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("cards")
    
    //MARK: NSCoding
    func encode(with aCoder: NSCoder) {
        aCoder.encode(cardNumber,forKey: Propertykey.cardNumberKey)
        aCoder.encode(cardName,forKey: Propertykey.cardNameKey)
        aCoder.encode(expirationDate, forKey: Propertykey.expirationDateKey)
        aCoder.encode(cvv2, forKey: Propertykey.cvv2Key)
        aCoder.encode(customerID, forKey: Propertykey.customerIDKey)
        aCoder.encode(bankName, forKey: Propertykey.bankNameKey)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        let num = aDecoder.decodeObject(forKey: Propertykey.cardNumberKey) as! Int
        let crdName = aDecoder.decodeObject(forKey: Propertykey.cardNameKey) as! String
        let exprdate = aDecoder.decodeObject(forKey: Propertykey.expirationDateKey) as! String
        let cvv2 = aDecoder.decodeObject(forKey: Propertykey.cvv2Key) as! Int
        let cusID = aDecoder.decodeObject(forKey: Propertykey.customerIDKey) as! Int
        let bankname = aDecoder.decodeObject(forKey: Propertykey.bankNameKey) as! String
        self.init(num: num,crdName: crdName,exprdate: exprdate,cvv2: cvv2,cusID: cusID,bankName: bankname)
    }
}
