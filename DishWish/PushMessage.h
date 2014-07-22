//
//  PushMessage.h
//  DishWish
//
//  Created by Will Parks on 7/17/14.
//  Copyright (c) 2014 DishWish. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QSAzureService.h"

@interface PushMessage : NSObject

+(void)push:(NSString *)deviceToken  header:(NSString *)header message:(NSString *)message;

@end
