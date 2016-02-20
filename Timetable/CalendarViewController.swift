//
//  CalendarViewController.swift
//  Timetable
//
//  Created by Sergey Rump on 20.02.2016.
//  Copyright © 2016 SPBSTU. All rights reserved.
//

import UIKit
import EPCalendarPicker

class CalendarViewController: UIViewController
{
    override func viewDidLoad()
    {
        super.viewDidLoad()
        TTDB.refresh({
            if let group=TTDB.findGroup(Preferences.group)
            {
                TTDB.loadSheduldeForGroup(group.id)
            }
        })
        // Do any additional setup after loading the view, typically from a nib.
    }
    override func viewDidAppear(animated: Bool)
    {
        super.viewDidAppear(animated)
        CalendarController.instance.showCalendar(self)        
    }
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewDidLayoutSubviews()
    {
        super.viewDidLayoutSubviews()
        // Commit frames' updates
    }          
}