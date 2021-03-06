//
//  Week.swift
//  Timetable
//
//  Created by Sergey Rump on 20.02.2016.
//  Copyright © 2016 spbstu. All rights reserved.
//

import Foundation
class Week
{
    static let dateFormatter=NSDateFormatter()
    
    var isOdd:Bool=false
    var dateStart=NSDate()
    var dateEnd=NSDate()
    var days=[Day]()
    init(json:JSON)
    {
        let weekJSON=json["week"]
        Week.dateFormatter.dateFormat="yyyy.MM.dd"
        if weekJSON["is_odd"].isBool
        {
            isOdd=weekJSON["is_odd"].asBool!
        }
        if weekJSON["date_start"].isString
        {
            if let date_start=weekJSON["date_start"].asString
            {
                dateStart=Week.dateFormatter.dateFromString(date_start)!
            }
        }
        if weekJSON["date_end"].isString
        {
            if let date_end=weekJSON["date_end"].asString
            {
                dateEnd=Week.dateFormatter.dateFromString(date_end)!
            }
        }
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