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
@property (nonatomic, copy) NSArray *places;
@property (nonatomic, assign) NSUInteger xrefId;
@property (nonatomic, copy) NSString *fromUserId;
@property (nonatomic, copy) NSString *fromUserName;
@property (nonatomic, copy) NSString *toUserId;
@property (nonatomic, copy) NSString *toUserName;

+(void)get:(NSString *)xrefId completion:(QSCompletionBlock)completion;
+(void)add:(NSString *)fromUserName toUser:(User *)toUser completion:(QSCompletionBlock)completion;

@end
