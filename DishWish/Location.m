//
//  Location.m
//  DishWish
//
//  Created by Will on 6/18/14.
//  Copyright (c) 2014 DishWish. All rights reserved.
//

#import "Location.h"

@implementation Location



- (id)init {
	self = [super init];
	if (self) {

        if ([CLLocationManager locationServicesEnabled]) {
            _locationManager = [[CLLocationManager alloc] init];
            
            _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
            _locationManager.delegate = self;
            _locationManager.pausesLocationUpdatesAutomatically = NO;
            
            [_locationManager startUpdatingLocation];
        }
        
//        self.locationManager = [[CLLocationManager alloc] init];
//        if ( [CLLocationManager locationServicesEnabled] ) {
//            [self.locationManager setDelegate:self];
//            [self.locationManager setDistanceFilter:kCLHeadingFilterNone];
//            //change the desired accuracy to kCLLocationAccuracyBest
//            [self.locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
//            //SOLUTION: set setPausesLocationUpdatesAutomatically to NO
//            [self.locationManager setPausesLocationUpdatesAutomatically:NO];
//            [self.locationManager startUpdatingLocation];
//        }
        
        //self.latitude = locationManager.location.coordinate.latitude;
        //self.longitude = locationManager.location.coordinate.longitude;
    }
	return self;
}

- (void)viewDidLoad
{
    if ([CLLocationManager locationServicesEnabled]) {
        _locationManager = [[CLLocationManager alloc] init];
        
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        _locationManager.delegate = self;
        _locationManager.pausesLocationUpdatesAutomatically = NO;
        
        [_locationManager startUpdatingLocation];
    }
}

- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray *)locations {
    // If it's a relatively recent event, turn off updates to save power.
    CLLocation* location = [locations lastObject];
    NSDate* eventDate = location.timestamp;
    NSTimeInterval howRecent = [eventDate timeIntervalSinceNow];
    if (abs(howRecent) < 15.0) {
        // If the event is recent, do something with it.
        NSLog(@"latitude %+.6f, longitude %+.6f\n",
              location.coordinate.latitude,
              location.coordinate.longitude);
    }
}


/*
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"didFailWithError: %@", error);
    UIAlertView *errorAlert = [[UIAlertView alloc]
                               initWithTitle:@"Error" message:@"Failed to Get Your Location" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [errorAlert show];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    NSLog(@"didUpdateToLocation: %@", locations[0]);
    CLLocation *currentLocation = [locations lastObject];
    
}
*/

@end
