#import "DWMap.h"

@interface DWMap ()
@property (nonatomic, strong) UIImageView *imageView;
@end

@implementation DWMap

- (id)initWithFrame:(CGRect)frame place:(Place *)place
{
    self = [super initWithFrame:frame];
    if (!self) return nil;
    
    
    [self loadMap:place];
    
    [self addNavBar:place];
    
    return self;
}

-(void)addNavBar:(Place *)place
{
    UINavigationBar *naviBarObj = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, 320, 40)];
    [self addSubview:naviBarObj];
    
    
    UIBarButtonItem *cancelItem = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:self action:@selector(exitMap)];
    
    UINavigationItem *navigItem = [[UINavigationItem alloc] initWithTitle:place.name];
    navigItem.leftBarButtonItem = cancelItem;
    naviBarObj.items = [NSArray arrayWithObjects: navigItem,nil];
}

-(void)loadMap:(Place *)place
{
    MKMapView *mapView = [[MKMapView alloc] initWithFrame:self.bounds];
    CLLocationCoordinate2D coord = CLLocationCoordinate2DMake(30.241675,-97.758916);
    
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(coord, 1000, 1000);
    MKCoordinateRegion adjustedRegion = [mapView regionThatFits:viewRegion];
    [mapView setRegion:adjustedRegion animated:YES];
    
    [mapView setCenterCoordinate:coord];
    
    MKPointAnnotation *point = [[MKPointAnnotation alloc] init];
    point.coordinate = coord;
    point.title = place.name;
    //point.subtitle = @"I'm here!!!";
    
    [mapView addAnnotation:point];
    
    
    /*
    DWAnnotation *annotation = [[DWAnnotation alloc] initWithCoordinate:coord];
    [mapView addAnnotation:annotation];
    
    MKMapPoint point = MKMapPointForCoordinate(coord);
    [mapView addAnnotation:point];
    
    
    MKAnnotation *ann = [[MKAnnotation alloc] in]
    MKAnnotationView *an = [[MKAnnotationView alloc] init]
    
    AddressAnnotation *addAnnotation = [[AddressAnnotation alloc] initWithCoordinate:coord];
    [mapView addAnnotation:addAnnotation];
    */
    [self addSubview:mapView];
    
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
