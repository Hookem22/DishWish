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

/*
- (id)initWithPlace:(Place *)place
{
    self = [super init];
    if (!self) return nil;
    
    self.place = place;
    
    self.panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(dragged:)];
    [self addGestureRecognizer:self.panGestureRecognizer];
    
    [self loadView];
    
    self.overlayView = [[DWOverlayView alloc] initWithFrame:self.bounds];
    self.overlayView.alpha = 0;
    [self addSubview:self.overlayView];
    
    return self;
}*/

- (id)initWithFrame:(CGRect)frame place:(Place *)place
{
    self = [super initWithFrame:frame];
    if (!self) return nil;

    self.place = place;
    self.currentImage = 0;
    
    self.panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(dragged:)];
    [self addGestureRecognizer:self.panGestureRecognizer];

    [self loadView];

    self.overlayView = [[DWOverlayView alloc] initWithFrame:self.bounds];
    self.overlayView.alpha = 0;
    [self addSubview:self.overlayView];
    

    return self;
}

- (void)loadView
{
    NSUInteger wd = [[UIScreen mainScreen] bounds].size.width;
    NSUInteger ht = [[UIScreen mainScreen] bounds].size.height;
    
    UIButton *img = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, wd, ht - 100)];
    [img addTarget:self action:@selector(mainImageClicked:) forControlEvents:UIControlEventTouchUpInside];
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
        [drinkButton addTarget:self action:@selector(loadMenu:) forControlEvents:UIControlEventTouchUpInside];
        drinkButton.tag = 2;
        self.drinkButton = drinkButton;
        [self addSubview:self.drinkButton];
        
        moreButtons = 50;
    }
    
    if([self.place.drinkMenu length] > 0)
    {
        UIButton *drinkButton = [[UIButton alloc] initWithFrame:CGRectMake(wd - 100 - moreButtons, ht - 95, 40, 40)];
        [drinkButton setImage:[UIImage imageNamed:@"wine"] forState:UIControlStateNormal];
        [drinkButton addTarget:self action:@selector(loadMenu:) forControlEvents:UIControlEventTouchUpInside];
        drinkButton.tag = 1;
        self.drinkButton = drinkButton;
        [self addSubview:self.drinkButton];
    
        moreButtons += 50;
    }
    
    UIButton *menuButton = [[UIButton alloc] initWithFrame:CGRectMake(wd - 100 - moreButtons, ht - 95, 40, 40)];
    [menuButton setImage:[UIImage imageNamed:@"fork"] forState:UIControlStateNormal];
    [menuButton addTarget:self action:@selector(loadMenu:) forControlEvents:UIControlEventTouchUpInside];
    menuButton.tag = 0;
    self.menuButton = menuButton;
    [self addSubview:self.menuButton];
    
    
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
    
    /*zoom into card funtionality
    [self.superview bringSubviewToFront:self];
    [self removeGestureRecognizer:self.panGestureRecognizer];
    
    [UIView animateWithDuration:0.3
             animations:^{
                 self.frame = CGRectMake(0, 50, self.superview.frame.size.width, self.superview.frame.size.height - 50);
                 
                 self.nameLabel.frame = CGRectMake(0, self.frame.size.height - 50, 100, 40);
                 self.mapButton.frame = CGRectMake(self.frame.size.width - 50, self.frame.size.height - 50, 40, 40);
                 self.menuButton.frame = CGRectMake(self.frame.size.width - 100, self.frame.size.height - 50, 40, 40);
             }
             completion:^(BOOL finished){
                 
             }];
    */
}

-(void)loadMenu:(id)sender
{
    UIButton *button = (UIButton *) sender;
    
    [UIView animateWithDuration:.2
         animations:^{
             self.center = self.originalPoint;
             self.overlayView.alpha = 0;
             self.transform = CGAffineTransformMakeRotation(0);
         }
         completion:^(BOOL finished) {
             [self.superview bringSubviewToFront:self];
             
             CGRect bounds = CGRectMake(self.bounds.origin.x, (-1) * self.bounds.size.height, self.bounds.size.width, self.bounds.size.height);
             self.menuScreen = [[DWMenu alloc] initWithFrame:bounds place:self.place menuType:button.tag];
             [self addSubview:self.menuScreen];
             
             [UIView animateWithDuration:0.3
                      animations:^{
                          self.menuScreen.frame = self.bounds;
                      }
                      completion:^(BOOL finished){
                          
                      }];
         }
     ];

    
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
        [self loadMenu:self];
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
                 [self animateImageComplete:self isYes:isYes];
             }
     ];
    
}

-(void) animateImage:(DWDraggableView *)card isYes:(BOOL)isYes
{
    float xOffset1 = (isYes) ? 80 : -80;
    float degrees = (isYes) ? 20 : -20;
    float xOffset2 = (isYes) ? 1300 : -1300;
    
    card.overlayView.mode = (isYes) ? DWOverlayViewModeRight : DWOverlayViewModeLeft;
    card.overlayView.alpha = 0.4;
    
    [UIView animateWithDuration:0.2
             animations:^{
                 card.center = CGPointMake(card.originalPoint.x + xOffset1, card.originalPoint.y - 80);
                 card.transform = CGAffineTransformMakeRotation(DEGREES_TO_RADIANS(degrees));
             }
             completion:^(BOOL finished) {
                 [UIView animateWithDuration:1.0
                          animations:^{
                              card.center = CGPointMake(card.originalPoint.x + xOffset2, card.originalPoint.y + 600);
                              card.transform = CGAffineTransformMakeRotation(DEGREES_TO_RADIANS(180));
                          }
                          completion:^(BOOL finished) {
                              [self animateImageComplete:card isYes:isYes];
                          }
                  ];
             }
     ];
}

