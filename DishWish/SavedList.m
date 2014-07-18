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
@synthesize xrefId = _xrefId;
@synthesize fromUserId = _fromUserId;
@synthesize fromUserName = _fromUserName;
@synthesize toUserId = _toUserId;
@synthesize toUserName = _toUserName;

- (id)init:(NSDictionary *)savedList {
	self = [super init];
	if (self) {
        self.listId = [savedList valueForKey:@"id"];
        self.places = [savedList valueForKey:@"places"];
        self.xrefId = [[savedList valueForKey:@"xrefid"] longValue];
        self.fromUserId = [savedList valueForKey:@"fromuserid"];
        self.fromUserName = [savedList valueForKey:@"fromusername"];
        self.toUserId = [savedList valueForKey:@"touserid"];
        self.toUserName = [savedList valueForKey:@"tousername"];
    }
	return self;
}

+(void)get:(NSString *)xrefId completion:(QSCompletionBlock)completion
{
    QSAzureService *service = [QSAzureService defaultService:@"SavedList"];
    
    [service getSavedList:xrefId completion:^(NSArray *results)  {
        if(results.count > 0) {
            SavedList *savedList = [[SavedList alloc] init:results[0]];
            
            NSString *placeIds = [results[0] valueForKey:@"places"];
            
            QSAzureService *placeService = [QSAzureService defaultService:@"Place"];

            [placeService getPlacesByIds:placeIds completion:^(NSArray * places) {
                NSMutableArray *placeList = [[NSMutableArray alloc] init];
                for(id place in places)
                {
                    [placeList addObject:[[Place alloc] init:place]];
                }
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
         completion([item valueForKey:@"xrefid"]);
     }];
}

@end
