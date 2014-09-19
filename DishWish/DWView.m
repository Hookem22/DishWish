#import "DWView.h"
#import "AppDelegate.h"
#import "ViewController.h"

@implementation DWView

@synthesize rightSideBar = _rightSideBar;

- (id)init
{
    self = [super init];
    if (!self) return nil;
    
    self.backgroundColor = [UIColor whiteColor];
    
    return self;
}

-(void)setup
{
    
    NSUInteger wd = [[UIScreen mainScreen] bounds].size.width;
    NSUInteger ht = [[UIScreen mainScreen] bounds].size.height;
    
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    NSString *savedListId = appDelegate.queryValue;
    
    if([savedListId length] > 0)
    {
        [self loadSavedList:[savedListId intValue]];
    }
    else
    {
        [Place getAllPlaces:^(NSArray *places) {
                        
            if(places.count == 0)
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Unavailable"
                            message:@"Let's Eat is not currently available in your city. It is currently only available in San Francisco."
                            delegate:nil
                            cancelButtonTitle:@"OK"
                            otherButtonTitles:nil];

                [alert show];
                return;
            }
            
            [[Session sessionVariables] setObject:places forKey:@"Places"];
            
            [self loadDraggableCustomView:places];
            
            [User login:^(User *user) {
                [SavedList add:@"" userId:user.userId completion:^(SavedList *savedList) {
                    
                }];
            }];
        }];
    }
    
    /*
    NSUInteger buttonWidth = [savedListId length] > 0 ? wd - 20 : 220;
    
    UIButton *resetButton = [[UIButton alloc] initWithFrame:CGRectMake((wd - buttonWidth)/2, 160, buttonWidth, 40)];
    [resetButton setTitleColor:[UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0] forState:UIControlStateNormal];
    [resetButton setTitle:@"Load More Places" forState:UIControlStateNormal];
    [resetButton.layer setBorderColor:[[UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0] CGColor]];
    [resetButton.layer setBorderWidth:1.0];
    resetButton.layer.cornerRadius = 15;
    [resetButton addTarget:self action:@selector(reloadPlaces:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:resetButton];
    [self sendSubviewToBack:resetButton];
    */
    
    UIButton *noButton = [[UIButton alloc] initWithFrame:CGRectMake(0, ht-40, wd/2, 40)];
    noButton.backgroundColor = [UIColor colorWithRed:229.0/255.0 green:76.0/255.0 blue:66.0/255.0 alpha:1.0];
    [noButton setImage:[UIImage imageNamed:@"x"] forState:UIControlStateNormal];
    noButton.tag = 0;
    [noButton addTarget:self action:@selector(voteButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:noButton];
    
    UIButton *yesButton = [[UIButton alloc] initWithFrame:CGRectMake(wd/2, ht-40, wd/2, 40)];
    yesButton.backgroundColor = [UIColor colorWithRed:79.0/255.0 green:180.0/255.0 blue:114.0/255.0 alpha:1.0];
    [yesButton setImage:[UIImage imageNamed:@"check"] forState:UIControlStateNormal];
    yesButton.tag = 1;
    [yesButton addTarget:self action:@selector(voteButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:yesButton];
    
    DWLeftSideBar *left = [[DWLeftSideBar alloc] initWithFrame:CGRectMake(0, 60, 0, ht - 60)];
    [self addSubview:left];
    
    //DWRightSideBar *right = [[DWRightSideBar alloc] initWithFrame:CGRectMake(wd, 60, (wd * 3)/4, ht - 60)];
    //[self addSubview:right];
    
//    UIImage *splash = [UIImage imageNamed:@"splash"];
//    UIImageView *splashView = [[UIImageView alloc] initWithImage:splash];
//    [self addSubview:splashView];

    for(id subview in self.subviews) {
        if([subview isMemberOfClass:[DWAddFriendsView class]])
            [self bringSubviewToFront:subview];
    }
    
}

-(void)loadSavedList:(NSUInteger)xrefId
{
    [MBProgressHUD showHUDAddedTo:self animated:YES];
    User *currentUser = (User *)[Session sessionVariables][@"currentUser"];
    if(currentUser == nil || currentUser.userId.length <= 0)
    {
        [User login:^(User *user) {
            [self loadSavedListForUser:xrefId user:user];
        }];
    }
    else
    {
        [self loadSavedListForUser:xrefId user:currentUser];
    }

}

-(void)loadSavedListForUser:(NSUInteger)xrefId user:(User *)user
{
    [SavedList getSpecific:[NSString stringWithFormat:@"%lu", (unsigned long)xrefId] userId:user.userId completion:^(SavedList *savedList) {
        if(savedList == nil || savedList.listId.length <= 0)
        {
            [SavedList add:[NSString stringWithFormat:@"%lu", (unsigned long)xrefId] userId:user.userId completion:^(SavedList *newSavedList) {
                [[Session sessionVariables] setObject:newSavedList forKey:@"currentSavedList"];
                [self loadPlacesForSavedList:newSavedList];
            }];
        }
        else
        {
            [[Session sessionVariables] setObject:savedList forKey:@"currentSavedList"];
            [self loadPlacesForSavedList:savedList];
        }
    }];
}

-(void)loadPlacesForSavedList:(SavedList *)savedList
{
    [Place getAllPlaces:^(NSArray *places) {
        

        NSMutableArray *newPlaces = [[NSMutableArray alloc] init];
        NSMutableArray *yesPlaces = [[NSMutableArray alloc] init];
        NSMutableArray *noPlaces = [[NSMutableArray alloc] init];
        
        NSArray *yeses = [[NSArray alloc] init];
        if(savedList.yesPlaceIds.length > 0)
        {
            if([savedList.yesPlaceIds rangeOfString:@","].location != NSNotFound)
                yeses = [savedList.yesPlaceIds componentsSeparatedByString:@","];
            else
                yeses = [[NSArray alloc] initWithObjects:savedList.yesPlaceIds, nil];
        }
        
        NSArray *nos = [[NSArray alloc] init];
        if(savedList.noPlaceIds.length > 0)
        {
            if([savedList.noPlaceIds rangeOfString:@","].location != NSNotFound)
                nos = [savedList.noPlaceIds componentsSeparatedByString:@","];
            else
                nos = [[NSArray alloc] initWithObjects:savedList.noPlaceIds, nil];
        }
        
        NSUInteger i = 0;
        for(Place *place in places)
        {
            if([yeses containsObject:place.placeId])
            {
                [yesPlaces addObject:place];
                [newPlaces insertObject:place atIndex:0];
                i++;
            }
            else if([nos containsObject:place.placeId])
            {
                [noPlaces addObject:place];
                [newPlaces insertObject:place atIndex:0];
                i++;
            }
            else
            {
                [newPlaces addObject:place];
            }
        }
        
        
        [[Session sessionVariables] setObject:newPlaces forKey:@"Places"];
        [[Session sessionVariables] setObject:yesPlaces forKey:@"yesPlaces"];
        [[Session sessionVariables] setObject:noPlaces forKey:@"noPlaces"];
        [[Session sessionVariables] setObject:[NSNumber numberWithInteger:i] forKey:@"CurrentId"];
        
        [self loadDraggableCustomView:places];
        [self addNavBar];
        
        for(id subview in self.subviews) {
            if(yeses.count > 0 && [subview isMemberOfClass:[DWLeftSideBar class]]) {
                DWLeftSideBar *left = (DWLeftSideBar *)subview;
                [left updateLeftSideBar];
            }
            else if([subview isMemberOfClass:[DWRightSideBar class]]) {
                DWRightSideBar *right = (DWRightSideBar *)subview;
                [right getMessagesFromDb];
            }
        }
        [MBProgressHUD hideHUDForView:self animated:YES];
    }];
}


-(void)reloadPlaces:(id)sender
{
    [MBProgressHUD showHUDAddedTo:self animated:YES];
    
    [Place getAllPlaces:^(NSArray *places) {
        
        [[Session sessionVariables] setObject:places forKey:@"Places"];
        
        [self loadDraggableCustomView:places];
        [self placesDidLoad];
        
        [MBProgressHUD hideHUDForView:self animated:YES];
    }];
}

-(void)addNavBar
{
    for(id subview in self.subviews) {
        if([subview isMemberOfClass:[UINavigationBar class]])
        {
            [self bringSubviewToFront:subview];
            return;
        }
    }
    
    UINavigationBar *naviBarObj = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, 60)];
    [self addSubview:naviBarObj];
    
    UIButton *menuButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 25, 30)];
    [menuButton setImage:[UIImage imageNamed:@"nav"] forState:UIControlStateNormal];
    [menuButton addTarget:self action:@selector(menuButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *userButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 35, 30)];
    [userButton setImage:[UIImage imageNamed:@"message"] forState:UIControlStateNormal];
    [userButton addTarget:self action:@selector(userButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    
    //UIBarButtonItem *menuButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav"] style:UIBarButtonItemStylePlain target:self action:@selector(menuButtonPressed)];
    
    //UIBarButtonItem *userButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"newmessage"] style:UIBarButtonItemStylePlain target:self action:@selector(userButtonPressed)];
    
    UINavigationItem *navigItem = [[UINavigationItem alloc] init];
    navigItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"letseat"]];
    navigItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:menuButton];
    navigItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:userButton];
    naviBarObj.items = [NSArray arrayWithObjects: navigItem,nil];
    
}

