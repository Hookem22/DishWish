#import <Foundation/Foundation.h>
#import "Place.h"

@interface DWMenu : UIView


- (id)initWithFrame:(CGRect)frame place:(Place *)place menuType:(NSUInteger)menuType;
-(void)exitMenu;

@end
