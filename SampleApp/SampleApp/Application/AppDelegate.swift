//
//  AppDelegate.swift
//  SampleApp
//
//  Created by Aniruddha Das on 23/07/20.
//  Copyright © 2020 Cred. All rights reserved.
//

import UIKit
import StackViewController

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    
    func initialVC() -> UIViewController {
        //Add any custom VC.
        let vc1 = TestVC(position: 0, bgColor: .red)
        let vc2 = TestVC(position: 1, bgColor: .green)
        let vc3 = TestVC(position: 2, bgColor: .blue)
        let vc4 = TestVC(position: 3, bgColor: .gray)
        let vc5 = TestVC(position: 4, bgColor: .purple)
        let vc6 = TestVC(position: 5, bgColor: .brown)
        
        return StackViewController(subViewControllers: [vc1, vc2, vc3, vc4, vc5, vc6])
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.rootViewController = initialVC()
        self.window?.makeKeyAndVisible()
        
        return true
    }
}
