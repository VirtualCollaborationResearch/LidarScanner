//
//  AppDelegate.swift
//  GLKittutorial
//
//  Created by Mathieu Labbe on 2020-12-28.
//

import UIKit
import SwiftUI
import Firebase
import FirebaseAuth

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        let defaults = UserDefaults.standard
        defaults.removeObject(forKey: "Version")
        FirebaseApp.configure()
        detectForOldUser()
        setDefaultsFromSettingsBundle()
        return true
    }
    
    func detectForOldUser() {
        let auth = Auth.auth()
        if auth.currentUser?.uid != nil {
            print("firebaseuid: ", auth.currentUser!.uid)
        } else {
            auth.signInAnonymously { authResult, error in
                guard let user = authResult?.user else {
                    print("auth error",error.debugDescription)
                    return
                }
                UserDefaults.userId = user.uid
                print("userid: \(user.uid)")
            }
        }
    }
    
    func setDefaultsFromSettingsBundle() {
        
        let plistFiles = ["Root", "Mapping", "Assembling"]
        
        for plistName in plistFiles {
            //Read PreferenceSpecifiers from Root.plist in Settings.Bundle
            if let settingsURL = Bundle.main.url(forResource: plistName, withExtension: "plist", subdirectory: "Settings.bundle"),
                let settingsPlist = NSDictionary(contentsOf: settingsURL),
                let preferences = settingsPlist["PreferenceSpecifiers"] as? [NSDictionary] {

                for prefSpecification in preferences {

                    if let key = prefSpecification["Key"] as? String, let value = prefSpecification["DefaultValue"] {

                        //If key doesn't exists in userDefaults then register it, else keep original value
                        if UserDefaults.standard.value(forKey: key) == nil {

                            UserDefaults.standard.set(value, forKey: key)
                            NSLog("registerDefaultsFromSettingsBundle: Set following to UserDefaults - (key: \(key), value: \(value), type: \(type(of: value)))")
                        }
                    }
                }
            } else {
                NSLog("registerDefaultsFromSettingsBundle: Could not find Settings.bundle")
            }
        }
    }
}
