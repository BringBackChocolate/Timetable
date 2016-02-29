//
//  Group.swift
//  Timetable
//
//  Created by Sergey Rump on 20.02.2016.
//  Copyright © 2016 spbstu. All rights reserved.
//

import Foundation
class Group : Equatable,Hashable,CustomStringConvertible
{
    var id:Int=0
    var name:String=""
    var level:Int=0
    var type:String="common"
    var spec:String=""
    var faculty:Faculty?
    var hashValue:Int{return id}
    
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
    var description:String{return name}
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
}//http://ruz2.spbstu.ru/api/v1/ruz/scheduler/19904?date=2016-02-22
func ==(lhs: Group, rhs: Group)->Bool
{
    return (lhs.id==rhs.id)&&(lhs.name==lhs.name)
}