-(void)placesDidLoad
{
    //return;
    //InstructionsView *instructions = [[InstructionsView alloc] initWithFrame:CGRectMake(0, 0, wd, ht)];
    //[self addSubview:instructions];

//    for(id subview in self.subviews) {
//        if([subview isMemberOfClass:[DWAddFriendsView class]])
//        {
//            [self addNavBar];
//            [subview removeFromSuperview];
//        }
//    }

//    [User login:^(User *user) {
//        [SavedList add:@"" userId:user.userId completion:^(SavedList *savedList) {
//            
//        }];
//    }];
    
}

-(void)menuButtonPressed
{
    [self closeRightSideBar];

    NSUInteger wd = [[UIScreen mainScreen] bounds].size.width;
    NSUInteger ht = [[UIScreen mainScreen] bounds].size.height;
    
    NSArray *views = self.subviews;
    for(id subview in views) {
        if([subview isMemberOfClass:[DWLeftSideBar class]]) {
            [self bringSubviewToFront:subview];
            DWLeftSideBar *left = (DWLeftSideBar *)subview;
            BOOL isOpen = left.bounds.size.width > 0;
            if(!isOpen)
                [left setContentOffset:CGPointZero];
            
            [UIView animateWithDuration:0.2
                 animations:^{
                     if(isOpen)
                         left.frame = CGRectMake(0, 60, 0, ht - 60);
                     else
                         left.frame = CGRectMake(0, 60, (wd * 3) /4, ht - 60);
                 }
                 completion:^(BOOL finished){
                     
                 }];
        }
    }
}
-(void)closeLeftSideBar
{
    NSUInteger ht = [[UIScreen mainScreen] bounds].size.height;
    
    NSArray *views = self.subviews;
    for(id subview in views) {
        if([subview isMemberOfClass:[DWLeftSideBar class]]) {
            [self bringSubviewToFront:subview];
            DWLeftSideBar *left = (DWLeftSideBar *)subview;
            BOOL isOpen = left.bounds.size.width > 0;
            if(!isOpen)
                return;
            
            [UIView animateWithDuration:0.2
                 animations:^{
                    left.frame = CGRectMake(0, 60, 0, ht - 60);
                 }
                 completion:^(BOOL finished){
                     
                 }];
        }
    }
}

