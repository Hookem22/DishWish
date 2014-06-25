#import "DWDraggableView.h"

#define DEGREES_TO_RADIANS(x) (M_PI * (x) / 180.0)

@interface DWDraggableView ()
@property(nonatomic, strong) UIPanGestureRecognizer *panGestureRecognizer;
@property (nonatomic, assign) NSUInteger currentImage;
@property (nonatomic, assign) BOOL secondaryLoad;
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

- (id)initWithFrame:(CGRect)frame place:(Place *)place async:(BOOL)async
{
    self = [super initWithFrame:frame];
    if (!self) return nil;

    self.place = place;
    self.currentImage = 0;
    self.secondaryLoad = NO;
    
    self.panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(dragged:)];
    [self addGestureRecognizer:self.panGestureRecognizer];

    [self initialLoadView:async];
    if(!async)
        [self secondaryLoadView:async];
    
    self.overlayView = [[DWOverlayView alloc] initWithFrame:self.bounds];
    self.overlayView.alpha = 0;
    [self addSubview:self.overlayView];

    return self;
}

#pragma mark Load Card

- (void)initialLoadView:(BOOL)async
{
    NSUInteger wd = [[UIScreen mainScreen] bounds].size.width;
    NSUInteger ht = [[UIScreen mainScreen] bounds].size.height;
    
    //Images
    if(async)
        [self downloadFirstImageAsync];
    else
        [self downloadFirstImage];
    
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
    
    if([self.place.menu length] > 0)
    {
        UIButton *menuButton = [[UIButton alloc] initWithFrame:CGRectMake(wd - 100 - moreButtons, ht - 95, 40, 40)];
        [menuButton setImage:[UIImage imageNamed:@"fork"] forState:UIControlStateNormal];
        [menuButton addTarget:self action:@selector(openMenu:) forControlEvents:UIControlEventTouchUpInside];
        menuButton.tag = 0;
        //self.menuButton = menuButton;
        [self addSubview:menuButton];
        
        moreButtons += 50;
    }
    
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, ht - 90, wd - (moreButtons + 60), 80)];
    nameLabel.text = [NSString stringWithFormat:@"%@", self.place.name];
    //nameLabel.backgroundColor = [UIColor whiteColor];
    nameLabel.numberOfLines = 2;
    nameLabel.lineBreakMode = NSLineBreakByWordWrapping;
    [nameLabel sizeToFit];
    
    self.nameLabel = nameLabel;
    [self addSubview:self.nameLabel];

    self.backgroundColor = [UIColor whiteColor];
    self.originalPoint = self.center;
}

- (void)secondaryLoadView:(BOOL)async
{
    if(self.secondaryLoad)
        return;
    
    self.secondaryLoad = YES;
    //Images
    if(async)
        [self downloadRestOfImagesAsync];
    else
        [self downloadRestOfImages];
    
    //Menus
    /*
    [self loadMenu:0 async:async];
    if([self.place.drinkMenu length] > 0)
    {
        [self loadMenu:1 async:async];
    }
    if([self.place.happyHourMenu length] > 0)
    {
        [self loadMenu:2 async:async];
    }
    */
}


#pragma mark Images

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

-(void)downloadFirstImage
{
    NSUInteger wd = [[UIScreen mainScreen] bounds].size.width;
    NSUInteger ht = [[UIScreen mainScreen] bounds].size.height;
    
    NSUInteger i = 1;
        
    UIView *uiView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, wd, ht - 100)];
    uiView.tag = i;
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, wd, ht - 100)];
    [button addTarget:self action:@selector(mainImageClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    NSURL *url = [NSURL URLWithString:self.place.images[i - 1]];
    NSData *data = [NSData dataWithContentsOfURL:url];
    UIImage *img = [UIImage imageWithData:data];
    //UIImage *img = [[UIImage alloc] initWithData:data];
    
    [button setImage:img forState:UIControlStateNormal];
    [uiView addSubview:button];
    
    [self addSubview:uiView];

}
-(void)downloadFirstImageAsync
{
    NSUInteger wd = [[UIScreen mainScreen] bounds].size.width;
    NSUInteger ht = [[UIScreen mainScreen] bounds].size.height;
    
    dispatch_queue_t queue = dispatch_queue_create("Download Image Queue",NULL);
    NSUInteger i = 1;
    
    dispatch_async(queue, ^{
        UIView *uiView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, wd, ht - 100)];
        uiView.tag = i;
        
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, wd, ht - 100)];
        [button addTarget:self action:@selector(mainImageClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        NSURL *url = [NSURL URLWithString:self.place.images[i - 1]];
        NSData *data = [NSData dataWithContentsOfURL:url];
        //UIImage *img = [[UIImage alloc] initWithData:data];
        UIImage *img = [UIImage imageWithData:data];
        dispatch_async(dispatch_get_main_queue(), ^{
            // Update the UI
            [button setImage:img forState:UIControlStateNormal];
            [uiView addSubview:button];
            
            [self addSubview:uiView];
            [self bringSubviewToFront:uiView];
            [self bringSubviewToFront:self.overlayView];
        });
    });
}

