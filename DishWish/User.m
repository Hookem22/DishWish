//
//  User.m
//  DishWish
//
//  Created by Will on 6/20/14.
//  Copyright (c) 2014 DishWish. All rights reserved.
//

#import "User.h"

@implementation User

@synthesize deviceId = _deviceId;
@synthesize facebookId = _facebookId;

- (id)init:(NSDictionary *)user {
	self = [super init];
	if (self) {
            self.deviceId = [user valueForKey:@"id"];
            self.facebookId = [user valueForKey:@"facebookid"];
    }
	return self;
}

+(void)login:(QSCompletionBlock)completion
{
    NSString *deviceId = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    
    [self get:deviceId completion:^(User *user) {
        
        if(user != nil && user.deviceId != nil)
        {
            completion(user);
        }
        else
        {
            [self newDevice:^(User *user) {
                completion(user);
            }];
        }
    }];
}

+(void)get:(id)deviceId completion:(QSCompletionBlock)completion
{
    QSAzureService *service = [QSAzureService defaultService:@"User"];
    [service get:deviceId completion:^(NSDictionary *item) {
        
        User *user = [[User alloc] init:item];
        completion(user);
    }];
}

+(void)newDevice:(QSCompletionBlock)completion
{
    QSAzureService *service = [QSAzureService defaultService:@"User"];
    
    NSString *deviceId = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    NSDictionary *device = @{@"id" : deviceId, @"facebookid" : @"" };
    [service addItem:device completion:^(NSDictionary *item)
     {
         User *user = [[User alloc] init:item];
         completion(user);
     }];
}

@end
