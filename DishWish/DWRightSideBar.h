//
//  DWRightSideBar.h
//  DishWish
//
//  Created by Will on 6/20/14.
//  Copyright (c) 2014 DishWish. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Place.h"
#import "Session.h"
#import "SavedList.h"
#import "MBProgressHUD.h"
#import "DWPreviousSideBar.h"

@interface DWRightSideBar : UIScrollView

@property (nonatomic, strong) UIButton *shareButton;
@property (nonatomic, strong) NSMutableArray *people;
@property (nonatomic, strong) UIView *topBackground;
@property (nonatomic, strong) UIView *topBorder;


-(void)addPerson:(NSDictionary *)person;
-(void)close;

@end
