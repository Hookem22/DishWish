//
//  DWRightSideBar.m
//  DishWish
//
//  Created by Will on 6/3/14.
//  Copyright (c) 2014 DishWish. All rights reserved.
//

#import "DWRightSideBar.h"
#import "DWView.h"

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
    [self.subviews makeObjectsPerformSelector: @selector(removeFromSuperview)];
    
    [self.savedLists insertObject:list atIndex:0];
    [self populateLists];
}

-(void)addAllList:(NSArray *)listArray
{
    [self.subviews makeObjectsPerformSelector: @selector(removeFromSuperview)];
    
    self.savedLists = [[NSMutableArray alloc] initWithArray:listArray];
    [self populateLists];
}

-(void) populateLists
{
    /*
    NSUInteger wd = [[UIScreen mainScreen] bounds].size.width;
    wd = (wd * 3) / 4;
    
    UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, wd, 40)];
    headerLabel.text = @"Shared Lists";
    [self addSubview:headerLabel];
    
    NSUInteger i = 0;
    for(SavedList *list in self.savedLists)
    {
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
            title = [NSString stringWithFormat:@"To %@    %@", list.toUserName, dateDiff];
        else
            title = [NSString stringWithFormat:@"From %@    %@", list.fromUserName, dateDiff];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [button addTarget:self action:@selector(listClicked:) forControlEvents:UIControlEventTouchUpInside];
        [button setTitle:title forState:UIControlStateNormal];
        button.frame = CGRectMake(0, (i * 40) + 30, wd, 40);
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        button.contentEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
        button.tag = i;
        [self addSubview:button];
        
        UIView *bottomBorder = [[UIView alloc] initWithFrame:CGRectMake(0, button.frame.size.height - 1.0f, button.frame.size.width, 1)];
        bottomBorder.backgroundColor = [UIColor colorWithRed:242.0/255.0 green:242.0/255.0 blue:242.0/255.0 alpha:1.0];
        [button addSubview:bottomBorder];
        
        i++;
        
        self.contentSize = CGSizeMake(wd, (i * 40) + 60);
    }
     */
}

-(void)listClicked:(id)sender
{
    /*
    [self close];
    
    [MBProgressHUD showHUDAddedTo:self.superview animated:YES];
    
    UIButton *button = (UIButton *)sender;
    SavedList *savedList = self.savedLists[button.tag];
    
    [SavedList getByPlaceIds:savedList.placeIds completion:^(NSArray *places) {
       
        
        DWView *dwView = (DWView *)self.superview;

        [[Session sessionVariables] setObject:places forKey:@"Places"];
        [dwView loadDraggableCustomView:places];

        
        [[Session sessionVariables] setObject:places forKey:@"yesPlaces"];
        
        NSArray *views = self.superview.subviews;
        for(id subview in views) {
            if([subview isMemberOfClass:[DWLeftSideBar class]]) {
                DWLeftSideBar *left = (DWLeftSideBar *)subview;
                [left updateLeftSideBar];
            }
        }
        
        [MBProgressHUD hideHUDForView:self.superview animated:YES];
        
    }];
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
