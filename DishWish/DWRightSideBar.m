//
//  DWRightSideBar.m
//  DishWish
//
//  Created by Will on 6/3/14.
//  Copyright (c) 2014 DishWish. All rights reserved.
//

#import "DWRightSideBar.h"

@implementation DWRightSideBar

@synthesize savedLists = _savedLists;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.savedLists = [[NSMutableArray alloc] init];
        self.backgroundColor = [UIColor whiteColor];
        
        NSUInteger wd = [[UIScreen mainScreen] bounds].size.width;
        wd = (wd * 3) / 4;
        UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, wd, 40)];
        headerLabel.text = @"Shared Lists";
        [self addSubview:headerLabel];
        
        UISwipeGestureRecognizer *recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(close)];
        [recognizer setDirection:(UISwipeGestureRecognizerDirectionRight)];
        [self addGestureRecognizer:recognizer];
    }
    return self;
}

-(void)addList:(SavedList *)list
{
    [self.savedLists addObject:list];
    
    NSString *dateDiff = @"";
    if(![list.createdAt isMemberOfClass:[NSNull class]])
    {
        NSTimeInterval secondsBetween = [[NSDate date] timeIntervalSinceDate:list.createdAt];
        if(secondsBetween > 600000)
        {
            return;
        }
        else if(secondsBetween > 86400)
        {
            dateDiff = [NSString stringWithFormat:@"%d days ago", (int)secondsBetween / 86400];
        }
        else if(secondsBetween > 3600)
        {
            dateDiff = [NSString stringWithFormat:@"%d hours ago", (int)secondsBetween / 3600];
        }
        else
        {
            dateDiff = [NSString stringWithFormat:@"%d minutes ago", ((int)secondsBetween / 60) + 1];
        }
    }
    NSString *title = @"";
    if([list.fromUserName isMemberOfClass:[NSNull class]] || [list.fromUserName length] <= 0)
        title = [NSString stringWithFormat:@"Sent to %@    %@", list.toUserName, dateDiff];
    else
        title = [NSString stringWithFormat:@"Recieved from %@    %@", list.fromUserName, dateDiff];
    
    
    NSUInteger wd = [[UIScreen mainScreen] bounds].size.width;
    wd = (wd * 3) / 4;
    
    NSUInteger i = self.savedLists.count;

    NSDate *now = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterShortStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    //NSLog(@"%@",[formatter stringFromDate:now]);
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button addTarget:self action:@selector(listClicked:) forControlEvents:UIControlEventTouchUpInside];
    [button setTitle:title forState:UIControlStateNormal];
    button.frame = CGRectMake(0, (i * 40) + 10, wd, 40);
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    button.contentEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    button.tag = i;
    [self addSubview:button];
    
    UIView *bottomBorder = [[UIView alloc] initWithFrame:CGRectMake(0, button.frame.size.height - 1.0f, button.frame.size.width, 1)];
    bottomBorder.backgroundColor = [UIColor colorWithRed:242.0/255.0 green:242.0/255.0 blue:242.0/255.0 alpha:1.0];
    [button addSubview:bottomBorder];
    
}

-(void)listClicked:(id)sender
{
    [self close];
    
    UIButton *button = (UIButton *)sender;
    SavedList *savedList = self.savedLists[button.tag];
    
    //TODO SET List to saved places list
    
    /*
    [[Session sessionVariables] setObject:places forKey:@"yesPlaces"];
    
    NSArray *views = self.superview.subviews;
    for(id subview in views) {
        if([subview isMemberOfClass:[DWLeftSideBar class]]) {
            DWLeftSideBar *left = (DWLeftSideBar *)subview;
            [left updateLeftSideBar];
        }
    }
    */
}

-(void)close {
    NSUInteger ht = [[UIScreen mainScreen] bounds].size.height;
    NSUInteger wd = [[UIScreen mainScreen] bounds].size.width;
    
    [UIView animateWithDuration:0.2
             animations:^{
                 self.frame = CGRectMake(wd, 60, (wd * 3) / 4, ht - 60);
             }
             completion:^(BOOL finished) {
                 //[self setContentOffset:CGPointZero];
             }
     ];
    
}






/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */

@end
