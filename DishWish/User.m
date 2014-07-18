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
@synthesize name = _name;
@synthesize pushDeviceToken = _pushDeviceToken;
@synthesize facebookId = _facebookId;
@synthesize phoneNumber = _phoneNumber;
@synthesize lastSignedIn = _lastSignedIn;

- (id)init:(NSDictionary *)user {
	self = [super init];
	if (self) {
        self.deviceId = [user valueForKey:@"id"];
        self.name = [user objectForKey:@"name"];
        self.pushDeviceToken = [user objectForKey:@"pushdevicetoken"];
        self.facebookId = [user valueForKey:@"facebookid"];
        self.phoneNumber = [user valueForKey:@"phonenumber"];
        self.lastSignedIn = [user objectForKey:@"lastsignedin"];
    }
	return self;
}

+(void)login:(QSCompletionBlock)completion
{
    NSString *deviceId = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSString *pushDeviceToken = appDelegate.deviceToken;
    
    [self get:deviceId pushDeviceToken:pushDeviceToken completion:^(User *user) {
        
        if(user != nil && user.deviceId != nil)
        {
            user.pushDeviceToken = pushDeviceToken;
            NSDate *timeStamp = [NSDate date];
            user.lastSignedIn = timeStamp;
            
            [user update:^(User *newUser) {
                [[Session sessionVariables] setObject:newUser forKey:@"currentUser"];
                completion(newUser);
            }];
        }
        else
        {
            NSDate *timeStamp = [NSDate date];
            NSDictionary *newUserDict = @{@"id" : @"", @"name" : @"", @"pushdevicetoken" : pushDeviceToken, @"facebookid" : @"", @"phonenumber" : @"",  @"lastsignedin" : timeStamp };
            User *newUser = [[User alloc] init:newUserDict];
            
            [newUser add:^(User *addedUser) {
                [[Session sessionVariables] setObject:addedUser forKey:@"currentUser"];
                completion(addedUser);
            }];
        }
    }];
}

+(void)get:(id)deviceId pushDeviceToken:(NSString *)pushDeviceToken completion:(QSCompletionBlock)completion
{
    QSAzureService *service = [QSAzureService defaultService:@"Users"];
    NSString *whereStatement = @"";
    if([pushDeviceToken length] > 0)
        whereStatement = [NSString stringWithFormat:@"id = '%@' OR pushdevicetoken = '%@'", deviceId, pushDeviceToken];
    else
        whereStatement = [NSString stringWithFormat:@"id = '%@'", deviceId];
    
    [service getByWhere:whereStatement completion:^(NSArray *results) {
        for(id item in results) {
            User *user = [[User alloc] init:item];
            completion(user);
            return;
        }
        completion(nil);
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

/*
+(void)newDevice:(QSCompletionBlock)completion
{
    QSAzureService *service = [QSAzureService defaultService:@"Users"];
    
    NSString *deviceId = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    NSString *timestamp = [NSString stringWithFormat:@"%f",[[NSDate date] timeIntervalSince1970] * 1000];
    
    NSDictionary *device = @{@"id" : deviceId, @"facebookid" : @"", @"phonenumber" : @"", @"lastsignedin" : timestamp };
    [service addItem:device completion:^(NSDictionary *item)
     {
         User *user = [[User alloc] init:item];
         completion(user);
     }];
}
*/
/*
+(void)newPhoneNumber:(NSString *)phoneNumber completion:(QSCompletionBlock)completion
{
    QSAzureService *service = [QSAzureService defaultService:@"Users"];
    
    NSDictionary *user = @{@"facebookid" : @"", @"phonenumber" : phoneNumber };
    [service addItem:user completion:^(NSDictionary *item)
     {
         User *user = [[User alloc] init:item];
         completion(user);
     }];
}
*/

-(void)add:(QSCompletionBlock)completion
{
    NSString *deviceId = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    
    QSAzureService *service = [QSAzureService defaultService:@"Users"];
    
    NSDictionary *user = @{@"id" : deviceId, @"name" : self.name, @"pushdevicetoken" : self.pushDeviceToken, @"facebookid" : self.facebookId, @"phonenumber" : self.phoneNumber,  @"lastsignedin" : self.lastSignedIn };
    [service addItem:user completion:^(NSDictionary *item)
     {
         User *user = [[User alloc] init:item];
         completion(user);
     }];
}

-(void)update:(QSCompletionBlock)completion
{
    QSAzureService *service = [QSAzureService defaultService:@"Users"];
    
    NSDictionary *user = @{@"id" : self.deviceId, @"name" : self.name, @"pushdevicetoken" : self.pushDeviceToken, @"facebookid" : self.facebookId, @"phonenumber" : self.phoneNumber,  @"lastsignedin" : self.lastSignedIn };
    [service updateItem:user completion:^(NSDictionary *item)
     {
         User *user = [[User alloc] init:item];
         completion(user);
     }];
}

@end
