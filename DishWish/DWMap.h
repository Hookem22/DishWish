#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import <AddressBook/AddressBook.h>
#import "Place.h"


@interface DWMap : UIView


- (id)initWithFrame:(CGRect)frame place:(Place *)place;

@end
