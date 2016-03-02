//
//  Settings.swift
//  Timetable
//
//  Created by Sergey Rump (SPHERE) on 02.03.2016.
//  Copyright © 2016 spbstu. All rights reserved.
//

import Foundation
class Settings
{
    static let instance=Settings()
    static var i:Settings{return instance}
    
    var showNotifications:Bool{return true}
    var showNotificationOnUpdate:Bool{return false}
}