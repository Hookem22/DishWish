#import "DWDraggableView.h"

#define DEGREES_TO_RADIANS(x) (M_PI * (x) / 180.0)

@interface DWDraggableView ()
@property(nonatomic, strong) UIPanGestureRecognizer *panGestureRecognizer;
@property (nonatomic, assign) NSUInteger currentImage;
@end

@implementation DWDraggableView


@synthesize originalPoint = _originalPoint;
@synthesize overlayView = _overlayView;
@synthesize place = _place;
@synthesize nameLabel = _nameLabel;
@synthesize menuButton = _menuButton;
@synthesize drinkButton = _drinkButton;
@synthesize mapButton = _mapButton;
@synthesize menuScreen = _menuScreen;
@synthesize mapScreen = _mapScreen;


- (id)initWithFrame:(CGRect)frame place:(Place *)place async:(BOOL)async
{
    self = [super initWithFrame:frame];
    if (!self) return nil;

    self.place = place;
    self.currentImage = 0;
    
    self.panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(dragged:)];
    [self addGestureRecognizer:self.panGestureRecognizer];

    [self loadView:async];

    self.overlayView = [[DWOverlayView alloc] initWithFrame:self.bounds];
    self.overlayView.alpha = 0;
    [self addSubview:self.overlayView];
    

    return self;
}

- (void)loadView:(BOOL)async
{
    NSUInteger wd = [[UIScreen mainScreen] bounds].size.width;
    NSUInteger ht = [[UIScreen mainScreen] bounds].size.height;
    
    UIButton *img = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, wd, ht - 100)];
    [img addTarget:self action:@selector(mainImageClicked:) forControlEvents:UIControlEventTouchUpInside];
    if(async)
        [self downLoadImagesAsync];
    else
        [self downLoadImages];
    
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, ht - 100, wd, 40)];
    nameLabel.text = [NSString stringWithFormat:@"     %@", self.place.name];
    nameLabel.backgroundColor = [UIColor whiteColor];
    self.nameLabel = nameLabel;
    [self addSubview:self.nameLabel];
    
    UIButton *mapButton = [[UIButton alloc] initWithFrame:CGRectMake(wd - 50, ht - 95, 40, 40)];
    [mapButton setImage:[UIImage imageNamed:@"map"] forState:UIControlStateNormal];
    [mapButton addTarget:self action:@selector(loadMap) forControlEvents:UIControlEventTouchUpInside];
    self.mapButton = mapButton;
    [self addSubview:self.mapButton];
    
    NSUInteger moreButtons = 0;
    if([self.place.happyHourMenu length] > 0)
    {
        UIButton *drinkButton = [[UIButton alloc] initWithFrame:CGRectMake(wd - 100, ht - 95, 40, 40)];
        [drinkButton setImage:[UIImage imageNamed:@"cocktail"] forState:UIControlStateNormal];
        [drinkButton addTarget:self action:@selector(openMenu:) forControlEvents:UIControlEventTouchUpInside];
        drinkButton.tag = 2;
        self.drinkButton = drinkButton;
        [self addSubview:self.drinkButton];
        
        moreButtons = 50;
    }
    
    if([self.place.drinkMenu length] > 0)
    {
        UIButton *drinkButton = [[UIButton alloc] initWithFrame:CGRectMake(wd - 100 - moreButtons, ht - 95, 40, 40)];
        [drinkButton setImage:[UIImage imageNamed:@"wine"] forState:UIControlStateNormal];
        [drinkButton addTarget:self action:@selector(openMenu:) forControlEvents:UIControlEventTouchUpInside];
        drinkButton.tag = 1;
        self.drinkButton = drinkButton;
        [self addSubview:self.drinkButton];
    
        moreButtons += 50;
    }
    
    UIButton *menuButton = [[UIButton alloc] initWithFrame:CGRectMake(wd - 100 - moreButtons, ht - 95, 40, 40)];
    [menuButton setImage:[UIImage imageNamed:@"fork"] forState:UIControlStateNormal];
    [menuButton addTarget:self action:@selector(openMenu:) forControlEvents:UIControlEventTouchUpInside];
    menuButton.tag = 0;
    //self.menuButton = menuButton;
    [self addSubview:menuButton];
    
    //Load Menus
    [self loadMenu:0 async:async];
    if([self.place.drinkMenu length] > 0)
    {
        [self loadMenu:1 async:async];
    }
    if([self.place.happyHourMenu length] > 0)
    {
        [self loadMenu:2 async:async];
    }
    
    self.backgroundColor = [UIColor whiteColor];
    self.originalPoint = self.center;
}

-(void)mainImageClicked:(id)sender
{
    if(self.place.images.count <= 1)
        return;
    
    if(self.currentImage + 1 >= self.place.images.count)
        self.currentImage = 0;
    else
        self.currentImage++;
    
    [self changeMainImage:sender];
    
}

