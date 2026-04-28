import Flutter
import UIKit
import FirebaseCore
import FBSDKCoreKit

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    // Initialize Firebase
    FirebaseApp.configure()
    // Initialize Meta/Facebook SDK
    ApplicationDelegate.shared.application(
      application,
      didFinishLaunchingWithOptions: launchOptions
    )
    
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
  
  // Handle Stripe URL callbacks for 3D Secure authentication
  // This is required for Stripe Payment Sheet to handle redirects
  override func application(
    _ app: UIApplication,
    open url: URL,
    options: [UIApplication.OpenURLOptionsKey : Any] = [:]
  ) -> Bool {
    // Let Facebook SDK handle its callbacks first, then pass through to Flutter plugins (e.g., Stripe)
    let handledByFacebook = ApplicationDelegate.shared.application(
      app,
      open: url,
      options: options
    )
    return handledByFacebook || super.application(app, open: url, options: options)
  }
  
  // Handle universal links (if using Stripe with universal links)
  override func application(
    _ application: UIApplication,
    continue userActivity: NSUserActivity,
    restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void
  ) -> Bool {
    return super.application(application, continue: userActivity, restorationHandler: restorationHandler)
  }
}
