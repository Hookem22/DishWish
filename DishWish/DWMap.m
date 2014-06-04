#import "DWMap.h"

@interface DWMap ()
@end

@implementation DWMap

- (id)initWithFrame:(CGRect)frame places:(NSArray *)places
{
    self = [super initWithFrame:frame];
    if (!self) return nil;
    
    if(places.count == 1) {
        Place *place = (Place *)places[0];
        [self loadMap:place];
        
        [self addNavBar:place.name];
    }
    else {
        [self loadMaps:places];
        
        [self addNavBar:@""];
    }

    
    return self;
}

-(void)addNavBar:(NSString *)titleText
{
    NSUInteger wd = [[UIScreen mainScreen] bounds].size.width;
    
    UINavigationBar *naviBarObj = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, wd, 60)];
    [self addSubview:naviBarObj];
    
    
    UIBarButtonItem *cancelItem = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:self action:@selector(exitMap)];
    
    UINavigationItem *navigItem = [[UINavigationItem alloc] initWithTitle:titleText];
    navigItem.leftBarButtonItem = cancelItem;
    naviBarObj.items = [NSArray arrayWithObjects: navigItem,nil];
}

-(void)loadMap:(Place *)place
{
    MKMapView *mapView = [[MKMapView alloc] initWithFrame:self.bounds];
    CLLocationCoordinate2D coord = CLLocationCoordinate2DMake(place.latitude, place.longitude);
    
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(coord, 1000, 1000);
    MKCoordinateRegion adjustedRegion = [mapView regionThatFits:viewRegion];
    [mapView setRegion:adjustedRegion animated:YES];
    
    [mapView setCenterCoordinate:coord];
    
    MKPointAnnotation *point = [[MKPointAnnotation alloc] init];
    point.coordinate = coord;
    point.title = place.name;
    //point.subtitle = @"I'm here!!!";
    
    [mapView addAnnotation:point];
    
    [self addSubview:mapView];
    
}

-(void)loadMaps:(NSArray *)places
{
    MKMapView *mapView = [[MKMapView alloc] initWithFrame:self.bounds];
    CLLocationCoordinate2D coord = [self centerCoord:places];
    
    CLLocationDistance distance = [self mapDistance:places];
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(coord, distance, distance);
    MKCoordinateRegion adjustedRegion = [mapView regionThatFits:viewRegion];
    [mapView setRegion:adjustedRegion animated:YES];
    
    [mapView setCenterCoordinate:coord];
    
    for(Place *place in places)
    {
        MKPointAnnotation *point = [[MKPointAnnotation alloc] init];
        point.coordinate = CLLocationCoordinate2DMake(place.latitude, place.longitude);
        point.title = place.name;
        
        [mapView addAnnotation:point];
    }

    
    [self addSubview:mapView];
    
}

-(CLLocationCoordinate2D)centerCoord:(NSArray *)places
{
    double lat = 0;
    double lng = 0;
    for(Place *place in places)
    {
        lat += place.latitude;
        lng += place.longitude;
    }
    
    lat = lat / places.count;
    lng = lng / places.count;
    
    return CLLocationCoordinate2DMake(lat, lng);
}

- (CLLocationDistance) mapDistance:(NSArray *)places{
    double topLat = -1000;
    double topLng = -1000;
    double bottomLat = 1000;
    double bottomLng = 1000;
    for(Place *place in places)
    {
        if(place.latitude > topLat)
            topLat = place.latitude;
        if(place.longitude > topLng)
            topLng = place.longitude;
        if(place.latitude < bottomLat)
            bottomLat = place.latitude;
        if(place.longitude < bottomLng)
            bottomLng = place.longitude;
    }
    
    CLLocation *loc1 = [[CLLocation alloc] initWithLatitude:topLat longitude:topLng];
    CLLocation *loc2 = [[CLLocation alloc] initWithLatitude:bottomLat longitude:bottomLng];

    return [loc1 distanceFromLocation:loc2];
}

/*
- (MKMapRect) mapRectThatFitsBoundsSW:(CLLocationCoordinate2D)sw
                                   NE:(CLLocationCoordinate2D)ne
{
    MKMapPoint pSW = MKMapPointForCoordinate(sw);
    MKMapPoint pNE = MKMapPointForCoordinate(ne);
    
    double antimeridianOveflow =
    (ne.longitude > sw.longitude) ? 0 : MKMapSizeWorld.width;
    
    return MKMapRectMake(pSW.x, pNE.y,
                         (pNE.x - pSW.x) + antimeridianOveflow,
                         (pSW.y - pNE.y));
}
*/

-(void)exitMap
{
    id topView = self.superview.superview;
    NSArray *views = self.superview.superview.subviews;
    for(id subview in views) {
        if([subview isMemberOfClass:[UINavigationBar class]])
            [topView bringSubviewToFront:subview];
    }
    
    [UIView animateWithDuration:0.3
             animations:^{
                 CGRect frame = self.frame;
                 frame.origin.y = frame.size.height;
                 self.frame = frame;
             }
             completion:^(BOOL finished){
                 [self removeFromSuperview];
             }];
}


/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */

@end
