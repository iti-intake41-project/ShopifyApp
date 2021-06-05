//
//  AppDelegate.swift
//  ShopifyApp
//
//  Created by Abanob Wadie on 19/05/2021.
//

import UIKit
import IQKeyboardManagerSwift
//import Firebase
//import GoogleSignIn

@main
class AppDelegate: UIResponder, UIApplicationDelegate/*, GIDSignInDelegate*/ {
    var window: UIWindow?

    
//    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error?) {
//        print("user email: \(user?.profile.email ?? "No email")")
//        if error != nil {
//            print("error \(error?.localizedDescription ?? "")")
//            return
//      }
//
//      guard let authentication = user.authentication else { return }
//      let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,
//                                                        accessToken: authentication.accessToken)
//
//        Auth.auth().signIn(with: credential) { (authResult, error) in
//            if let error = error {
//                print(error.localizedDescription)
//                return
//            }
//            print("signIn result: " + authResult!.user.email!)
//        }
//    }

//    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
//        // Perform any operations when the user disconnects from app here.
//        // ...
//    }

//    @available(iOS 9.0, *)
//    func application(_ application: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any])
//      -> Bool {
//      return GIDSignIn.sharedInstance().handle(url)
//    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
//        FirebaseApp.configure()
//
//        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
//        GIDSignIn.sharedInstance().delegate = self

        IQKeyboardManager.shared.enable = true
        
        return true
    }


}

