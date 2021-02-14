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
    private var ref : DatabaseReference!
    private var versionFromFB : String?
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        sleep(1)
        FirebaseApp.configure()
        
        ref = Database.database().reference()
        
        let sd = UserDefaults.standard

        //If firstTime
        let didLaunchBefore = sd.bool(forKey: "firstTime")
        if !didLaunchBefore {
            sd.setValue(true, forKey: "firstTime")
            self.getDataFromFirebase()
            do {
                try sd.setObject([CourseVO](), forKey: "course")
            }
            catch {
                print(error.localizedDescription)
            }
        }
        let version = sd.string(forKey: "version")
        ref.child("version").observeSingleEvent(of: .value, with: { snapshot in
            self.versionFromFB = snapshot.value as? String
            //If version is different
            if version != self.versionFromFB {
                self.getDataFromFirebase()
            }
        })
        
//        if version != versionFromFB {
//            self.getDataFromFirebase()
//        }
        return true
    }
    
    private func getDataFromFirebase() {
        let sd = UserDefaults.standard
        ref.child("all_courses").observeSingleEvent(of: .value, with: { snapshot in
            let value = snapshot.value as? [NSDictionary]
            sd.set(value, forKey: "all_courses")
        }) { error in
            print("Error in getting courses JSON: \(error.localizedDescription)")
        }
        ref.child("calendar").observeSingleEvent(of: .value, with: { snapshot in
            let value = snapshot.value as? [NSDictionary]
            sd.set(value, forKey: "calendar")
        }) { error in
            print("Error in getting calendar JSON: \(error.localizedDescription)")
        }
        ref.child("phone_number").observeSingleEvent(of: .value, with: { snapshot in
            let value = snapshot.value as? [NSDictionary]
            sd.set(value, forKey: "phone_number")
        }) { error in
            print("Error in getting phone number JSON: \(error.localizedDescription)")
        }
        ref.child("version").observeSingleEvent(of: .value, with: { snapshot in
            let value = snapshot.value as? String
            sd.set(value, forKey: "version")
        }) { error in
            print("Error in getting version number: \(error.localizedDescription)")
        }
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

