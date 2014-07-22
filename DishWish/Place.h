//
//  Place.h
//  TinderLikeAnimations
//
//  Created by Will on 5/6/14.
//  Copyright (c) 2014 theguti.self. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <WindowsAzureMobileServices/WindowsAzureMobileServices.h>
#import "QSAzureService.h"
#import "Session.h"

@interface Place : NSObject

@property (strong, nonatomic)   QSAzureService   *azureService;

@property (nonatomic, copy) NSString *placeId;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign) NSUInteger imageCount;
@property (nonatomic, copy) NSArray *images;
@property (nonatomic, assign) double latitude;
@property (nonatomic, assign) double longitude;
@property (nonatomic, copy) NSString *googleId;
@property (nonatomic, copy) NSString *googleReferenceId;
@property (nonatomic, copy) NSString *yelpId;
@property (nonatomic, copy) NSString *website;
@property (nonatomic, copy) NSString *menu;
@property (nonatomic, copy) NSString *lunchMenu;
@property (nonatomic, copy) NSString *brunchMenu;
@property (nonatomic, copy) NSString *drinkMenu;
@property (nonatomic, copy) NSString *happyHourMenu;
@property (nonatomic, assign) NSUInteger yesVote;
@property (nonatomic, assign) NSUInteger noVote;

-(id)init:(NSDictionary *)place;
-(void)savePlace;
//+(void)get:id completion:(QSCompletionBlock)completion;
//+(void)get:(QSCompletionBlock)completion;
+(void)getAllPlaces:(QSCompletionBlock)completion;
-(void)vote:(BOOL)isYes;
+(void)saveList:(QSCompletionBlock)completion;
+(void)saveXref:(NSString *)userId name:(NSString *)name listId:(NSString *)listId completion:(QSCompletionBlock)completion;

@end


