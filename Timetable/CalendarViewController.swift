//
//  CalendarViewController.swift
//  Timetable
//
//  Created by Sergey Rump on 20.02.2016.
//  Copyright © 2016 SPBSTU. All rights reserved.
//

import UIKit
import EPCalendarPicker

class CalendarViewController: UIViewController,EPCalendarPickerDelegate
{
    let calendarPicker = EPCalendarPicker(startYear:NSDate().prevYear, endYear:NSDate().nextYear, multiSelection: false, selectedDates:nil)
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    override func viewDidAppear(animated: Bool)
    {
        super.viewDidAppear(animated)
        showCalendar()
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
    
    func showCalendar()
    {
        let calendarPicker = EPCalendarPicker(startYear: 2015, endYear: 2017, multiSelection: true, selectedDates: nil)
        calendarPicker.calendarDelegate = self
        calendarPicker.multiSelectEnabled=false
        let navigationController = UINavigationController(rootViewController: calendarPicker)
        self.presentViewController(navigationController, animated: true, completion: nil)
    }
    
    func epCalendarPicker(_: EPCalendarPicker, didCancel error : NSError)
    {
        
    }
    func epCalendarPicker(_: EPCalendarPicker, didSelectDate date : NSDate)
    {
        print(date)
    }
    func epCalendarPicker(_: EPCalendarPicker, didSelectMultipleDate dates : [NSDate]){}    
}