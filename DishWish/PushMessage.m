//
//  PushMessage.m
//  DishWish
//
//  Created by Will Parks on 7/17/14.
//  Copyright (c) 2014 DishWish. All rights reserved.
//

#import "PushMessage.h"

@implementation PushMessage

+(void)push:(NSString *)deviceToken  header:(NSString *)header message:(NSString *)message
{
    QSAzureService *service = [QSAzureService defaultService:@""];
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    
    [params setValue:deviceToken forKey:@"devicetoken"];
    [params setValue:header forKey:@"header"];
    [params setValue:message forKey:@"message"];
    
    [service sendPushMessage:params];
}

@end
