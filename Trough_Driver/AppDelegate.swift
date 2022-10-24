//
//  AppDelegate.swift
//  Trough_Driver
//
//  Created by Imed on 17/02/2021.
//

import UIKit
import IQKeyboardManagerSwift
import Firebase
import SVProgressHUD
import GoogleMaps
import GooglePlaces

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    var locationManager = CLLocationManager()
    
    let gcmMessageIDKey = "gcm_msg_id"

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        if #available(iOS 13.0, *) {
            window?.overrideUserInterfaceStyle = .light
        }
        
        IQKeyboardManager.shared.enable = true
        
        SVProgressHUD.setDefaultMaskType(.none)
        SVProgressHUD.setDefaultAnimationType(.native)
        SVProgressHUD.setBackgroundColor(.clear)
        //Key
        GMSServices.provideAPIKey("AIzaSyDxk2eBfguzscVRjti4xs0nGXzNBdz-vdo")
        GMSPlacesClient.provideAPIKey("AIzaSyDxk2eBfguzscVRjti4xs0nGXzNBdz-vdo")
        
        self.locationManager.requestWhenInUseAuthorization()
        
        FirebaseApp.configure()
        
        Messaging.messaging().delegate = self
        
//        if #available(iOS 10.0, *) {
//          // For iOS 10 display notification (sent via APNS)
//          UNUserNotificationCenter.current().delegate = self
//
//          let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
//          UNUserNotificationCenter.current().requestAuthorization(
//            options: authOptions,
//            completionHandler: {_, _ in })
//        } else {
//          let settings: UIUserNotificationSettings =
//          UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
//          application.registerUserNotificationSettings(settings)
//        }
//
//        application.registerForRemoteNotifications()
        
        UNUserNotificationCenter.current().delegate = self
        Messaging.messaging().token { token, error in
          if let error = error {
            print("Error fetching FCM registration token: \(error)")
          } else if let token = token {
            print("FCM registration token: \(token)")
            Global.shared.fcmToken = token
          }
        }
        self.registerForPushNotifications()

        
        return true
    }
    
    

    

}

extension AppDelegate{
    func registerForPushNotifications() {
        //1
        Messaging.messaging().delegate = self
        UNUserNotificationCenter.current()
            .requestAuthorization(
                options: [.alert, .sound, .badge]) { [weak self] granted, _ in
                print("Permission granted: \(granted)")
                guard granted else { return }
                self?.getNotificationSettings()
            }
    }
    
    func getNotificationSettings() {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            print("Notification settings: \(settings)")
            guard settings.authorizationStatus == .authorized else { return }
            DispatchQueue.main.async {
                UIApplication.shared.registerForRemoteNotifications()
            }
        }
    }
}

@available(iOS 10, *)
extension AppDelegate : UNUserNotificationCenterDelegate {

  // Receive displayed notifications for iOS 10 devices.
  func userNotificationCenter(_ center: UNUserNotificationCenter,
                              willPresent notification: UNNotification,
    withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
    let userInfo = notification.request.content.userInfo

    // With swizzling disabled you must let Messaging know about the message, for Analytics
    // Messaging.messaging().appDidReceiveMessage(userInfo)

    // Print message ID.
    if let messageID = userInfo[gcmMessageIDKey] {
      print("Message ID: \(messageID)")
    }

    // Print full message.
    print(userInfo)

    // Change this to your preferred presentation option
    completionHandler([[.alert, .sound, .badge]])
  }

  func userNotificationCenter(_ center: UNUserNotificationCenter,
                              didReceive response: UNNotificationResponse,
                              withCompletionHandler completionHandler: @escaping () -> Void) {
    let userInfo = response.notification.request.content.userInfo
    // Print message ID.
    if let messageID = userInfo[gcmMessageIDKey] {
      print("Message ID: \(messageID)")
    }
    
    GCD.async(.Main, delay: 1.0) {
        self.handleNotification()
    }

    // With swizzling disabled you must let Messaging know about the message, for Analytics
    // Messaging.messaging().appDidReceiveMessage(userInfo)

    // Print full message.
    print(userInfo)

    completionHandler()
  }
}

extension AppDelegate:MessagingDelegate{
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        
        if let fcmToken = fcmToken{
            UserDefaults.standard.set(fcmToken, forKey: "FCMToken")
            UserDefaults.standard.synchronize()
            print("Firebase registration token: \(String(describing: fcmToken))")

        }
      

