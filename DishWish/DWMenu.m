#import "DWMenu.h"

@interface DWMenu ()
@property (nonatomic, strong) UIImageView *imageView;
@end

@implementation DWMenu

- (id)initWithFrame:(CGRect)frame place:(Place *)place
{
    self = [super initWithFrame:frame];
    if (!self) return nil;
    
    [self loadWebSite:place];
    
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

- (void)loadWebSite:(Place *)place {
    UIWebView *webView = [[UIWebView alloc] initWithFrame:self.bounds];
    
    NSString *urlAddress = place.menu;
    NSURL *url = [[NSURL alloc] initWithString:urlAddress];
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    
    [webView loadRequest:requestObj];
    webView.scrollView.delegate = self;
    
    [self addSubview:webView];
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (scrollView.contentOffset.y >= scrollView.contentSize.height - scrollView.frame.size.height) {
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
