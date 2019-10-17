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
import GoogleMobileAds
import YandexMobileMetrica

import Fabric
import Crashlytics
import YandexMobileAds

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, CLLocationManagerDelegate {

    var window: UIWindow?
    var request1 = ""
    var survays1 = ""
    var news1    = ""
    let locationManager = CLLocationManager()
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        UNUserNotificationCenter.current().delegate = self
        // Override point for customization after application launch.
        do {
            try Network.reachability = Reachability(hostname: "www.google.com")
        }
        catch {
            switch error as? Network.Error {
            case let .failedToCreateWith(hostname)?:
                print("Network error:\nFailed to create reachability object With host named:", hostname)
            case let .failedToInitializeWith(address)?:
                print("Network error:\nFailed to initialize reachability object With address:", address)
            case .failedToSetCallout?:
                print("Network error:\nFailed to set callout")
            case .failedToSetDispatchQueue?:
                print("Network error:\nFailed to set DispatchQueue")
            case .none:
                print(error)
            }
        }
        FirebaseApp.configure()
        
        application.registerForRemoteNotifications()
        
        Fabric.with([Crashlytics.self])
        
        requestNotificationAuthorization(application: application)
//        locationNotificationAuthorization(application: application)
        YMAMobileAds.enableLogging()
        GADMobileAds.sharedInstance().start(completionHandler: nil)
        var apiKey = ""
        #if isOur_Obj_Home
        apiKey = ""
        #elseif isChist_Dom
        apiKey = ""
        #elseif isMupRCMytishi
        apiKey = ""
        #elseif isDJ
        apiKey = ""
        #elseif isStolitsa
        apiKey = ""
        #elseif isKomeks
        apiKey = ""
        #elseif isUKKomfort
        apiKey = "1361881b-37dd-49e9-8573-c7a37ee7a239"
        #elseif isKlimovsk12
        apiKey = ""
        #elseif isPocket
        apiKey = ""
        #elseif isReutKomfort
        apiKey = ""
        #elseif isUKGarant
        apiKey = ""
        #elseif isSoldatova1
        apiKey = ""
        #elseif isTafgai
        apiKey = ""
        #elseif isServiceKomfort
        apiKey = ""
        #elseif isParitet
        apiKey = ""
        #elseif isSkyfort
        apiKey = ""
        #elseif isStandartDV
        apiKey = ""
        #elseif isGarmonia
        apiKey = ""
        #endif
        if apiKey != ""{
            let configuration = YMMYandexMetricaConfiguration.init(apiKey: apiKey)
            // Отслеживание новых пользователей
            configuration?.handleFirstActivationAsUpdate = true
            // Отслеживание аварийной остановки приложений
            configuration?.crashReporting = true
            configuration?.statisticsSending = true
            YMMYandexMetrica.activate(with: configuration!)
        }
        
        if let notification = launchOptions?[.remoteNotification] as? [String:AnyObject]{
            let aps = notification["aps"] as! [String:AnyObject]
            var body: String = ""
            var title: String = ""
            if let alert = aps["alert"] as? String {
                body = alert
            } else if let alert = aps["alert"] as? [String : String] {
                body = alert["body"]!
                title = alert["title"]!
            }
            var news = 0
            var apps = 0
            if notification["unreadedAnnouncements"] != nil{
                news = Int(notification["unreadedAnnouncements"]! as! String)!
                if news > 0{
                     UserDefaults.standard.set(news, forKey: "newsKol")
                }else{
                     UserDefaults.standard.set(0, forKey: "newsKol")
                }
            }
            if notification["requestsUnreadedCount"] != nil{
                apps = Int(notification["requestsUnreadedCount"]! as! String)!
                if apps > 0{
                     UserDefaults.standard.set(apps, forKey: "appsKol")
                }else{
                     UserDefaults.standard.set(0, forKey: "appsKol")
                }
            }
            let updatedBadgeNumber = UserDefaults.standard.integer(forKey: "appsKol") + UserDefaults.standard.integer(forKey: "newsKol")
            if (updatedBadgeNumber > -1) {
                UIApplication.shared.applicationIconBadgeNumber = updatedBadgeNumber
            }
            if notification["gcm.notification.type_push"] as? String == "announcement"{
                UserDefaults.standard.set(true, forKey: "newNotifi")
                UserDefaults.standard.set(body, forKey: "bodyNotifi")
                UserDefaults.standard.set(title, forKey: "titleNotifi")
                UserDefaults.standard.synchronize()
                print("---isNEWS---")
                let main: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let initialView: UIViewController = main.instantiateViewController(withIdentifier: "notifi") as UIViewController
                self.window = UIWindow(frame: UIScreen.main.bounds)
                self.window?.rootViewController = initialView
                self.window?.makeKeyAndVisible()
            }
        }
    
        return true
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {
        NSLog("[RemoteNotification] applicationState: \(applicationStateString) didReceiveRemoteNotification for iOS9: \(userInfo)")
        print("==============")
//        guard let aps = userInfo["comment"] as? [String : AnyObject] else {
//            print("Error parsing aps")
//            return
//        }
//        print(aps)
//        guard let requests = userInfo["meters"] as? String else {
//            print("Error parsing request")
//            return
//        }
//        print(requests)
        guard let notifi = userInfo["aps"] as? [String : AnyObject] else {
            print("Error parsing")
            return
        }
//        guard let news = userInfo["announcement"] as? String else {
//            print("Error parsing news")
//            return
//        }
//        guard let survays = userInfo["other"] as? String else {
//            print("Error parsing survays")
//            return
//        }
//        print(survays)
//        if (requests != request1) || (news != news1) || (survays != survays1){
//            UIApplication.shared.applicationIconBadgeNumber = 0
//            UIApplication.shared.applicationIconBadgeNumber = Int(requests)! + Int(news)! + Int(survays)!
//            request1 = requests
//            news1 = news
//            survays1 = survays
//            print("Уведомления: ", UIApplication.shared.applicationIconBadgeNumber)
//        }
        var body = ""
        var title = ""
//        var msgURL = ""
        if let alert = notifi["alert"] as? String {
            body = alert
        } else if let alert = notifi["alert"] as? [String : String] {
            body = alert["body"]!
            title = alert["title"]!
        }
        var news = 0
        var apps = 0
        if userInfo["gcm.notification.unreadedAnnouncements"] != nil{
            news = Int(userInfo["gcm.notification.unreadedAnnouncements"]! as! String)!
            if news > 0{
                 UserDefaults.standard.set(news, forKey: "newsKol")
            }else{
                 UserDefaults.standard.set(0, forKey: "newsKol")
            }
        }
        if userInfo["unreadedAnnouncements"] != nil{
            news = Int(userInfo["unreadedAnnouncements"]! as! String)!
            if news > 0{
                 UserDefaults.standard.set(news, forKey: "newsKol")
            }else{
                 UserDefaults.standard.set(0, forKey: "newsKol")
            }
        }
        if userInfo["gcm.notification.requestsUnreadedCount"] != nil{
            apps = Int(userInfo["gcm.notification.requestsUnreadedCount"]! as! String)!
            if apps > 0{
                UserDefaults.standard.set(apps, forKey: "appsKol")
            }else{
                UserDefaults.standard.set(0, forKey: "appsKol")
            }
        }
        if userInfo["requestsUnreadedCount"] != nil{
            apps = Int(userInfo["requestsUnreadedCount"]! as! String)!
            if apps > 0{
                UserDefaults.standard.set(apps, forKey: "appsKol")
            }else{
                UserDefaults.standard.set(0, forKey: "appsKol")
            }
        }
        let updatedBadgeNumber = UserDefaults.standard.integer(forKey: "appsKol") + UserDefaults.standard.integer(forKey: "newsKol")
        if (updatedBadgeNumber > -1) {
            UIApplication.shared.applicationIconBadgeNumber = updatedBadgeNumber
        }
        if userInfo["gcm.notification.type_push"] as? String == "comment"{
//            UserDefaults.standard.set(true, forKey: "newNotifi")
//            UserDefaults.standard.synchronize()
            print("---isCOMMENT---")
        }
//
//        if let alert1 = aps["category"] as? String {
//            msgURL = alert1
//        }

        print("Body:", body, "Title:", title)
        let db = DB()
        db.addSettings(id: 1, name: "notification", diff: "true")
        if title.contains("поступил комментарий"){
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "reloadTheTable"), object: nil)
        }
        if UIApplication.shared.applicationState == .active {
            //TODO: Handle foreground notification
        } else {
            //TODO: Handle background notification
        }
    }
    
    func application(_ application: UIApplication, handleOpen url: URL) -> Bool {
        YMMYandexMetrica.handleOpen(url)
        return true
    }
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        YMMYandexMetrica.handleOpen(url)
        return true
    }
    
    // Делегат для трекинга Universal links.
    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([Any]?) -> Void) -> Bool {
        if userActivity.activityType == NSUserActivityTypeBrowsingWeb {
            if let url = userActivity.webpageURL {
                YMMYandexMetrica.handleOpen(url)
            }
        }
        return true
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Messaging.messaging().apnsToken = deviceToken
        let token = deviceToken.map { String(format: "%02.2hhx", $0) }.joined()
        print("TOKEN: ", token)
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
//            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
//            UNUserNotificationCenter.current().requestAuthorization(options: authOptions, completionHandler: {_, _ in })
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) {
                (granted, error) in
                print("Permission granted: \(granted)")
                guard granted else { return }
                self.getNotificationSettings()
            }
        } else {
            let settings: UIUserNotificationSettings = UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
    }
    
    func getNotificationSettings() {
        UNUserNotificationCenter.current().getNotificationSettings { (settings) in
            print("Notification settings: \(settings)")
            guard settings.authorizationStatus == .authorized else { return }
            DispatchQueue.main.async {
                UIApplication.shared.registerForRemoteNotifications()
            }            
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
        let aps = userInfo["aps"] as! [String:AnyObject]
        var body: String = ""
        var title: String = ""
        if let alert = aps["alert"] as? String {
            body = alert
        } else if let alert = aps["alert"] as? [String : String] {
            body = alert["body"]!
            title = alert["title"]!
        }
        if userInfo["gcm.notification.type_push"] as? String == "announcement"{
            if UIApplication.shared.applicationState == .active {
                //TODO: Handle foreground notification
                UserDefaults.standard.set(true, forKey: "newNotifi")
                UserDefaults.standard.set(body, forKey: "bodyNotifi")
                UserDefaults.standard.set(title, forKey: "titleNotifi")
                UserDefaults.standard.synchronize()
                let main: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let initialView: UIViewController = main.instantiateViewController(withIdentifier: "notifi") as UIViewController
                self.window = UIWindow(frame: UIScreen.main.bounds)
                self.window?.rootViewController = initialView
                self.window?.makeKeyAndVisible()
            } else {
                //TODO: Handle background notification
            }
            print("---isNEWS---")
        }
        completionHandler()
    }
}