              let dataDict:[String: String] = ["token": fcmToken ?? ""]
      NotificationCenter.default.post(name: Notification.Name("FCMToken"), object: nil, userInfo: dataDict)
      // TODO: If necessary send token to application server.
      // Note: This callback is fired at each app startup and whenever a new token is generated.
    }
    
    func application(
        _ application: UIApplication,
        didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data
    ) {
        let tokenParts = deviceToken.map { data in String(format: "%02.2hhx", data) }
        let token = tokenParts.joined()
        print("Device Token: \(token)")
//        Global.shared.fcmToken  = token
    }
    
    func application(
        _ application: UIApplication,
        didFailToRegisterForRemoteNotificationsWithError error: Error
    ) {
        print("Failed to register: \(error)")
    }
    
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID did reci: \(messageID)")
        }
        if let messageType = userInfo["type"] {
            print("Message Type \(messageType)")
        }
        if let messageMsg = userInfo["msg"] {
            print("Message Message \(messageMsg)")
        }

      // Print full message.
      print(userInfo)
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        switch UIApplication.shared.applicationState {
        case .active:
            //app is currently active, can update badges count here
            break
        case .inactive:
            //app is transitioning from background to foreground (user taps notification), do what you need when user taps here
            break
        case .background:
//            GCD.async(.Main, delay: 4.0) {
//                self.handleNotification()
//            }

//            self.showTopNotification(userInfo: userInfo)
            //app is in background, if content-available key of your notification is set to 1, poll to your backend to retrieve data and update your interface here
            break
        default:
            break
        }
        
        print("recieved")
        
    }
}

extension AppDelegate {
    func handleNotification(){
        let viewController = UIApplication.shared.keyWindow!.rootViewController
        var controller = viewController
        while ((controller?.presentedViewController) != nil){
            controller = controller?.presentedViewController
        }
        if let topVC = UIApplication.topViewController() {
            if let vc = topVC as? BaseViewController {
                vc.openNotification()

            }
        }
    }
}

extension UIApplication {
    class func topViewController(controller: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let navigationController = controller as? UINavigationController {
            return topViewController(controller: navigationController.visibleViewController)
        }
        if let tabController = controller as? UITabBarController {
            if let selected = tabController.selectedViewController {
                return topViewController(controller: selected)
            }
        }
        if let presented = controller?.presentedViewController {
            return topViewController(controller: presented)
        }
        return controller
    }
}



extension AppDelegate:CLLocationManagerDelegate{
     func loadMap() {
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
        self.locationManager.allowsBackgroundLocationUpdates = true
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else {
            return
        }
                if GlobalVariable.isFirstTime{
                    GlobalVariable.truckCurrentLatitude = location.coordinate.latitude
                    GlobalVariable.truckCurrentLongitude = location.coordinate.longitude
                    GlobalVariable.isFirstTime = false
                }
                else{
                    let coordinate0 = CLLocation(latitude: GlobalVariable.truckCurrentLatitude, longitude: GlobalVariable.truckCurrentLongitude)
                    let coordinate1 = CLLocation(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
                    let distanceInMeters = coordinate0.distance(from: coordinate1)
                    
                    if distanceInMeters >= 200.00{
                        print(distanceInMeters)
                        GlobalVariable.isFirstTime = true
                        
                        //----Api Called------
                        let params =
                            [
                                
                                "liveLongitude"        : GlobalVariable.truckCurrentLongitude
                                
                            ] as [String : Any]
                        let service = Services()
                        GCD.async(.Default) {
                            service.UpdateTruckLiveLocation(params: params) { (serviceResponse) in
                                switch serviceResponse.serviceResponseType {
                                case .Success :
                                    GCD.async(.Main) {
                                        if let data = serviceResponse.data {
                                            print(data)
                                            print("YEsssss")
                                        }
                                        else {
                                            print("Error Updating Live Location 1")
                                        }
                                    }
                                case .Failure :
                                    GCD.async(.Main) {
                                        print("Error Updating Live Location 2")
                                    }
                                default :
                                    GCD.async(.Main) {
                                        print("Error Updating Live Location 3")                                    }
                                }
                            }
                        }

                        //----Api Calling End
                        
                    }//If statement End
        
                }//Else Statement End here
        print(location.coordinate)
    }
}
