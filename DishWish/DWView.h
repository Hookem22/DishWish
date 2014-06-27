#import <Foundation/Foundation.h>
#import "DWDraggableView.h"
#import "DWOverlayView.h"
#import "Place.h"
#import "DWLeftSideBar.h"
#import "DWRightSideBar.h"

@interface DWView : UIView

@property (nonatomic, strong) DWLeftSideBar *leftSideBar;
-(void)setup:(CLLocation *)location;

-(void)menuButtonPressed;
-(void)userButtonPressed;

@end