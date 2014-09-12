//
//  DWPreviousSideBar.h
//  DishWish
//
//  Created by Will on 8/26/14.
//  Copyright (c) 2014 DishWish. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Place.h"
#import "Session.h"
#import "SavedList.h"
#import "MBProgressHUD.h"

@interface DWPreviousSideBar : UIScrollView

@property (nonatomic, strong) NSMutableArray *savedLists;

-(void)populateLists:(NSArray *)listArray;

@end