-(void)loadMenu:(NSUInteger)menuType async:(BOOL)async {
   
    if(self.menuScreen == nil) {
        CGRect bounds = CGRectMake(self.bounds.origin.x, (-1) * self.bounds.size.height, self.bounds.size.width, self.bounds.size.height);
        self.menuScreen = [[DWMenu alloc] initWithFrame:bounds place:self.place];
        self.menuScreen.alpha = 0;
        [self addSubview:self.menuScreen];
    }
    

    
    [self.menuScreen addMenu:menuType async:async];
    
}

-(void)openMenu:(id)sender {
    UIButton *button = (UIButton *) sender;
    NSUInteger menuType = button.tag;
    
    NSArray *views = self.menuScreen.subviews;
    for(id subview in views)
    {
        if([subview isMemberOfClass:[UIWebView class]]) {
            UIWebView *webView = (UIWebView *)subview;
            if(menuType == webView.tag) {
                webView.alpha = 1;
                [webView.scrollView setContentOffset:CGPointZero];
                continue;
            }
            webView.alpha = 0;
        }
        else if([subview isMemberOfClass:[UIScrollView class]]) {
            UIScrollView *scrollView = (UIScrollView *)subview;
            if(menuType == scrollView.tag) {
                scrollView.alpha = 1;
                [scrollView setContentOffset:CGPointZero];
                continue;
            }
            scrollView.alpha = 0;	
        }
    }
    
    [self.superview bringSubviewToFront:self];
    self.menuScreen.alpha = 1;
    [self bringSubviewToFront:self.menuScreen];
    
    [UIView animateWithDuration:0.3
          animations:^{
              self.menuScreen.frame = self.bounds;
          }
          completion:^(BOOL finished){
              
          }];
}

-(void)loadMap
{
    [UIView animateWithDuration:.2
             animations:^{
                 self.center = self.originalPoint;
                 self.overlayView.alpha = 0;
                 self.transform = CGAffineTransformMakeRotation(0);
             }
             completion:^(BOOL finished) {
                 CGRect bounds = CGRectMake(self.bounds.origin.x, self.bounds.size.height, self.bounds.size.width, self.bounds.size.height);
                 self.mapScreen = [[DWMap alloc] initWithFrame:bounds place:self.place];
                 [self addSubview:self.mapScreen];
                 
                 [UIView animateWithDuration:0.3
                          animations:^{
                              self.mapScreen.frame = self.bounds;
                          }
                          completion:^(BOOL finished){
                              [self.superview bringSubviewToFront:self];
                          }];
             }
     ];
    
}

