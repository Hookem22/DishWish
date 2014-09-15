//
//  Message.h
//  DishWish
//
//  Created by Will Parks on 9/12/14.
//  Copyright (c) 2014 DishWish. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QSAzureService.h"
#import "User.h"
#import "SavedList.h"
#import "Session.h"

@interface Message : NSObject

@property (nonatomic, copy) NSString *messageId;
@property (nonatomic, assign) NSUInteger xrefId;
@property (nonatomic, copy) NSString *userId;
@property (nonatomic, copy) NSString *message;

+(void)get:(NSUInteger)xrefId completion:(QSCompletionBlock)completion;
+(void)add:(NSString *)message completion:(QSCompletionBlock)completion;

@end
