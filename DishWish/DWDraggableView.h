#import <Foundation/Foundation.h>
#import "DWOverlayView.h"
#import "Place.h"
#import "DWMenu.h"
#import "DWMap.h"

@class DWOverlayView;


@interface DWDraggableView : UIView

@property(nonatomic) CGPoint originalPoint;
@property(nonatomic, strong) DWOverlayView *overlayView;
@property(nonatomic) Place *place;
@property(nonatomic) DWMenu *menuScreen;
@property(nonatomic) DWMap *mapScreen;
@property (nonatomic, weak) IBOutlet UIButton *mainImage;
@property (nonatomic, weak) IBOutlet UILabel *nameLabel;
@property (nonatomic, weak) IBOutlet UIButton *menuButton;
@property (nonatomic, weak) IBOutlet UIButton *mapButton;

//- (id)initWithPlace:(Place *)place;
- (id)initWithFrame:(CGRect)frame place:(Place *)place;
-(void) animateImage:(DWDraggableView *)card isYes:(BOOL)isYes;
-(void)nextPlace:(Place *)place;

@end