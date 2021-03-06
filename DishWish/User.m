//
//  User.m
//  DishWish
//
//  Created by Will on 6/20/14.
//  Copyright (c) 2014 DishWish. All rights reserved.
//

#import "User.h"

@implementation User

@synthesize userId = _userId;
@synthesize deviceId = _deviceId;
@synthesize name = _name;
@synthesize pushDeviceToken = _pushDeviceToken;
@synthesize facebookId = _facebookId;
@synthesize phoneNumber = _phoneNumber;
@synthesize lastSignedIn = _lastSignedIn;

- (id)init {
	self = [super init];
	if (self) {
        self.userId = @"";
        self.deviceId = @"";
        self.name = @"";
        self.pushDeviceToken = @"";
        self.facebookId = @"";
        self.phoneNumber = @"";
        self.lastSignedIn = [NSDate date];
    }
	return self;
}

- (id)init:(NSDictionary *)user {
	self = [super init];
	if (self) {
        self.userId = [user valueForKey:@"id"];
        self.deviceId = [user valueForKey:@"deviceid"];
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
    NSString *pushDeviceToken = appDelegate.deviceToken == nil ? @"" : appDelegate.deviceToken;
    NSString *referralId = appDelegate.queryValue;
    
    [self get:deviceId pushDeviceToken:pushDeviceToken completion:^(User *deviceUser) {
        //0 Users
        if((deviceUser == nil || deviceUser.deviceId.length <= 0) && [referralId length] <= 0) {
            User *newUser = [[User alloc] init];
            newUser.deviceId = deviceId;
            newUser.pushDeviceToken = pushDeviceToken;
            
            [newUser add:^(User *addedUser) {
                [[Session sessionVariables] setObject:addedUser forKey:@"currentUser"];
                completion(addedUser);
            }];
        }
        //1 User - device user
        else if ([referralId length] <= 0)
        {
            if(deviceUser.pushDeviceToken.length <= 0)
            {
                deviceUser.pushDeviceToken = pushDeviceToken;
                
                [deviceUser update:^(User *newUser) {
                    [[Session sessionVariables] setObject:newUser forKey:@"currentUser"];
                    completion(newUser);
                }];
            }
            else
            {
                [[Session sessionVariables] setObject:deviceUser forKey:@"currentUser"];
                completion(deviceUser);
            }
        }
        //1 User - referral user
        else if (deviceUser == nil || deviceUser.deviceId.length <= 0)
        {
            [SavedList getByReferenceId:referralId completion:^(SavedList *savedList) {
                User *referralUser = [[User alloc] init];
                referralUser.userId = savedList.userId;
                referralUser.deviceId = deviceId;
                referralUser.pushDeviceToken = pushDeviceToken;
                
                [referralUser update:^(User *newUser) {
                    [[Session sessionVariables] setObject:newUser forKey:@"currentUser"];
                    completion(newUser);
                }];
            }];
        }
        //2 users - consolidate
        else
        {
            [SavedList getByReferenceId:referralId completion:^(SavedList *savedList) {
                [User get:savedList.userId completion:^(User *referralUser) {
                    savedList.userId = deviceUser.userId;
                    [savedList update:^(SavedList *savedList) {
                    
                        if(deviceUser.phoneNumber.length <= 0 && referralUser.phoneNumber.length > 0)
                        {
                            deviceUser.phoneNumber = referralUser.phoneNumber;
                            [deviceUser update:^(User *newUser) {
                                [referralUser delete];
                                [[Session sessionVariables] setObject:newUser forKey:@"currentUser"];
                                completion(newUser);
                            }];
                        }
                        else if([deviceUser.userId isEqualToString:referralUser.userId])
                        {
                            [[Session sessionVariables] setObject:deviceUser forKey:@"currentUser"];
                            completion(deviceUser);
                        }
                        else
                        {
                            [referralUser delete];
                            [[Session sessionVariables] setObject:deviceUser forKey:@"currentUser"];
                            completion(deviceUser);
                        }
                    }];
                }];
            }];
        }

    }];
    
    /*
    [self get:deviceId pushDeviceToken:pushDeviceToken completion:^(User *user) {
        if(user != nil && user.deviceId.length > 0)
        {
            if(user.pushDeviceToken.length <= 0)
            {
                user.pushDeviceToken = pushDeviceToken;
                
                [user update:^(User *newUser) {
                    [[Session sessionVariables] setObject:newUser forKey:@"currentUser"];
                    completion(newUser);
                }];
            }
            else
            {
                completion(user);
            }
        }
        else
        {
            NSString *referenceId = appDelegate.queryValue;
            
            if([referenceId length] > 0)
            {
                [SavedList getByReferenceId:referenceId completion:^(SavedList *savedList) {
                    User *newUser = [[User alloc] init];
                    newUser.userId = savedList.userId;
                    newUser.deviceId = deviceId;
                    newUser.pushDeviceToken = pushDeviceToken;
                    
                    [newUser update:^(User *addedUser) {
                        [[Session sessionVariables] setObject:addedUser forKey:@"currentUser"];
                        completion(addedUser);
                    }];
                }];
            }
            else
            {
                User *newUser = [[User alloc] init];
                newUser.deviceId = deviceId;
                newUser.pushDeviceToken = pushDeviceToken;
                
                [newUser add:^(User *addedUser) {
                    [[Session sessionVariables] setObject:addedUser forKey:@"currentUser"];
                    completion(addedUser);
                }];
            }
        }
    }];
     */
}

+(void)get:(NSString *)userId completion:(QSCompletionBlock)completion
{
    QSAzureService *service = [QSAzureService defaultService:@"Users"];
    NSString *whereStatement = [NSString stringWithFormat:@"id = '%@'", userId];

    [service getByWhere:whereStatement completion:^(NSArray *results) {
        for(id item in results) {
            User *user = [[User alloc] init:item];
            completion(user);
            return;
        }
        completion(nil);
    }];
}

+(void)get:(id)deviceId pushDeviceToken:(NSString *)pushDeviceToken completion:(QSCompletionBlock)completion
{
    QSAzureService *service = [QSAzureService defaultService:@"Users"];
    NSString *whereStatement = @"";
    if([pushDeviceToken length] > 0)
        whereStatement = [NSString stringWithFormat:@"deviceid = '%@' OR pushdevicetoken = '%@'", deviceId, pushDeviceToken];
    else
        whereStatement = [NSString stringWithFormat:@"deviceid = '%@'", deviceId];
    
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
    
    NSString *whereStatement = [NSString stringWithFormat:@"phonenumber = '%@'", phoneNumber];
    
    [service getByWhere:whereStatement completion:^(NSArray *results)  {
        for(id item in results) {
            User *user = [[User alloc] init:item];
            completion(user);
            return;
        }
        completion(nil);
    }];
}


-(void)add:(QSCompletionBlock)completion
{
   
    
    QSAzureService *service = [QSAzureService defaultService:@"Users"];
    
    NSDictionary *user = @{@"deviceid" : self.deviceId, @"name" : self.name, @"pushdevicetoken" : self.pushDeviceToken, @"facebookid" : self.facebookId, @"phonenumber" : self.phoneNumber,  @"lastsignedin" : self.lastSignedIn };
    [service addItem:user completion:^(NSDictionary *item)
     {
         User *user = [[User alloc] init:item];
         completion(user);
     }];
}

-(void)update:(QSCompletionBlock)completion
{
    QSAzureService *service = [QSAzureService defaultService:@"Users"];
    
    NSDictionary *user = @{@"id" : self.userId, @"deviceid" : self.deviceId, @"name" : self.name, @"pushdevicetoken" : self.pushDeviceToken, @"facebookid" : self.facebookId, @"phonenumber" : self.phoneNumber,  @"lastsignedin" : self.lastSignedIn };
    [service updateItem:user completion:^(NSDictionary *item)
     {
         User *user = [[User alloc] init:item];
         completion(user);
     }];
}

-(void)delete
{
    QSAzureService *service = [QSAzureService defaultService:@"Users"];
    
    [service deleteItem:self.userId completion:^(id itemId)
     {

     }];
}

@end
