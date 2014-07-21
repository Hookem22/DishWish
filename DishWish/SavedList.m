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
@synthesize places = _places;
@synthesize placeIds = _placeIds;
@synthesize xrefId = _xrefId;
@synthesize fromUserId = _fromUserId;
@synthesize fromUserName = _fromUserName;
@synthesize toUserId = _toUserId;
@synthesize toUserName = _toUserName;
@synthesize createdAt = _createdAt;

- (id)init:(NSDictionary *)savedList {
	self = [super init];
	if (self) {
        self.listId = [savedList valueForKey:@"id"];
        self.placeIds = [savedList valueForKey:@"places"];
        self.places = [[NSArray alloc] init];
        self.xrefId = [[savedList valueForKey:@"xrefid"] isMemberOfClass:[NSNull class]] ? 0 : [[savedList valueForKey:@"xrefid"] longValue];
        self.fromUserId = [savedList valueForKey:@"fromuserid"];
        self.fromUserName = [savedList valueForKey:@"fromusername"];
        self.toUserId = [savedList valueForKey:@"touserid"];
        self.toUserName = [savedList valueForKey:@"tousername"];
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
            
            NSString *placeIds = [results[0] valueForKey:@"places"];
            
            [self getByPlaceIds:placeIds completion:^(NSArray * placeList) {
                savedList.places = [NSArray arrayWithArray:placeList];
                completion(savedList);
             }];
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
            
            if([currentUser.userId isEqualToString:savedList.fromUserId])
                savedList.fromUserName = @"";
            else
                savedList.toUserName = @"";
            
            [listArray addObject:savedList];
        }
        completion(listArray);
    }];
}

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

@end
