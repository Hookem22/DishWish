//
//  SharedList.m
//  DishWish
//
//  Created by Will on 7/17/14.
//  Copyright (c) 2014 DishWish. All rights reserved.
//

#import "SharedList.h"

@implementation SharedList

@synthesize userId = _userId;
@synthesize listId = _listId;
@synthesize name = _name;

- (id)init:(NSDictionary *)sharedList {
	self = [super init];
	if (self) {
        self.userId = [sharedList valueForKey:@"userid"];
        self.listId = [sharedList valueForKey:@"listid"];
        self.name = [sharedList valueForKey:@"name"];
    }
	return self;
}


+(void)get:(NSString *)xrefId completion:(QSCompletionBlock)completion
{
    QSAzureService *service = [QSAzureService defaultService:@"SharedList"];
    
    [service getSharedList:xrefId completion:^(NSArray *results)  {
        for(id item in results) {
            SharedList *sharedList = [[SharedList alloc] init:item];
            completion(sharedList);
            return;
        }
        completion(nil);
    }];
}

@end
