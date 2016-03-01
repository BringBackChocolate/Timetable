//
//  DDCalendarEventView.m
//  CustomerApp
//
//  Created by Dominik Pich on 25/09/15.
//  Copyright © 2015 Dominik Pich. All rights reserved.
//

#import "DDCalendarEventView.h"
#import "DDCalendarEvent.h"
#import "NSDate+DDCalendar.h"
#import "DDCalendarSingleDayView.h"

@interface DDCalendarEventView ()
@property(nonatomic, strong) DDCalendarEvent *event;
@property(nonatomic, weak) DDCalendarSingleDayView *calendar;

@property(nonatomic, weak) UILabel *label;
@end

@interface DDCalendarSingleDayView (private)
- (CGRect)frameForEvent:(DDCalendarEvent*)event;
@end

@implementation DDCalendarEventView

- (id)initWithEvent:(DDCalendarEvent*)event {
    self = [super initWithFrame:CGRectMake(10, 10, 10, 10)];
    if(self) {
        UILabel *label = [[UILabel alloc] initWithFrame:self.bounds];
        self.label = label;
        self.label.numberOfLines = 0;
        [self addSubview:self.label];

        self.event = event;
        self.activeBackgroundColor=[[UIColor redColor] colorWithAlphaComponent:1];
        self.inactiveBackgroundColor=[self.activeBackgroundColor colorWithAlphaComponent:0.5];
        self.active = NO;
    }
    return self;
}

- (void)layoutSubviews {
    self.label.frame = self.bounds;
}

- (void)setEvent:(DDCalendarEvent *)event {
    _event = event;
    
    assert(event.title.length);
    assert(event.dateBegin);
    assert(event.dateEnd);
    
    self.label.text = [NSString stringWithFormat:@"%@\n\n%@\n%@", event.title, event.dateBegin.stringWithTimeOnly, event.dateEnd.stringWithTimeOnly];
    [self.label sizeToFit];
}

- (void)setActive:(BOOL)active {
    _active = active;
    if(_active) {
        self.backgroundColor = self.activeBackgroundColor;
        self.layer.borderColor = nil;
        self.layer.borderWidth = 0;
    }
    else {
        self.backgroundColor = self.inactiveBackgroundColor;
        self.layer.borderColor = nil;
        self.layer.borderWidth = 0;
    }
}

- (UIView *)draggableView {
    BOOL oldActive = self.active;
    self.active = YES;
    CGRect oldFrame = self.frame;
    self.frame = [self.calendar frameForEvent:self.event];

    UIGraphicsBeginImageContextWithOptions(self.bounds.size, YES, 0);
    [self drawViewHierarchyInRect:self.bounds afterScreenUpdates:YES];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    UIImageView * imageViewForAnimation = [[UIImageView alloc] initWithImage:image];
    imageViewForAnimation.backgroundColor = self.backgroundColor;

    self.active = oldActive;
    self.frame = oldFrame;
    
    return imageViewForAnimation;
}
-(void) setActiveBackgroundColor:(UIColor *)activeBackgroundColor
{
    if(activeBackgroundColor==NULL){return;}
    _activeBackgroundColor=activeBackgroundColor;
}
-(void) setInactiveBackgroundColor:(UIColor *)inactiveBackgroundColor
{
    if(inactiveBackgroundColor==NULL){return;}
    _inactiveBackgroundColor=inactiveBackgroundColor;
}
@end
