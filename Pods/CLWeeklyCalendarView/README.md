#CLWeeklyCalendarView

CLWeeklyCalendarView is a scrollable weekly calendarView for iPhone. It is easy to use and customised.

![alt tag](https://github.com/esusatyo/CLWeeklyCalendarView/blob/master/screenshot.PNG)

## Installation

Manually:

* Drag the `CLWeeklyCalendarViewSource` folder into your project.

If you are using Cocoapods you can use this for the time being:

`pod 'CLWeeklyCalendarView', :git => 'https://github.com/esusatyo/CLWeeklyCalendarView.git'`

## Initialize 

Using CLWeeklyCalendarViewSource in your app will usually look as simple as this :


```objective-c

//Initialize
-(CLWeeklyCalendarView *)calendarView
{
    if(!_calendarView){
        _calendarView = [[CLWeeklyCalendarView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 100)];
        _calendarView.delegate = self;
    }
    return _calendarView;
}

//Add it into parentView
[self.view addSubview:self.calendarView];

```

## Delegate

After the date in the calendar has been selected , following delegate function will be fired

```objective-c
//After getting data callback
-(void)dailyCalendarViewDidSelect:(NSDate *)date
{
    //You can do any logic after the view select the date
}
```

You can delegate to tell the calenderView scrollTo specified date by using following delegate function

```objective-c
- (void)redrawToDate: (NSDate *)dt;
```

## Customisation

**Please be aware customisation method is optional, if u do not apply it, it will just fire the default value.

The following customisation key is allowed:

```
CLCalendarWeekStartDay;    //The Day of weekStart from 1 - 7 - Default: 1
CLCalendarDayTitleTextColor; //Day Title text color,  Mon, Tue, etc label text color
CLCalendarPastDayNumberTextColor;    //Day number text color for dates in the past
CLCalendarFutureDayNumberTextColor;  //Day number text color for dates in the future
CLCalendarCurrentDayNumberTextColor; //Day number text color for today
CLCalendarSelectedDayNumberTextColor;    //Day number text color for the selected day
CLCalendarSelectedCurrentDayNumberTextColor; //Day number text color when today is selected
CLCalendarCurrentDayNumberBackgroundColor;   //Day number background color for today when not selected
CLCalendarSelectedDayNumberBackgroundColor;  //Day number background color for selected day
CLCalendarSelectedCurrentDayNumberBackgroundColor;   //Day number background color when today is selected
CLCalendarSelectedDatePrintFormat;   //Selected Date print format,  - Default: @"EEE, d MMM yyyy"
CLCalendarSelectedDatePrintColor;    //Selected Date print text color -Default: [UIColor whiteColor]
CLCalendarSelectedDatePrintFontSize; //Selected Date print font size - Default : 13.f
CLCalendarBackgroundImageColor;      //BackgroundImage color - Default : see applyCustomDefaults.
```

You need to use this method to apply your customisation:

```objective-c

self.calendarView.calendarAttributes = @{
       CLCalendarBackgroundImageColor : [UIColor lightBackgroundColor],
       
       //Unselected days in the past and future, colour of the text and background.
       CLCalendarPastDayNumberTextColor : [UIColor lightGrayColor],
       CLCalendarFutureDayNumberTextColor : [UIColor lightGrayColor],
       
       CLCalendarCurrentDayNumberTextColor : [UIColor lightGrayColor],
       CLCalendarCurrentDayNumberBackgroundColor : [UIColor clearColor],
       
       //Selected day (either today or non-today)
       CLCalendarSelectedDayNumberTextColor : [UIColor whiteColor],
       CLCalendarSelectedDayNumberBackgroundColor : [UIColor primaryColor],
       CLCalendarSelectedCurrentDayNumberTextColor : [UIColor whiteColor],
       CLCalendarSelectedCurrentDayNumberBackgroundColor : [UIColor primaryColor],
       
       //Day: e.g. Saturday, 1 Dec 2016
       CLCalendarDayTitleTextColor : [UIColor darkGrayColor],
       CLCalendarSelectedDatePrintColor : [UIColor darkGrayColor],
       };

```

If you call `setEnabledDates:` on `CLWeeklyCalendarView`, then it will make only the enabled dates to be selectable in the UI. This is useful if you only have content to show on particular days.

If you use this option, make sure to also set `CLCalendarDisabledDayBackgroundColor` or `CLCalendarDisabledDayTextColor` to indicate to the users that some dates aren't selectable.