-(void)userButtonPressed
{
    [self closeLeftSideBar];
    
    NSUInteger wd = [[UIScreen mainScreen] bounds].size.width;
    NSUInteger ht = [[UIScreen mainScreen] bounds].size.height;
    
    NSArray *views = self.subviews;
    for(id subview in views) {
        if([subview isMemberOfClass:[DWRightSideBar class]]) {
            [self bringSubviewToFront:subview];
            DWRightSideBar *right = (DWRightSideBar *)subview;
            [right changeIcon:NO];
            
            BOOL isOpen = right.frame.origin.x < wd;
            if(!isOpen)
                [right populateMessages:@""];
            
            [UIView animateWithDuration:0.2
                 animations:^{
                     if(isOpen)
                         right.frame = CGRectMake(wd, 60, (wd * 3)/4, ht - 60);
                     else
                         right.frame = CGRectMake(wd /4, 60, (wd * 3)/4, ht - 60);
                 }
                 completion:^(BOOL finished){
                     
                 }];
        }
        if([subview isMemberOfClass:[DWPreviousSideBar class]]) {
            [self bringSubviewToFront:subview];
            DWPreviousSideBar *prev = (DWPreviousSideBar *)subview;

            [UIView animateWithDuration:0.2
                 animations:^{
                     prev.frame = CGRectMake(wd, 60, (wd * 3)/4, ht - 60);
                 }
                 completion:^(BOOL finished){
                     
                 }];
        }

        
    }
}

