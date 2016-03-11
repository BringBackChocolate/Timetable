//
//  Group.swift
//  Timetable
//
//  Created by Sergey Rump (SPHERE) on 04.03.2016.
//  Copyright © 2016 spbstu. All rights reserved.
//

import Foundation
import CoreData

@objc(Group)
class Group: NSManagedObject
{

// Insert code here to add functionality to your managed object subclass

    override var hashValue:Int
    {
        if let val=self.id?.hashValue{return val}
        return 0;
    }
    
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
        if json["level"].isInt
        {
            level=json["level"].asInt!
        }
        if json["type"].isString
        {
            type=json["type"].asString!
        }
        if json["spec"].isString
        {
            spec=json["spec"].asString!
        }
        
    }
    static func arrayWithJSON(json:JSON)->[Group]
    {
        var res=[Group]()
        let arr=json["groups"]
        for (_,obj) in arr
        {
            res.append(Group(json:obj))
        }
        return res
    }
    override var description:String
    {
        if let n=name{return n}
        return ""
    }
    var json:JSON
    {
            var dict=[String:AnyObject]()
            dict["id"]=id
            dict["name"]=name
            dict["level"]=level
            dict["type"]=type
            dict["spec"]=spec
            return JSON(dict)
    }
    var jsonString:String
        {
            return json.toString()
    }
}
func ==(lhs: Group, rhs: Group)->Bool
{
    return (lhs.id==rhs.id)&&(lhs.name==lhs.name)
}
