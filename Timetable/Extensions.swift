//
//  Extensions.swift
//  Timetable
//
//  Created by Sergey Rump on 20.02.2016.
//  Copyright © 2016 spbstu. All rights reserved.
//

import Foundation
extension NSDate
{
    func dateBySettingTime(time:String)->NSDate
    {
        var date=NSDate()
        let hoursStr=time.componentsSeparatedByString(":")[0]
        let minutesStr=time.componentsSeparatedByString(":")[1]
        date=self.dateByAddingTimeInterval(60*60*Double(hoursStr)!)
        date=date.dateByAddingTimeInterval(60*Double(minutesStr)!)
        return date
    }
    var startOfDay: NSDate{return NSCalendar.currentCalendar().startOfDayForDate(self)}
    
    var endOfDay: NSDate?
    {
        let components = NSDateComponents()
        components.day = 1
        components.second = -1
        return NSCalendar.currentCalendar().dateByAddingComponents(components, toDate: startOfDay, options: NSCalendarOptions())
    }
    
    var dateStr:String
    {
        let date=self.startOfWeek
        let components = NSCalendar.currentCalendar().components([.Day,.Month,.Year],fromDate:date)
        let dateStr="\(components.year)-\(components.month)-\(components.day)"
        return dateStr
    }
    var startOfWeek:NSDate
    {
        var beginningOfWeek:NSDate?
        NSCalendar.currentCalendar().rangeOfUnit(.WeekOfYear,
            startDate:&beginningOfWeek,interval: nil, forDate: self)
        return beginningOfWeek!
    }
    var nextWeek:NSDate
    {
       return self.dateByAddingTimeInterval(604800)
    }
}