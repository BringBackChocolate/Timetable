//
//  Preferences.swift
//  Timetable
//
//  Created by Sergey Rump on 20.02.2016.
//  Copyright © 2016 spbstu. All rights reserved.
//

import Foundation
class Preferences
{
    static let preferences = NSUserDefaults.standardUserDefaults()
    static var group:String
    {
        get
        {
            if let str=preferences.stringForKey("com.spbstu.group")
            {
                return str
            }
            self.group="53504/3"
            return self.group
        }
        set{
            preferences.setObject(newValue,forKey:"com.spbstu.group")
        }
    }
}