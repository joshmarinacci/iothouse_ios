//
//  AppDelegate.swift
//  SimpsonsHousePulse
//
//  Created by Josh on 12/27/15.
//  Copyright © 2015 PubNub. All rights reserved.
//

import UIKit
import PubNub

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, PNObjectEventListener {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }
    
    var client: PubNub?
    override init() {
        let configuration = PNConfiguration(
            publishKey: "pub-c-de8f6ece-75ec-49ec-bdd9-b0e9d287a45b",
            subscribeKey: "sub-c-85f8eba0-ad8d-11e5-ae71-02ee2ddab7fe"
        )
        client = PubNub.clientWithConfiguration(configuration)
        super.init()
        client?.addListener(self)
        Swift.print("done setting up pubnub")
        client?.timeWithCompletion({(result,status) -> Void in
            if status == nil {
                print("status is nil we are good")
                print(result.data.timetoken)
            } else {
                print("error", status.category)
            }
        })
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

