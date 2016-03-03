//
//  LessonsNotifier.swift
//  Timetable
//
//  Created by Sergey Rump (SPHERE) on 02.03.2016.
//  Copyright © 2016 spbstu. All rights reserved.
//

import Foundation
class LessonsNotifier:LNNotificationAppSettings,BookmarksListener
{
    static let instance=LessonsNotifier()
    var onceToken:dispatch_once_t=0;
    let notificationsBlock={
        if(Settings.i.showNotifications)
        {
            if let myGroup=TTDB.bookmarks.first
            {
                let sh=TTDB.loadSheduldeForGroup(myGroup.id)
                LessonsNotifier.instance.sheduldeNotfications(sh)
                if(Settings.i.showNotificationOnUpdate)
                {
                    LessonsNotifier.instance.sheduldeNotificationAt(NSDate(),
                        title:"Notifications updated",
                        message:":D")
                }
            }
        }
    }
    func updateNotifications()
    {dispatch_once(&onceToken,{
        self.notificationsBlock()
        EVERY_INTERVAL(600,self.notificationsBlock)
    })}
    func onAddBookmark(bookmark: Group){notificationsBlock()}
    func onRemoveBookmark(bookmark: Group){notificationsBlock()}
    override init()
    {
        super.init()
        let app=UIApplication.sharedApplication()
        //let notificationCategory:UIMutableUserNotificationCategory = UIMutableUserNotificationCategory()
        //notificationCategory.identifier = "INVITE_CATEGORY"
        //notificationCategory .setActions([replyAction], forContext: UIUserNotificationActionContext.Default)
        
        //registerting for the notification.
        app.registerUserNotificationSettings(UIUserNotificationSettings(forTypes:[ .Sound, .Alert], categories: nil))
        if let appname=NSBundle.mainBundle().objectForInfoDictionaryKey("CFBundleName") as?String
        {
        LNNotificationCenter.defaultCenter().registerApplicationWithIdentifier("timetable",
            name:appname, icon:UIImage(named:"AppIcon40x40")!, defaultSettings:self)
        }
        TTDB.bookmarksListener=self
    }
    func sheduldeNotfications(shedulde:Shedulde)
    {
        if let week=shedulde.week
        {
            for day in week.days
            {
                for lesson in day.lessons
                {
                    let message=lesson.placeString
                    let title=lesson.name
                    let date=lesson.start
                    if NSDate().dateByAddingTimeInterval(-600).compare(date) == .OrderedAscending
                    {
                        self.sheduldeNotificationAt(date,title:title,message:message)
                    }
                }
            }
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