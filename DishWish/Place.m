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
@synthesize azureService = _azureService;

+ (id)placeWithId:(NSUInteger)placeId name:(NSString *)placeName {
	return [[[self class] alloc] initWithId:placeId name:placeName];
}

- (id)initWithId:(NSUInteger)placeId name:(NSString *)placeName {
	self = [super init];
	if (self) {
		self.placeId = placeId;
		self.name = placeName;
        
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
        

        long placeId = [item valueForKey:@"id"];
        NSString *name = [item valueForKey:@"Name"];
        Place * place = [[Place alloc] initWithId:placeId name:name];

        completion(place);
    }];
    
}

+ (void)get:(QSCompletionBlock)completion
{
    QSAzureService *service = [QSAzureService defaultService:@"Place"];
    [service get:^(NSArray *results) {
        
        NSMutableArray *places = [[NSMutableArray alloc] init];
        for(id place in results) {
            //Place *place = (Place *)thisPlace;
            long placeId = [place valueForKey:@"id"];
            NSString *name = [place valueForKey:@"Name"];
            [places addObject:[[Place alloc] initWithId:placeId name:name]];
        }
        
        completion(places);
    }];

}

+ (NSArray *)initialPlaces {
	NSMutableArray *places = [[NSMutableArray alloc] init];

    Place *place1 = [Place placeWithId:1 name:@"Perla's"];
    place1.images = [NSArray arrayWithObjects: @"http://starrhardin.files.wordpress.com/2013/02/perlas-7.jpg", @"http://www.examiner.com/images/blog/EXID13641/images/AB_perlas1.jpg", @"http://tideandbloom.files.wordpress.com/2013/10/perlas-oysters-1a.jpg", nil];
    Place *place2 = [Place placeWithId:2 name:@"Docs"];
    place2.images = [NSArray arrayWithObjects: @"http://www.videocityguide.com/austin/PCWUploads/Doc's%20Motorworks%20Bar%20and%20Grill/docsmotorwirk-austin-image2.jpg", nil];
    Place *place3 = [Place placeWithId:3 name:@"Vino Vino"];
    place3.images = [NSArray arrayWithObjects: @"http://goodtastereport.files.wordpress.com/2007/06/vinovino1.jpg", nil];
    Place *place4 = [Place placeWithId:4 name:@"Clark's"];
    place4.images = [NSArray arrayWithObjects: @"http://dishwishes.blob.core.windows.net/places/olive", @"http://www.bonappetit.com/wp-content/uploads/2013/02/clarks-oysters-459.jpg", @"http://2.bp.blogspot.com/-P-eMsNdtNAs/UeXBRD1F3SI/AAAAAAAAEWQ/S1KZP7ei69Y/s640/522786_542229305803321_1737954152_n.jpg", @"http://images.huffingtonpost.com/2014-02-11-AUSTINCLARKSBARbar129451.jpg", nil];
    
    [places addObject:place1];
    [places addObject:place2];
    [places addObject:place3];
    [places addObject:place4];
    
  
    
    return places;
}

+(Place *)nextPlace
{
    Place *place = [Place placeWithId:5 name:@"Uchi"];
    place.images = [NSArray arrayWithObjects:@"http://img1.southernliving.timeinc.net/sites/default/files/image/2013/09/100-places-to-eat-now/uchi-austin-texas-l.jpg",@"http://dishwishes.blob.core.windows.net/places/rudys", @"http://si.wsj.net/public/resources/images/PT-AM790_Austin_F_20091016170801.jpg", @"http://roomfu.com/wp-content/uploads/2012/09/uchi-austin-interior3.jpg", nil];
    return place;
}

@end
