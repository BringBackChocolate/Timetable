//
//  SettingsViewController.swift
//  Timetable
//
//  Created by Sergey Rump on 02.03.2016.
//  Copyright © 2016 spbstu. All rights reserved.
//

import Foundation
class SettingsViewController: TimetableVC
{
    @IBOutlet var notificationsSw:UISwitch!
    @IBOutlet var notificationsOnUpdateSw:UISwitch!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.navigationItem.title="Настройки"
        notificationsSw.on=Settings.i.showNotifications
        notificationsOnUpdateSw.on=Settings.i.showNotificationOnUpdate
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        notificationsSw.on=Settings.i.showNotifications
        notificationsOnUpdateSw.on=Settings.i.showNotificationOnUpdate
    }
    @IBAction func onSettingsChange(sender:AnyObject?)
    {
        Settings.i.showNotifications=notificationsSw.on
        Settings.i.showNotificationOnUpdate=notificationsOnUpdateSw.on
    }
    
    @IBAction func resetSettings(sender:AnyObject?)
    {
        Settings.i.firstLaunch=true
        Settings.i.reset()
        self.navigationController?.popViewControllerAnimated(true)
        let n=LNNotification(title:"Настойки",message:"Настройки были сброшены")
        LNNotificationCenter.defaultCenter().presentNotification(n, forApplicationIdentifier:"timetable")
    }
}