-(void)animateImageComplete:(DWDraggableView *)card isYes:(BOOL)isYes
{
    [card.superview sendSubviewToBack:card];
    [card.menuScreen removeFromSuperview];
    card.center = card.originalPoint;
    card.transform = CGAffineTransformMakeRotation(0);
    card.overlayView.alpha = 0.0;
    [card.menuScreen exitMenu];
    [card.mapScreen exitMap];
    
    NSString *key = isYes ? @"yesPlaces" : @"noPlaces";
    
    NSMutableArray *prevPlaces = [NSMutableArray arrayWithArray:[Session sessionVariables][key]];

    [prevPlaces addObject:card.place.placeId];
    [[Session sessionVariables] setObject:prevPlaces forKey:key];

        
    [card nextPlace];
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
    
    //[self populateNextPlace:places[currentId]];
    
    currentId++;
    [[Session sessionVariables] setObject:[NSNumber numberWithInteger:currentId] forKey:@"CurrentId"];
    
    dispatch_queue_t imageQueue = dispatch_queue_create("Image Queue",NULL);
    
    dispatch_async(imageQueue, ^{
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            // Update the UI
            [self populateNextPlace:places[currentId]];
        });
        
    });
    
    
    /*
    [Place get:placeId completion:^(Place *place) {
        [self populateNextPlace:place];
    }];
    */

}

-(void)populateNextPlace:(Place *)place
{
    NSUInteger wd = [[UIScreen mainScreen] bounds].size.width;
    NSUInteger ht = [[UIScreen mainScreen] bounds].size.height;
    
    DWDraggableView *draggableView = [[DWDraggableView alloc] initWithFrame:CGRectMake(0, 0, wd, ht-40) place:place];
    
    [self.superview addSubview:draggableView];
    [self.superview sendSubviewToBack:draggableView];
    
    [self removeFromSuperview];
    
//    self.place = place;
//    self.nameLabel.text = [NSString stringWithFormat:@"     %@", place.name];
//    self.currentImage = 0;
//    
//    NSUInteger wd = [[UIScreen mainScreen] bounds].size.width;
//    NSUInteger ht = [[UIScreen mainScreen] bounds].size.height;
//    
//    NSURL *url = [NSURL URLWithString:self.place.images[self.currentImage]];
//    NSData *data = [NSData dataWithContentsOfURL:url];
//    UIImage *img = [[UIImage alloc] initWithData:data];
//    UIImage *myIcon = [self imageWithImage:img scaledToSize:CGSizeMake(wd, ht - 100)];
//    
//    [self.mainImage setImage:myIcon forState:UIControlStateNormal];

}

-(void)downLoadImages
{
    NSUInteger wd = [[UIScreen mainScreen] bounds].size.width;
    NSUInteger ht = [[UIScreen mainScreen] bounds].size.height;
    
    dispatch_queue_t queue = dispatch_queue_create("Download Image Queue",NULL);
    for (NSUInteger i = self.place.imageCount; i > 0; i--) {
        dispatch_async(queue, ^{
            UIView *uiView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, wd, ht - 100)];
            
            UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, wd, ht - 100)];
            [button addTarget:self action:@selector(mainImageClicked:) forControlEvents:UIControlEventTouchUpInside];
            
            NSURL *url = [NSURL URLWithString:self.place.images[i - 1]];
            NSData *data = [NSData dataWithContentsOfURL:url];
            UIImage *img = [[UIImage alloc] initWithData:data];
            
            [button setImage:img forState:UIControlStateNormal];
            [uiView addSubview:button];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                // Update the UI
                [self addSubview:uiView];
            });
        });
    }
}

-(void)changeMainImage:(id)sender
{
    UIButton *send = (UIButton *)sender;
    int tag = send.tag;
    
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

    
    /*
    NSUInteger wd = [[UIScreen mainScreen] bounds].size.width;
    NSUInteger ht = [[UIScreen mainScreen] bounds].size.height;
    
    CFTimeInterval startTime = CFAbsoluteTimeGetCurrent();
    
    NSURL *url = [NSURL URLWithString:self.place.images[self.currentImage]];
    NSData *data = [NSData dataWithContentsOfURL:url];
    UIImage *img = [[UIImage alloc] initWithData:data];
    
    CFTimeInterval difference = CFAbsoluteTimeGetCurrent() - startTime;
    NSLog([NSString stringWithFormat:@"%f\n", difference]);
    
    //UIImage *myIcon = [self imageWithImage:img scaledToSize:CGSizeMake(wd, ht - 100)];
    
    [self.mainImage setImage:img forState:UIControlStateNormal];
    */

}

- (void)dealloc
{
    [self removeGestureRecognizer:self.panGestureRecognizer];
}

@end