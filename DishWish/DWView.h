#import <Foundation/Foundation.h>
#import "DWDraggableView.h"
#import "DWOverlayView.h"
#import "Place.h"
#import "DWAddFriendsView.h"
#import "DWLeftSideBar.h"
#import "DWRightSideBar.h"
#import "InstructionsView.h"
#import "SavedList.h"
#import "User.h"
#import "MBProgressHUD.h"

@interface DWView : UIView

@property (nonatomic, strong) DWAddFriendsView *addFriendsView;
@property (nonatomic, strong) DWRightSideBar *rightSideBar;
@property (nonatomic, strong) SavedList *savedList;

-(void)setup;

-(void)addNavBar;
-(void)menuButtonPressed;
-(void)userButtonPressed;
-(void)loadDraggableCustomView:(NSArray *)places;

@end