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
class AppDelegate: UIResponder, UIApplicationDelegate, CLLocationManagerDelegate{
    var window: UIWindow?
    
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
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
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
        let content = UNMutableNotificationContent()
        content.title = "Pay here with MyPay"
        content.body = "you are close to a store"
        content.badge = 12
        content.sound = UNNotificationSound.default()
//        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5,repeats: false)
        let request = UNNotificationRequest(identifier: "braconnotifi", content: content, trigger: nil)
        let center = UNUserNotificationCenter.current()
        center.add(request, withCompletionHandler: nil)
        locationManager.startRangingBeacons(in: self.region)
    }
    
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        let content = UNMutableNotificationContent()
        content.title = "Goodbye"
        content.body = "you left the Store"
        content.badge = 12
        content.sound = UNNotificationSound.default()
        //        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5,repeats: false)
        let request = UNNotificationRequest(identifier: "beaconnotifi", content: content, trigger: nil)
        let center = UNUserNotificationCenter.current()
        center.add(request, withCompletionHandler: nil)
        locationManager.startRangingBeacons(in: self.region)
        locationManager.stopRangingBeacons(in: self.region)
    }

}

