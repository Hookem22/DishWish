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
#import "Message.h"
#import "PushMessage.h"
#import "MBProgressHUD.h"
#import "DWPreviousSideBar.h"

@interface DWRightSideBar : UIScrollView <UITextFieldDelegate>

@property (nonatomic, strong) UIButton *shareButton;
@property (nonatomic, strong) UITextField *messageTextField;

-(void)addPerson:(User *)user;
-(void)changeIcon:(BOOL)newMessages;
-(void)getMessagesFromDb;
-(void)populateMessages:(NSString *)message;
-(void)close;

@end