-(void)downloadRestOfImages
{
    NSUInteger wd = [[UIScreen mainScreen] bounds].size.width;
    NSUInteger ht = [[UIScreen mainScreen] bounds].size.height;
    
    /*
     UIImageView *uiImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, wd, ht - 100)];
     
     UIImage *loading = [UIImage imageNamed:@"loading@2x.gif"];
     [uiImageView setImage:loading];
     [self insertSubview:uiImageView atIndex:0];
     */
    
    UIView *prevView = [[UIView alloc] init];
    for(id subview in self.subviews)
    {
        if([subview isMemberOfClass:[UIView class]])
        {
            prevView = (UIView *)subview;
            break;
        }
    }
    
    for (NSUInteger i = 2; i <= self.place.imageCount; i++) {
        
        UIView *uiView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, wd, ht - 100)];
        uiView.tag = i;
        
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, wd, ht - 100)];
        [button addTarget:self action:@selector(mainImageClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        NSURL *url = [NSURL URLWithString:self.place.images[i - 1]];
        NSData *data = [NSData dataWithContentsOfURL:url];
        //UIImage *img = [[UIImage alloc] initWithData:data];
        UIImage *img = [UIImage imageWithData:data];
        [button setImage:img forState:UIControlStateNormal];
        [uiView addSubview:button];
        
        [self insertSubview:uiView belowSubview:prevView];
        prevView = uiView;
        
    }
}
-(void)downloadRestOfImagesAsync
{
    
    NSUInteger wd = [[UIScreen mainScreen] bounds].size.width;
    NSUInteger ht = [[UIScreen mainScreen] bounds].size.height;
    
    dispatch_queue_t queue = dispatch_queue_create("Download Image Queue",NULL);
    
    
    for (NSUInteger i = 2; i <= self.place.imageCount; i++) {
        
        UIView *uiView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, wd, ht - 100)];
        uiView.tag = i;
        
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, wd, ht - 100)];
        [button addTarget:self action:@selector(mainImageClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        dispatch_async(queue, ^{
            
            NSURL *url = [NSURL URLWithString:self.place.images[i - 1]];
            NSData *data = [NSData dataWithContentsOfURL:url];
            //UIImage *img = [[UIImage alloc] initWithData:data];
            UIImage *img = [UIImage imageWithData:data];
            dispatch_async(dispatch_get_main_queue(), ^{
                // Update the UI
                [button setImage:img forState:UIControlStateNormal];
                [uiView addSubview:button];
                
                [self addSubview:uiView];
                [self sendSubviewToBack:uiView];
            });
        });
    }
}

-(void)changeMainImage:(id)sender
{
    
    NSArray *views = self.subviews;
    NSMutableArray *pictures = [[NSMutableArray alloc] init];
    for(id subview in views)
    {
        if(![subview isMemberOfClass:[UIButton class]] && [subview isMemberOfClass:[UIView class]])
        {
            [pictures addObject:subview];
        }
    }
    
    [self sendSubviewToBack:pictures.lastObject];
    
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

#pragma mark Menu

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
    
    [self loadMenu:menuType async:false];
    
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
              [self.superview bringSubviewToFront:self];
              [self bringSubviewToFront:self.menuScreen];
          }];
}

#pragma mark Map

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
                 NSArray *places = [[NSArray alloc] initWithObjects:self.place, nil];
                 //self.mapScreen = [[DWMap alloc] initWithFrame:bounds places:places];
                 DWMap *map = [[DWMap alloc] initWithFrame:bounds places:places];
                 [self addSubview:map];
                 
                 [UIView animateWithDuration:0.3
                          animations:^{
                              map.frame = self.bounds;
                          }
                          completion:^(BOOL finished){
                              [self.superview bringSubviewToFront:self];
                          }];
             }
     ];
    
}

