//
//  Settings.swift
//  Timetable
//
//  Created by Sergey Rump on 02.03.2016.
//  Copyright © 2016 spbstu. All rights reserved.
//

import Foundation
class Settings
{
    static let instance=Settings()
    static var i:Settings{return instance}
    let bundle=NSBundle.mainBundle().objectForInfoDictionaryKey("CFBundleIdentifier")!
    let defaults = NSUserDefaults.standardUserDefaults()
    func key(k:String)->String{return "\(bundle).\(k)"}
    
    var showNotifications:Bool{
        get{
            return defaults.boolForKey(key("showNotifications"))
        }
        set{
            defaults.setBool(newValue, forKey:key("showNotifications"))
        }
    }
    var showNotificationOnUpdate:Bool{
        get{
            return defaults.boolForKey(key("showNotificationOnUpdate"))
        }
        set{
            defaults.setBool(newValue, forKey:key("showNotificationOnUpdate"))
        }
    }
    var firstLaunch:Bool{
        get{
            return !defaults.boolForKey(key("firstLaunch"))
        }
        set{
            defaults.setBool(!newValue, forKey:key("firstLaunch"))
        }
    }
    func reset()
    {
        if(firstLaunch)
        {
            showNotifications=true
            showNotificationOnUpdate=false
            firstLaunch=false
        }
    }
    init()
    {
       reset()
    }
}