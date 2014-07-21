#import "DWView.h"

@implementation DWView

@synthesize leftSideBar = _leftSideBar;

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
        [SavedList get:savedListId completion:^(SavedList *savedList) {
            
            [[Session sessionVariables] setObject:savedList.places forKey:@"Places"];
            [self loadDraggableCustomView:savedList.places];
            [self placesDidLoad];
        }];

    }
    else
    {
        [Place getAllPlaces:^(NSArray *places) {
            
            [[Session sessionVariables] setObject:places forKey:@"Places"];
            
            [self loadDraggableCustomView:places];

            [self placesDidLoad];
            
        }];
    }
    
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
    
    //DWLeftSideBar *left = [[DWLeftSideBar alloc] initWithFrame:CGRectMake(0, 60, 0, ht - 60)];
    //[self addSubview:left];
    
    DWRightSideBar *right = [[DWRightSideBar alloc] initWithFrame:CGRectMake(wd, 60, (wd * 3)/4, ht - 60)];
    [self addSubview:right];
    
    UIImage *splash = [UIImage imageNamed:@"splash"];
    UIImageView *splashView = [[UIImageView alloc] initWithImage:splash];
    
    [self addSubview:splashView];
    
}
-(void)addNavBar:(NSUInteger)width
{
    for(id subview in self.subviews) {
        if([subview isMemberOfClass:[UINavigationBar class]])
        {
            [self bringSubviewToFront:subview];
            return;
        }
    }
    
    UINavigationBar *naviBarObj = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, width, 60)];
    [self addSubview:naviBarObj];
    
    UIBarButtonItem *menuButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_menu"] style:UIBarButtonItemStyleBordered target:self action:@selector(menuButtonPressed)];
    
    UIBarButtonItem *userButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_user"] style:UIBarButtonItemStyleBordered target:self action:@selector(userButtonPressed)];
    
    UINavigationItem *navigItem = [[UINavigationItem alloc] init];
    navigItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"letseat"]];
    navigItem.leftBarButtonItem = menuButton;
    navigItem.rightBarButtonItem = userButton;
    naviBarObj.items = [NSArray arrayWithObjects: navigItem,nil];
}

-(void)placesDidLoad
{
    
    //InstructionsView *instructions = [[InstructionsView alloc] initWithFrame:CGRectMake(0, 0, wd, ht)];
    //[self addSubview:instructions];
    
    for(id subview in self.subviews) {
        if([subview isMemberOfClass:[UIImageView class]])
            [subview removeFromSuperview];
    }
    
    
    [User login:^(User *user) {
        NSString *userId = user.deviceId;
        
        [SavedList getByUser:^(NSArray *savedLists) {
            DWRightSideBar *right;
            for(id subview in self.subviews) {
                if([subview isMemberOfClass:[DWRightSideBar class]])
                    right = (DWRightSideBar *)subview;
            }
            
            for(id savedList in savedLists)
            {
                [right addList:savedList];
            }
         }];
    }];
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
    NSUInteger wd = [[UIScreen mainScreen] bounds].size.width;
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

            BOOL isOpen = right.frame.origin.x < wd;

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
    for(id subview in self.superview.subviews)
    {
        if([subview isMemberOfClass:[DWDraggableView class]])
            [subview removeFromSuperview];
    }
    
    NSUInteger wd = [[UIScreen mainScreen] bounds].size.width;
    NSUInteger ht = [[UIScreen mainScreen] bounds].size.height;
    
    DWDraggableView *prevDraggableView = [[DWDraggableView alloc] initWithFrame:CGRectMake(0, 0, wd, ht-40) place:places[0] async:NO];
    [self addSubview:prevDraggableView];
    
    NSUInteger currentId = places.count - 1 > 3 ? 3 : places.count - 1;
    [[Session sessionVariables] setObject:[NSNumber numberWithInteger:currentId] forKey:@"CurrentId"];
    
    for(int i = 1; i <= currentId; i++)
    {
        
        BOOL async = i > 1;
        DWDraggableView *draggableView = [[DWDraggableView alloc] initWithFrame:CGRectMake(0, 0, wd, ht-40) place:places[i] async:async];

        [self insertSubview:draggableView belowSubview:prevDraggableView];
        prevDraggableView = draggableView;
    }
    
    [self addNavBar:[[UIScreen mainScreen] bounds].size.width];
}

-(void) voteButtonClick:(id)sender
{
    [self closeLeftSideBar];
    [self closeRightSideBar];
    
    BOOL isYes = (((UIButton*)sender).tag == 1);
    
    DWDraggableView *card = [self getCurrentCard];
    [card animateImageToBack:isYes];
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