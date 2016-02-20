//
//  TTDB.swift
//  Timetable
//
//  Created by Sergey Rump (SPHERE) on 20.02.2016.
//  Copyright © 2016 spbstu. All rights reserved.
//

import Foundation

class TTDB
{
    static let facultiesURL=NSURL(string:"http://ruz2.spbstu.ru/api/v1/ruz/faculties/")!
    static func groupsURL(facId:Int)->NSURL
    {
        return NSURL(string:"\(facultiesURL.absoluteString)/\(facId)/groups")!
    }
    static func groupURL(id:Int)->NSURL
    {
        return NSURL(string:"http://ruz2.spbstu.ru/api/v1/ruz/scheduler/\(id)")!
    }
    static var groups=Set<Group>()
    static var faculties=[Faculty]()
    
    static let fileManager=NSFileManager.defaultManager()
    static func stringWithContentsOfURL(url:NSURL)->String?
    {
        if let data=NSData(contentsOfURL:url)
        {
            if let string=String(data:data, encoding:NSWindowsCP1251StringEncoding)
            {
                return string
            }
            if let string=String(data:data, encoding:NSUTF8StringEncoding)
            {
                return string
            }
        }
        return nil;
    }
    static func jsonFromURL(url:NSURL)->JSON?
    {
        if let jsonString=stringWithContentsOfURL(url)
        {
            let json=JSON(string:jsonString)
            return json
        }
        return nil
    }
    static func loadFaculties()->[Faculty]
    {
        if let json=jsonFromURL(facultiesURL)
        {
            saveIfNeeded(json,file:"faculties.json")
            return Faculty.arrayWithJSON(json)
        }
        if let json=jsonFromFile("faculties.json")
        {
            return Faculty.arrayWithJSON(json)
        }
        return [Faculty]()
    }
    static func loadFaculty(id:Int)->[Group]
    {
        if let json=jsonFromURL(groupsURL(id))
        {
            saveIfNeeded(json,file:"groups\(id).json")
            return Group.arrayWithJSON(json)
        }
        if let json=jsonFromFile("groups\(id).json")
        {
            return Group.arrayWithJSON(json)
        }
        return [Group]()
    }
    static func loadSheduldeForGroup(id:Int)->Shedulde
    {
        if let json=jsonFromURL(groupURL(id))
        {
            saveIfNeeded(json,file:"g\(id).json")
            return Shedulde(json:json)
        }
        if let json=jsonFromFile("g\(id).json")
        {
            return Shedulde(json:json)
        }
        return Shedulde(json:JSON("{}"))
    }

    
    static func findGroup(name:String)->Group?
    {
        for g in groups
        {
            if(g.name == name)
            {
                return g
            }
        }
        return nil
    }
    
    
    
    
    static func saveIfNeeded(json:JSON,file:String)
    {
        let str="\(json)"
        if let oldStr=loadFromFile(file)
        {
            if str==oldStr{return}
        }
        save(str,toFile:file)
    }
    static var documentsFolder:String
    {
        let paths=NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true);
        let documents=paths.first!
        if !fileManager.fileExistsAtPath(documents)
        {
            do{
                try fileManager.createDirectoryAtPath(documents,withIntermediateDirectories:true, attributes:[:])
            }catch let e {print("\(e)")}
        }
        return  documents;
    }
    static func document(file:String)->String{return "\(documentsFolder)/\(file)"}
    static func save(string:String,toFile file:String)
    {
        do{try string.writeToFile(document(file),atomically:true,encoding:NSUTF8StringEncoding)}
        catch let e {print("\(e)")}
    }
    static func loadFromFile(file:String)->String?
    {
        do{return try String(contentsOfFile:document(file))}
        catch let e {print("\(e)")}
        return nil
    }
    static func jsonFromFile(file:String)->JSON?
    {
        if let jsonString=loadFromFile(file)
        {
            let json=JSON(string:jsonString)
            return json
        }
        return nil
    }
    static func refresh(onEnd:dispatch_block_t={})
    {
        loadCache()
        let group = dispatch_group_create()
        dispatch_group_async(group,dispatch_get_global_queue(0, 0),{
            faculties=loadFaculties()
            for fac in faculties
            {dispatch_group_async(group,dispatch_get_global_queue(0, 0),{
                let arr=loadFaculty(fac.id)
                for g in arr
                {
                    groups.insert(g)
                }
            })}
        })
        dispatch_group_notify(group,dispatch_get_global_queue(0,0),onEnd)
    }
    static func loadCache()
    {
        if let facJSON=jsonFromFile("faculties.json")
        {
            faculties=Faculty.arrayWithJSON(facJSON)
            for fac in faculties
            {
                let arr=loadFaculty(fac.id)
                for g in arr
                {
                    groups.insert(g)
                }
            }
        }
    }
}