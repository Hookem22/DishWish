#import <Foundation/Foundation.h>
#import "DWOverlayView.h"
#import "Place.h"
#import "Session.h"
#import "DWMenu.h"
#import "DWMap.h"
#import "DWLeftSideBar.h"

@class DWOverlayView;


@interface DWDraggableView : UIView

@property(nonatomic) CGPoint originalPoint;
@property(nonatomic, strong) DWOverlayView *overlayView;
@property(nonatomic) Place *place;
@property(nonatomic) DWMenu *menuScreen;
@property (nonatomic, weak) IBOutlet UILabel *nameLabel;
@property (nonatomic, weak) IBOutlet UIButton *menuButton;
@property (nonatomic, weak) IBOutlet UIButton *drinkButton;
@property (nonatomic, weak) IBOutlet UIButton *mapButton;

//- (id)initWithPlace:(Place *)place;
- (id)initWithFrame:(CGRect)frame place:(Place *)place async:(BOOL)async;
-(void)animateImageToBack:(BOOL)isYes;
-(void)animateImageToFront:(BOOL)isYes;

@end