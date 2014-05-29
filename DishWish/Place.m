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
@synthesize yelpId = _yelpId;
@synthesize website = _website;
@synthesize menu = _menu;
@synthesize lunchMenu = _lunchMenu;
@synthesize brunchMenu = _brunchMenu;
@synthesize drinkMenu = _drinkMenu;
@synthesize happyHourMenu = _happyHourMenu;

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
        self.yelpId = [place valueForKey:@"yelpid"];
        self.website = [place valueForKey:@"website"];
        self.menu = [place valueForKey:@"menu"];
        self.lunchMenu = [place valueForKey:@"lunchmenu"];
        self.brunchMenu = [place valueForKey:@"brunchmenu"];
        self.drinkMenu = [place valueForKey:@"drinkmenu"];
        self.happyHourMenu = [place valueForKey:@"happyhourmenu"];        
        
        NSString *container = @"http://dishwishes.blob.core.windows.net/places/";
        NSMutableArray *imgArray = [[NSMutableArray alloc] initWithCapacity:self.imageCount];
        for(int i = 0; i < self.imageCount; i++)
        {
            [imgArray addObject:[NSString stringWithFormat:@"%@%@_%d.png", container, self.placeId, i]];
        }
        self.images = imgArray;
        
        self.azureService = [QSAzureService defaultService:@"Place"];
    }
	return self;
}



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
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setValue:placeIds forKey:@"placeids"];
    [params setValue:@"30.261862" forKey:@"latitude"]; //TODO Get device location
    [params setValue:@"-97.758768" forKey:@"longitude"];

    
    [service getNextPlace:params completion:^(NSArray *results) {
        
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
