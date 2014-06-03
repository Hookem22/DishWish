#import "DWMenu.h"

@interface DWMenu ()
//@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIScrollView *scrollView;
@end

@implementation DWMenu

@synthesize place = _place;

- (id)initWithFrame:(CGRect)frame place:(Place *)place
{
    self = [super initWithFrame:frame];
    if (!self) return nil;
    
    self.place = place;

    [self addNavBar:place];
   
    return self;
}

-(void)addNavBar:(Place *)place
{
    NSUInteger wd = [[UIScreen mainScreen] bounds].size.width;
    
    UINavigationBar *naviBarObj = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, wd, 60)];
    [self addSubview:naviBarObj];
    
    
    UIBarButtonItem *cancelItem = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:self action:@selector(exitMenu)];
    
    UINavigationItem *navigItem = [[UINavigationItem alloc] initWithTitle:place.name];
    navigItem.leftBarButtonItem = cancelItem;
    naviBarObj.items = [NSArray arrayWithObjects: navigItem,nil];
}

-(void)addMenu:(NSUInteger)menuType
{
    NSString *menu = [self getMenu:menuType];    
    
    if ([menu rangeOfString:@".png"].location == NSNotFound) {
        [self loadWebSite:menu menuType:menuType];
    }
    else {
        [self loadImage:menu menuType:menuType];
    }
}

-(NSString *)getMenu:(NSUInteger)menuType
{
    NSString *menu = self.place.menu;
    if(menuType == 0) {
        NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        NSDateComponents *comps = [gregorian components:(NSHourCalendarUnit | NSWeekdayCalendarUnit) fromDate:[NSDate date]];
        NSUInteger hour = [comps hour];
        NSUInteger weekday = [comps weekday];
        
        if([self.place.brunchMenu length] > 0 && (weekday == 1 || weekday == 7) && hour < 15)
        {
            menu = self.place.brunchMenu;
        }
        else if([self.place.lunchMenu length] > 0 && hour < 15)
        {
            menu = self.place.lunchMenu;
        }
    }
    else if(menuType == 1)
        menu = self.place.drinkMenu;
    else if(menuType == 2)
        menu = self.place.happyHourMenu;
    
    return menu;
}

-(void)exitMenu
{
    id topView = self.superview.superview;
    id navView;
    NSArray *views = self.superview.superview.subviews;
    for(id subview in views) {
        if([subview isMemberOfClass:[UINavigationBar class]])
            navView = subview;
    }
    
    [UIView animateWithDuration:0.3
             animations:^{
                 CGRect frame = self.frame;
                 frame.origin.y = frame.size.height * (-1);
                 self.frame = frame;
             }
             completion:^(BOOL finished){
                 self.alpha = 0;
                 [topView bringSubviewToFront:navView];
             }];
}

- (void)loadWebSite:(NSString *)menu menuType:(NSUInteger)menuType {

    NSUInteger wd = [[UIScreen mainScreen] bounds].size.width;
    NSUInteger ht = [[UIScreen mainScreen] bounds].size.height;
    
    UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(0,60,wd,ht - 100)];
    [webView setScalesPageToFit:YES];
    
    NSString *urlAddress = menu;
    NSURL *url = [[NSURL alloc] initWithString:urlAddress];
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    
    [webView loadRequest:requestObj];
    webView.scrollView.delegate = self;
    webView.tag = menuType;
    
    [self addSubview:webView];
}

- (void)loadImage:(NSString *)menu menuType:(NSUInteger)menuType
{
    NSUInteger wd = [[UIScreen mainScreen] bounds].size.width;
    NSUInteger ht = [[UIScreen mainScreen] bounds].size.height;
    
    UIScrollView *view = [[UIScrollView alloc] initWithFrame:CGRectMake(0,60,wd,ht - 100)];
    
    NSURL *url = [NSURL URLWithString:menu];
    NSData *data = [NSData dataWithContentsOfURL:url];
    UIImage *img = [[UIImage alloc] initWithData:data];
    double ratio = wd / img.size.width;
    
    NSUInteger height = img.size.height * ratio;
    
    UIImage *image = [self imageWithImage:img scaledToSize:CGSizeMake(wd, height)];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    
    [view addSubview:imageView];
    [view setContentSize:imageView.frame.size];
    
    self.scrollView = view;
    self.scrollView.delegate = self;
    view.tag = menuType;
    
    [self addSubview: view];
    
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

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (scrollView.contentOffset.y - 60 >= scrollView.contentSize.height - scrollView.frame.size.height) {
        [self exitMenu];
        //NSLog([NSString stringWithFormat:@"%f", scrollView.contentOffset.y]);
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
}

- (void) loadRemotePdf
{
    CGRect rect = [[UIScreen mainScreen] bounds];
    CGSize screenSize = rect.size;
    
    UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(0,0,screenSize.width,screenSize.height - 100)];
    webView.autoresizesSubviews = YES;
    webView.autoresizingMask=(UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth);
    
    NSURL *myUrl = [NSURL URLWithString:@"http://www.chavez-austin.com/menus/CHAVEZ_Menu.pdf"];
    NSURLRequest *myRequest = [NSURLRequest requestWithURL:myUrl];
    
    [webView loadRequest:myRequest];
    
    [self addSubview: webView];
    
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
