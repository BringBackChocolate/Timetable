//
//  Globals.swift
//  Timetable
//
//  Created by Sergey Rump on 20.02.2016.
//  Copyright © 2016 spbstu. All rights reserved.
//

import Foundation

extension NSDate
{
    var year:Int{
        return NSCalendar.currentCalendar().component(NSCalendarUnit.Year, fromDate: self)}
    var nextYear:Int{return self.year+1}
    var prevYear:Int{return self.year-1}
    
    var timeString:String
    {
        var hour = 0
        var minute = 0
        let calendar = NSCalendar.currentCalendar()
        calendar.getHour(&hour,minute:&minute,second:nil,nanosecond:nil,fromDate:self)
        if(minute<10)
        {
            return "\(hour):0\(minute)"
        }
        return "\(hour):\(minute)"
    }
}
extension UIColor
{
    static func polytechColor()->UIColor{return UIColor(red:31.0/255, green:179.0/255, blue: 85.0/255, alpha: 1)}
}
func EVERY_INTERVAL(interval:NSTimeInterval,_ block:dispatch_block_t)
{
    let popTime=dispatch_time(DISPATCH_TIME_NOW, Int64(interval*Double(NSEC_PER_SEC)))
    let queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
    dispatch_after(popTime, queue,
        {
            block()
            EVERY_INTERVAL(interval,block)
    });
}