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
@synthesize phoneNumber = _phoneNumber;
@synthesize lastSignedIn = _lastSignedIn;

- (id)init:(NSDictionary *)user {
	self = [super init];
	if (self) {
            self.deviceId = [user valueForKey:@"id"];
            self.facebookId = [user valueForKey:@"facebookid"];
            self.phoneNumber = [user valueForKey:@"phonenumber"];
            self.lastSignedIn = [user valueForKey:@"lastsignedin"];
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
    QSAzureService *service = [QSAzureService defaultService:@"Users"];
    [service get:deviceId completion:^(NSDictionary *item) {
        
        User *user = [[User alloc] init:item];
        completion(user);
    }];
}

+(void)getByPhoneNumber:(NSString *)phoneNumber completion:(QSCompletionBlock)completion
{
    QSAzureService *service = [QSAzureService defaultService:@"Users"];
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    
    [params setValue:@"Users" forKey:@"tablename"];
    [params setValue:@"phonenumber" forKey:@"columnname"];
    
    [params setValue:[NSString stringWithFormat:@"%@", phoneNumber] forKey:@"columnval"];
    
    [service getByColumn:params completion:^(NSArray *results)  {
        for(id item in results) {
            User *user = [[User alloc] init:item];
            completion(user);
            return;
        }
        completion(nil);
    }];
}

+(void)newDevice:(QSCompletionBlock)completion
{
    QSAzureService *service = [QSAzureService defaultService:@"Users"];
    
    NSString *deviceId = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    NSDictionary *device = @{@"id" : deviceId, @"facebookid" : @"", @"phonenumber" : @"", @"lastsignedin" : @"" };
    [service addItem:device completion:^(NSDictionary *item)
     {
         User *user = [[User alloc] init:item];
         completion(user);
     }];
}

@end
