//
//  SharedList.h
//  DishWish
//
//  Created by Will on 7/17/14.
//  Copyright (c) 2014 DishWish. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QSAzureService.h"

@interface SharedList : NSObject

@property (nonatomic, copy) NSString *listId;
@property (nonatomic, copy) NSString *userId;
@property (nonatomic, copy) NSString *name;

+(void)get:(NSString *)xrefId completion:(QSCompletionBlock)completion;

@end
