//
//  CalendarViewController.swift
//  Timetable
//
//  Created by Sergey Rump on 20.02.2016.
//  Copyright © 2016 SPBSTU. All rights reserved.
//

import UIKit
import EPCalendarPicker

class CalendarViewController : UIViewController,CLWeeklyCalendarViewDelegate
{
    @IBOutlet var weekView:CLWeeklyCalendarView!
    override func viewDidLoad()
    {
        super.viewDidLoad()
        //self.weekView.autoresizingMask = UIViewAutoresizing.FlexibleWidth;
        self.weekView.selectedDate = NSDate()
        self.weekView.delegate=self
        TTDB.refresh({
            if let group=TTDB.findGroup(Preferences.group)
            {
                TTDB.loadSheduldeForGroup(group.id)
            }
        })
        // Do any additional setup after loading the view, typically from a nib.
    }
    func dailyCalendarViewDidSelect(date:NSDate)
    {
        if let group=TTDB.findGroup(Preferences.group)
        {
            TTDB.loadSheduldeForGroup(group.id,date:date)
        }
    }
    override func viewDidAppear(animated: Bool)
    {
        self.navigationController?.setNavigationBarHidden(false,animated:animated)
        super.viewDidAppear(animated)
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
    func CLCalendarBehaviorAttributes() -> [NSObject : AnyObject]! {
        return [CLCalendarCurrentDayNumberBackgroundColor:UIColor.redColor()]
    }
}