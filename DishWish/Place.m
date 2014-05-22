//
//  Place.m
//  TinderLikeAnimations
//
//  Created by Will on 5/6/14.
//  Copyright (c) 2014 theguti.self. All rights reserved.
//

#import "Place.h"


@implementation Place

@synthesize placeId = _placeId;
@synthesize name = _name;
@synthesize images = images;
@synthesize imageCount = _imageCount;
@synthesize latitude = _latitude;
@synthesize longitude = _longitude;
@synthesize googleId = _googleId;
@synthesize googleReferenceId = _googleReferenceId;

@synthesize azureService = _azureService;


- (id)init:(NSDictionary *)place {
	self = [super init];
	if (self) {
		self.placeId = [place valueForKey:@"id"];
		self.name = [place valueForKey:@"Name"];
        self.imageCount = [[place objectForKey:@"imagecount"] intValue];
        self.latitude = [[place objectForKey:@"latitude"] doubleValue];
        self.longitude = [[place objectForKey:@"longitude"] doubleValue];
        self.googleId = [place valueForKey:@"googleid"];
        self.googleReferenceId = [place valueForKey:@"googlereferenceid"];
        
        NSString *container = @"http://dishwishes.blob.core.windows.net/places/";
        NSMutableArray *imgArray = [[NSMutableArray alloc] initWithCapacity:self.imageCount];
        for(int i = 0; i < self.imageCount; i++)
        {
            [imgArray addObject:[NSString stringWithFormat:@"%@%@_%d", container, self.placeId, i]];
        }
        self.images = imgArray;
        
        self.azureService = [QSAzureService defaultService:@"Place"];
    }
	return self;
}



//- (id)init:(NSString *)placeId name:(NSString *)name imageCount:(NSUInteger)imageCount latitude:(double)latitude longitude:(double)longitude googleId:(NSString *)googleId googleReferenceId:(NSString *)googleReferenceId {
//	self = [super init];
//	if (self) {
//		self.placeId = placeId;
//		self.name = name;
//        self.imageCount = imageCount;
//        self.latitude = latitude;
//        self.longitude = longitude;
//        self.googleId = googleId;
//        self.googleReferenceId = googleReferenceId;
//        
//        self.azureService = [QSAzureService defaultService:@"Place"];
//    }
//	return self;
//}

//-(id)constructor:(NSDictionary *)place {
//    NSString *placeId = [place valueForKey:@"id"];
//    NSString *name = [place valueForKey:@"Name"];
//    NSUInteger imageCount = [place valueForKey:@"imagecount"];
//    double latitude = [place valueForKey:@"Name"];
//    double longitude = [place valueForKey:@"Name"];
//    NSString *googleId = [place valueForKey:@"Name"];
//    NSString *
//    
//    Place * place = [[Place alloc] init:placeId name:name];
//}

-(void)savePlace
{
    NSDictionary *thisPlace = @{@"id" : [NSString stringWithFormat: @"%lu", (unsigned long)self.placeId], @"Name" : self.name };
    [self.azureService addItem:thisPlace completion:^(NSUInteger index)
     {
         NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];

     }];
}


+(void)get:(id)placeId completion:(QSCompletionBlock)completion
{

    QSAzureService *service = [QSAzureService defaultService:@"Place"];
    
    [service get:placeId completion:^(NSDictionary *item) {
        
        Place *place = [[Place alloc] init:item];
        completion(place);
    }];
}

+(void)getNextPlace:(QSCompletionBlock)completion
{
    
     QSAzureService *service = [QSAzureService defaultService:@"Place"];
     NSMutableArray *allPlaces = [NSMutableArray arrayWithArray:[Session sessionVariables][@"yesPlaces"]];
     [allPlaces addObjectsFromArray:[NSMutableArray arrayWithArray:[Session sessionVariables][@"noPlaces"]]];
     
     NSString *placeIds = @"";
     for(id placeId in allPlaces) {
         placeIds = [NSString stringWithFormat:@"%@'%@',", placeIds, placeId];
     }
     placeIds = [placeIds substringToIndex:placeIds.length - 1];
    
    NSDictionary *idsDict = @{ @"placeids": placeIds};
    
    [service getNextPlace:idsDict completion:^(NSArray *results) {
        
        Place *place = [[Place alloc] init:results.lastObject];
        completion(place);
        
    }];

}

+ (void)get:(QSCompletionBlock)completion
{
    QSAzureService *service = [QSAzureService defaultService:@"Place"];
    [service get:^(NSArray *results) {
        
        NSMutableArray *places = [[NSMutableArray alloc] init];
        for(id item in results) {
            [places addObject:[[Place alloc] init:item]];
        }
        
        completion(places);
    }];

}

+(void)getFivePlaces:(QSCompletionBlock)completion
{
    QSAzureService *service = [QSAzureService defaultService:@"Place"];
    
    [service getTopFive:^(NSArray *results)  {
        NSMutableArray *places = [[NSMutableArray alloc] init];
        for(id item in results) {
            [places addObject:[[Place alloc] init:item]];
        }
        
        completion(places);
        
    }];
}



@end
