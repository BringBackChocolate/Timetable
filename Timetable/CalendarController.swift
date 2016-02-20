//
//  CalendarController.swift
//  Timetable
//
//  Created by Sergey Rump (SPHERE) on 20.02.2016.
//  Copyright © 2016 spbstu. All rights reserved.
//

import Foundation
import EPCalendarPicker
class CalendarController : NSObject,EPCalendarPickerDelegate
{
    var calendarPicker = EPCalendarPicker(startYear:NSDate().prevYear,
                                          endYear:NSDate().nextYear,
                                          multiSelection:false,selectedDates:nil)
    static let instance=CalendarController()
    func showCalendar(sender:UIViewController)
    {
        calendarPicker.calendarDelegate = self
        calendarPicker.multiSelectEnabled=false
        let navigationController = UINavigationController(rootViewController: calendarPicker)
        sender.presentViewController(navigationController, animated: true, completion: nil)
    }
    
    func epCalendarPicker(_: EPCalendarPicker, didCancel error : NSError)
    {
        
    }
    func epCalendarPicker(_: EPCalendarPicker, didSelectDate date : NSDate)
    {
        print(date)
        
        calendarPicker = EPCalendarPicker(startYear:NSDate().prevYear,
            endYear:NSDate().nextYear,
            multiSelection:false,selectedDates:nil)
    }
    func epCalendarPicker(_: EPCalendarPicker, didSelectMultipleDate dates : [NSDate]){}
}