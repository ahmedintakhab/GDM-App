// import UIKit
// import Flutter
// import Firebase
// import FirebaseMessaging
//
// @UIApplicationMain
// @objc class AppDelegate: FlutterAppDelegate {
//   override func application(
//     _ application: UIApplication,
//     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
//   ) -> Bool {
//     FirebaseApp.configure()
//
//     // Set UNUserNotificationCenter delegate
//     if #available(iOS 10.0, *) {
//       UNUserNotificationCenter.current().delegate = self
//     }
//
//     // Register for remote notifications
//     application.registerForRemoteNotifications()
//
//     GeneratedPluginRegistrant.register(with: self)
//     return super.application(application, didFinishLaunchingWithOptions: launchOptions)
//   }
//
//   // Handle APNs token
//   override func application(
//     _ application: UIApplication,
//     didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data
//   ) {
//     Messaging.messaging().apnsToken = deviceToken
//   }
//
//   // Handle foreground notifications
//   @available(iOS 10.0, *)
//   func userNotificationCenter(
//     _ center: UNUserNotificationCenter,
//     willPresent notification: UNNotification,
//     withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
//   ) {
//     completionHandler([.alert, .badge, .sound])
//   }
//
//   // Handle notification tap
//   @available(iOS 10.0, *)
//   func userNotificationCenter(
//     _ center: UNUserNotificationCenter,
//     didReceive response: UNNotificationResponse,
//     withCompletionHandler completionHandler: @escaping () -> Void
//   ) {
//     let userInfo = response.notification.request.content.userInfo
//     Messaging.messaging().appDidReceiveMessage(userInfo)
//     completionHandler()
//   }
// }


import Flutter
import UIKit

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
