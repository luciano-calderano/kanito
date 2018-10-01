//
//  AppDelegate.swift
//  Kanito
//
//  Created by Luciano Calderano on 10/11/16.
//  Copyright © 2016 it.kanito. All rights reserved.
//

import UIKit
import FacebookCore

@UIApplicationMain

class AppDelegate: UIResponder, UIApplicationDelegate { //, GIDSignInDelegate {
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        self.userConfig()
//        FIRApp.configure()
    /// Fb
        SDKApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)
        return true
    }
    
     /// Google
    func application(_ application: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any])
        -> Bool {
            SDKApplicationDelegate.shared.application(application, open: url, options: options)

            GIDSignIn.sharedInstance().handle(url, sourceApplication:options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String, annotation: [:])
            return true
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        self.userConfig()
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
//        AppEventsLogger.activate(application)
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
    }

    func applicationWillTerminate(_ application: UIApplication) {
    }
    
    private func userConfig () {
        LanguageClass.shared.selectLanguage()
        self.checkCache()
    }
    
    private func checkCache () {
        let settingsKey = "settings.clearCache"
        var forceClear = false
        if UserDefaults.standard.bool(forKey: settingsKey) == true {
            forceClear = true
            UserDefaults.standard.set(false, forKey: settingsKey)
        }
        PetCachedClass.shared.checkCache(forceClear: forceClear)
        KActivity.shared.load(forceClear: forceClear)
//        Activities.shared.checkCache(forceClear: forceClear)
    }
}

