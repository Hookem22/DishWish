//
//  Message.m
//  DishWish
//
//  Created by Will Parks on 9/12/14.
//  Copyright (c) 2014 DishWish. All rights reserved.
//

#import "Message.h"

@implementation Message

@synthesize messageId = _messageId;
@synthesize xrefId = _xrefId;
@synthesize userId = _userId;
@synthesize message = _message;

- (id)init:(NSDictionary *)message {
	self = [super init];
	if (self) {
        self.messageId = [message valueForKey:@"messageId"];
        self.xrefId = [[message valueForKey:@"xrefid"] isMemberOfClass:[NSNull class]] ? 0 : [[message valueForKey:@"xrefid"] longValue];
        self.userId = [message valueForKey:@"userid"];
        self.message = [message valueForKey:@"message"];
    }
	return self;
}

+(void)get:(NSUInteger)xrefId completion:(QSCompletionBlock)completion
{
    QSAzureService *service = [QSAzureService defaultService:@"Messages"];
    NSString *whereStatement = [NSString stringWithFormat:@"xrefid = %lu", (unsigned long)xrefId];
    
    [service getByWhere:whereStatement completion:^(NSArray *results) {
        NSMutableArray *messages = [[NSMutableArray alloc] init];
        for(id message in results) {
            [messages addObject:[[Message alloc] init:message]];
        }
        completion(messages);
    }];
}


+(void)add:(NSString *)message completion:(QSCompletionBlock)completion
{
    QSAzureService *service = [QSAzureService defaultService:@"Messages"];
    
    User *user = (User *)[Session sessionVariables][@"currentUser"];
    SavedList *currentSavedList = (SavedList *)[Session sessionVariables][@"currentSavedList"];
    
    NSDictionary *newMessage = @{@"xrefid": [NSString stringWithFormat:@"%lu", (unsigned long)currentSavedList.xrefId], @"userid" : user.userId, @"message" : message };
    [service addItem:newMessage completion:^(NSDictionary *item)
     {
         Message *message = [[Message alloc] init:item];
         completion(message);
     }];
}


@end
