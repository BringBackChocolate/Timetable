//
//  Week.swift
//  Timetable
//
//  Created by Sergey Rump (SPHERE) on 04.03.2016.
//  Copyright © 2016 spbstu. All rights reserved.
//

import Foundation
import CoreData

@objc(Week)
class Week: NSManagedObject
{
    static let dateFormatter=NSDateFormatter()
    var days=[Day]()
    // Insert code here to add functionality to your managed object subclass
    convenience init(json:JSON)
    {
        self.init()
        let weekJSON=json["week"]
        Week.dateFormatter.dateFormat="yyyy.MM.dd"
        if weekJSON["is_odd"].isBool
        {
            is_odd=weekJSON["is_odd"].asBool!
        }
        if weekJSON["date_start"].isString
        {
            if let date_start=weekJSON["date_start"].asString
            {
                self.date_start=Week.dateFormatter.dateFromString(date_start)!
            }
        }
        /*if weekJSON["date_end"].isString
        {
            if let date_end=weekJSON["date_end"].asString
            {
                dateEnd=Week.dateFormatter.dateFromString(date_end)!
            }
        }*/
        days=Day.arrayWithJSON(json)
    }
    func getDay(var weekDay:Int)->Day?
    {
        weekDay = weekDay - 1
        if(weekDay<=0)
        {
            weekDay=7
        }
        for day in days
        {
            if day.weekday==weekDay
            {
                return day
            }
        }
        return nil
    }
}
