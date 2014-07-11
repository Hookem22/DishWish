//
//  ViewController.m
//  DishWish
//
//  Created by Will on 5/9/14.
//  Copyright (c) 2014 DishWish. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

@synthesize mainView = _mainView;

- (void)loadView {
    
    self.mainView = [[DWView alloc] init];
    self.view = self.mainView;
    
    [User login:^(User *user) {
        NSString *userId = user.deviceId;
    }];
    
    //debugging only
    if (TARGET_IPHONE_SIMULATOR)
    {
        CLLocationCoordinate2D coord = CLLocationCoordinate2DMake(30.261862, -97.758768);
        CLLocation *location = [[CLLocation alloc] initWithCoordinate:coord altitude:0 horizontalAccuracy:0 verticalAccuracy:0 timestamp:nil];
        [self.mainView setup:location];
    }
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    [self addLeftSideBar];
    
    if ([CLLocationManager locationServicesEnabled] &&
        [CLLocationManager authorizationStatus] != kCLAuthorizationStatusDenied) {
        _locationManager = [[CLLocationManager alloc] init];
        
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        _locationManager.delegate = self;
        //_locationManager.pausesLocationUpdatesAutomatically = NO;
        
        [_locationManager startUpdatingLocation];
    }
    else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No GPS"
                                                        message:@"Turn on Location"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
}

-(void)addLeftSideBar
{
    NSUInteger ht = [[UIScreen mainScreen] bounds].size.height;
    
    UIButton *shareButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [shareButton setTitle:@"Send List to Friends" forState:UIControlStateNormal];
    shareButton.frame = CGRectMake(0, 0, 0, 0);
    [shareButton addTarget:self action:@selector(shareButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    DWLeftSideBar *left = [[DWLeftSideBar alloc] initWithFrame:CGRectMake(0, 60, 0, ht - 60)];
    
    left.shareButton = shareButton;
    [left addSubview:shareButton];
    
    self.mainView.leftSideBar = left;
    [self.view addSubview:left];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    // If it's a relatively recent event, turn off updates to save power.
    CLLocation* location = [locations lastObject];
    
    [_locationManager stopUpdatingLocation];
    
    if(self.mainView.subviews.count > 1) //Bug for loading cards twice
        return;
    
    [self.mainView setup:location];
    
    NSDate* eventDate = location.timestamp;
    NSTimeInterval howRecent = [eventDate timeIntervalSinceNow];
    if (abs(howRecent) < 15.0) {
        // If the event is recent, do something with it.
        NSLog(@"latitude %+.6f, longitude %+.6f\n",
              location.coordinate.latitude,
              location.coordinate.longitude);
    }
}

- (IBAction)shareButtonPressed:(UIButton *)sender
{   
    [self.mainView.leftSideBar close];
    [self performSegueWithIdentifier:@"MessageSegue" sender:self];
}

-(void)menuButtonPressed
{
    DWView *dwView = (DWView *)self.view;
    [dwView menuButtonPressed];
}

-(void)userButtonPressed
{
    DWView *dwView = (DWView *)self.view;
    [dwView userButtonPressed];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
