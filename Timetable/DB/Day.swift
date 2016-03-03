//
//  Day.swift
//  Timetable
//
//  Created by Sergey Rump on 20.02.2016.
//  Copyright © 2016 spbstu. All rights reserved.
//

import Foundation
class Day
{
    var weekday:Int=0
    var date=NSDate()
    var lessons=[Lesson]()
    
    init(json:JSON)
    {
        Week.dateFormatter.dateFormat="yyyy-MM-dd"
        if json["weekday"].isInt
        {
            weekday=json["weekday"].asInt!
        }
        if json["date"].isString
        {
            date=Week.dateFormatter.dateFromString(json["date"].asString!)!
            date=date.startOfDay
        }
        lessons=Lesson.arrayWithJSON(json,date:date)
    }
    static func arrayWithJSON(json:JSON)->[Day]
    {
        var res=[Day]()
        let arr=json["days"]
        for (_,obj) in arr
        {
            res.append(Day(json:obj))
        }
        return res
    }
}