//
//  SharedList.h
//  DishWish
//
//  Created by Will on 7/17/14.
//  Copyright (c) 2014 DishWish. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QSAzureService.h"
#import "Place.h"
#import "User.h"
#import "Session.h"

@interface SavedList : NSObject

@property (nonatomic, copy) NSString *listId;
@property (nonatomic, assign) NSUInteger xrefId;
@property (nonatomic, assign) NSUInteger referenceId;
@property (nonatomic, copy) NSString *userId;
@property (nonatomic, copy) NSString *userName;
@property (nonatomic, copy) NSString *yesPlaceIds;
@property (nonatomic, copy) NSString *noPlaceIds;
@property (nonatomic, copy) NSDate *updatedAt;
@property (nonatomic, copy) NSDate *createdAt;

+(void)get:(NSString *)xrefId completion:(QSCompletionBlock)completion;
+(void)getSpecific:(NSString *)xrefId userId:(NSString *)userId completion:(QSCompletionBlock)completion;
+(void)getByReferenceId:(NSString *)referenceId completion:(QSCompletionBlock)completion;
+(void)getByPlaceIds:(NSString *)placeIds completion:(QSCompletionBlock)completion;
+(void)getByUser:(QSCompletionBlock)completion;
+(void)add:(NSString *)xrefId userId:(NSString *)userId completion:(QSCompletionBlock)completion;
+(void)updateList:(NSString *)placeId isYes:(BOOL)isYes;

@end
