
#import <UIKit/UIKit.h>
#import "Session.h"
#import "Place.h"
#import "DWDraggableView.h"
#import "DWMap.h"
#import "DWRightSideBar.h"

@interface DWLeftSideBar : UIScrollView

@property (nonatomic, strong) UIButton *shareButton;

-(void)updateLeftSideBar;
-(void)close;

@end
