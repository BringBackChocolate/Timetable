//
//  Day.swift
//  Timetable
//
//  Created by Sergey Rump on 20.02.2016.
//  Copyright © 2016 spbstu. All rights reserved.
//

import Foundation
class Shedulde
{
    //var json=JSON("{}")
    
    var week:Week?
    
    init(json:JSON)
    {
        //self.json=json
        //print("\(json)")
        self.week=Week(json:json)
    }
   
}