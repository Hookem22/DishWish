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
    
    //debugging only
    if (TARGET_IPHONE_SIMULATOR)
    {
        CLLocationCoordinate2D coord = CLLocationCoordinate2DMake(30.2500, -97.7500);
        CLLocation *location = [[CLLocation alloc] initWithCoordinate:coord altitude:0 horizontalAccuracy:0 verticalAccuracy:0 timestamp:nil];
        [[Session sessionVariables] setObject:location forKey:@"location"];
        
        [self.mainView setup];
    }
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    [self addInviteFriends];
    [self addRightSideBar];
    
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

-(void)addInviteFriends
{   
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSString *savedListId = appDelegate.queryValue;    
    if([savedListId length] > 0)
        return;
    
    NSUInteger wd = [[UIScreen mainScreen] bounds].size.width;
    NSUInteger ht = [[UIScreen mainScreen] bounds].size.height;
    
    UIButton *shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [shareButton setTitle:@"Add a Friend to Eat With" forState:UIControlStateNormal];
    shareButton.frame = CGRectMake(40, ht / 3, wd - 80, 40);
    shareButton.titleLabel.font = [UIFont systemFontOfSize:18.0f];
    shareButton.titleLabel.textColor = [UIColor whiteColor];
    shareButton.layer.backgroundColor =  [UIColor colorWithRed:19.0/255.0 green:128.0/255.0 blue:249.0/250.0 alpha:1.0].CGColor;
    shareButton.layer.cornerRadius = 5.0;
    shareButton.titleLabel.textAlignment = UIControlContentHorizontalAlignmentLeft;
    
    [shareButton addTarget:self action:@selector(shareButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    DWAddFriendsView *view = [[DWAddFriendsView alloc] initWithFrame:CGRectMake(0, 0, wd, ht)];
    
    view.shareButton = shareButton;
    [view addSubview:shareButton];
    
    self.mainView.addFriendsView = view;
    [self.view addSubview:view];
}

-(void)addRightSideBar
{
    NSUInteger wd = [[UIScreen mainScreen] bounds].size.width;
    NSUInteger ht = [[UIScreen mainScreen] bounds].size.height;
    
    UIButton *shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [shareButton setTitle:@"Add Friends to Eat With" forState:UIControlStateNormal];
    shareButton.frame = CGRectMake(10, 10, (wd * 3)/4 - 40, 40);
    shareButton.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    shareButton.titleLabel.textColor = [UIColor whiteColor];
    shareButton.layer.backgroundColor =  [UIColor colorWithRed:19.0/255.0 green:128.0/255.0 blue:249.0/250.0 alpha:1.0].CGColor;
    shareButton.layer.cornerRadius = 5.0;
    shareButton.titleLabel.textAlignment = UIControlContentHorizontalAlignmentLeft;
    
    [shareButton addTarget:self action:@selector(shareButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    DWRightSideBar *right = [[DWRightSideBar alloc] initWithFrame:CGRectMake(wd, 60, (wd * 3)/4, ht - 60)];
    
    right.shareButton = shareButton;
    [right addSubview:shareButton];
    
    self.mainView.rightSideBar = right;
    [self.view addSubview:right];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    // If it's a relatively recent event, turn off updates to save power.
    CLLocation* location = [locations lastObject];
    
    [_locationManager stopUpdatingLocation];
    
    [[Session sessionVariables] setObject:location forKey:@"location"];
    
    for(id subview in self.mainView.subviews) { //Bug for loading cards twice
        if([subview isMemberOfClass:[DWDraggableView class]] || [subview isMemberOfClass:[DWLeftSideBar class]] )
            return;
    }
    
    [self.mainView setup];
    
}

- (IBAction)shareButtonPressed:(UIButton *)sender
{
    DWMessageViewController *message = [[DWMessageViewController alloc] init];
    message.viewController = self;
    [self presentViewController:message animated:YES completion:nil];
    
    //[self performSegueWithIdentifier:@"MessageSegue" sender:self];
    
    /*
    NSArray *yesPlaces = (NSArray *)[Session sessionVariables][@"yesPlaces"];
    if(yesPlaces.count <= 0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No Places"
                    message:@"You have not added any places to your list."
                    delegate:nil
                    cancelButtonTitle:@"OK"
                    otherButtonTitles:nil];
        
         [alert show];
    }
    else
    {
        [self.mainView.rightSideBar close];
        [self performSegueWithIdentifier:@"MessageSegue" sender:self];
    }
    */
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
