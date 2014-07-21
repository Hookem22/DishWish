#import <Foundation/Foundation.h>
#import "DWDraggableView.h"
#import "DWOverlayView.h"
#import "Place.h"
#import "DWLeftSideBar.h"
#import "DWRightSideBar.h"
#import "InstructionsView.h"
#import "AppDelegate.h"
#import "SavedList.h"
#import "User.h"

@interface DWView : UIView

@property (nonatomic, strong) DWLeftSideBar *leftSideBar;
-(void)setup;

-(void)menuButtonPressed;
-(void)userButtonPressed;
- (void)loadDraggableCustomView:(NSArray *)places;

@end