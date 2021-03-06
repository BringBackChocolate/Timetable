//
//  AppDelegate.swift
//  Timetable
//
//  Created by Sergey Rump on 20.02.2016.
//  Copyright © 2016 SPBSTU. All rights reserved.
//

import UIKit

class TimetableVC : UIViewController
{
    deinit
    {
        NSLog("ARC: \(self).deinit")
    }
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate,UISplitViewControllerDelegate
{
    var window: UIWindow?
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool
    {
        let splitViewController:UISplitViewController? = self.window?.rootViewController as? UISplitViewController
        splitViewController?.delegate = self
        dispatch_async(dispatch_get_global_queue(0,0),{
            TTDB.loadBookmarks()
            LessonsNotifier.instance.updateNotifications()
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
    
    func application(application: UIApplication, didReceiveLocalNotification notification: UILocalNotification)
    {
        if let date=notification.fireDate
        {
            if NSDate().dateByAddingTimeInterval(-600).compare(date) == .OrderedAscending
            {
                Notifier.i.presentNotification(notification)
            }
        }else{Notifier.i.presentNotification(notification)}
    }
    
    func splitViewController(splitViewController: UISplitViewController, collapseSecondaryViewController secondaryViewController: UIViewController, ontoPrimaryViewController primaryViewController: UIViewController) -> Bool {
        if let calendarViewController = (secondaryViewController as? UINavigationController)?.topViewController as? CalendarViewController
        {
            if(calendarViewController.group == nil)
            {
                splitViewController.preferredDisplayMode = .AllVisible
                return true
            }
        }
        splitViewController.preferredDisplayMode = .Automatic
        return false
    }
}
