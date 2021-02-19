//
//  AppDelegate.swift
//  Suni
//
//  Created by 전하성 on 2021/01/20.
//

import UIKit
import Firebase

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var existedCourses : [CourseVO] = []
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
//        for family in UIFont.familyNames {
//            print(UIFont.fontNames(forFamilyName: family))
//        }
        sleep(1)
        FirebaseApp.configure()
        let ud = UserDefaults.standard
        Constant.didLaunchBefore = ud.bool(forKey: "firstTime")
        if !Constant.didLaunchBefore {
            do {
                try ud.setObject([CourseVO](), forKey: "course")
            }
            catch {
                print(error.localizedDescription)
            }

        }        
        return true
    }


    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

}

