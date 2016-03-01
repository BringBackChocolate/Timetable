//
//  CalendarViewController.swift
//  Timetable
//
//  Created by Sergey Rump on 20.02.2016.
//  Copyright © 2016 SPBSTU. All rights reserved.
//

import UIKit

class CalendarViewController : UIViewController,CLWeeklyCalendarViewDelegate,DDCalendarViewDataSource,DDCalendarViewDelegate
{
    @IBOutlet var weekView:CLWeeklyCalendarView!
    @IBOutlet var eventsView:DDCalendarView!
    @IBOutlet var favButton:UIBarButtonItem!
    var group:Group?
    var dateSelected=NSDate()
    var selectedDayLessons=[Lesson]()
    override func viewDidLoad()
    {
        super.viewDidLoad()
        //self.weekView.autoresizingMask = UIViewAutoresizing.FlexibleWidth;
        self.weekView.selectedDate = NSDate()
        self.weekView.delegate=self
        self.eventsView.showsTomorrow=false
        self.eventsView.showsTimeMarker=true
        if(dateSelected==NSDate()){self.dailyCalendarViewDidSelect(NSDate())}
        dispatch_async(dispatch_get_global_queue(0,0),{
            TTDB.refresh({
                if(self.dateSelected==NSDate())
                {
                    self.dailyCalendarViewDidSelect(NSDate())
                }
            })
        })
        if let g=group{TTDB.cacheGroup(g.id, date:NSDate(),weeks:4)}
        // Do any additional setup after loading the view, typically from a nib.
    }
    func dailyCalendarViewDidSelect(date:NSDate)
    {
        if let group=self.group
        {
            dispatch_async(dispatch_get_global_queue(0,0),{
                self.dateSelected=date
                let shedulde=TTDB.loadLocalSheduldeForGroup(group.id,date:date,onWeb:
                {shedulde in
                    if(date==self.dateSelected)
                    {
                        self.reloadShedulde(shedulde,forDate:date)
                    }
                })
                self.reloadShedulde(shedulde,forDate:date)
            })
        }
    }
    override func viewWillAppear(animated: Bool)
    {
        self.navigationItem.title=group?.name
        if let g=group
        {
            setBarButtonItem(TTDB.groupIsFav(g))
        }
    }
    override func viewDidAppear(animated:Bool)
    {
        if group==nil
        {
            self.navigationController?.popViewControllerAnimated(animated)
        }
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
    var calendarAttributes=[CLCalendarCurrentDayNumberBackgroundColor:UIColor.redColor(),
                            CLCalendarBackgroundImageColor:UIColor.whiteColor(),
                            CLCalendarDayTitleTextColor:UIColor.blackColor(),
                            CLCalendarSelectedDayNumberTextColor:UIColor.whiteColor(),
                            CLCalendarSelectedDayNumberBackgroundColor:UIColor.polytechColor(),
                            CLCalendarFutureDayNumberTextColor:UIColor.blackColor(),
                            CLCalendarSelectedCurrentDayNumberBackgroundColor:UIColor.polytechColor(),
                            CLCalendarSelectedCurrentDayNumberTextColor:UIColor.whiteColor(),
                            CLCalendarPastDayNumberTextColor:UIColor.lightGrayColor()]
    func CLCalendarBehaviorAttributes() -> [NSObject : AnyObject]! {
        return calendarAttributes
    }
    func reloadShedulde(shedulde:Shedulde,forDate date:NSDate)
    {dispatch_async(dispatch_get_global_queue(0,0),{
        let comp=NSCalendar.currentCalendar().components(NSCalendarUnit.Weekday,fromDate:date)
        if let currentDay=shedulde.week?.getDay(comp.weekday)
        {
            self.showLessons(currentDay.lessons)
        }else{self.showLessons(nil)}
        dispatch_async(dispatch_get_main_queue(),{self.eventsView.date=date})
    })}
    func showLessons(l:[Lesson]?)
    {dispatch_async(dispatch_get_main_queue(),{
        if let lessons=l
        {
            self.selectedDayLessons=lessons
            self.eventsView.reloadData()
        }
        else
        {
            self.selectedDayLessons.removeAll()
            self.eventsView.reloadData()
        }
    })}
    func calendarView(view: DDCalendarView, eventsForDay date: NSDate) -> [AnyObject]?
    {
        var events=[DDCalendarEvent]()
        for l in selectedDayLessons
        {
            let event=DDCalendarEvent()
            event.dateBegin=l.start
            event.dateEnd=l.end
            event.title="\(l.name)\n\(l.placeString)\n\(l.teachersString)"
            events.append(event)
        }
        if(events.count>0)
        {dispatch_async(dispatch_get_main_queue(),{
            var dateToScroll=events[0].dateBegin.dateByAddingTimeInterval(-2*3600)
            if dateToScroll.startOfDay == NSDate().startOfDay
            {
                dateToScroll=NSDate()
            }
            view.scrollDateToVisible(dateToScroll, animated:false)
        })}
        return events
    }
    func calendarView(view: DDCalendarView, allowEditingEvent event: DDCalendarEvent)->Bool {return false}
    func calendarView(view:DDCalendarView,viewForEvent event:DDCalendarEvent)->DDCalendarEventView?
    {
        let res=DDCalendarEventView(event:event)
        for v in res.subviews
        {
            v.tintColor=UIColor.whiteColor()
            if let l=v as?UILabel
            {
                l.textColor=UIColor.whiteColor()
            }
        }
        res.backgroundColor=UIColor.polytechColor()
        res.tintColor=UIColor.whiteColor()
        return res;
    }
    @IBAction func favButtonPressed()
    {
        if let g=group
        {
            if(TTDB.groupIsFav(g))
            {
                TTDB.removeBookmark(g)
                setBarButtonItem(false)
            }
            else
            {
                TTDB.addBookmark(g)
                setBarButtonItem(true)
            }
        }
    }
    func setBarButtonItem(state:Bool)
    {
        if(state)
        {
            favButton.image=UIImage(named:"Bookmark-Filled")
        }
        else
        {
            favButton.image=UIImage(named:"Bookmark")
        }
    }
}