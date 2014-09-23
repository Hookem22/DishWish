//
//  SharedList.m
//  DishWish
//
//  Created by Will on 7/17/14.
//  Copyright (c) 2014 DishWish. All rights reserved.
//
#import "SavedList.h"

@implementation SavedList

@synthesize listId = _listId;
@synthesize xrefId = _xrefId;
@synthesize userId = _userId;
@synthesize userName = _userName;
@synthesize yesPlaceIds = _yesPlaceIds;
@synthesize noPlaceIds = _noPlaceIds;
@synthesize updatedAt = _updatedAt;
@synthesize createdAt = _createdAt;

- (id)init:(NSDictionary *)savedList {
	self = [super init];
	if (self) {
        self.listId = [savedList valueForKey:@"id"];
        self.xrefId = [[savedList valueForKey:@"xrefid"] isMemberOfClass:[NSNull class]] ? 0 : [[savedList valueForKey:@"xrefid"] longLongValue];
        self.userId = [savedList valueForKey:@"userid"];
        self.userName = [savedList valueForKey:@"username"];
        self.yesPlaceIds = [savedList valueForKey:@"yesplaces"];
        self.noPlaceIds = [savedList valueForKey:@"noplaces"];
        self.updatedAt = [savedList valueForKey:@"__updatedAt"];
        self.createdAt = [savedList valueForKey:@"__createdAt"];
    }
	return self;
}


+(void)get:(NSString *)xrefId completion:(QSCompletionBlock)completion
{
    QSAzureService *service = [QSAzureService defaultService:@"SavedList"];
    User *currentUser = (User *)[Session sessionVariables][@"currentUser"];
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:xrefId forKey:@"xrefid"];
    [params setValue:currentUser.userId forKey:@"userid"];
    
    [service getSavedListByXrefId:params completion:^(NSArray *results)  {
        if(results.count > 0) {
            NSMutableArray *savedLists = [[NSMutableArray alloc] init];
            for(id result in results)
            {
                [savedLists addObject:[[SavedList alloc] init:result]];
            }
            completion(savedLists);
        }
        else
        {
            completion(nil);
        }
    }];
}

+(void)getSpecific:(NSString *)xrefId userId:(NSString *)userId completion:(QSCompletionBlock)completion
{
    QSAzureService *service = [QSAzureService defaultService:@"SavedList"];
    NSString *whereStatement = [NSString stringWithFormat:@"xrefid = '%@' AND userid = '%@'", xrefId, userId];
    
    [service getByWhere:whereStatement completion:^(NSArray *results) {
        for(id item in results) {
            SavedList *list = [[SavedList alloc] init:item];
            completion(list);
            return;
        }
        completion(nil);
    }];
}

+(void)getByPlaceIds:(NSString *)placeIds completion:(QSCompletionBlock)completion
{

    QSAzureService *placeService = [QSAzureService defaultService:@"Place"];
    
    [placeService getPlacesByIds:placeIds completion:^(NSArray * places) {
        NSMutableArray *placeList = [[NSMutableArray alloc] init];
        for(id place in places)
        {
            [placeList addObject:[[Place alloc] init:place]];
        }
        completion(placeList);
    }];
}

+(void)getByUser:(QSCompletionBlock)completion
{
    QSAzureService *service = [QSAzureService defaultService:@"SavedList"];
    
    User *currentUser = (User *)[Session sessionVariables][@"currentUser"];
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:currentUser.userId forKey:@"userid"];
    
    [service getSavedListByUser:params completion:^(NSArray *results)  {
        NSMutableArray *listArray = [[NSMutableArray alloc] init];
        for(id item in results)
        {
            SavedList *savedList = [[SavedList alloc] init:item];
            /*
            if([currentUser.userId isEqualToString:savedList.fromUserId])
                savedList.fromUserName = @"";
            else
                savedList.toUserName = @"";
            */
            [listArray addObject:savedList];
        }
        completion(listArray);
    }];
}

+(void)add:(NSString *)xrefId userId:(NSString *)userId completion:(QSCompletionBlock)completion
{
    QSAzureService *service = [QSAzureService defaultService:@"SavedList"];
    
    if(userId.length <= 0) {
        User *user = (User *)[Session sessionVariables][@"currentUser"];
        userId = user.userId;
    }
    NSDictionary *savedList = @{@"xrefid": xrefId, @"userid" : userId, @"yesplaces" : @"", @"noplaces": @"" };
    [service addItem:savedList completion:^(NSDictionary *item)
     {
         SavedList *savedList = [[SavedList alloc] init:item];
         [[Session sessionVariables] setObject:savedList forKey:@"currentSavedList"];
         
         NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
         [defaults setObject:[NSString stringWithFormat:@"%lu", (unsigned long)savedList.xrefId] forKey:@"xrefId"];
         [defaults setObject:[NSDate date] forKey:@"createdDate"];
         [defaults synchronize];
         
         completion(savedList);
     }];
}

+(void)updateList:(NSString *)placeId isYes:(BOOL)isYes;
{
    SavedList *savedList = (SavedList *)[Session sessionVariables][@"currentSavedList"];
    
    QSAzureService *service = [QSAzureService defaultService:@"SavedList"];
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    
    [params setValue:savedList.listId forKey:@"savedlistid"];
    
    if(isYes)
    {
        if([savedList.yesPlaceIds length] > 0)
            savedList.yesPlaceIds = [NSString stringWithFormat:@"%@,%@", savedList.yesPlaceIds, placeId];
        else
            savedList.yesPlaceIds = [NSString stringWithFormat:@"%@", placeId];
                
        [params setValue:[NSString stringWithFormat:@"%@", savedList.yesPlaceIds] forKey:@"placeids"];
        [params setValue:[NSString stringWithFormat:@"%@", @"yesplaces"] forKey:@"yesorno"];
    }
    else
    {
        if([savedList.noPlaceIds length] > 0)
            savedList.noPlaceIds = [NSString stringWithFormat:@"%@,%@", savedList.noPlaceIds, placeId];
        else
            savedList.noPlaceIds = [NSString stringWithFormat:@"%@", placeId];
        
        [params setValue:[NSString stringWithFormat:@"%@", savedList.noPlaceIds] forKey:@"placeids"];
        [params setValue:[NSString stringWithFormat:@"%@", @"noplaces"] forKey:@"yesorno"];
    }
    
    [service updateList:params];
}

@end
