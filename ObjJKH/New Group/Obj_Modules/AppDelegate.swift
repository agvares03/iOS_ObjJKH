//
//  AppDelegate.swift
//  ObjJKH
//
//  Created by Роман Тузин on 27.08.2018.
//  Copyright © 2018 The Best. All rights reserved.
//

import UIKit
import UserNotifications
import Firebase
import FirebaseInstanceID
import FirebaseMessaging
import CoreData
import CoreLocation

import Fabric
import Crashlytics

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, CLLocationManagerDelegate {

    var window: UIWindow?
    var request1 = ""
    var survays1 = ""
    var news1    = ""
    let locationManager = CLLocationManager()
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        FirebaseApp.configure()
        
        application.registerForRemoteNotifications()
        
        Fabric.with([Crashlytics.self])
        
        requestNotificationAuthorization(application: application)
//        locationNotificationAuthorization(application: application)
        return true
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Messaging.messaging().apnsToken = deviceToken
        let token = deviceToken.map { String(format: "%02.2hhx", $0) }.joined()
        print(token)
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        NSLog("didFailToRegisterForRemoteNotificationsWithError")
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
        let core = CoreDataManager()
        core.saveContext()
    }
    
    func applicationReceivedRemoteMessage(_ remoteMessage: MessagingRemoteMessage) {
        print(remoteMessage.appData)
    }
    
    var applicationStateString: String {
        if UIApplication.shared.applicationState == .active {
            return "active"
        } else if UIApplication.shared.applicationState == .background {
            return "background"
        }else {
            return "inactive"
        }
    }
    func requestNotificationAuthorization(application: UIApplication) {
        Messaging.messaging().delegate = self
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().delegate = self
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(options: authOptions, completionHandler: {_, _ in })
        } else {
            let settings: UIUserNotificationSettings = UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
    }
    
    func locationNotificationAuthorization(application: UIApplication) {
        
//        if CLLocationManager.locationServicesEnabled() == true {
//
//            if CLLocationManager.authorizationStatus() == .restricted || CLLocationManager.authorizationStatus() == .denied ||  CLLocationManager.authorizationStatus() == .notDetermined {
//                locationManager.requestWhenInUseAuthorization()
//            }
//            locationManager.desiredAccuracy = kCLLocationAccuracyBest
//            locationManager.delegate = self
//            locationManager.startUpdatingLocation()
//        } else {
//            print("PLease turn on location services or GPS")
//        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        self.locationManager.stopUpdatingLocation()
//        var location : [String:String] = [:]
//        let userLocation :CLLocation = locations[0] as CLLocation
//        location["latitude"] = String(userLocation.coordinate.latitude)
//        location["longitude"] = String(userLocation.coordinate.longitude)
//
//        let geocoder = CLGeocoder()
//        geocoder.reverseGeocodeLocation(userLocation) { (placemarks, error) in
//            if (error != nil){
//                print("error in reverseGeocode")
//            }
//            let placemark = placemarks! as [CLPlacemark]
//            if placemark.count>0{
//                let placemark = placemarks![0]
//                location["locality"] = placemark.locality!
//                location["administrativeArea"] = placemark.administrativeArea!
//                location["country"] = placemark.country!
//                print(location)
//                UserDefaults.standard.setValue(location, forKey: "locationData") //Сохранение геопозиции пользователя
//            }
//        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
//        print("Unable to access your current location")
    }
}

@available(iOS 10, *)
extension AppDelegate : UNUserNotificationCenterDelegate {
    // iOS10+, called when presenting notification in foreground
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let userInfo = notification.request.content.userInfo
        NSLog("[UserNotificationCenter] applicationState: \(applicationStateString) willPresentNotification: \(userInfo)")
        //TODO: Handle foreground notification
        completionHandler([.alert])
    }
    
    // iOS10+, called when received response (default open, dismiss or custom action) for a notification
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        NSLog("[UserNotificationCenter] applicationState: \(applicationStateString) didReceiveResponse: \(userInfo)")
        //TODO: Handle background notification
        completionHandler()
    }
}

extension AppDelegate : MessagingDelegate {
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        NSLog("[RemoteNotification] didRefreshRegistrationToken: \(fcmToken)")
    }
    
    // iOS9, called when presenting notification in foreground
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {
        NSLog("[RemoteNotification] applicationState: \(applicationStateString) didReceiveRemoteNotification for iOS9: \(userInfo)")
        print("==============")
        guard let aps = userInfo["aps"] as? [String : AnyObject] else {
            print("Error parsing aps")
            return
        }
        print(aps)
        guard let requests = userInfo["requestsCount"] as? String else {
            print("Error parsing request")
            return
        }
        print(requests)
        guard let news = userInfo["unreadedAnnouncements"] as? String else {
            print("Error parsing news")
            return
        }
        print(news)
        guard let survays = userInfo["survaysCount"] as? String else {
            print("Error parsing survays")
            return
        }
        print(survays)
        if (requests != request1) || (news != news1) || (survays != survays1){
            UIApplication.shared.applicationIconBadgeNumber = 0
            UIApplication.shared.applicationIconBadgeNumber = Int(requests)! + Int(news)! + Int(survays)!
            request1 = requests
            news1 = news
            survays1 = survays
            print("Уведомления: ", UIApplication.shared.applicationIconBadgeNumber)
        }
        
//        if let alert = aps["alert"] as? String {
//            body = alert
//        } else if let alert = aps["alert"] as? [String : String] {
//            body = alert["body"]!
//            title = alert["title"]!
//        }
//
//        if let alert1 = aps["category"] as? String {
//            msgURL = alert1
//        }
        
//        print("Body:", body, "Title:", title, "msgURL:", msgURL)
        
        let db = DB()
        db.addSettings(id: 1, name: "notification", diff: "true")
        
        if UIApplication.shared.applicationState == .active {
            //TODO: Handle foreground notification
        } else {
            //TODO: Handle background notification
        }
    }
}
