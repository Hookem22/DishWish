#import <Foundation/Foundation.h>
#import "Place.h"
#import "MBProgressHUD.h"

@interface DWMenu : UIView

@property(nonatomic) Place *place;

- (id)initWithFrame:(CGRect)frame place:(Place *)place;
-(void)addMenu:(NSUInteger)menuType async:(BOOL)async;
-(void)exitMenu;



@end
