//
//  AppDelegate.swift
//  GCDQueueDemo
//
//  Created by qwer on 2018/3/19.
//  Copyright © 2018年 qwer. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ViewController")
        self.window?.rootViewController = UINavigationController.init(rootViewController: vc)
        
        return true
    }


}

