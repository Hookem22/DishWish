//
//  Place.h
//  TinderLikeAnimations
//
//  Created by Will on 5/6/14.
//  Copyright (c) 2014 theguti.self. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WindowsAzureMobileServices/WindowsAzureMobileServices.h>
#import "QSAzureService.h"

@interface Place : NSObject

@property (strong, nonatomic)   QSAzureService   *azureService;

@property (nonatomic, assign) NSUInteger placeId;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSArray *images;

+ (NSArray *)initialPlaces;
+ (Place *)nextPlace;
-(void)savePlace;
+(void)get:id completion:(QSCompletionBlock)completion;
+(void)get:(QSCompletionBlock)completion;

@end
