//
//  Faculty.swift
//  Timetable
//
//  Created by Sergey Rump (SPHERE) on 04.03.2016.
//  Copyright © 2016 spbstu. All rights reserved.
//

import Foundation
import CoreData

@objc(Faculty)
class Faculty: NSManagedObject
{// Insert code here to add functionality to your managed object subclass
    convenience init(json:JSON)
    {
        self.init()
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
    override var description:String
    {
        if let a=abbr{return a}
        return ""
    }
}
