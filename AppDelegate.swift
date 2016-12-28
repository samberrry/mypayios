//
//  AppDelegate.swift
//  mypay
//
//  Created by Hessam on 12/5/16.
//  Copyright © 2016 Hessam. All rights reserved.
//

import UIKit
import CoreLocation
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, CLLocationManagerDelegate,URLSessionDelegate,URLSessionDataDelegate{
    var window: UIWindow?
    static var storeName: String?
    static var storeID: Int?
    var cookie: HTTPCookie?
    //MARK: Properties
    let locationManager = CLLocationManager()
    let region = CLBeaconRegion(proximityUUID: NSUUID(uuidString: "163EB541-B100-4BA5-8652-EB0C513FB0F4")! as UUID , identifier: "mypay")
    let center = UNUserNotificationCenter.current()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        // Notification Authorization
        center.requestAuthorization(options: [.alert, .sound]) { (granted, error) in
            // Enable or disable features based on authorization
        }
        locationManager.requestAlwaysAuthorization()
        locationManager.startMonitoring(for: region)
        locationManager.delegate = self
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        self.cookie = HTTPCookieStorage.shared.cookies?[0]
        
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    //MARK: Beacon
    
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        locationManager.startRangingBeacons(in: self.region)
        let content = UNMutableNotificationContent()
        content.title = "Pay here with MyPay"
        content.body = "you are close to a store"
        content.badge = 12
        content.sound = UNNotificationSound.default()
//        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5,repeats: false)
        let request = UNNotificationRequest(identifier: "braconnotifi", content: content, trigger: nil)
        let center = UNUserNotificationCenter.current()
        center.add(request, withCompletionHandler: nil)
    }
    
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        Store.state = false
        Store.name = nil
        Store.storeID = nil
        let content = UNMutableNotificationContent()
        content.title = "heey!"
        content.body = "you left the Beacon area"
        content.badge = 12
        content.sound = UNNotificationSound.default()
        //        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5,repeats: false)
        let request = UNNotificationRequest(identifier: "beaconnotifi", content: content, trigger: nil)
        let center = UNUserNotificationCenter.current()
        center.add(request, withCompletionHandler: nil)
    }

    //MARK: Ranging
    func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
        if beacons.count > 0 {
            let knownBeacon = beacons[0]
            notifyEntryToServer(uuid: knownBeacon.proximityUUID.uuidString, major: knownBeacon.major.intValue, minor: knownBeacon.minor.intValue)
            locationManager.stopRangingBeacons(in: self.region)
        }
    }
    //*******************************************************
    func notifyEntryToServer(uuid: String,major: Int,minor: Int) {
        let defaultConfiguration = URLSessionConfiguration.default
        let delegate = self
        let operationQueue = OperationQueue.main
        let defaultSession = URLSession(configuration: defaultConfiguration, delegate: delegate, delegateQueue: operationQueue)
        
        if let srvURL = URL(string: "http://hessam/getstore") {
            var srvUrlRequest = URLRequest(url: srvURL)
            srvUrlRequest.httpMethod = "POST"
            
            let body = BodyMaker()
            body.appednKeyValue(key: "uuid", value: uuid)
            body.appednKeyValue(key: "major", value: String(major))
            body.appednKeyValue(key: "minor", value: String(minor))
            
            let bodyString  = body.getBody()
            srvUrlRequest.httpBody = bodyString?.data(using: String.Encoding.utf8)
            let dataTask = defaultSession.dataTask(with: srvUrlRequest)
            dataTask.resume()
        }
    }
    
    //********************************************************
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        var serverResultCode: Int?
        var serverMetaData: String?
        var serverStoreID: Int?
        var serverStoreName: String?
        let responseData = data
        //  parse the result as JSON, since that's what the API provides
        do {
            guard let receivedData = try JSONSerialization.jsonObject(with: responseData,options: []) as? [String: Any] else {
                // print("Could not get JSON from responseData as dictionary")
                return
            }
            
            guard let resutlCode = receivedData["resultcode"] as? Int else {
                // print("Could not get resultcode as int from JSON")
                return
            }
            serverResultCode = resutlCode
            guard let metaData = receivedData["metadata"] as? String else {
                // print("Could not get resultcode as int from JSON")
                return
            }
            serverMetaData = metaData
            guard let storeID = receivedData["storeid"] as? Int else {
                // print("Could not get resultcode as int from JSON")
                return
            }
            serverStoreID = storeID
            guard let storeName = receivedData["storename"] as? String else {
                // print("Could not get resultcode as int from JSON")
                return
            }
            serverStoreName = storeName
            
        } catch  {
            // print("error parsing response from POST on /getstore")
            return
        }
        if serverResultCode == 500
        {
            Store.state = true
            Store.name = serverStoreName
            Store.storeID = serverStoreID
            print(serverMetaData!)
//            AppDelegate.storeName = serverStoreName
//            AppDelegate.storeID = serverStoreID
            
        }
    }
    //********************************************************
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        guard error == nil else {
            print(error!)
            return
        }
    }
    
    //********************************************************
    func notifyExitToServer() -> Int? {
        return nil
    }
    
//    func locationManager(_ manager: CLLocationManager, monitoringDidFailFor region: CLRegion?, withError error: Error) {
//        let alertController = UIAlertController(title: "Failure", message: "Beacon monitoring failed!", preferredStyle: UIAlertControllerStyle.alert)
//        
//        let okAction = UIAlertAction(title: "try later", style: UIAlertActionStyle.default) { (result : UIAlertAction) -> Void in
//            print("OK")
//        }
//        alertController.addAction(okAction)
//        self.present(alertController, animated: true, completion: nil)    }
//    //
//    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
//        let alertController = UIAlertController(title: "Failure", message: "Location Manager failed!", preferredStyle: UIAlertControllerStyle.alert)
//        
//        let okAction = UIAlertAction(title: "try later", style: UIAlertActionStyle.default) { (result : UIAlertAction) -> Void in
//            print("OK")
//        }
//        alertController.addAction(okAction)
//        self.present(alertController, animated: true, completion: nil)
//    }
    
}

