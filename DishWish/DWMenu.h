#import <Foundation/Foundation.h>
#import "Place.h"

@interface DWMenu : UIView

@property(nonatomic) Place *place;

- (id)initWithFrame:(CGRect)frame place:(Place *)place;
-(void)addMenu:(NSUInteger)menuType;
-(void)exitMenu;



@end