#pragma mark Animations

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
    
    NSMutableArray *subviews = [[NSMutableArray alloc] init];
    for(id subview in self.superview.subviews)
    {
        if([subview isKindOfClass:[DWDraggableView class]])
            [subviews addObject:subview];
    }
    
    DWDraggableView *topView = (DWDraggableView *)[subviews lastObject];
    if(topView != self && topView.layer.animationKeys.count == 0)
    {
        BOOL isYes = topView.center.x >= 0;
        [topView animateImageComplete:isYes];
        NSLog([NSString stringWithFormat:@"%hhd", isYes]);
        //NSLog([NSString stringWithFormat:@"%d", topView.layer.animationKeys.count]);
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
    //TODO:Close map
    //[self.mapScreen exitMap];
    
    NSMutableArray *yesPlaces = [NSMutableArray arrayWithArray:[Session sessionVariables][@"yesPlaces"]];
    NSMutableArray *noPlaces = [NSMutableArray arrayWithArray:[Session sessionVariables][@"noPlaces"]];
    
    if([yesPlaces containsObject:self.place] && !isYes) {
        [yesPlaces removeObject:self.place];
        [[Session sessionVariables] setObject:yesPlaces forKey:@"yesPlaces"];
    }
    else if([noPlaces containsObject:self.place] && isYes) {
        [noPlaces removeObject:self.place];
        [[Session sessionVariables] setObject:yesPlaces forKey:@"noPlaces"];
    }
    
    if(![yesPlaces containsObject:self.place] && ![noPlaces containsObject:self.place])
    {
        if(isYes)
        {
            [yesPlaces addObject:self.place];
            [[Session sessionVariables] setObject:yesPlaces forKey:@"yesPlaces"];
        }
        else
        {
            [noPlaces addObject:self.place];
            [[Session sessionVariables] setObject:yesPlaces forKey:@"noPlaces"];
        }
    }

    [self updateLeftSideBar:yesPlaces];
    
    int ct = 0;
    for(id subview in self.superview.subviews)
    {
        if([subview isMemberOfClass:[DWDraggableView class]])
            ct++;
    }
    
    if(ct <= 4) //Number of cards
        [self nextPlace];

    //if(!isYes) {
        for(id subview in self.subviews)
        {
            [subview removeFromSuperview];
        }
        [self removeFromSuperview];
    //}
    //else
    //    [self removeItems];
    
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
                      [self secondaryLoadView:NO];
                  }
              ];
         }
     ];
}


#pragma mark Remove Place

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

-(void)removeItems
{
    self.alpha = 0;
    [self removeImages];
    [self removeMenus];
}

-(void)removeImages
{
    NSArray *views = self.subviews;
    for(id subview in views)
    {
        if([subview isMemberOfClass:[UIView class]])
        {
            UIView *image = (UIView *)subview;
            if(image.tag > 1) {
                [image removeFromSuperview];
            }
        }
    }
}

-(void)removeMenus
{
    for(id subview in self.menuScreen.subviews)
    {
        [subview removeFromSuperview];
    }
    
    [self.menuScreen removeFromSuperview];
    self.menuScreen = nil;
}

#pragma mark Next Place

-(void)nextPlace
{
    NSArray *places = [NSArray arrayWithArray:[Session sessionVariables][@"Places"]];
    NSUInteger currentId = [[[Session sessionVariables] objectForKey:@"CurrentId"] intValue];
    
    currentId++;
    [[Session sessionVariables] setObject:[NSNumber numberWithInteger:currentId] forKey:@"CurrentId"];
    
    [self populateNextPlace:places[currentId]];
    
    for(id subview in self.superview.subviews)
    {
        if([subview isMemberOfClass:[DWDraggableView class]]) {
            DWDraggableView *view = (DWDraggableView *)subview;

            [view secondaryLoadView:YES];
        }
    }

}

-(void)populateNextPlace:(Place *)place
{
    NSUInteger wd = [[UIScreen mainScreen] bounds].size.width;
    NSUInteger ht = [[UIScreen mainScreen] bounds].size.height;
    
    DWDraggableView *draggableView = [[DWDraggableView alloc] initWithFrame:CGRectMake(0, 0, wd, ht-40) place:place async:true];
    
    [self.superview addSubview:draggableView];
    [self.superview sendSubviewToBack:draggableView];
    
}


- (void)dealloc
{
    [self removeGestureRecognizer:self.panGestureRecognizer];
}

@end