-(void)closeRightSideBar
{
    NSUInteger wd = [[UIScreen mainScreen] bounds].size.width;
    NSUInteger ht = [[UIScreen mainScreen] bounds].size.height;
    
    NSArray *views = self.subviews;
    for(id subview in views) {
        if([subview isMemberOfClass:[DWRightSideBar class]]) {
            [self bringSubviewToFront:subview];
            DWRightSideBar *right = (DWRightSideBar *)subview;
            
            BOOL isOpen = right.frame.origin.x < wd;
            if(!isOpen)
                return;
            
            [UIView animateWithDuration:0.2
                 animations:^{
                     right.frame = CGRectMake(wd, 60, (wd * 3)/4, ht - 60);
                 }
                 completion:^(BOOL finished){
                     
                 }];
        }
    }
}

- (void)loadDraggableCustomView:(NSArray *)places
{
    for(id subview in self.subviews)
    {
        if([subview isMemberOfClass:[DWDraggableView class]])
            [subview removeFromSuperview];
    }
    
    NSUInteger wd = [[UIScreen mainScreen] bounds].size.width;
    NSUInteger ht = [[UIScreen mainScreen] bounds].size.height;
       
    DWDraggableView *prevDraggableView = [[DWDraggableView alloc] initWithFrame:CGRectMake(0, 0, wd, ht-40) place:places[0] async:NO];
    [self insertSubview:prevDraggableView atIndex:1];
    
    NSUInteger currentId = places.count - 1 > 3 ? 3 : places.count - 1;
    [[Session sessionVariables] setObject:[NSNumber numberWithInteger:currentId] forKey:@"CurrentId"];
    
    for(int i = 1; i <= currentId; i++)
    {
        
        BOOL async = i > 1;
        DWDraggableView *draggableView = [[DWDraggableView alloc] initWithFrame:CGRectMake(0, 0, wd, ht-40) place:places[i] async:async];

        [self insertSubview:draggableView belowSubview:prevDraggableView];
        prevDraggableView = draggableView;
    }
    
    //[self addNavBar];
}

-(void) voteButtonClick:(id)sender
{
    [self closeLeftSideBar];
    [self closeRightSideBar];
    
    for(id subview in self.subviews)
    {
        if([subview isMemberOfClass:[UIButton class]])
            [self sendSubviewToBack:subview];
    }
    
    
    BOOL isYes = (((UIButton*)sender).tag == 1);
    
    @try {
        DWDraggableView *card = [self getCurrentCard];
        [card animateImageToBack:isYes];
    }
    @catch(NSException *ex) {
    }
}

-(DWDraggableView *)getCurrentCard
{
    NSArray *views = self.subviews;
    NSMutableArray *drags = [[NSMutableArray alloc] init];
    for(id subview in views) {
        if([subview isMemberOfClass:[DWDraggableView class]]) {
            [drags addObject:subview];
        }
    }
    
    DWDraggableView *drag = (DWDraggableView *)drags[[drags count] - 1];
    if(drag.center.x == drag.originalPoint.x) {
        return drag;
    }
    drag = (DWDraggableView *)drags[[drags count] - 2];
    if(drag.center.x == drag.originalPoint.x) {
        return drag;
    }
    drag = (DWDraggableView *)drags[[drags count] - 3];
    if(drag.center.x == drag.originalPoint.x) {
        return drag;
    }
    drag = (DWDraggableView *)drags[[drags count] - 4];
    return drag;

}

@end