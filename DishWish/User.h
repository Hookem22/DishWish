//
//  User.h
//  DishWish
//
//  Created by Will on 6/20/14.
//  Copyright (c) 2014 DishWish. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WindowsAzureMobileServices/WindowsAzureMobileServices.h>
#import "QSAzureService.h"

@interface User : NSObject

@property (nonatomic, copy) NSString *deviceId;
@property (nonatomic, copy) NSString *facebookId;

+(void)login:(QSCompletionBlock)completion;

@end
