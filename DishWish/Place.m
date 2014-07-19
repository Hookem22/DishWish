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
        self.yesVote = [[place objectForKey:@"yesvote"] isKindOfClass:[NSNull class]] ? 0 : [[place objectForKey:@"yesvote"] intValue];
        self.noVote = [[place objectForKey:@"novote"] isKindOfClass:[NSNull class]] ? 0 : [[place objectForKey:@"novote"] intValue];;
        
        NSString *container = @"http://dishwishes.blob.core.windows.net/places/";
        NSMutableArray *imgArray = [[NSMutableArray alloc] initWithCapacity:self.imageCount];
        for(int i = 0; i < self.imageCount; i++)
        {
            [imgArray addObject:[NSString stringWithFormat:@"%@%@_%d.jpg", container, self.placeId, i]];
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

/*
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
*/
+(void)getAllPlaces:(QSCompletionBlock)completion
{
    QSAzureService *service = [QSAzureService defaultService:@"Place"];
    
    CLLocation *location = (CLLocation *)[Session sessionVariables][@"location"];
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];

    [params setValue:[NSString stringWithFormat:@"%f", location.coordinate.latitude] forKey:@"latitude"];
    [params setValue:[NSString stringWithFormat:@"%f", location.coordinate.longitude] forKey:@"longitude"];
    
    //[params setValue:@"30.261862" forKey:@"latitude"]; //TODO Get device location
    //[params setValue:@"-97.758768" forKey:@"longitude"];
    
    
    [service getAllPlaces:params completion:^(NSArray *results) {
        NSMutableArray *places = [[NSMutableArray alloc] init];
        for(id item in results) {
            [places addObject:[[Place alloc] init:item]];
        }
        
        NSMutableArray *randomPlaces = [self randomizePlaces:places];
        
        completion(randomPlaces);
    }];
}

+(NSMutableArray *)randomizePlaces:(NSMutableArray *)places
{
    NSMutableDictionary *placesDict = [[NSMutableDictionary alloc] init];
    int i = 5;
    for(Place * place in places)
    {
        int r = (arc4random() % 10) + 1;
        int key = r * i;
        
        while(true)
        {
            NSString *keyId = [NSString stringWithFormat:@"%d", key];
            if([placesDict objectForKey:keyId] == nil)
            {
                [placesDict setObject:place forKey:keyId];
                i++;
                break;
            }
            key++;
        }
        
    }
    
    i = 1;
    NSMutableArray *randomPlaces = [[NSMutableArray alloc] initWithCapacity:places.count];
    while(placesDict.count > 0)
    {
        NSString *keyId = [NSString stringWithFormat:@"%d", i];
        Place *newPlace = (Place *)[placesDict objectForKey:keyId];
        if([placesDict objectForKey:keyId] != nil)
        {
            [randomPlaces addObject:newPlace];
            [placesDict removeObjectForKey:keyId];
        }
        i++;
    }
    
    return randomPlaces;
}

-(void)vote:(BOOL)isYes
{
    QSAzureService *service = [QSAzureService defaultService:@"Place"];
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    
    [params setValue:self.placeId forKey:@"placeid"];
    
    if(isYes)
    {
        [params setValue:[NSString stringWithFormat:@"%lu", self.yesVote + 1] forKey:@"votes"];
        [params setValue:[NSString stringWithFormat:@"%@", @"yesvote"] forKey:@"yesorno"];
    }
    else
    {
        [params setValue:[NSString stringWithFormat:@"%lu", self.noVote + 1] forKey:@"votes"];
        [params setValue:[NSString stringWithFormat:@"%@", @"novote"] forKey:@"yesorno"];
    }
    
    [service vote:params];
}

+(void)saveList:(QSCompletionBlock)completion
{
    QSAzureService *service = [QSAzureService defaultService:@"SavedList"];
    
    NSString *deviceId = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    
    NSString *places = @"";
    NSArray *yesPlaces = [NSMutableArray arrayWithArray:[Session sessionVariables][@"yesPlaces"]];
    for(Place *place in yesPlaces)
    {
        places = [NSString stringWithFormat:@"%@|%@", places, place.placeId];
    }
    
    places = [places substringFromIndex:1];
    
    NSDictionary *savedList = @{@"name" : @"", @"createduserid" : deviceId, @"places" : places };
    [service addItem:savedList completion:^(NSDictionary *item)
     {
         completion([item valueForKey:@"id"]);
     }];
}

+(void)saveXref:(NSString *)userId name:(NSString *)name listId:(NSString *)listId completion:(QSCompletionBlock)completion
{
    QSAzureService *service = [QSAzureService defaultService:@"SharedList"];
    
    NSDictionary *sharedList = @{@"id" : @"", @"userid" : userId, @"name" : name, @"listid" : listId, @"xrefid" : @"0" };
    [service addItem:sharedList completion:^(NSDictionary *item)
     {
         long xrefId = [[item objectForKey:@"xrefid"] longValue];
         completion([NSString stringWithFormat:@"%ld", xrefId]);
     }];
}

@end
