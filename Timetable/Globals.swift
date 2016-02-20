//
//  Globals.swift
//  Timetable
//
//  Created by Sergey Rump (SPHERE) on 20.02.2016.
//  Copyright © 2016 spbstu. All rights reserved.
//

import Foundation

extension NSDate
{
    var year:Int{
        return NSCalendar.currentCalendar().component(NSCalendarUnit.Year, fromDate: self)}
    var nextYear:Int{return self.year+1}
    var prevYear:Int{return self.year-1}
}