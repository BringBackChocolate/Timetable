//
//  Notifier.swift
//  Timetable
//
//  Created by Sergey Rump (SPHERE) on 03.03.2016.
//  Copyright © 2016 spbstu. All rights reserved.
//

import Foundation
class Notifier:LNNotificationAppSettings
{
    static let i=Notifier()
    static var instance:Notifier{return i}
    
    override init()
    {
        super.init()
        //registerting for the notification.
        let app=UIApplication.sharedApplication()
        app.registerUserNotificationSettings(UIUserNotificationSettings(forTypes:[ .Sound, .Alert], categories: nil))
        if let appname=NSBundle.mainBundle().objectForInfoDictionaryKey("CFBundleName") as?String
        {
            LNNotificationCenter.defaultCenter().registerApplicationWithIdentifier("timetable",
                name:appname, icon:UIImage(named:"AppIcon40x40")!, defaultSettings:self)
        }
    }    
    func cancelNotifications()
    {
        UIApplication.sharedApplication().cancelAllLocalNotifications()
    }
    func sheduldeNotificationAt(alertTime:NSDate=NSDate().dateByAddingTimeInterval(10.0),
        title:String="!!!",message:String="!!!",
        repeatInterval:NSCalendarUnit = NSCalendarUnit(rawValue:0))
    {
        let app=UIApplication.sharedApplication()
        let notification=UILocalNotification()
        notification.fireDate=alertTime
        notification.repeatInterval=repeatInterval
        notification.alertBody=message
        notification.alertTitle=title
        notification.timeZone=NSTimeZone.defaultTimeZone()
        app.scheduleLocalNotification(notification)
        //app.presentLocalNotificationNow(notification)
    }
    func presentNotification(ln:UILocalNotification)
    {
        let n=LNNotification(title:ln.alertTitle,message:ln.alertBody)
        LNNotificationCenter.defaultCenter().presentNotification(n, forApplicationIdentifier:"timetable")
    }
}