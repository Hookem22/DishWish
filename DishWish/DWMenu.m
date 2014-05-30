#import "DWMenu.h"

@interface DWMenu ()
//@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIScrollView *scrollView;
@end

@implementation DWMenu

- (id)initWithFrame:(CGRect)frame place:(Place *)place menuType:(NSUInteger)menuType;
{
    self = [super initWithFrame:frame];
    if (!self) return nil;
    
    NSString *menu = place.menu;
    if(menuType == 0) {
        NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        NSDateComponents *comps = [gregorian components:(NSHourCalendarUnit | NSWeekdayCalendarUnit) fromDate:[NSDate date]];
        int hour = [comps hour];
        int weekday = [comps weekday];
        
        if([place.brunchMenu length] > 0 && (weekday == 1 || weekday == 7) && hour < 15)
        {
            menu = place.brunchMenu;
        }
        else if([place.lunchMenu length] > 0 && hour < 15)
        {
            menu = place.lunchMenu;
        }
    }
    else if(menuType == 1)
        menu = place.drinkMenu;
    
    if ([menu rangeOfString:@".png"].location == NSNotFound) {
        [self loadWebSite:menu];
    }
    else {
        [self loadImage:menu];
    }
    
    [self addNavBar:place];
    
    return self;
}

-(void)addNavBar:(Place *)place
{
    UINavigationBar *naviBarObj = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, 320, 40)];
    [self addSubview:naviBarObj];
    
    
    UIBarButtonItem *cancelItem = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:self action:@selector(exitMenu)];
    
    UINavigationItem *navigItem = [[UINavigationItem alloc] initWithTitle:place.name];
    navigItem.leftBarButtonItem = cancelItem;
    naviBarObj.items = [NSArray arrayWithObjects: navigItem,nil];
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
                 [self removeFromSuperview];
                 [topView bringSubviewToFront:navView];
             }];
}

- (void)loadWebSite:(NSString *)menu {

    NSUInteger wd = [[UIScreen mainScreen] bounds].size.width;
    NSUInteger ht = [[UIScreen mainScreen] bounds].size.height;
    
    UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(0,40,wd,ht - 80)];
    
    NSString *urlAddress = menu;
    NSURL *url = [[NSURL alloc] initWithString:urlAddress];
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    
    [webView loadRequest:requestObj];
    webView.scrollView.delegate = self;
    
    [self addSubview:webView];
}

- (void)loadImage:(NSString *)menu
{
    NSUInteger wd = [[UIScreen mainScreen] bounds].size.width;
    NSUInteger ht = [[UIScreen mainScreen] bounds].size.height;
    
    UIScrollView *view = [[UIScrollView alloc] initWithFrame:CGRectMake(0,40,wd,ht - 80)];
    
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
