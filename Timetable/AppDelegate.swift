//
//  AppDelegate.swift
//  Timetable
//
//  Created by Sergey Rump on 20.02.2016.
//  Copyright © 2016 SPBSTU. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate,UISplitViewControllerDelegate
{
    var window: UIWindow?
    
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool
    {
        if let splitViewController=self.window?.rootViewController as?UISplitViewController
        {
            if splitViewController.collapsed
            {
                let viewControllers = splitViewController.viewControllers
                for controller in viewControllers
                {
                    // PrimaryNavigationController is the navigation controller I use
                    // as the split views master view, which is also set as its delegate
                    // but it could be any UINavigationController that is the
                    // primary controller of the split view
                    if let c=controller as?UINavigationController
                    {
                        if !(c is CalendarNavigationController)
                        {
                            c.popViewControllerAnimated(false)
                        }
                    }
                }
            }
        }
        dispatch_async(dispatch_get_global_queue(0,0),{
            TTDB.refresh()
        })
        // Override point for customization after application launch.
        return true
    }
    
    func applicationWillResignActive(application: UIApplication)
    {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication)
    {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication)
    {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication)
    {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication)
    {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
}

