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
@synthesize createdAt = _createdAt;

- (id)init:(NSDictionary *)savedList {
	self = [super init];
	if (self) {
        self.listId = [savedList valueForKey:@"id"];
        self.xrefId = [[savedList valueForKey:@"xrefid"] isMemberOfClass:[NSNull class]] ? 0 : [[savedList valueForKey:@"xrefid"] longValue];
        self.userId = [savedList valueForKey:@"userid"];
        self.userName = [savedList valueForKey:@"username"];
        self.yesPlaceIds = [savedList valueForKey:@"yesplaces"];
        self.noPlaceIds = [savedList valueForKey:@"noplaces"];
        self.createdAt = [savedList valueForKey:@"__createdAt"];
    }
	return self;
}

+(void)get:(NSString *)xrefId completion:(QSCompletionBlock)completion
{
    QSAzureService *service = [QSAzureService defaultService:@"SavedList"];
    
    NSString *where = [NSString stringWithFormat:@"xrefid = %@", xrefId];
    
    [service getByWhere:where completion:^(NSArray *results)  {
        if(results.count > 0) {
            SavedList *savedList = [[SavedList alloc] init:results[0]];
            /*
            NSString *placeIds = [results[0] valueForKey:@"places"];
            
            [self getByPlaceIds:placeIds completion:^(NSArray * placeList) {
                savedList.places = [NSArray arrayWithArray:placeList];
                completion(savedList);
             }];
             */
        }
        else
        {
            completion(nil);
        }
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
/*
+(void)add:(NSString *)fromUserName toUser:(User *)toUser completion:(QSCompletionBlock)completion
{
    QSAzureService *service = [QSAzureService defaultService:@"SavedList"];
    
    NSString *places = @"";
    NSArray *yesPlaces = [NSMutableArray arrayWithArray:[Session sessionVariables][@"yesPlaces"]];
    for(Place *place in yesPlaces)
    {
        places = [NSString stringWithFormat:@"%@,'%@'", places, place.placeId];
    }
    
    places = [places substringFromIndex:1];
    
    User *fromUser = (User *)[Session sessionVariables][@"currentUser"];
    
    NSDictionary *savedList = @{@"places" : places, @"fromuserid" : fromUser.userId, @"fromusername" : fromUserName, @"touserid": toUser.userId, @"tousername" : toUser.name };
    [service addItem:savedList completion:^(NSDictionary *item)
     {
         SavedList *savedList = [[SavedList alloc] init:item];
         completion(savedList);
     }];
}
*/

+(void)add:(QSCompletionBlock)completion
{
    QSAzureService *service = [QSAzureService defaultService:@"SavedList"];
    
    User *user = (User *)[Session sessionVariables][@"currentUser"];
    
    NSDictionary *savedList = @{@"userid" : user.userId, @"yesplaces" : @"", @"noplaces": @"" };
    [service addItem:savedList completion:^(NSDictionary *item)
     {
         SavedList *savedList = [[SavedList alloc] init:item];
         [[Session sessionVariables] setObject:savedList forKey:@"currentSavedList"];
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
