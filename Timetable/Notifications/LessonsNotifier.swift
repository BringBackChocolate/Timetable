//
//  LessonsNotifier.swift
//  Timetable
//
//  Created by Sergey Rump (SPHERE) on 02.03.2016.
//  Copyright © 2016 spbstu. All rights reserved.
//

import Foundation
class LessonsNotifier:BookmarksListener
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
                    Notifier.i.sheduldeNotificationAt(NSDate(),
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
    init()
    {
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
                        Notifier.i.sheduldeNotificationAt(date,title:title,message:message)
                    }
                }
            }
        }
    }    
}