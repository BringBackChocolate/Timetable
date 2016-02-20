//
//  Extensions.swift
//  Timetable
//
//  Created by Sergey Rump (SPHERE) on 20.02.2016.
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
        let components = NSCalendar.currentCalendar().components([.Day,.Month,.Year],fromDate:self)
        let dateStr="\(components.year)-\(components.month)-\(components.day)"
        return dateStr
    }
}