//
//  User.h
//  DishWish
//
//  Created by Will on 6/20/14.
//  Copyright (c) 2014 DishWish. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WindowsAzureMobileServices/WindowsAzureMobileServices.h>
#import "QSAzureService.h"
#import "Session.h"
#import "AppDelegate.h"

@interface User : NSObject

@property (nonatomic, copy) NSString *deviceId;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *pushDeviceToken;
@property (nonatomic, copy) NSString *facebookId;
@property (nonatomic, copy) NSString *phoneNumber;
@property (nonatomic, copy) NSDate *lastSignedIn;


+(void)login:(QSCompletionBlock)completion;
-(void)add:(QSCompletionBlock)completion;
-(void)update:(QSCompletionBlock)completion;

+(void)getByPhoneNumber:(NSString *)phoneNumber completion:(QSCompletionBlock)completion;
/*
+(void)newPhoneNumber:(NSString *)phoneNumber completion:(QSCompletionBlock)completion;
*/
@end
