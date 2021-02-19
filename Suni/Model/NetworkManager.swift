//
//  NetworkManager.swift
//  Suni
//
//  Created by 전하성 on 2021/02/18.
//

import Network
import UIKit
import Firebase

class NetworkManager {
    
    private var courseRef : DatabaseReference!
    private var calendarRef : DatabaseReference!
    private var phoneRef : DatabaseReference!
    private var verRef : DatabaseReference!
    
    private var versionFromFB : String?
    
    func signInAnonyously (with vc : UIViewController) {
        
        self.courseRef = Database.database().reference()
        self.calendarRef = Database.database(url: "https://suni-f0e4b-calendar.firebaseio.com/").reference()
        self.phoneRef = Database.database(url: "https://suni-f0e4b-pn.firebaseio.com/").reference()
        self.verRef = Database.database(url: "https://suni-f0e4b-ver.firebaseio.com/").reference()
        
        Auth.auth().signInAnonymously(completion: { (authResult, error) in
            if let error = error {
                print("Sign in failed: \(error.localizedDescription)")
                print(error)
            }
            else {
                print("In signInAnonymously Successful")
                let ud = UserDefaults.standard
                //If firstTime
                if !Constant.didLaunchBefore {
                    ud.setValue(true, forKey: "firstTime")
                    print("firstTime Operation")
                    self.getDataFromFirebase(with: vc)
                                        
                }
                else {
                    let version = ud.string(forKey: "version")
                    self.verRef.child("version").observeSingleEvent(of: .value, with: { snapshot in
                        self.versionFromFB = snapshot.value as? String
                        //If version is different
                        if version != self.versionFromFB {
                            print("version updated")
                            self.getDataFromFirebase(with: vc)
                        }
                        else {
                            if let scheduleVC = vc as? ScheduleVC {
                                scheduleVC.isLoaded = true
                                self.courseRef.removeAllObservers()
                                self.calendarRef.removeAllObservers()
                                self.phoneRef.removeAllObservers()
                                self.verRef.removeAllObservers()
                                
                            }
                        }
                    })
                }
            }
            
            
        })
        
    }
    private func getDataFromFirebase(with vc : UIViewController) {
        let ud = UserDefaults.standard
        self.courseRef.child("all_courses").observeSingleEvent(of: .value, with: { snapshot in
            let value = snapshot.value as? [NSDictionary]
            ud.set(value, forKey: "all_courses")
            print("all_courses complete")
            if let scheduleVC = vc as? ScheduleVC {
                scheduleVC.isLoaded = true
            }
        }) { error in
            print("Error in getting courses JSON: \(error.localizedDescription)")
        }
        self.calendarRef.child("calendar").observeSingleEvent(of: .value, with: { snapshot in
            let value = snapshot.value as? [NSDictionary]
            ud.set(value, forKey: "calendar")
            print("calendar complete")
        }) { error in
            print("Error in getting calendar JSON: \(error.localizedDescription)")
        }
        self.phoneRef.child("phone_number").observeSingleEvent(of: .value, with: { snapshot in
            let value = snapshot.value as? [NSDictionary]
            ud.set(value, forKey: "phone_number")
            print("phone_number complete")
        }) { error in
            print("Error in getting phone number JSON: \(error.localizedDescription)")
        }
        self.verRef.child("version").observeSingleEvent(of: .value, with: { snapshot in
            let value = snapshot.value as? String
            ud.set(value, forKey: "version")
            print("version complete")
            
        }) { error in
            print("Error in getting version number: \(error.localizedDescription)")
        }
        self.courseRef.removeAllObservers()
        self.calendarRef.removeAllObservers()
        self.phoneRef.removeAllObservers()
        self.verRef.removeAllObservers()
    }
}
