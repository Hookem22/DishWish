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

@interface DWRightSideBar : UIScrollView

@property (nonatomic, strong) NSMutableArray *savedLists;

-(void)addList:(SavedList *)list;

@end
