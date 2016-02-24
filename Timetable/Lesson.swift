//
//  Subject.swift
//  Timetable
//
//  Created by Sergey Rump on 20.02.2016.
//  Copyright © 2016 spbstu. All rights reserved.
//

import Foundation
class Lesson : CustomStringConvertible
{
    var name=""
    var additionalInfo=""
    var place=""
    var start=NSDate()
    var end=NSDate()
    var teacher=""
    
    init(json:JSON,date:NSDate)
    {
        if json["subject"].isString
        {
            name=json["subject"].asString!
        }
        if json["additional_info"].isString
        {
            additionalInfo=json["additional_info"].asString!
        }
        let auditories=json["auditories"]
        for (_,obj) in auditories
        {
            var room=""
            if obj["name"].isString{room=obj["name"].asString!}
            let building=obj["building"]
            if building["name"].isString
            {
                room="Аудитория \(room) \(building["name"].asString!)"
            }
            place=room
        }
        let teachers=json["teacher"]
        for (_,obj) in teachers
        {
            if obj["full_name"].isString
            {
                teacher=obj["full_name"].asString!
            }
        }
        if json["time_start"].isString
        {
            let timestr=json["time_start"].asString!
            start=date.dateBySettingTime(timestr)
        }
        if json["time_end"].isString
        {
            let timestr=json["time_end"].asString!
            end=date.dateBySettingTime(timestr)
        }
    }
    static func arrayWithJSON(json:JSON,date:NSDate)->[Lesson]
    {
        var res=[Lesson]()
        let arr=json["lessons"]
        for (_,obj) in arr
        {
            res.append(Lesson(json:obj,date:date))
        }
        return res
    }
    var placeString:String{return place}
    var description:String
    {
        return "\(start.timeString)\n\(name)\n\(placeString)"
    }
}