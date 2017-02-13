//
//  AppDelegate.swift
//  MeetingRooms
//
//  Created by Amy Cheong on 11/2/17.
//  Copyright © 2017 amycheong. All rights reserved.
//

import UIKit
import Firebase
import FBSDKCoreKit
import FBSDKLoginKit
import RxSwift
import RxCocoa

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        FIRApp.configure()
        setupRootViewController()
        return true
    }
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        return FBSDKApplicationDelegate.sharedInstance().application(application, open: url, sourceApplication: sourceApplication, annotation: annotation)
    }

}

//Navigations
extension AppDelegate {
    
    func setupRootViewController() {
        let main = R.storyboard.main().instantiateInitialViewController()
        window?.rootViewController = main
    }
    
    func baseViewControllerSetup() {
        
        if UserSession.default.user != nil {
           
        }
    }
}

