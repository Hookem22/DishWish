//
//  PushMessage.m
//  DishWish
//
//  Created by Will Parks on 7/17/14.
//  Copyright (c) 2014 DishWish. All rights reserved.
//

#import "PushMessage.h"

@implementation PushMessage

+(void)push:(NSString *)deviceToken message:(NSString *)message
{
    
    deviceToken = @"2a5a3836 1c577b99 82967907 037887d0 95fc7752 646ce25f b6139e54 9b1251e2";
    QSAzureService *service = [QSAzureService defaultService:@""];
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    
    [params setValue:deviceToken forKey:@"devicetoken"];
    [params setValue:message forKey:@"message"];
    
    [service sendPushMessage:params];
}

@end