-(UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {
    //UIGraphicsBeginImageContext(newSize);
    // In next line, pass 0.0 to use the current device's pixel scaling factor (and thus account for Retina resolution).
    // Pass 1.0 to force exact pixel size.
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

- (void)dragged:(UIPanGestureRecognizer *)gestureRecognizer
{
    CGPoint point = [gestureRecognizer locationInView:gestureRecognizer.view];
    UIView *viewTouched = [gestureRecognizer.view hitTest:point withEvent:nil];
    if (!([viewTouched isKindOfClass:[DWDraggableView class]] || [viewTouched isKindOfClass:[DWOverlayView class]] || [viewTouched isKindOfClass:[UIButton class]] )) {
        //NSLog([NSString stringWithFormat:@"%@", viewTouched.class]);
        return;
    }
        else {
        //NSLog([NSString stringWithFormat:@"%@", viewTouched.class]);
    }
    
    
    CGFloat xDistance = [gestureRecognizer translationInView:self].x;
    CGFloat yDistance = [gestureRecognizer translationInView:self].y;

    switch (gestureRecognizer.state) {
        case UIGestureRecognizerStateBegan:{
            //self.originalPoint = self.center;
            break;
        };
        case UIGestureRecognizerStateChanged:{
            CGFloat rotationStrength = MIN(xDistance / 320, 1);
            CGFloat rotationAngle = (CGFloat) (2*M_PI/16 * rotationStrength);
            CGFloat scaleStrength = 1 - fabsf(rotationStrength) / 4;
            CGFloat scale = MAX(scaleStrength, 0.93);
            CGAffineTransform transform = CGAffineTransformMakeRotation(rotationAngle);
            CGAffineTransform scaleTransform = CGAffineTransformScale(transform, scale, scale);
            self.transform = scaleTransform;
            self.center = CGPointMake(self.originalPoint.x + xDistance, self.originalPoint.y + yDistance);
          
            [self updateOverlay:xDistance];
            
            break;
        };
        case UIGestureRecognizerStateEnded: {
            [self resetViewPositionAndTransformations:xDistance  y:yDistance];
            break;
        };
        case UIGestureRecognizerStatePossible:break;
        case UIGestureRecognizerStateCancelled:break;
        case UIGestureRecognizerStateFailed:break;
    }
}


- (void)updateOverlay:(CGFloat)distance
{
    if (distance > 0) {
        self.overlayView.mode = DWOverlayViewModeRight;
    } else if (distance <= 0) {
        self.overlayView.mode = DWOverlayViewModeLeft;
    }
    CGFloat overlayStrength = MIN(fabsf(distance) / 100, 0.4);
    self.overlayView.alpha = overlayStrength;
}

- (void)resetViewPositionAndTransformations:(CGFloat)x y:(CGFloat)y
{
    if(x < 70 && x > -70 && y > 70) {
        [UIView animateWithDuration:.2
             animations:^{
                 self.center = self.originalPoint;
                 self.overlayView.alpha = 0;
                 self.transform = CGAffineTransformMakeRotation(0);
             }
             completion:^(BOOL finished){
                 [self openMenu:self];
             }
         ];
        
    }
    else if(x < 70 && x > -70 && y < -70) {
        [self loadMap];
    }
    else if (x > 70)    {
        [self animateImage:YES];
    }
    else if (x < -70)    {
        [self animateImage:NO];
    }
    else {
        [self returnImage];
    }
    
}

-(void) animateImage:(BOOL)isYes
{
    float xOffset2 = (isYes) ? 1300 : -1300;
    
    [UIView animateWithDuration:1.0
             animations:^{
                 self.center = CGPointMake(self.originalPoint.x + xOffset2, self.originalPoint.y + 600);
                 self.transform = CGAffineTransformMakeRotation(DEGREES_TO_RADIANS(180));
             }
             completion:^(BOOL finished) {
                 [self animateImageComplete:isYes];
             }
     ];
    
}

-(void) animateImageToBack:(BOOL)isYes
{
    float xOffset1 = (isYes) ? 80 : -80;
    float degrees = (isYes) ? 20 : -20;
    float xOffset2 = (isYes) ? 1300 : -1300;
    
    self.overlayView.mode = (isYes) ? DWOverlayViewModeRight : DWOverlayViewModeLeft;
    self.overlayView.alpha = 0.4;
    
    [UIView animateWithDuration:0.2
             animations:^{
                 self.center = CGPointMake(self.originalPoint.x + xOffset1, self.originalPoint.y - 80);
                 self.transform = CGAffineTransformMakeRotation(DEGREES_TO_RADIANS(degrees));
             }
             completion:^(BOOL finished) {
                 [UIView animateWithDuration:1.0
                          animations:^{
                              self.center = CGPointMake(self.originalPoint.x + xOffset2, self.originalPoint.y + 600);
                              self.transform = CGAffineTransformMakeRotation(DEGREES_TO_RADIANS(180));
                          }
                          completion:^(BOOL finished) {
                              [self animateImageComplete:isYes];
                          }
                  ];
             }
     ];
}

-(void)animateImageComplete:(BOOL)isYes
{
    [self.superview sendSubviewToBack:self];
    self.center = self.originalPoint;
    self.transform = CGAffineTransformMakeRotation(0);
    self.overlayView.alpha = 0.0;
    [self.menuScreen exitMenu];
    [self.mapScreen exitMap];
    
    NSString *key = isYes ? @"yesPlaces" : @"noPlaces";
    NSMutableArray *prevPlaces = [NSMutableArray arrayWithArray:[Session sessionVariables][key]];

    if(![prevPlaces containsObject:self.place])
    {
        [prevPlaces addObject:self.place];
        [[Session sessionVariables] setObject:prevPlaces forKey:key];
        [self updateLeftSideBar:prevPlaces];
    }
    
    [self nextPlace];
    
    if(!isYes)
        [self removeFromSuperview];
    else
        self.alpha = 0;
}

-(void) animateImageToFront:(BOOL)isYes
{
    float xOffset1 = (isYes) ? 80 : -80;
    float degrees = (isYes) ? 20 : -20;
    float xOffset2 = (isYes) ? 1300 : -1300;
    
    self.center = CGPointMake(self.originalPoint.x + xOffset2, self.originalPoint.y + 600);
    self.transform = CGAffineTransformMakeRotation(DEGREES_TO_RADIANS(180));
    self.alpha = 1;
    [self.superview bringSubviewToFront:self];
    
    [UIView animateWithDuration:0.5
                     animations:^{
                         self.center = CGPointMake(self.originalPoint.x + xOffset1, self.originalPoint.y - 80);
                         self.transform = CGAffineTransformMakeRotation(DEGREES_TO_RADIANS(degrees));
                     }
                     completion:^(BOOL finished) {
                         [UIView animateWithDuration:0.2
                                          animations:^{
                                              self.center = self.originalPoint;
                                              self.transform = CGAffineTransformMakeRotation(0);
                                          }
                                          completion:^(BOOL finished) {
                                              NSArray *views = self.superview.subviews;
                                              for(id subview in views) {
                                                  if([subview isMemberOfClass:[UINavigationBar class]]) {
                                                      UINavigationBar *nav = (UINavigationBar *)subview;
                                                      [self.superview bringSubviewToFront:nav];
                                                  }
                                              }
                                          }
                          ];
                     }
     ];
}

-(void)updateLeftSideBar:(NSMutableArray *)places
{
    NSArray *views = self.superview.subviews;
    for(id subview in views) {
        if([subview isMemberOfClass:[DWLeftSideBar class]]) {
            DWLeftSideBar *left = (DWLeftSideBar *)subview;
            [left updateLeftSideBar];
        }
    }
}

-(void) returnImage
{
    [UIView animateWithDuration:.2
         animations:^{
             self.center = self.originalPoint;
             self.overlayView.alpha = 0;
             self.transform = CGAffineTransformMakeRotation(0);
         }
     ];
}

-(void)nextPlace
{
    NSArray *places = [NSArray arrayWithArray:[Session sessionVariables][@"Places"]];
    NSUInteger currentId = [[[Session sessionVariables] objectForKey:@"CurrentId"] intValue];
    
    currentId++;
    [[Session sessionVariables] setObject:[NSNumber numberWithInteger:currentId] forKey:@"CurrentId"];
    
    [self populateNextPlace:places[currentId]];

}

-(void)populateNextPlace:(Place *)place
{
    NSUInteger wd = [[UIScreen mainScreen] bounds].size.width;
    NSUInteger ht = [[UIScreen mainScreen] bounds].size.height;
    
    DWDraggableView *draggableView = [[DWDraggableView alloc] initWithFrame:CGRectMake(0, 0, wd, ht-40) place:place async:true];
    
    [self.superview addSubview:draggableView];
    [self.superview sendSubviewToBack:draggableView];
    
}

-(void)downLoadImages
{
    NSUInteger wd = [[UIScreen mainScreen] bounds].size.width;
    NSUInteger ht = [[UIScreen mainScreen] bounds].size.height;
  
    /*
    UIImageView *uiImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, wd, ht - 100)];
    
    UIImage *loading = [UIImage imageNamed:@"loading@2x.gif"];
    [uiImageView setImage:loading];
    [self insertSubview:uiImageView atIndex:0];
     */
    
    for (NSUInteger i = self.place.imageCount; i > 0; i--) {

        UIView *uiView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, wd, ht - 100)];
            
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, wd, ht - 100)];
        [button addTarget:self action:@selector(mainImageClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        NSURL *url = [NSURL URLWithString:self.place.images[i - 1]];
        NSData *data = [NSData dataWithContentsOfURL:url];
        UIImage *img = [[UIImage alloc] initWithData:data];
        
        [button setImage:img forState:UIControlStateNormal];
        [uiView addSubview:button];

        [self insertSubview:uiView atIndex:i + 10];
                
    }
}
-(void)downLoadImagesAsync
{
    
    NSUInteger wd = [[UIScreen mainScreen] bounds].size.width;
    NSUInteger ht = [[UIScreen mainScreen] bounds].size.height;
    
    dispatch_queue_t queue = dispatch_queue_create("Download Image Queue",NULL);
    for (NSUInteger i = 0, ii = self.place.imageCount; i < ii; i++) {
        dispatch_async(queue, ^{
            UIView *uiView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, wd, ht - 100)];
            
            UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, wd, ht - 100)];
            [button addTarget:self action:@selector(mainImageClicked:) forControlEvents:UIControlEventTouchUpInside];
            
            NSURL *url = [NSURL URLWithString:self.place.images[i]];
            NSData *data = [NSData dataWithContentsOfURL:url];
            UIImage *img = [[UIImage alloc] initWithData:data];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                // Update the UI
                [button setImage:img forState:UIControlStateNormal];
                [uiView addSubview:button];
                
                [self insertSubview:uiView atIndex:self.subviews.count - i];
            });
        });
    }
}

-(void)changeMainImage:(id)sender
{
    
    NSArray *views = self.subviews;
    NSMutableArray *buttons = [[NSMutableArray alloc] init];
    for(id subview in views)
    {
        if([subview isMemberOfClass:[UIView class]])
        {
            [buttons addObject:subview];
        }
    }
    
    [self sendSubviewToBack:buttons.lastObject];

}

- (void)dealloc
{
    [self removeGestureRecognizer:self.panGestureRecognizer];
}

@end