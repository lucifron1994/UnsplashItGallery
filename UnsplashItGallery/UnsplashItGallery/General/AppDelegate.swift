//
//  AppDelegate.swift
//  UnsplashItGallery
//
//  Created by WangHong on 15/12/30.
//  Copyright © 2015年 WangHong. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    fileprivate var blueView: UIImageView!
    fileprivate var redView: UIImageView!
    fileprivate var purpleView: UIImageView!
    fileprivate let animationDuration = 0.8
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey : Any]? = nil) -> Bool {
        
        self.window?.backgroundColor = UIColor.black
        self.window?.makeKeyAndVisible()
        
        prepareForAnimation()
        runAnimation()
        
        return true
    }
    
    func prepareForAnimation(){
        let originalFrame = CGRect(x: -kWidth/2, y: 0, width: kWidth, height: kHeight)
        
        redView = UIImageView(frame: originalFrame)
        redView.contentMode = .scaleAspectFill
        redView.image = UIImage(named: "redPart")
        self.window?.addSubview(redView)
        
        purpleView = UIImageView(frame: originalFrame)
        purpleView.contentMode = .scaleAspectFill
        purpleView.image = UIImage(named: "purplePart")
        self.window?.addSubview(purpleView)
        
        
        blueView = UIImageView(frame: originalFrame)
        blueView.contentMode = .scaleAspectFill
        blueView.image = UIImage(named: "bluePart")
        self.window?.addSubview(blueView)
        
        
    }

    func runAnimation(){
        UIView.animate(withDuration: animationDuration, animations: { () -> Void in
            self.redView.frame = CGRect(x: 0, y: 0, width: kWidth*2, height: kHeight)
            self.redView.alpha = 0
            self.purpleView.frame = CGRect(x: -kWidth, y: 0, width: kWidth*2, height: kHeight)
            self.purpleView.alpha = 0
            self.blueView.frame = CGRect(x: -kWidth/2, y: kHeight, width: kWidth*2, height: kHeight)
            self.blueView.alpha = 0
            
            self.window?.backgroundColor = UIColor.white
            
            }) { (bool) -> Void in
            self.redView.removeFromSuperview()
            self.purpleView.removeFromSuperview()
            self.blueView.removeFromSuperview()
        }
    }
    
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

