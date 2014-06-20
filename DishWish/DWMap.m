#import "DWMap.h"

@interface DWMap ()
@property (nonatomic, strong) MKMapView *mapView;
@property(nonatomic, assign) CLLocationCoordinate2D endLocation;

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
    self.mapView = [[MKMapView alloc] initWithFrame:self.bounds];
    CLLocationCoordinate2D coord = CLLocationCoordinate2DMake(place.latitude, place.longitude);
    
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(coord, 1000, 1000);
    MKCoordinateRegion adjustedRegion = [self.mapView regionThatFits:viewRegion];
    [self.mapView setRegion:adjustedRegion animated:YES];
    
    [self.mapView setCenterCoordinate:coord];
    
    MKPointAnnotation *point = [[MKPointAnnotation alloc] init];
    point.coordinate = coord;
    point.title = place.name;
    //point.subtitle = @"I'm here!!!";
    
    [self.mapView addAnnotation:point];
    
    [self addSubview:self.mapView];
    
    //mapView.delegate = self;
    self.endLocation = coord;
    [self getRouteTime];
    
}

-(void)loadMaps:(NSArray *)places
{
    MKMapView *mapView = [[MKMapView alloc] initWithFrame:self.bounds];
    CLLocationCoordinate2D coord = [self centerCoord:places];
    
    CLLocationDistance distance = [self mapSize:places];
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

- (CLLocationDistance) mapSize:(NSArray *)places{
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

-(void)getRouteTime
{
    CLLocation *location = (CLLocation *)[Session sessionVariables][@"location"];
    
    MKPlacemark *startPlacemark = [[MKPlacemark alloc] initWithCoordinate:location.coordinate addressDictionary:nil];
    MKMapItem *start = [[MKMapItem alloc] initWithPlacemark:startPlacemark];
    
    MKPlacemark *endPlacemark = [[MKPlacemark alloc] initWithCoordinate:self.endLocation addressDictionary:nil];
    MKMapItem *end = [[MKMapItem alloc] initWithPlacemark:endPlacemark];
    
    MKDirectionsRequest *request = [[MKDirectionsRequest alloc] init];
    [request setSource:start];
    [request setDestination:end];
    [request setTransportType:MKDirectionsTransportTypeAny]; // This can be limited to automobile and walking directions.
    [request setRequestsAlternateRoutes:YES]; // Gives you several route options.
    MKDirections *directions = [[MKDirections alloc] initWithRequest:request];
    [directions calculateDirectionsWithCompletionHandler:^(MKDirectionsResponse *response, NSError *error) {
        if (!error) {
            if([response routes].count > 0)
            {
                MKRoute *route = [response routes][0];
                NSUInteger wd = [[UIScreen mainScreen] bounds].size.width;
                NSUInteger ht = [[UIScreen mainScreen] bounds].size.height;
                
                UILabel *travelLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, ht - 80, wd, 40)];
                travelLabel.backgroundColor = [UIColor whiteColor];
                travelLabel.text = [NSString stringWithFormat:@"   Travel Time: %d minutes", (int)((route.expectedTravelTime / 60) + 1)];
                [self addSubview:travelLabel];
                
                UIButton *directionsButton = [[UIButton alloc] initWithFrame:CGRectMake(wd - 60, ht - 75, 60, 30)];
                [directionsButton setImage:[UIImage imageNamed:@"directions"] forState:UIControlStateNormal];
                [directionsButton addTarget:self action:@selector(getRoute:) forControlEvents:UIControlEventTouchUpInside];
                [self addSubview:directionsButton];
            }
        }
    }];
    
}

-(void)getRoute:(id)sender
{
    self.mapView.delegate = self;
    
    CLLocation *location = (CLLocation *)[Session sessionVariables][@"location"];
    
    MKPlacemark *startPlacemark = [[MKPlacemark alloc] initWithCoordinate:location.coordinate addressDictionary:nil];
    MKMapItem *start = [[MKMapItem alloc] initWithPlacemark:startPlacemark];
    
    MKPlacemark *endPlacemark = [[MKPlacemark alloc] initWithCoordinate:self.endLocation addressDictionary:nil];
    MKMapItem *end = [[MKMapItem alloc] initWithPlacemark:endPlacemark];
    
    MKDirectionsRequest *request = [[MKDirectionsRequest alloc] init];
    [request setSource:start];
    [request setDestination:end];
    [request setTransportType:MKDirectionsTransportTypeAny]; // This can be limited to automobile and walking directions.
    [request setRequestsAlternateRoutes:YES]; // Gives you several route options.
    MKDirections *directions = [[MKDirections alloc] initWithRequest:request];
    [directions calculateDirectionsWithCompletionHandler:^(MKDirectionsResponse *response, NSError *error) {
        if (!error) {
            for (MKRoute *route in [response routes]) {
                [self.mapView addOverlay:[route polyline] level:MKOverlayLevelAboveRoads];
                break;
                // You can also get turn-by-turn steps, distance, advisory notices, ETA, etc by accessing various route properties.
            }
        }
    }];

}

- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay
{
    if ([overlay isKindOfClass:[MKPolyline class]]) {
        MKPolylineRenderer *renderer = [[MKPolylineRenderer alloc] initWithOverlay:overlay];
        [renderer setStrokeColor:[UIColor colorWithRed:0/255.0 green:120.0/255.0 blue:250.0/255.0 alpha:1.0]];
        [renderer setLineWidth:5.0];
        return renderer;
    }
    return nil;
}

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