extension AppDelegate : MessagingDelegate {
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        NSLog("[RemoteNotification] didRefreshRegistrationToken: \(fcmToken)")
    }
    
    // iOS9, called when presenting notification in foreground
//    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {
//        NSLog("[RemoteNotification] applicationState: \(applicationStateString) didReceiveRemoteNotification for iOS9: \(userInfo)")
//        print("==============")
//        guard let aps = userInfo["comment"] as? [String : AnyObject] else {
//            print("Error parsing aps")
//            return
//        }
//        print(aps)
//        guard let requests = userInfo["meters"] as? String else {
//            print("Error parsing request")
//            return
//        }
//        print(requests)
//        guard let news = userInfo["announcement"] as? String else {
//            print("Error parsing news")
//            return
//        }
//        print(news)
//        guard let survays = userInfo["other"] as? String else {
//            print("Error parsing survays")
//            return
//        }
//        print(survays)
//        if (requests != request1) || (news != news1) || (survays != survays1){
//            UIApplication.shared.applicationIconBadgeNumber = 0
//            UIApplication.shared.applicationIconBadgeNumber = Int(requests)! + Int(news)! + Int(survays)!
//            request1 = requests
//            news1 = news
//            survays1 = survays
//            print("Уведомления: ", UIApplication.shared.applicationIconBadgeNumber)
//        }
//
////        if let alert = aps["alert"] as? String {
////            body = alert
////        } else if let alert = aps["alert"] as? [String : String] {
////            body = alert["body"]!
////            title = alert["title"]!
////        }
////
////        if let alert1 = aps["category"] as? String {
////            msgURL = alert1
////        }
//
////        print("Body:", body, "Title:", title, "msgURL:", msgURL)
//        print("---УВЕДОМЛЕНИЕ---")
//        let db = DB()
//        db.addSettings(id: 1, name: "notification", diff: "true")
//        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "reloadTheTable"), object: nil)
//        if UIApplication.shared.applicationState == .active {
//            //TODO: Handle foreground notification
//        } else {
//            //TODO: Handle background notification
//        }
//    }
}
