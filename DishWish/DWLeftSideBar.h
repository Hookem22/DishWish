
#import <UIKit/UIKit.h>
#import "Session.h"
#import "Place.h"
#import "DWDraggableView.h"
#import "DWMap.h"
#import "DWRightSideBar.h"
#import "DWMessage.h"

@interface DWLeftSideBar : UIScrollView

@property (nonatomic, strong) UIButton *shareButton;

-(void)updateLeftSideBar;


@end
