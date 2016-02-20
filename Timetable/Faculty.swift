//
//  Faculty.swift
//  Timetable
//
//  Created by Sergey Rump (SPHERE) on 20.02.2016.
//  Copyright © 2016 spbstu. All rights reserved.
//

import Foundation
class Faculty
{
    var id:Int=0
    var abbr:String=""
    var name:String=""
    init(json:JSON)
    {
        if json["id"].isInt
        {
            id=json["id"].asInt!
        }
        if json["name"].isString
        {
            name=json["name"].asString!
        }
        if json["abbr"].isString
        {
            abbr=json["abbr"].asString!
        }
    }
    static func arrayWithJSON(json:JSON)->[Faculty]
    {
        var res=[Faculty]()
        let arr=json["faculties"]
        for (_,obj) in arr
        {
            res.append(Faculty(json:obj))
        }
        return res
    }
}